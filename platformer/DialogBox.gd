extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var dialog_text = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"]
var num_visible = 0
var page = 0

func _ready():
	set_bbcode(dialog_text[page])
	set_visible_characters(-1)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
