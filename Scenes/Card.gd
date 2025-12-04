extends Node2D

signal hovered
signal hovered_off

var hand_original_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = Vector2(150, 890)
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		

func _on_generic_card_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_generic_card_mouse_exited() -> void:
	emit_signal("hovered_off", self)
