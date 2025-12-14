extends Node2D

var event_active: bool
var event_card_global 
var current_score := 0 

@onready var event_deck: Node2D = $"../EventDeck"
@onready var slot_manager: Node2D = $"../SlotManager"
@onready var control: Control = $"../Control"
@onready var card_manager: Node2D = $"../CardManager"
@onready var deck: Node2D = $"../Deck"
const CARD = preload("res://scenes/Card.tscn")

func start_event(event_card):
	event_card_global = event_card
	event_requisites_write(event_card)
	lock_current_event()

func get_event_requisites_cards(event_card):
	if event_card.resource.RequisitesAndRewards["requisites"]["cards"].size() != 0:
		var event_requisites_cards_array: Array[String]
		for i in event_card.resource.RequisitesAndRewards["requisites"]["cards"]:
			event_requisites_cards_array.append(" (" + i + ") ")
		return event_requisites_cards_array
	else: 
		return []

func get_event_requisites_events(event_card):
	if event_card.resource.RequisitesAndRewards["requisites"]["events"].size() != 0:
		var event_requisites_events_array: Array[String]
		for j in event_card.resource.RequisitesAndRewards["requisites"]["events"]:
			event_requisites_events_array.append(" (" + j + ") ")
		return event_requisites_events_array
	else: 
		return []

func get_event_rewards_cards(event_card):
	if event_card.resource.RequisitesAndRewards["rewards"]["cards"].size() != 0:
		var event_rewards_cards_array: Array[String]
		for i in event_card.resource.RequisitesAndRewards["rewards"]["cards"]:
			event_rewards_cards_array.append(" (" + i + ") ")
		return event_rewards_cards_array
	else: 
		return []

func get_event_rewards_events(event_card):
	if event_card.resource.RequisitesAndRewards["rewards"]["events"].size() != 0:
		var event_rewards_events_array: Array[String]
		for j in event_card.resource.RequisitesAndRewards["rewards"]["events"]:
			event_rewards_events_array.append(" (" + j + ") ")
		return event_rewards_events_array
	else: 
		return []

func event_requisites_write(event_card): #WRITE REQUISITES ON CARD
	
	var erc = get_event_requisites_cards(event_card)
	var ere = get_event_requisites_events(event_card)  
	var erc2 = get_event_rewards_cards(event_card)
	var ere2 = get_event_rewards_events(event_card)  
	
	for card in erc:
		event_card.get_node("EventRequisites").text += card
	for card in ere:
		event_card.get_node("EventRequisites").text += card
	for card in erc2:
		event_card.get_node("EventRewards").text += card
	for card in ere2:
		event_card.get_node("EventRewards").text += card

func event_rewards_write(event_card): #WRITE REWARDS ON CARD
	var reqsandrew = event_card.resource.RequisitesAndRewards
	
	if reqsandrew["rewards"]["cards"].size() != 0 or reqsandrew["rewards"]["events"].size() != 0:
		for i in reqsandrew["rewards"]["cards"]:
			event_card.get_node("EventRewards").text += " (" + i + ") "
		for j in reqsandrew["rewards"]["events"]:
			event_card.get_node("EventRewards").text += " (" + j + ") "
	else:
		print('wutuheeeeell') 

func lock_current_event():
	event_active = true #CANNOT HAVE MORE THAN ONE PER TURN
	event_deck.get_node("Area2D/CollisionShape2D").disabled = true
	
func unlock_current_event():
	event_active = false #CANNOT HAVE MORE THAN ONE PER TURN
	event_deck.get_node("Area2D/CollisionShape2D").disabled = false
	score()
	
func score():
	current_score += 1
	control.current_score_number.text = str(current_score)
	
	if int(control.current_score_number.text) >= int(control.high_score_number.text):
		control.high_score_number.text = control.current_score_number.text
		control.save(int(control.current_score_number.text))
	
