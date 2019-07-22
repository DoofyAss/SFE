;/
	Mr. Black	"mr.black.developer@gmail.com"
	2019.07.16
/;

ScriptName DialogueFollowerScript extends Quest conditional

Message property AnimalDismissMessage auto
Message property FollowerDismissMessage auto
Message property FollowerDismissMessageCompanions auto
Message property FollowerDismissMessageCompanionsFemale auto
Message property FollowerDismissMessageCompanionsMale auto
Message property FollowerDismissMessageWait auto
Message property FollowerDismissMessageWedding auto

SetHirelingRehire property HirelingRehireScript auto

Faction property pCurrentHireling auto
Faction property pDismissedFollower auto

ReferenceAlias property pAnimalAlias auto
GlobalVariable property pPlayerAnimalCount auto

ReferenceAlias[] property FollowerAlias auto
GlobalVariable property PlayerFollowerCount auto
GlobalVariable property PlayerFollowerMaxCount auto

EffectShader property EffectWait auto
EffectShader property EffectFollow auto
EffectShader property EffectSetFollower auto
EffectShader property EffectDismiss auto

Idle property AnimWait auto
Idle property AnimFollows auto
Idle property AnimDismiss auto
Idle property AnimIdleStop auto
Idle property AnimIdleMagic auto
Idle property AnimCleanSword auto
Idle property AnimShieldCheer auto











;	Misc		----------------------------------------------------------------------------------------------------

int function GetFollowerSlot(Actor Follower)
	int slot = 0
	int i = 0
	
	while i < FollowerAlias.length
		if FollowerAlias[i].GetActorRef() == Follower
			slot = i
		endif
		i += 1
	endwhile
	
	return slot
endFunction



int function GetFreeSlot()
	int i = 0
	
	while i < FollowerAlias.length
		if FollowerAlias[i].GetActorRef() == none
			return i
		endif
		i += 1
	endwhile
endFunction



function ResetFollowerCount()

	int count = 0
	int i = 0
	
	while i < FollowerAlias.length
		if FollowerAlias[i].GetActorRef() != none
			count += 1
		endif
		i += 1
	endwhile
	
	PlayerFollowerCount.SetValue(count)
endFunction



function Debug()

	; Debug.Notification("Follower01: " + FollowerAlias[0].GetActorReference().GetBaseObject().GetName())
	
	string names
	int i = 0
	
	while i < FollowerAlias.length
		if FollowerAlias[i].GetActorRef() != none
			names = names + (i + 1) + ". " + FollowerAlias[i].GetActorReference().GetBaseObject().GetName() + "\n"
		endif
		i += 1
	endwhile
	
	Debug.MessageBox(names)
	
endFunction










;	Speaker		----------------------------------------------------------------------------------------------------

function SpeakerAnimWait(Actor Follower)

	Follower.PlayIdle(AnimIdleStop)
	
	if Follower.GetActorBase().GetSex() == 1
		Follower.PlayIdle(AnimWait)
		Utility.Wait(2)
	endif
endFunction



function SpeakerAnimFollow(Actor Follower)

	Follower.PlayIdle(AnimIdleStop)
	
	;	"if follower has shield in left hand"
	if (Follower.GetEquippedItemType(0) == 10)
		Follower.DrawWeapon()
		Utility.Wait(2)
		Follower.PlayIdle(AnimShieldCheer)
		Utility.Wait(2)
		Follower.SheatheWeapon()
	;	"if follower has sword in right hand"
	elseif (Follower.GetEquippedItemType(1) == 1)
		Follower.PlayIdle(AnimCleanSword)
	else
		if Follower.GetActorBase().GetSex() == 1
			;	"if female has magic spell in right hand"
			if (Follower.GetEquippedItemType(1) == 9)
				Follower.PlayIdle(AnimIdleMagic)
			else
				Follower.PlayIdle(AnimFollows)
			endIf
		endif
	endif
	
	Utility.Wait(3)
	
endFunction



function SpeakerDismiss(Actor Follower)

	DismissCurrentFollower(GetFollowerSlot(Follower), 0)
endFunction



function SpeakerDismissGroup()

	int i = 0
	
	while i < FollowerAlias.length
		if FollowerAlias[i].GetActorRef() != none
			DismissCurrentFollower(i, 0)
		endif
		i += 1
	endwhile
	
	Utility.Wait(2)
endFunction



function SpeakerWait(Actor Follower)

	ResetFollowerCount()
	CurrentFollowerWait(GetFollowerSlot(Follower))
endFunction



function SpeakerWaitGroup()

	int i = 0
	
	while i < FollowerAlias.length
		if FollowerAlias[i].GetActorRef() != none
			CurrentFollowerWait(i)
		endif
		i += 1
	endwhile
endFunction



function SpeakerFollow(Actor Follower)

	CurrentFollowerFollow(GetFollowerSlot(Follower))
endFunction



function SpeakerFollowGroup()

	int i = 0
	
	while i < FollowerAlias.length
		if FollowerAlias[i].GetActorRef() != none
			CurrentFollowerFollow(i)
		endif
		i += 1
	endwhile
