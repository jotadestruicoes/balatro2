extends Node2D

var event_active: bool
var event_card_global 

@onready var event_deck: Node2D = $"../EventDeck"
@onready var slot_manager: Node2D = $"../SlotManager"
@onready var control: Control = $"../Control"
@onready var card_manager: Node2D = $"../CardManager"

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

func event_requisites_write(event_card):
	
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
	#
	#if event_card.resource.RequisitesAndRewards["requisites"]["cards"].size() != 0 or event_card.resource.RequisitesAndRewards["requisites"]["events"].size() != 0:
		#for i in event_card.resource.RequisitesAndRewards["requisites"]["cards"]:
			#event_card.get_node("EventRequisites").text += " (" + i + ") "
		#for j in event_card.resource.RequisitesAndRewards["requisites"]["events"]:
			#event_card.get_node("EventRequisites").text += " (" + j + ") "
#
	#else:
		#event_rewards_write(event_card)

func event_rewards_write(event_card):
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
	
func event_req_card_check():
	var array_of_cards_to_destroy: Array[Node2D] = []
	var array_of_cards_to_give: Array[Node2D] = []
	var array_of_slots_to_free: Array[Node2D] = []
	var requirements: PackedStringArray = []
	var j := 1
	
	if event_card_global != null: #IS THERE AN EVENT?
		for i in event_card_global.resource.RequisitesAndRewards["requisites"]["cards"]: 
			#adding all reqs to a list
			requirements.append(i)
			
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
			
		for card in array_of_cards_to_destroy:
			card.queue_free()
		for slot in array_of_slots_to_free:
			slot.has_card = false
			slot.card_in_slot = null
		slot_manager.get_node("SlotMiddle1").has_card = false
		slot_manager.get_node("SlotMiddle2").has_card = false
			
		if array_of_cards_to_destroy.size() == 0:
			event_rew_card_give()
			
		var tween = get_tree().create_tween()
		tween.tween_property(event_card_global, "scale", Vector2(0.0,0.0), 1.5).set_trans(Tween.TRANS_ELASTIC)
		
		control.error_message("Event complete! Congrats!")
		await tween.finished
		event_card_global.queue_free()
		unlock_current_event()
		
		return 1
			
	else:
		control.error_message("No event active at this moment!")
		return -1

func event_rew_card_give():
	pass
