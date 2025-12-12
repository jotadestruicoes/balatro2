extends Control

@onready var errors: Label = $Errors
@onready var event_card_manager: Node2D = $"../EventCardManager"

func _ready() -> void:
	errors.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func do_it_button_pressed():
	if event_card_manager.event_conditions_met():
		$DoItLabelArea/CollisionShape2D.disabled = false 
	else:
		errors.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property(errors, "modulate", Color("ffffff"), 0.3)
		errors.text = "Event conditions not met!"

func _on_label_mouse_entered() -> void:
	print("entrou")
	var tween = get_tree().create_tween()
	tween.tween_property($DoIt, "scale", Vector2(1.3, 1.3), 0.23).set_trans(Tween.TRANS_EXPO)

func _on_label_mouse_exited() -> void:
	print("saiu")
	var tween = get_tree().create_tween()
	tween.tween_property($DoIt, "scale", Vector2(1, 1), 0.23).set_trans(Tween.TRANS_EXPO)
