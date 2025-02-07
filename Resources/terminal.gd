class_name Terminal
extends Control

const InputResponse = preload("res://Resources/input_response.tscn")
@export var history_container: VBoxContainer
@export var scroll: ScrollContainer
@onready var scrollbar:VScrollBar = scroll.get_v_scroll_bar()
var max_scroll:=0.0
@export var command_procesor:CommandProcesor
var lambda_scroll = func(): if max_scroll != scrollbar.max_value:
	max_scroll = scrollbar.max_value
	scroll.scroll_vertical = max_scroll

func _ready() -> void:
	command_procesor.clear_signal.connect(command_procesor_clear)
	scrollbar.connect("changed",lambda_scroll)
	max_scroll = scrollbar.max_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_input_text_submitted(command: String) -> void:
	command_proces_start(command)
	
	
	
	
func command_proces_start(command: String) -> void:
	var input:String = command
	var respons:String 
	if command.is_empty():
		return

	respons = command_procesor.process_command(input)



	if not respons.is_empty():
		var input_response = InputResponse.instantiate()
		input_response.set_text(input,respons)
		history_container.add_child(input_response)

func command_procesor_clear() -> void:	
	for child in history_container.get_children():
		child.queue_free()
