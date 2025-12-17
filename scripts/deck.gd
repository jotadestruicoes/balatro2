extends Node2D

var player_deck = ["skeleton", "chicken", "sword", "cap"]

@onready var player_hand: Node2D = $"../PlayerHand"
@onready var card_manager: Node2D = $"../CardManager"
var card_scene = preload("res://scenes/Card.tscn")
#signal send_card_sprite_and_res(name: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck.shuffle()
	$RichTextLabel.text = str(player_deck.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func draw_card():
	var card_drawn = player_deck[0]
	var sprite_of_drawn_card = card_drawn
	player_deck.erase(card_drawn)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$RichTextLabel.visible = false
	

	$RichTextLabel.text = str(player_deck.size())
	
	var new_card = card_scene.instantiate()
	
	new_card.position = self.position
	new_card.get_node("CardSprite").texture = load("res://assets/card/"+ card_drawn +".png")
	new_card.resource = load("res://resources/cards/"+card_drawn+".tres")
	
	new_card.card_type = new_card.resource.card_type
	new_card.card_tier = new_card.resource.tier
	new_card.get_node("Name").text = new_card.resource.name.capitalize()
	new_card.get_node("Name").horizontal_alignment = 1
	
	card_manager.add_child(new_card)
	new_card.name = sprite_of_drawn_card
	player_hand.add_card_to_hand(new_card)

func receive_card(card_type, slot_pos):
	var random_card
	var card_dictionary: PackedStringArray = [] #well copy the part of the card 
												#dictionary that we want here
	match card_type:
		"g":
			for i in CardDictionary.card_dictionary: #generic, so any card, etc
				print("i: ", i)
				var index := 0
				for j in CardDictionary.card_dictionary[i]: #for every card in every array of the dictionary
					card_dictionary.append(CardDictionary.card_dictionary[i][index])  #...add to our BIG long array
					index += 1
			
			var rng = RandomNumberGenerator.new()
			var random_index = rng.randi_range(0, card_dictionary.size() - 1) 
			random_card = card_dictionary[random_index] #get a random card of all the cards
			
			instantiate_card(random_card, slot_pos)
		"w":
			get_random_card_from_set_card_type("weapon", card_dictionary, random_card, slot_pos)
		"a":
			get_random_card_from_set_card_type("armor", card_dictionary, random_card, slot_pos)
		"c":
			get_random_card_from_set_card_type("consumable", card_dictionary, random_card, slot_pos)
		"m":
			get_random_card_from_set_card_type("monster", card_dictionary, random_card, slot_pos)
		#ADD OTHER CARD TYPES HERE
	
func get_random_card_from_set_card_type(card_type, card_dictionary, random_card, slot_pos):
		var index := 0
		for i in CardDictionary.card_dictionary[card_type]: #consumables
			 #for every card in every array of the dictionary
			card_dictionary.append(CardDictionary.card_dictionary[card_type][index])  #...add to our BIG long array
			index += 1
		
		var rng = RandomNumberGenerator.new()
		var random_index = rng.randi_range(0, card_dictionary.size() - 1) 
		random_card = card_dictionary[random_index] #get a random card of all the cards
		instantiate_card(random_card, slot_pos)
	

func instantiate_card(random_card, slot_pos):
		var new_card = card_scene.instantiate()

		new_card.position = slot_pos
		new_card.get_node("CardSprite").texture = load("res://assets/card/"+ random_card +".png")
		new_card.resource = load("res://resources/cards/" + random_card + ".tres")
		
		new_card.card_type = new_card.resource.card_type
		new_card.card_tier = new_card.resource.tier
		new_card.get_node("Name").text = new_card.resource.name.capitalize()
		new_card.get_node("Name").horizontal_alignment = 1
					
		card_manager.add_child(new_card)
		new_card.name = random_card
		player_hand.add_card_to_hand(new_card)
