extends Node2D

var event_active: bool
var global_event_card 
var current_score := 0 

@onready var event_deck: Node2D = $"../EventDeck"
@onready var slot_manager: Node2D = $"../SlotManager"
@onready var control: Control = $"../Control"
@onready var card_manager: Node2D = $"../CardManager"
@onready var deck: Node2D = $"../Deck"
const CARD = preload("res://scenes/Card.tscn")

func start_event(event_card):
	global_event_card = event_card
	event_requisites_write(event_card)
	lock_current_event()

func get_event_requisites_cards(event_card):
	if event_card.resource.RequisitesAndRewards["requisites"]["cards"].size() != 0:
		var event_requisites_cards_array: Array[String]
		for i in event_card.resource.RequisitesAndRewards["requisites"]["cards"]:
			event_requisites_cards_array.append("(" + i + ")")
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
	
	var slots_with_cards: Array[String]
	var free_slots: Array[StringName] = []
	var max_slots = 3
	var slot_number = 1
	var requisites: PackedStringArray = []
	var j := 1
	
	if global_event_card != null: #IS THERE AN EVENT?
		#if count_empty_slots(3, free_slots, 1).size() < get_event_rewards_cards(global_event_card).size(): 
			#control.error_message("Free up the slots, take your cards!")
			#return
			
		for i in get_event_requisites_cards(global_event_card): 
			#adding all reqs to a list
			requisites.append(i) # ex [" (g) ", " (g) "]
			
		if requisites.is_empty(): # []
			event_rew_card_give()
			print("requisites empty")
			return 0
		
		for i in max_slots: #CONTANDO SLOTS COM CARTAS
			var slot_path := "SlotMiddle" + str(slot_number) # "SlotMiddle" + "1"
			var slot = slot_manager.get_node(slot_path)
			
			if slot.card_in_slot != null: #IF IT HAS A CARD
				slots_with_cards.append(slot_path) # ex slots_with_cards = [ $SlotMiddle1, $SlotMiddle3 ]
				# #we'll use to free the slots later
				 
			slot_number += 1
			
		
		#ADICIONAR AQUI A CHECAGEM DE REWARDS... 
			#MESMA LÓGICA DE CARTAS DE REWARDS SÓ QUE NO REQUISITES PRA TER ESPAÇO 
			#DEPOIS PRA ENTREGAR OS REWARDS
			
		if slots_with_cards.size() >= requisites.size(): #HAS ENOUGH CARDS IN THE TABLE
			var requisites_left = requisites.size() #FALTA ADICIONAR VERIFICADOR DE TIPO
			for req in requisites:
				var slots_copy = slots_with_cards.duplicate()
				for slot in slots_copy:
					if requisites_left > 0:
						var card = slot_manager.get_node(slot).card_in_slot
						var card_type = card.card_type

						if letter_to_type(req, card_type) == card_type: #int and int ok
							print("req: ", letter_to_type(req, card_type))
							print(card_type)
							array_of_cards_to_destroy.append(card)
							slots_with_cards.erase(slot) # remove da lista original
							array_of_slots_to_free.append(slot_manager.get_node(slot))
							requisites_left -= 1
							break
						else:
							control.error_message("Wrong card type!")
							return							
		else: 
			control.error_message("Not enough cards!")
			return 0
			
		animate_cards(array_of_cards_to_destroy, array_of_slots_to_free)
		event_rew_card_give()
			
		var tween = get_tree().create_tween() #animate event card
		tween.tween_property(global_event_card, "scale", Vector2(0.0,0.0), 1.5).set_trans(Tween.TRANS_ELASTIC)
		
		control.get_node("DoIt/DoItLabelArea/CollisionShape2D").disabled = true
		control.error_message("Event complete! Congrats!")
		await tween.finished
		global_event_card.queue_free()
		control.get_node("DoIt/DoItLabelArea/CollisionShape2D").disabled = false
		unlock_current_event()
		
		return 1
			
	else:
		control.error_message("No event active at this moment!")
		return -1

func letter_to_type(letter, card_type):
	match letter:
		"(g)": 
			return card_type
		"(c)":
			return Card.CardType.CONSUMABLE
		"(a)":
			return Card.CardType.ARMOR
		"(w)":
			return Card.CardType.WEAPON
		"(m)":
			return Card.CardType.MONSTER
			
func event_rew_card_give() -> void:
	var rewards: PackedStringArray = []
	
	# 1. Coletar todas as cartas recompensa
	for card_name in global_event_card.resource.RequisitesAndRewards["rewards"]["cards"]:
		rewards.append(card_name) #QUANTAS CARTAS PRECISA-SE ENTREGAR

	if rewards.is_empty():
		return # nada a fazer

	var free_slots: Array[StringName] = [] #QUANTOS SLOTS LIVRES TEMOS PARA ENTREGAR
	var slot_number := 1 #SLOT1, SLOT 2 E SLOT 3
	var max_slots := 3 #HOW MANY SLOTS DO WE HAVE - HAS TO BE UPDATED IF WE ADD MORE

	free_slots = count_empty_slots(max_slots, free_slots, slot_number) #returns free_slots
		
	# 3. Se há slots suficientes, entregar as cartas
	if free_slots.size() >= rewards.size():
		for index in range(rewards.size()):
			var slot_path = free_slots[index]
			var slot = slot_manager.get_node(str(slot_path))
			var pos = slot.position
			var card_name = rewards[index]
		
			deck.receive_card(card_name, pos)

		var tween = get_tree().create_tween()
		tween.tween_property(global_event_card, "scale", Vector2(0.0,0.0), 1.5).set_trans(Tween.TRANS_ELASTIC)
		
		control.error_message("Event complete! Congrats!")
		await tween.finished
		global_event_card.queue_free()
		unlock_current_event()
	else:
		control.error_message("Free up the slots, take your cards!")
		return

func animate_cards(array_of_cards_to_destroy, array_of_slots_to_free):
	control.get_node("DoIt/DoItLabelArea/CollisionShape2D").disabled = false
	for card in array_of_cards_to_destroy:
		var tween = get_tree().create_tween()
		tween.tween_property(card, "scale", Vector2(0.0,0.0), 1.5).set_trans(Tween.TRANS_ELASTIC)
		erase_card(card, tween)
		
	for slot in array_of_slots_to_free:
		slot.has_card = false
		slot.card_in_slot = null

func erase_card(card, tween):
	await tween.finished 
	card.queue_free()

func count_empty_slots(max_slots, free_slots, slot_number):
	for i in max_slots: #CONTANDO SLOTS LIVRES
		var slot_path := "SlotMiddle" + str(slot_number)
		var slot = slot_manager.get_node(slot_path)
		
		if slot.card_in_slot == null:
			free_slots.append(slot_path)
			
		slot_number += 1
	return free_slots
