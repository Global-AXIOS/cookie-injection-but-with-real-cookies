extends Polygon2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func set_text(text):
	var text_box = self.get_node("text_box")
	text_box.dialog_text = text
	text_box.page = 0

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
