extends Control

@onready var errors: Label = $Errors
@onready var event_card_manager: Node2D = $"../EventCardManager"
@onready var do_it: Label = $DoIt

func _ready() -> void:
	errors.visible = false

func do_it_button_pressed():
	
	errors.visible = true
	await event_card_manager.event_req_card_check()
	
		
	#else:
		#errors.visible = true
		#var tween = get_tree().create_tween()
		#tween.tween_property(errors, "modulate", Color("ffffff70"), 0.3)
		#errors.text = "Event conditions not met!"

func error_message(text):
	errors.modulate = Color(1,1,1,0) # garante alpha 0
	errors.text = text

	var tween = get_tree().create_tween()
	tween.tween_property(errors, "modulate", Color(1,1,1,0.7), 0.23)
	
	await get_tree().create_timer(3.0).timeout

	var tween2 = get_tree().create_tween()
	tween2.tween_property(errors, "modulate", Color(1,1,1,0), 0.3)
	
func _on_label_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($DoIt, "scale", Vector2(1.3, 1.3), 0.23).set_trans(Tween.TRANS_EXPO)

func _on_label_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($DoIt, "scale", Vector2(1, 1), 0.23).set_trans(Tween.TRANS_EXPO)
