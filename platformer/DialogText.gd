extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var dialog_text = [""]
var num_visible = 0
var page = 0

func _ready():
	print("Created DialogBox")
	set_bbcode(dialog_text[page])
	set_visible_characters(-1)
	set_process_input(true)
	

func set_text(text):
	dialog_text = text
	page = 0
	
func is_finished():
	print(page, " ", dialog_text.size())
	return page == dialog_text.size() - 1 and get_total_character_count() == dialog_text[page].length()

func _input(event):
	if Input.is_action_pressed("ui_interact") and get_parent().is_visible():
		# print("Pressed")
		if get_visible_characters() > get_total_character_count():
			if page < dialog_text.size() - 1:
				page += 1
				set_bbcode(dialog_text[page])
				set_visible_characters(0)
			else:
				get_parent().hide()
		else:
			set_visible_characters(get_total_character_count() + 1)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Timer_timeout():
	#print("Time Executed")
	set_visible_characters(get_visible_characters() + 1)
