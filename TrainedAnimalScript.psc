ScriptName TrainedAnimalScript extends ReferenceAlias

DialogueFollowerScript Property DialogueFollower Auto



event OnUpdateGameTime()

	if Self.GetActorRef().GetAV("WaitingforPlayer") == 0
		;	"kill the update if the animal isn't waiting anymore"
		
		Self.UnRegisterForUpdateGameTime()
	else
		;	"Dismissing the animal because he is waiting and 3 days have passed."
		
		DialogueFollower.DismissAnimal()
		Self.UnRegisterForUpdateGameTime()
	endif
endEvent



event OnUnload()

	;	"if animal unloads while waiting for the player, wait 3 days then dismiss him."
	
	if Self.GetActorRef().GetAV("WaitingforPlayer") == 1
		DialogueFollower.AnimalWait()
	endif
endEvent



event OnCombatStateChanged(Actor akTarget, int aeCombatState)

	;	"Dismissing follower because he is now attacking the player"
	
	if (akTarget == Game.GetPlayer())
		DialogueFollower.DismissAnimal()
	endif
endEvent



event OnDeath(Actor akKiller)

	;	"Clearing the animal because the player killed him."
	
	DialogueFollower.DismissAnimal()
endEvent
