extends Card
class_name MonsterCard
#THIS IS THE RESOURCE FOR A WEAPON CARD. INHERITS CARD.

enum MonsterType { 
	SHARP,
	BLUNT,
	MAGICAL
}

@export var health: int
@export var damage: int
@export var attack_speed: float
@export var monster_type: MonsterType
@export var name: String #REMEMBER ABOUT THE SPRITE LOADING
