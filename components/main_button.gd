@tool
extends Button
class_name MainButton
@export var description :String="":
	set(v):
		description = v
		if lbl:
			lbl.text = v
			_update_layout()

@onready var lbl:Label = $Label

func _ready():
	lbl.text = description
	lbl.resized.connect(_update_layout)
	resized.connect(_update_layout)
	
func _update_layout():
	lbl.reset_size()
	var description_size:Vector2 = lbl.get_rect().size
	lbl.position = (size - description_size) * 0.5
	lbl.pivot_offset =  description_size * 0.5
