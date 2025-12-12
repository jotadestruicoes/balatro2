extends Node2D

var event_active: bool
@onready var event_deck: Node2D = $"../EventDeck"

func start_event(event_card):
	print(event_card.resource.name)
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
	
	if event_card.resource.RequisitesAndRewards["rewards"]["cards"].size() != 0 or event_card.resource.RequisitesAndRewards["rewards"]["events"].size() != 0:
		for i in event_card.resource.RequisitesAndRewards["rewards"]["cards"]:
			event_card.get_node("EventRewards").text += " (" + i + ") "
		for j in event_card.resource.RequisitesAndRewards["rewards"]["events"]:
			event_card.get_node("EventRewards").text += " (" + j + ") "
	else:
		print('wutuheeeeell') 

func lock_current_event():
	print('lock')
	event_active = true #CANNOT HAVE MORE THAN ONE PER TURN
	event_deck.get_node("Area2D/CollisionShape2D").disabled = true
	
func unlock_current_event():
	print('lock')
	event_active = false #CANNOT HAVE MORE THAN ONE PER TURN
	event_deck.get_node("Area2D/CollisionShape2D").disabled = true
	
func event_conditions_met():
	pass
