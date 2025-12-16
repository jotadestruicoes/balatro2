extends Node2D

signal hovered
signal hovered_off

var card_type
var card_tier
var hand_original_pos
var current_slot = null

var resource: Resource
@onready var deck: Node2D = $"../../Deck"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#deck.send_card_sprite_and_res.connect(set_sprite_and_resource)
	get_parent().connect_card_signals(self)
	
	self.get_node("Attack").visible = false
	self.get_node("Health").visible = false
	self.get_node("Attack2").visible = false
	self.get_node("Health2").visible = false
	self.get_node("Shield").visible = false
	
	match self.resource.card_type:
		3:
			self.get_node("Health").visible = true
			self.get_node("Attack").visible = true
			self.get_node("Health").text = str(self.resource.health)
			self.get_node("Attack").text = str(self.resource.damage)
			self.get_node("Attack2").visible = true
			self.get_node("Health2").visible = true
		2: #consumable
			pass
		1: #armor
			self.get_node("Shield").visible = true
			self.get_node("Health").visible = true
			self.get_node("Health").text = str(self.resource.defense)
		0: #weapon
			self.get_node("Attack2").visible = true
			self.get_node("Attack").visible = true
			self.get_node("Attack").text = str(self.resource.damage)



	tiering()

func tiering():
	match card_tier: #DYNAMIC TIERING IN THE LABEL "$Tier"
		_: 
			$Tier.text = "T" + str(card_tier + 1)

func _on_generic_card_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_generic_card_mouse_exited() -> void:
	emit_signal("hovered_off", self)
