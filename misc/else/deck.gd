extends Node2D

var player_deck = ["skeleton", "chicken", "sword", "plate"]

@onready var player_hand: Node2D = $"../PlayerHand"
@onready var card_manager: Node2D = $"../CardManager"

signal send_card_sprite_and_res(name: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
	self.emit_signal("send_card_sprite_and_res")
	new_card.position = self.position
	
	
	#new_card.card_type = CardTypes.
	#new_card.get_node("Attack").text = CardTypes[card_drawn][0]
	#new_card.get_node("Health").text = CardTypes[card_drawn][1]
	
	card_manager.add_child(new_card)
	new_card.name = sprite_of_drawn_card
	player_hand.add_card_to_hand(new_card)
