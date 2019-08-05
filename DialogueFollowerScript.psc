;/
	Mr. Black	"mr.black.developer@gmail.com"
	begin v1.0	2019.07.16
	begin v1.1	2019.07.20
/;

ScriptName DialogueFollowerScript extends Quest conditional

Message property AnimalDismissMessage auto
Message property AnimalDeathMessage auto

Message property FollowerDismissMessage auto
Message property FollowerDismissMessageCompanions auto
Message property FollowerDismissMessageCompanionsFemale auto
Message property FollowerDismissMessageCompanionsMale auto
Message property FollowerDismissMessageWait auto
Message property FollowerDismissMessageWedding auto

Message property Follower01DismissMessage auto
Message property Follower02DismissMessage auto
Message property Follower03DismissMessage auto
Message property Follower04DismissMessage auto
Message property Follower05DismissMessage auto
Message property Follower06DismissMessage auto
Message property Follower07DismissMessage auto
Message property Follower08DismissMessage auto

Message property Follower01DeathMessage auto
Message property Follower02DeathMessage auto
Message property Follower03DeathMessage auto
Message property Follower04DeathMessage auto
Message property Follower05DeathMessage auto
Message property Follower06DeathMessage auto
Message property Follower07DeathMessage auto
Message property Follower08DeathMessage auto

SetHirelingRehire property HirelingRehireScript auto

Faction property CurrentHireling auto
Faction property DismissedFollowerFaction auto

ReferenceAlias property AnimalAlias auto
GlobalVariable property PlayerAnimalCount auto

ReferenceAlias[] property FollowerAlias auto
GlobalVariable property PlayerFollowerCount auto
GlobalVariable property PlayerFollowerMaxCount auto

EffectShader property EffectWait auto
EffectShader property EffectFollow auto
EffectShader property EffectSetFollower auto
EffectShader property EffectDismiss auto

Idle property AnimWait auto
Idle property AnimFollows auto ; "I dont understand why propery name AnimFollowers doesn't work"
Idle property AnimDismiss auto
Idle property AnimIdleStop auto
Idle property AnimIdleMagic auto
Idle property AnimCleanSword auto
Idle property AnimShieldCheer auto

Spell property PlayerHealingTrigger auto
Actor property petMudcrab auto
Actor property petSpider auto
Actor property petWolf auto
Actor property petHare auto










;	Misc		----------------------------------------------------------------------------------------------------

int function GetFollowerSlot(Actor Follower)
	int i = 0
	
	while i < FollowerAlias.length
		if FollowerAlias[i].GetActorRef() == Follower
			return i
		endif
		i += 1
	endwhile
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



function showDismissMessage(int i)

	if i == 0
		Follower01DismissMessage.Show()
	elseif i == 1
		Follower02DismissMessage.Show()
	elseif i == 2
		Follower03DismissMessage.Show()
	elseif i == 3
		Follower04DismissMessage.Show()
	elseif i == 4
		Follower05DismissMessage.Show()
	elseif i == 5
		Follower06DismissMessage.Show()
	elseif i == 6
		Follower07DismissMessage.Show()
	elseif i == 7
		Follower08DismissMessage.Show()
	else
		FollowerDismissMessage.Show()
	endif
endFunction



function showDeathMessage(int i)

	if i == 0
		Follower01DeathMessage.Show()
	elseif i == 1
		Follower02DeathMessage.Show()
	elseif i == 2
		Follower03DeathMessage.Show()
	elseif i == 3
		Follower04DeathMessage.Show()
	elseif i == 4
		Follower05DeathMessage.Show()
	elseif i == 5
		Follower06DeathMessage.Show()
	elseif i == 6
		Follower07DeathMessage.Show()
	elseif i == 7
		Follower08DeathMessage.Show()
	else
	endif
endFunction










;	Dialogue		----------------------------------------------------------------------------------------------------

function switchHealingTrigger(Actor Follower)

	if Follower.HasSpell(PlayerHealingTrigger)
		Follower.RemoveSpell(PlayerHealingTrigger)
	else
		Follower.AddSpell(PlayerHealingTrigger)
	endif
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
	
	Utility.Wait(2)
	
endFunction



function SpeakerDismiss(Actor Follower)

	Follower.PlayIdle(AnimIdleStop)
	Follower.PlayIdle(AnimDismiss)

	DismissCurrentFollower(GetFollowerSlot(Follower), 0)
	Utility.Wait(1)
endFunction



function SpeakerDismissGroup(Actor Follower)

	Follower.PlayIdle(AnimIdleStop)
	Follower.PlayIdle(AnimDismiss)
	
	DismissGroup()
	DismissAnimal()
	Utility.Wait(1)
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
	
	AnimalWait()
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
	
	AnimalFollow()
endFunction










;	Follower	----------------------------------------------------------------------------------------------------



function SetFollower(ObjectReference FollowerRef)
	
	ResetFollowerCount()
	
	Actor Follower = FollowerRef as Actor
	Follower.RemoveFromFaction(DismissedFollowerFaction)
	if Follower.GetRelationshipRank(Game.GetPlayer()) < 3 && Follower.GetRelationshipRank(Game.GetPlayer()) >= 0
		Follower.SetRelationshipRank(Game.GetPlayer(), 3)
	endIf
	Follower.SetPlayerTeammate(true, true)
	PlayerFollowerCount.SetValue(PlayerFollowerCount.GetValue() + 1)
	FollowerAlias[GetFreeSlot()].ForceRefTo(Follower)
	EffectSetFollower.Play(Follower, 3.0)
