extends Control

@onready var errors: Label = $Errors
@onready var event_card_manager: Node2D = $"../EventCardManager"
@onready var do_it: Label = $DoIt
@onready var high_score_number: Label = $ScoresVBox/HighScoreHBox/HighScoreNUMBER
@onready var current_score_number: Label = $ScoresVBox/CurrentScoreHBox/CurrentScoreNUMBER

var save_file_path = "res://saves/savefile.save"
var high_score
var reset_high_score_value := 0 

func _ready() -> void:
	errors.visible = false
	
	current_score_number.text = "0"
	set_hs(0)
	
	load_score()
	
func do_it_button_pressed():
	
	errors.visible = true
	await event_card_manager.event_req_card_check()

func _on_reset_game_pressed() -> void:
	get_tree().reload_current_scene() 
	
func _on_reset_high_score_button_pressed() -> void:
	print("reset")
	var file = FileAccess.open(save_file_path, FileAccess.WRITE) 
	var highest_score = 0 
	file.store_var(highest_score)
	load_score()

func load_score():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)

		if file.get_length() > 0:
			var value = file.get_var()
			high_score = value
			high_score_number.text = str(high_score)
		else:
			print("Arquivo existe, mas está vazio.")
			high_score = 0
			set_hs(0)
	else:
		print("Nenhum arquivo encontrado.")
		high_score = 0
		set_hs(0)

func save(highest_score):
	var file = FileAccess.open(save_file_path, FileAccess.WRITE) 
	highest_score = int(high_score_number.text)
	file.store_var(highest_score)
	
func set_hs(new_high_score):
	high_score_number.text = str(new_high_score)
	return
func set_s(score):
	current_score_number.text = str(score)
	return

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
