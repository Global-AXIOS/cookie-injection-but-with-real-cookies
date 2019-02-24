extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var count = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_bbcode("Chocolate chips: " + str(count))
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_MinusCChips_pressed():
	count = max(count - 1, 0)
	set_bbcode("Chocolate chips: " + str(count))
	pass # replace with function body


func _on_PlusCChips_pressed():
	count = min(count + 1, 5)
	
	set_bbcode("Chocolate chips: " + str(count))
	pass # replace with function body