endFunction



function DismissCurrentFollower(int i, int reason)

	Actor Follower = FollowerAlias[i].GetActorRef()
	
	if reason == 1
		FollowerDismissMessageWait.Show()
		;	Debug.Notification(Follower.GetActorBase().GetName())
	elseif reason == 2
		showDeathMessage(i)
	else
		showDismissMessage(i)
	endIf
	
	Follower.StopCombatAlarm()
	Follower.AddToFaction(DismissedFollowerFaction)
	Follower.SetPlayerTeammate(false, true)
	Follower.RemoveFromFaction(CurrentHireling)
	Follower.SetAV("WaitingForPlayer", 0)
	HirelingRehireScript.DismissHireling(Follower.GetActorBase())
	
	FollowerAlias[i].Clear()
	ResetFollowerCount()
	
	EffectDismiss.Play(Follower, 3.0)
	Follower.EvaluatePackage()
	
	;	SetObjectiveDisplayed(i * 10, false, false)
endFunction



function DismissGroup()

	int i = 0
	
	while i < FollowerAlias.length
		if FollowerAlias[i].GetActorRef() != none
			DismissCurrentFollower(i, 0)
		endif
		i += 1
	endwhile
	
	Utility.Wait(2)
endFunction



function DismissCurrentFollowerRef(Actor Follower, int reason)

	DismissCurrentFollower(GetFollowerSlot(Follower), reason)
endFunction



function CurrentFollowerWait(int i)

	Actor Follower = FollowerAlias[i].GetActorRef()
	EffectWait.Play(Follower, 3.0)
	Follower.SetAV("WaitingForPlayer", 1)
	FollowerAlias[i].RegisterForUpdateGameTime(72)
	
	;	SetObjectiveDisplayed(i * 10, true, true)
endFunction



function CurrentFollowerWaitRef(Actor Follower)

	CurrentFollowerWait(GetFollowerSlot(Follower))
endFunction



function CurrentFollowerFollow(int i)

	Actor Follower = FollowerAlias[i].GetActorRef()
	EffectFollow.Play(Follower, 3.0)
	Follower.SetAV("WaitingForPlayer", 0)
	
	;	SetObjectiveDisplayed(i * 10, false, false)
endFunction










;	just in case	------------------------------------------------------------------------------------------------


function DismissFollower(int iMessage, int iSayLine)

	if iMessage == 1
		FollowerDismissMessageWedding.Show()
	elseif iMessage == 2
		FollowerDismissMessageCompanions.Show()
	elseif iMessage == 3
		FollowerDismissMessageCompanionsMale.Show()
	elseif iMessage == 4
		FollowerDismissMessageCompanionsFemale.Show()
	elseif iMessage == 5
		FollowerDismissMessageWait.Show()
	endIf
	
	DismissGroup()

endFunction










;	Animal		----------------------------------------------------------------------------------------------------



function SetAnimal(ObjectReference AnimalRef)

	Actor Animal = AnimalRef as Actor
	
	Animal.SetAV("Lockpicking", 0)
	Animal.SetRelationshipRank(Game.GetPlayer(), 3)
	Animal.SetPlayerTeammate(true, false)
	AnimalAlias.ForceRefTo(Animal)
	PlayerAnimalCount.SetValue(1)
endFunction



function AnimalWait()

	Actor Animal = AnimalAlias.GetActorRef()
	Animal.SetAV("WaitingForPlayer", 1)
	EffectWait.Play(Animal, 3.0)
	AnimalAlias.RegisterForUpdateGameTime(72)
endFunction



function AnimalFollow()

	Actor Animal = AnimalAlias.GetActorRef()
	Animal.SetAV("WaitingForPlayer", 0)
	EffectFollow.Play(Animal, 3.0)
	
	;	SetObjectiveDisplayed(20, false, false)
endFunction



function SummonAnimal(int Character)

	Actor Player = Game.GetPlayer()
	Actor CharacterRef
	
	;	"behind player"
	float x = 250.0 * -Math.Sin(Player.GetAngleZ())
	float y = 250.0 * -Math.Cos(Player.GetAngleZ())
	
	if Character == 0
		CharacterRef = petMudcrab
	elseif Character == 1
		CharacterRef = petSpider
	elseif Character == 2
		CharacterRef = petWolf
	elseif Character == 3
		CharacterRef = petHare
	endif
	
	CharacterRef.MoveTo(Player, x, y)
	CharacterRef.EnableNoWait()
	;	CharacterRef.AllowPCDialogue(true)	;	"Okay, how about doors?"
	setAnimal(CharacterRef)
endFunction



function DismissAnimal()

	Actor Animal = AnimalAlias.GetActorRef()
	
	if Animal == none
		return
	endif
	
	if Animal.IsDead()
		AnimalDeathMessage.Show()
	else
		AnimalDismissMessage.Show()
	endif
	
	Animal.SetActorValue("Variable04", 0)
	Animal.SetAV("WaitingForPlayer", 0)
	AnimalAlias.Clear()
	PlayerAnimalCount.SetValue(0)
	
	if Animal == petMudcrab || Animal == petSpider || Animal == petWolf || Animal == petHare
		Animal.DisableNoWait()	;	Animal.Delete()
	endif
endFunction
