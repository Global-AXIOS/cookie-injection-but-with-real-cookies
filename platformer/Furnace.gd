extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func pass_test_one(cc, pb, oat, ras):
	return cc > 0 && pb == 0 && oat == 0 && ras == 0

func _pressed():
	var cc = get_parent().get_node("Chocolate Chips/label").get_t();
	var pb = get_parent().get_node("Peanut Butter/label").get_t();
	var oat = get_parent().get_node("Oatmeal/label").get_t();
	var ras = get_parent().get_node("Rasins/label").get_t(); 
	print(pass_test_one(cc, pb, oat, ras))