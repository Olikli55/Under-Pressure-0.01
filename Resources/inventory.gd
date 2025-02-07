extends Node
@onready var iron_label: Label = $CanvasLayer/Iron


var inventor:Dictionary = {
	"coal":0,
	"iron":0
}

func _ready() -> void:
	Global.add_to_inventory.connect(add_to_inventory)
	
	
func add_to_inventory(item:String) -> void:
	inventor[item] += 1
	iron_label.text = "iron:"+str(inventor[item])
