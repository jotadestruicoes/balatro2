extends Resource
class_name Card

enum CardType {
	WEAPON,  #0
	ARMOR,   #1
	CONSUMABLE,  #2
	MONSTER, #3
	GENERIC #4
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
