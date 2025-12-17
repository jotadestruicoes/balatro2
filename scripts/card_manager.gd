extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2
const COLLISION_MASK_PLAYER_HAND = 64

var card_being_dragged
var screen_size
var is_hovering_on_card

@onready var player_hand: Node2D = $"../PlayerHand"
@onready var input_manager: Node2D = $"../InputManager"


func _ready() -> void:
	screen_size = get_viewport_rect().size
	input_manager.connect("left_mouse_button_released", on_left_click_released)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), clamp(mouse_pos.y, 0, screen_size.y))

var original_slot: Node = null  # referência ao slot de origem durante o drag

func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)

	# Guarda o slot original para fallback
	original_slot = card.current_slot

	# Libera imediatamente o slot de origem (para não ficar marcado como ocupado)
	if original_slot != null:
		original_slot.has_card = false
		if original_slot.card_in_slot == card:
			original_slot.card_in_slot = null
		card.current_slot = null

func finish_drag():
	card_being_dragged.scale = Vector2(1.05, 1.05)
	var card_slot_found = raycast_check_for_card_slot()
	var hand_area_found = raycast_check_for_hand()
	var card = card_being_dragged

	# 1) Drop explícito na mão tem prioridade
	if hand_area_found:
		card.current_slot = null
		player_hand.add_card_to_hand(card)
		card_being_dragged = null
		original_slot = null
		return
		
	# 2) Achou slot e é permitido
	if card_slot_found and card_slot_found.card_type_allowed.has(card.card_type):
		if not card_slot_found.has_card: #se o slot está vazio
			player_hand.remove_card_from_hand(card)
			card.position = card_slot_found.position
			card_slot_found.card_in_slot = card
			card_slot_found.has_card = true
			card.current_slot = card_slot_found
		else:
			# Slot destino ocupado → fallback pro slot original
			if original_slot != null and not original_slot.has_card:
				card.position = original_slot.position
				original_slot.card_in_slot = card
				original_slot.has_card = true
				card.current_slot = original_slot
			else:
				card.current_slot = null
				player_hand.add_card_to_hand(card)
	else:
		# 3) Não achou slot: se não está sobre a mão, fallback pro slot original; senão já teria retornado acima
		if original_slot != null and not original_slot.has_card:
			card.position = original_slot.position
			original_slot.card_in_slot = card
			original_slot.has_card = true
			card.current_slot = original_slot
		else:
			card.current_slot = null
			player_hand.add_card_to_hand(card)

	card_being_dragged = null
	original_slot = null

func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)	
	
func on_left_click_released():
	if card_being_dragged:
		finish_drag()
	
func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)
		
func on_hovered_off_card(card):
	if !card_being_dragged:
		highlight_card(card, false)
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1

func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT 
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
		#return get_card_with_highest_z_index(result)
	return null

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD 
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return get_card_with_highest_z_index(result)
	return null
	
func raycast_check_for_hand():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_PLAYER_HAND
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()  # retorna o HandArea
	return null

func get_card_with_highest_z_index(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	
	return highest_z_card


func _on_button_pressed() -> void:
	pass # Replace with function body.
