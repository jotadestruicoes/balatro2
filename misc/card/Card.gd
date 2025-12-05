extends Node2D

signal hovered
signal hovered_off

var card_type
var hand_original_pos

@export var resource: Resource
@onready var deck: Node2D = $"../../Deck"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck.send_card_sprite_and_res.connect(set_sprite_and_resource.bind("card_drawn"))
	get_parent().connect_card_signals(self)
	
func set_sprite_and_resource(card_drawn):
	var sprite = $CardSprite.texture
	sprite = load("res://assets/card/"+card_drawn+".png")
	resource = load("res://misc/resources/"+card_drawn+".tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_generic_card_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_generic_card_mouse_exited() -> void:
	emit_signal("hovered_off", self)
