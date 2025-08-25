@tool
extends LineEdit
@export var label:Label:
	set(v):
		if v:
			label = v
			self.size.y = label.get_rect().size.y + extra
@export var extra:int:
	set(v):
		extra = v
		self.size.y = label.get_rect().size.y + extra

func _ready() -> void:
	if label:
		self.size.y = label.get_rect().size.y + extra
