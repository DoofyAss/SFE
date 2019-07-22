scriptName FreeformSkyHavenTempleAScript extends Quest conditional

DialogueFollowerScript property DialogueFollower auto

Int property BladesCount auto conditional
ReferenceAlias property Blade01 auto
ReferenceAlias property Blade02 auto
ReferenceAlias property Blade03 auto

Faction property PotentialFollowerFaction auto
Faction property BladesFaction auto
LeveledItem property LItemBanditWeaponMissile auto

Weapon property AkaviriKatana auto
Outfit property ArmorBladesOutfit auto










function RecruitBlade(Actor RecruitREF)

	if BladesCount == 0
		Blade01.ForceRefTo(RecruitREF)
		DialogueFollower.DismissCurrentFollower(0, 0)
		BladesCount = 1
		Self.SetStage(20)
	elseIf BladesCount == 1
		Blade02.ForceRefTo(RecruitREF)
		DialogueFollower.DismissCurrentFollower(0, 0)
		BladesCount = 2
		Self.SetStage(30)
	elseIf BladesCount == 2
		Blade03.ForceRefTo(RecruitREF)
		DialogueFollower.DismissCurrentFollower(0, 0)
		BladesCount = 3
		Self.SetStage(40)
	endIf
endFunction



function EquipBlade(Actor RecruitREF)

	RecruitREF.AddtoFaction(BladesFaction)
	RecruitREF.SetOutfit(ArmorBladesOutfit, false)
	RecruitREF.AddItem(AkaviriKatana, 1, false)
	RecruitREF.EquipItem(AkaviriKatana, false, false)
	RecruitREF.AddItem(LItemBanditWeaponMissile, 1, false)
endFunction