func event_req_card_check():
	var array_of_cards_to_destroy: Array[Node2D] = []
	var array_of_cards_to_give: Array[Node2D] = []
	var array_of_slots_to_free: Array[Node2D] = []
	var requirements: PackedStringArray = []
	var j := 1
	
	if event_card_global != null: #IS THERE AN EVENT?
		for i in get_event_requisites_cards(event_card_global): 
			#adding all reqs to a list
			requirements.append(i)
			
		if requirements.is_empty():
			event_rew_card_give()
			print("requirements empty")
			return 0
		
		for i in requirements: #for every requirement check a slot and notes the card to be taken
			if slot_manager.get_node("SlotMiddle" + str(requirements.bsearch(i) + j)).card_in_slot != null:
				#has a card in the j slot
				array_of_cards_to_destroy.append(slot_manager.get_node("SlotMiddle" + str(requirements.bsearch(i) + j)).card_in_slot)
				array_of_slots_to_free.append(slot_manager.get_node("SlotMiddle" + str(requirements.bsearch(i) + j)))
				j += 1
			else:
				#does not have card
				control.error_message("Event requirements not met!")
				return 0
			
		animate_cards(array_of_cards_to_destroy, array_of_slots_to_free)
			
			
		var tween = get_tree().create_tween() #animate event card
		tween.tween_property(event_card_global, "scale", Vector2(0.0,0.0), 1.5).set_trans(Tween.TRANS_ELASTIC)
		
		
		control.error_message("Event complete! Congrats!")
		await tween.finished
		event_card_global.queue_free()
		unlock_current_event()
		
		return 1
			
	else:
		control.error_message("No event active at this moment!")
		return -1

func animate_cards(array_of_cards_to_destroy, array_of_slots_to_free):
	for card in array_of_cards_to_destroy:
		var tween = get_tree().create_tween()
		tween.tween_property(card, "scale", Vector2(0.0,0.0), 1.5).set_trans(Tween.TRANS_ELASTIC)
		erase_card(card, tween)
		
	for slot in array_of_slots_to_free:
		slot.has_card = false
		slot.card_in_slot = null
	slot_manager.get_node("SlotMiddle1").has_card = false
	slot_manager.get_node("SlotMiddle2").has_card = false

func erase_card(card, tween):
	await tween.finished 
	card.queue_free()

func event_rew_card_give() -> void:
	var rewards: PackedStringArray = []
	
	# 1. Coletar todas as cartas recompensa
	for card_name in event_card_global.resource.RequisitesAndRewards["rewards"]["cards"]:
		rewards.append(card_name) #QUANTAS CARTAS PRECISA-SE ENTREGAR

	if rewards.is_empty():
		return # nada a fazer

	var free_slots: Array[StringName] = [] #QUANTOS SLOTS LIVRES TEMOS PARA ENTREGAR
	var slot_number := 1 #SLOT1, SLOT 2 E SLOT 3
	var max_slots := 3 #HOW MANY SLOTS DO WE HAVE - HAS TO BE UPDATED IF WE ADD MORE

	for i in max_slots: #CONTANDO SLOTS LIVRES
		var slot_path := "SlotMiddle" + str(slot_number)
		var slot = slot_manager.get_node(slot_path)
		
		if slot.card_in_slot == null:
			free_slots.append(slot_path)
			
		slot_number += 1
		
	# 3. Se há slots suficientes, entregar as cartas
	if free_slots.size() >= rewards.size():
		for index in range(rewards.size()):
			var slot_path = free_slots[index]
			var slot = slot_manager.get_node(str(slot_path))
			var pos = slot.position
			var card_name = rewards[index]

			deck.receive_card(card_name, pos)
		
		control.get_node("DoIt/DoItLabelArea/CollisionShape2D").disabled = true
		var tween = get_tree().create_tween()
		tween.tween_property(event_card_global, "scale", Vector2(0.0,0.0), 1.5).set_trans(Tween.TRANS_ELASTIC)
		
		control.error_message("Event complete! Congrats!")
		await tween.finished
		event_card_global.queue_free()
		unlock_current_event()
	else:
		control.error_message("Free up the slots, take your cards!")
		return


	
