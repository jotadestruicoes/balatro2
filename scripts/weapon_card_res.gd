extends Card
class_name WeaponCard
#THIS IS THE RESOURCE FOR A WEAPON CARD. INHERITS CARD.

enum WeaponType { 
	RANGED,
	SHARP,
	BLUNT
}

@export var damage: int
@export var weapon_type: WeaponType
@export var name: String #REMEMBER ABOUT THE SPRITE LOADING
