extends Node2D

var event_deck = ["give2cards", "give1cards", "receive2cards"]

@onready var player_hand: Node2D = $"../PlayerHand"
@onready var card_manager: Node2D = $"../CardManager"
@onready var event_card_manager: Node2D = $"../EventCardManager"

func _ready() -> void:
	pass
	
func draw_event_card():
	event_deck.shuffle()
	
	var event_card_drawn = event_deck[0]
	var sprite_of_drawn_card = event_card_drawn
	
	#if event_deck.size() == 0: #EVENT DECK WILL NEVER BE EMPTY
		#$Area2D/CollisionShape2D.disabled = true
		#$RichTextLabel.visible = false
	
	var event_card_scene = preload("res://scenes/event_card.tscn")
	var new_card = event_card_scene.instantiate() #CREATING EVENT CARD
	new_card.position = self.position
	new_card.resource = load("res://resources/"+event_card_drawn+".tres")
	new_card.get_node("EventName").text = new_card.resource.name
	new_card.get_node("EventDescription").text = new_card.resource.description
	event_card_manager.start_event(new_card)
	
	
	#if new_card.resource.requisites.size() != 0:
		#for i in new_card.resource.requisites: #ele ta pegando 'a' em vez de pegar um index de verdade
			#new_card.get_node("EventRequisites").text = "(" + str(i) + ")"
			#print(new_card.get_node("EventRequisites").text)
			#print("(" + str(i) + ")")
	#else:
		#new_card.get_node("EventRequisites").text = "—"
	#if new_card.resource.rewards.size() != 0:
		#for i in new_card.resource.rewards: #ele ta pegando 'a' em vez de pegar um index de verdade
			#new_card.get_node("EventRewards").text = "(" + str(i) + ")"
	#else:
		#new_card.get_node("EventRewards").text = "—"
	
	
	$"../CardManager".add_child(new_card)
	
	update_event_card_position(new_card, Vector2(self.position.x - 170, self.position.y), Vector2(1.4,1.4))

		
func update_event_card_position(event_card, new_position, new_scale):
	var tween = get_tree().create_tween()
	tween.tween_property(event_card, "position", new_position, 0.2)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(event_card, "scale", new_scale, 0.2)
	
	
