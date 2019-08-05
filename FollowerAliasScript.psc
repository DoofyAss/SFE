ScriptName FollowerAliasScript extends ReferenceAlias

DialogueFollowerScript property DialogueFollower auto



event OnUpdateGameTime()

	if Self.GetActorRef().GetAV("WaitingforPlayer") == 0
		;	"kill the update if the follower isn't waiting anymore"
		Self.UnRegisterForUpdateGameTime()
	else
		;	"Dismissing the follower because he is waiting and 3 days have passed."
		DialogueFollower.DismissCurrentFollowerRef(Self.GetActorRef(), 1)
		Self.UnRegisterForUpdateGameTime()
	endif
endEvent



event OnUnload()

	;	"if follower unloads while waiting for the player, wait 3 days then dismiss him."
	
	if Self.GetActorRef().GetAV("WaitingforPlayer") == 1
		DialogueFollower.CurrentFollowerWaitRef(Self.GetActorRef())
	endIf
endEvent



event OnCombatStateChanged(Actor akTarget, int aeCombatState)

	;	"Dismissing follower because he is now attacking the player"
	
	if (akTarget == Game.GetPlayer())
		DialogueFollower.DismissCurrentFollowerRef(Self.GetActorRef(), 0)
	endif
endEvent



event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

	;	"Fix - equipped weapon with magic in one hand"
	;	"Fuck you FollowerHuntingBow and FollowerIronArrow"
	
	Actor Follower = Self.GetActorRef()
	
	;	"Both fist"
	
	if Follower.GetEquippedItemType(0) == 0 && Follower.GetEquippedItemType(1) == 0
		Follower.UnequipSpell(Follower.GetEquippedSpell(0), 0)
		Follower.UnequipSpell(Follower.GetEquippedSpell(1), 1)
	endif
	
	if akBaseObject as Weapon
	
		int weaponType = (akBaseObject as Weapon).GetWeaponType()
		
		; "Left Hand"
		
		if Follower.GetEquippedItemType(0) == weaponType
			Follower.UnequipSpell(Follower.GetEquippedSpell(0), 0)
		endif
		
		; "Right Hand"
		
		if Follower.GetEquippedItemType(1) == weaponType
			Follower.UnequipSpell(Follower.GetEquippedSpell(1), 1)
		endif
	endif
endEvent



event OnDeath(Actor akKiller)

	;	"Clearing the follower because the player killed him."
	DialogueFollower.DismissCurrentFollowerRef(Self.GetActorRef(), 2)
endEvent
