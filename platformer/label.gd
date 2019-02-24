extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var t = 0;
onready var the_name = get_parent().get_name()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	p()
	pass
func p():
	set_bbcode("[right]" + the_name + ": " + str(t) + "[/right]")
	self.get_parent().get_node("plus").release_focus()
	self.get_parent().get_node("minus").release_focus()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_plus_pressed():
	if Input.is_action_just_pressed("mouse_left") || true:
		print("plus pressed")
		t = min(t + 1, 5)
		p()
	pass # replace with function body


func _on_minus_pressed():
	if Input.is_action_just_pressed("mouse_left") || true:
		print("minus pressed")
		t = max(t - 1, 0)
		p()
	pass # replace with function body
