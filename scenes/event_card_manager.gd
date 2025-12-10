extends Node2D

func start_event(event_card):
	print(event_card.resource.name)
	event_requisites_check(event_card)
		
func event_requisites_check(event_card):
	
	if event_card.resource.RequisitesAndRewards["requisites"]["cards"].size() != 0 or event_card.resource.RequisitesAndRewards["requisites"]["events"].size() != 0:
		for i in event_card.resource.RequisitesAndRewards["requisites"]["cards"]:
			event_card.get_node("EventRequisites").text += " (" + i + ") "
		for j in event_card.resource.RequisitesAndRewards["requisites"]["events"]:
			event_card.get_node("EventRequisites").text += " (" + j + ") "

	else:
		event_rewards_check(event_card)

func event_rewards_check(event_card):
	var reqsandrew = event_card.resource.RequisitesAndRewards
	
	if event_card.resource.RequisitesAndRewards["rewards"]["cards"].size() != 0 or event_card.resource.RequisitesAndRewards["rewards"]["events"].size() != 0:
		for i in event_card.resource.RequisitesAndRewards["rewards"]["cards"]:
			event_card.get_node("EventRewards").text += " (" + i + ") "
		for j in event_card.resource.RequisitesAndRewards["rewards"]["events"]:
			event_card.get_node("EventRewards").text += " (" + j + ") "
	else:
		print('wutuheeeeell') 