endFunction










;	Follower	----------------------------------------------------------------------------------------------------



function SetFollower(ObjectReference FollowerRef)
	
	ResetFollowerCount()
	
	Actor Follower = FollowerRef as Actor
	Follower.RemoveFromFaction(pDismissedFollower)
	if Follower.GetRelationshipRank(Game.GetPlayer()) < 3 && Follower.GetRelationshipRank(Game.GetPlayer()) >= 0
		Follower.SetRelationshipRank(Game.GetPlayer(), 3)
	endIf
	Follower.SetPlayerTeammate(true, true)
	int FollowerCount = PlayerFollowerCount.GetValue() as int
	PlayerFollowerCount.SetValue(FollowerCount + 1)
	
	FollowerAlias[GetFreeSlot()].ForceRefTo(Follower)
	
	EffectSetFollower.Play(Follower, 3.0)
endFunction



function DismissCurrentFollower(int i, int reason)

	Actor Follower = FollowerAlias[i].GetActorRef()
	
	Follower.PlayIdle(AnimIdleStop)
	Follower.PlayIdle(AnimDismiss)
	
	if reason == 1
		FollowerDismissMessageWait.Show()
	elseif reason == 2
		;	"follower is dead"
	else
		FollowerDismissMessage.Show()
	endIf
	
	Debug.Notification(Follower.GetActorBase().GetName())
	
	Follower.StopCombatAlarm()
	Follower.AddToFaction(pDismissedFollower)
	Follower.SetPlayerTeammate(false, true)
	Follower.RemoveFromFaction(pCurrentHireling)
	Follower.SetAV("WaitingForPlayer", 0)
	HirelingRehireScript.DismissHireling(Follower.GetActorBase())
	
	FollowerAlias[i].Clear()
	int FollowerCount = PlayerFollowerCount.GetValue() as int
	PlayerFollowerCount.SetValue(FollowerCount - 1)
	
	EffectDismiss.Play(Follower, 3.0)
	Follower.EvaluatePackage()
endFunction



function DismissCurrentFollowerRef(Actor Follower, int reason)

	DismissCurrentFollower(GetFollowerSlot(Follower), reason)
endFunction



function CurrentFollowerWait(int i)

	Actor Follower = FollowerAlias[i].GetActorRef()
	EffectWait.Play(Follower, 3.0)
	Follower.SetAV("WaitingForPlayer", 1)
	FollowerAlias[i].RegisterForUpdateGameTime(72)
endFunction



function CurrentFollowerWaitRef(Actor Follower)

	CurrentFollowerWait(GetFollowerSlot(Follower))
endFunction



function CurrentFollowerFollow(int i)

	Actor Follower = FollowerAlias[i].GetActorRef()
	EffectFollow.Play(Follower, 3.0)
	Follower.SetAV("WaitingForPlayer", 0)
	Self.SetObjectiveDisplayed(10, false, false)
endFunction










;	just in case	------------------------------------------------------------------------------------------------


function DismissFollower(int iMessage, int iSayLine)

	if iMessage == 0
		FollowerDismissMessage.Show()
	elseIf iMessage == 1
		FollowerDismissMessageWedding.Show()
	elseIf iMessage == 2
		FollowerDismissMessageCompanions.Show()
	elseIf iMessage == 3
		FollowerDismissMessageCompanionsMale.Show()
	elseIf iMessage == 4
		FollowerDismissMessageCompanionsFemale.Show()
	elseIf iMessage == 5
		FollowerDismissMessageWait.Show()
	else
		FollowerDismissMessage.Show()
	endIf
	
	SpeakerDismissGroup()

endFunction










;	Animal		----------------------------------------------------------------------------------------------------



function SetAnimal(ObjectReference AnimalRef)

	Actor AnimalActor = AnimalRef as Actor
	AnimalActor.SetAV("Lockpicking", 0)
	AnimalActor.SetRelationshipRank(Game.GetPlayer(), 3)
	AnimalActor.SetPlayerTeammate(true, false)
	pAnimalAlias.ForceRefTo(AnimalActor)
	pPlayerAnimalCount.SetValue(1)
endFunction



function AnimalWait()

	Actor AnimalActor = pAnimalAlias.GetActorRef()
	AnimalActor.SetAV("WaitingForPlayer", 1)
	pAnimalAlias.RegisterForUpdateGameTime(72)
endFunction



function AnimalFollow()

	Actor AnimalActor = pAnimalAlias.GetActorRef()
	AnimalActor.SetAV("WaitingForPlayer", 0)
	self.SetObjectiveDisplayed(20, false, false)
endFunction



function DismissAnimal()

	if pAnimalAlias as bool && pAnimalAlias.GetActorRef().IsDead() == false
		Actor DismissedAnimalActor = pAnimalAlias.GetActorRef()
		DismissedAnimalActor.SetActorValue("Variable04", 0)
		pPlayerAnimalCount.SetValue(0)
		pAnimalAlias.Clear()
		AnimalDismissMessage.Show()
	endIf
endFunction
