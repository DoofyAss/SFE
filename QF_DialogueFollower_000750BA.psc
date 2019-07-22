;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 0
Scriptname QF_DialogueFollower_000750BA Extends Quest Hidden

;BEGIN ALIAS PROPERTY Follower01
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower01 Auto
;END ALIAS PROPERTY

;	"useless property"	------------------------------------------------------------------------------------------------

;BEGIN ALIAS PROPERTY Animal
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Animal Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower02 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower03
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower03 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower04
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower04 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower05
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower05 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower06
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower06 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower07
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower07 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Follower08
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Follower08 Auto
;END ALIAS PROPERTY










;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
FreeformSkyhavenTempleA.RecruitBlade(Alias_Follower01.GetActorRef())
;END CODE
EndFunction
;END FRAGMENT



;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
FreeformSkyhavenTempleA.RecruitBlade(Alias_Follower01.GetActorRef())
;END CODE
EndFunction
;END FRAGMENT



;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
FreeformSkyhavenTempleA.RecruitBlade(Alias_Follower01.GetActorRef())
;END CODE
EndFunction
;END FRAGMENT



;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
Quest __temp = self as Quest
dialoguefollowerscript kmyQuest = __temp as dialoguefollowerscript
kmyQuest.DismissCurrentFollower(0, 0)
;END CODE
EndFunction
;END FRAGMENT



;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
Quest __temp = self as Quest
hirelingcommentscript kmyQuest = __temp as hirelingcommentscript
kmyQuest.Commented()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

FreeformSkyHavenTempleAScript property FreeformSkyhavenTempleA auto
