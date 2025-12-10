extends Resource
class_name Card

enum CardType {
	WEAPON, 
	ARMOR, 
	CONSUMABLE, 
	MONSTER
}

enum Tier {
	ONE, TWO, THREE
}

@export var card_type: CardType
@export var tier: Tier

func get_tier():
	return self.tier
	
func get_card_type():
	return self.card_type
