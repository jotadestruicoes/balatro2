extends Node2D

signal hovered
signal hovered_off

var card_type
var card_tier
var hand_original_pos

var resource: Resource
@onready var deck: Node2D = $"../../Deck"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#deck.send_card_sprite_and_res.connect(set_sprite_and_resource)
	get_parent().connect_card_signals(self)
	
	match card_tier: #DYNAMIC TIERING IN THE LABEL "$Tier"
		_: 
			$Tier.text = "T" + str(card_tier + 1)


func _on_generic_card_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_generic_card_mouse_exited() -> void:
	emit_signal("hovered_off", self)
