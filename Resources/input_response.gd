extends VBoxContainer

@export var input_history_label:Label 
@export var response_label:Label

func set_text(input:String,response:String) -> void:
	if input.is_empty() or response.is_empty():
		return
	if response.contains("err"):
		response_label.add_theme_color_override("font_color", Color(1, 0, 0, 1))
	input_history_label.text  = " > " + input
	response_label.text = response
