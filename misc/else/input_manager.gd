extends Node2D

signal left_mouse_button_cliked
signal left_mouse_button_released

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 4

@onready var card_manager: Node2D = $"../CardManager"
@onready var deck: Node2D = $"../Deck"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			emit_signal("left_mouse_button_cliked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")
			pass

func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	
	var results = space_state.intersect_point(parameters)
	if results.is_empty():
		return
	
	for r in results:
		var collider = r.collider
		var layer = collider.collision_layer
		
		if layer == COLLISION_MASK_CARD:
			var card_found = collider.get_parent()
			if card_found:
				card_manager.start_drag(card_found)
			return  # já encontrou uma carta, não precisa continuar
		
		elif layer == COLLISION_MASK_DECK:
			deck.draw_card()
			return  # já encontrou o deck, não precisa continuar


#func raycast_at_cursor():
	#var space_state = get_world_2d().direct_space_state
	#var parameters = PhysicsPointQueryParameters2D.new()
	#parameters.position = get_global_mouse_position()
	#parameters.collide_with_areas = true
	#var result = space_state.intersect_point(parameters)
	#if result.size() > 0:
		#print(result)
		#var result_collision_mask = result[0].collider.collision_mask
		#if result_collision_mask == COLLISION_MASK_CARD:
			##deck clicked
			#var card_found = result[0].collider.get_parent()
			#if card_found:
				#card_manager.start_drag(card_found)
		#elif result_collision_mask == COLLISION_MASK_DECK:
			##deck clicked
			#deck.draw_card()
