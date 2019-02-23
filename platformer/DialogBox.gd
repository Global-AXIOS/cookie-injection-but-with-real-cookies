extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var dialog_text = ["This is the first page", "This is the second page"]
var num_visible = 0
var page = 0

func _ready():
	set_bbcode(dialog_text[page])
	set_visible_characters(-1)
	set_process_input(true)


func _input(event):
	if event.is_pressed():
		# print("Pressed")
		if get_visible_characters() > get_total_character_count():
			if page < dialog_text.size() - 1:
				page += 1
				set_bbcode(dialog_text[page])
				set_visible_characters(0)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
