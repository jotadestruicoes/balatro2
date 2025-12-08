extends Node2D

var event_deck = ["give2cards", "give1card", "receive2card"]

@onready var player_hand: Node2D = $"../PlayerHand"
@onready var card_manager: Node2D = $"../CardManager"

func _ready() -> void:
	event_deck.shuffle()
	
func draw_event_card():
	event_deck.shuffle()
	
	var event_card_drawn = event_deck[0]
	var sprite_of_drawn_card = event_card_drawn
	
	#if event_deck.size() == 0: #EVENT DECK WILL NEVER BE EMPTY
		#$Area2D/CollisionShape2D.disabled = true
		#$RichTextLabel.visible = false
	
	var event_card_scene = preload("res://misc/else/event_card.tscn")
	var new_card = event_card_scene.instantiate() #CREATING EVENT CARD
	new_card.position = self.position
	$"../CardManager".add_child(new_card)
	print(new_card.position)
	update_event_card_position(new_card, Vector2(self.position.x - 170, self.position.y), Vector2(1.4,1.4))
	
func update_event_card_position(event_card, new_position, new_scale):
	var tween = get_tree().create_tween()
	tween.tween_property(event_card, "position", new_position, 0.2)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(event_card, "scale", new_scale, 0.2)
	print(new_position)
	
