extends RigidBody2D

# Character Demo, written by Juan Linietsky.
#
# Implementation of a 2D Character controller.
# This implementation uses the physics engine for
# controlling a character, in a very similar way
# than a 3D character controller would be implemented.
#
# Using the physics engine for this has the main
# advantages:
# -Easy to write.
# -Interaction with other physics-based objects is free
# -Only have to deal with the object linear velocity, not position
# -All collision/area framework available
# 
# But also has the following disadvantages:
#  
# -Objects may bounce a little bit sometimes
# -Going up ramps sends the chracter flying up, small hack is needed.
# -A ray collider is needed to avoid sliding down on ramps and  
#   undesiderd bumps, small steps and rare numerical precision errors.
#   (another alternative may be to turn on friction when the character is not moving).
# -Friction cant be used, so floor velocity must be considered
#  for moving platforms.

# Member variables
var anim = ""
var siding_left = false
var jumping = false
var stopping_jump = false
var shooting = false

var WALK_ACCEL = 1500.0
var WALK_DEACCEL = 1500.0
var WALK_MAX_VELOCITY = 300.0
var AIR_ACCEL = 200.0
var AIR_DEACCEL = 200.0
var JUMP_VELOCITY = 460
var STOP_JUMP_FORCE = 900.0

var MAX_FLOOR_AIRBORNE_TIME = 0.15

var airborne_time = 1e20
var shoot_time = 1e20

var MAX_SHOOT_POSE_TIME = 0.3

var IN_DIALOGUE = false

var bullet = preload("res://bullet.tscn")

var floor_h_velocity = 0.0
onready var enemy = load("res://enemy.tscn")
#var current_dialogue = null

func _ready():
	set_process_input(true)
	var text = get_node("camera/Dialog/text")
	text.set_text(["", "This is some text", "MMemesMemesMemesMemesemes", "The last BOX"])
	

func _input(event):
	if Input.is_action_just_pressed("ui_interact"):
		var text = get_node("camera/Dialog/text")
		var dialog = get_node("camera/Dialog")
		
		if not IN_DIALOGUE:
			IN_DIALOGUE = true
			dialog.show()
			text._input(event)
		elif text.is_finished():
			text.set_text(["", "This is some text", "MMemesMemesMemesMemesemes", "The last BOX"])
			dialog.hide()
			IN_DIALOGUE = false
	


func _physics_process(delta):
	#print(get_node("camera/Dialog/text").dialog_text)
	#var camera = get_node("camera")
	#print(camera)
	#print(get_node("camera/Dialog").get_viewport_transform(), " ", self.position)
	#if current_dialog:
	#	print(current_dialog.position)
	#var camera = get_node("camera")
	#var new_pos = camera.get_camera_screen_center()
	
	#if current_dialog:
	#	current_dialog.position = new_pos
	#if current_dialogue != null:
	#	print(self.position, current_dialogue.position)
	
#	if current_dialogue == null:
#		IN_DIALOGUE = false
	"""
	if !IN_DIALOGUE:
		var space_state = get_world_2d().direct_space_state
		var pos = self.position
		
		var result = space_state.intersect_ray(Vector2(pos[0], pos[1]), Vector2(pos[0] + 100, pos[1]), [self])
		
		if result.has("collider"):
			if result["collider"].get_name() == "enemy":
				var enemy = result["collider"];
				var dialogue_text = enemy.get_dialog()
				
				dialogue.get_child(1).init(dialogue_text)
				
				dialogue.position = self.position
				dialogue.z_index = self.z_index + 1
				
				print(dialogue)
				print(dialogue.get_node("notifier").is_on_screen())
				
				IN_DIALOGUE = true
	"""
		
		

func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()
	
	var new_anim = anim
	var new_siding_left = siding_left
	
	# Get the controls
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var shoot = Input.is_action_pressed("shoot")
	var spawn = Input.is_action_pressed("spawn")
	
	if spawn:
		var e = enemy.instance()
		var p = position
		p.y = p.y - 100
		e.position = p
		get_parent().add_child(e)
	
	# Deapply prev floor velocity
	lv.x -= floor_h_velocity
	floor_h_velocity = 0.0
	
	# Find the floor (a contact with upwards facing collision normal)
	var found_floor = false
	var floor_index = -1
	
	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)
		if ci.dot(Vector2(0, -1)) > 0.6:
			found_floor = true
			floor_index = x
	
	# A good idea when implementing characters of all kinds,
	# compensates for physics imprecision, as well as human reaction delay.
	if shoot and not shooting:
		shoot_time = 0
		var bi = bullet.instance()
		var ss
		if siding_left:
			ss = -1.0
		else:
			ss = 1.0
		var pos = position + $bullet_shoot.position * Vector2(ss, 1.0)
		
		bi.position = pos
		get_parent().add_child(bi)
		
		bi.linear_velocity = Vector2(800.0 * ss, -80)
		
		$sprite/smoke.restart()
		$sound_shoot.play()
		
		add_collision_exception_with(bi) # Make bullet and this not collide
	else:
		shoot_time += step
	
	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air
	
	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump
	if jumping:
		if lv.y > 0:
			# Set off the jumping flag if going down
			jumping = false
		elif not jump:
			stopping_jump = true
		
		if stopping_jump:
			lv.y += STOP_JUMP_FORCE * step
	
	if on_floor:
		# Process logic when character is on floor
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= WALK_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += WALK_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv
		
		# Check jump
		if not jumping and jump:
			lv.y = -JUMP_VELOCITY
			jumping = true
			stopping_jump = false
			$sound_jump.play()
		
		# Check siding
		if lv.x < 0 and move_left:
			new_siding_left = true
		elif lv.x > 0 and move_right:
			new_siding_left = false
		if jumping:
			new_anim = "jumping"
		elif abs(lv.x) < 0.1:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "idle_weapon"
			else:
				new_anim = "idle"
		else:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "run_weapon"
			else:
				new_anim = "run"
	else:
		# Process logic when the character is in the air
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= AIR_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += AIR_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= AIR_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv
		
		if lv.y < 0:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "jumping_weapon"
			else:
				new_anim = "jumping"
		else:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "falling_weapon"
			else:
				new_anim = "falling"
	
	# Update siding
	if new_siding_left != siding_left:
		if new_siding_left:
			$sprite.scale.x = -1
		else:
			$sprite.scale.x = 1
		
		siding_left = new_siding_left
	
	# Change animation
	if new_anim != anim:
		anim = new_anim
		$anim.play(anim)
	
	shooting = shoot
	
	# Apply floor velocity
	if found_floor:
		floor_h_velocity = s.get_contact_collider_velocity_at_position(floor_index).x
		lv.x += floor_h_velocity
	
	# Finally, apply gravity and set back the linear velocity
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)
