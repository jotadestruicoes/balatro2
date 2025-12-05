extends Card
class_name ArmorCard
#THIS IS THE RESOURCE FOR A WEAPON CARD. INHERITS CARD.

enum ArmorType { 
	SHARPBLUNT,
	SHARP,
	BLUNT,
	MAGICAL
}

@export var defense: int
@export var armor_type: ArmorType
@export var name: String #REMEMBER ABOUT THE SPRITE LOADING
