extends Card
class_name ConsumableCard
#THIS IS THE RESOURCE FOR A WEAPON CARD. INHERITS CARD.

enum ConsumableType { 
	HEALTH,
	CARDS
}

@export var restoration: int
@export var consumable_type: ConsumableType
@export var name: String #REMEMBER ABOUT THE SPRITE LOADING
