extends Node2D

var player_deck = ["skeleton", "chicken", "sword", "cap"]

@onready var player_hand: Node2D = $"../PlayerHand"
@onready var card_manager: Node2D = $"../CardManager"

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
	
	var card_scene = preload("res://misc/card/Card.tscn")
	$RichTextLabel.text = str(player_deck.size())
	
	var new_card = card_scene.instantiate()
	
	new_card.position = self.position
	new_card.get_node("CardSprite").texture = load("res://assets/card/"+ card_drawn +".png")
	new_card.resource = load("res://misc/resources/"+card_drawn+".tres")
	
	new_card.card_type = new_card.resource.card_type
	new_card.card_tier = new_card.resource.tier
	print(new_card.get_node("Name"))
	new_card.get_node("Name").text = new_card.resource.name.capitalize()
	new_card.get_node("Name").horizontal_alignment = 1
	
	
	if new_card.card_type == 3: #IF ITS A MONSTER
		new_card.get_node("Health").text = str(new_card.resource.health)
		new_card.get_node("Attack").text = str(new_card.resource.damage)
	else: 
		new_card.get_node("Attack").visible = false
		new_card.get_node("Health").visible = false
	
	
	card_manager.add_child(new_card)
	new_card.name = sprite_of_drawn_card
	player_hand.add_card_to_hand(new_card)
