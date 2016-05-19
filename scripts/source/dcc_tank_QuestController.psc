Scriptname dcc_tank_QuestController extends Quest
{The main API for I Am Your Shield.}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int Property VersionCheck = 0 Auto
{this will get modified by the on load event.}

Int Function GetVersion() Global
{get the mod version.}

	Return 101
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; so it appears ForceRefTo does not get saved, as my tanker alias is getting
;; reset to its default state of None when the Game is relaunched. so now i
;; have to track the actor and reapply it on game load.

ReferenceAlias Property Tanker Auto
Actor Property TankerActor Auto Hidden

ReferenceAlias Property PlayerRef Auto
Actor Property Player Auto

;; vanilla forms

Topic Property TopicTaunts Auto
Keyword Property KeywordWeapTypeBow Auto

;; mod forms.

Message Property dcc_tank_MsgTankSwap Auto
MagicEffect Property dcc_tank_EffectMisdirect Auto
Spell Property dcc_tank_SpellAssign Auto
Spell Property dcc_tank_SpellHitEffect Auto
Spell Property dcc_tank_SpellFear Auto
Spell Property dcc_tank_SpellFocus Auto
Spell Property dcc_tank_SpellMisdirect Auto
Spell Property dcc_tank_SpellPing Auto
Spell Property dcc_tank_SpellTauntTarget Auto
Spell Property dcc_tank_SpellTauntAOE1 Auto
Spell Property dcc_tank_SpellTauntAOE1_NoFX Auto
Spell Property dcc_tank_SpellTauntAOE2 Auto
Shout Property dcc_tank_ShoutTaunt Auto
Sound Property dcc_tank_SoundHornBlow Auto
WordOfPower Property dcc_tank_WordTauntTarget Auto
WordOfPower Property dcc_tank_WordTauntAOE1 Auto
WordOfPower Property dcc_tank_WordTauntAOE2 Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int  Property OptFollowerTauntAttackCount = 5 Auto Hidden
Bool Property OptFollowerTauntFX = TRUE Auto Hidden
Bool Property OptFollowerTauntSay = TRUE Auto Hidden
Bool Property OptFollowerTauntOnHit = FALSE Auto Hidden
Int  Property OptFollowerTauntOnHitDistance = 894 Auto Hidden
Bool Property OptTauntTargetFearOnTaunt = TRUE Auto Hidden
Bool Property OptTauntFX = TRUE Auto Hidden
Bool Property OptTauntPing = TRUE Auto Hidden
Bool Property OptTauntFocus = TRUE Auto Hidden
Bool Property OptDebug = FALSE Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Print(String Msg)
{print normal notifications.}

	Debug.Notification("[IAYS] " + Msg)
	Return
EndFunction

Function PrintDebug(String Msg)
{print debug notifications}

	If(self.OptDebug)
		Debug.Notification("[IAYS-DBG] " + Msg)
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function ResetMod()
{perform a full mod reset}

	self.Reset()
	Utility.Wait(0.5)
	self.Stop()
	Utility.Wait(0.5)
	self.Start()

	Return
EndFunction

Function ResetMod_Values()
{reset all the options to default}

	self.VersionCheck = dcc_tank_QuestController.GetVersion()

	self.OptTauntTargetFearOnTaunt = TRUE
	self.OptFollowerTauntAttackCount = 5
	self.OptFollowerTauntFX = TRUE
	self.OptFollowerTauntSay = TRUE
	self.OptFollowerTauntOnHit = FALSE
	self.OptFollowerTauntOnHitDistance = 894
	self.OptTauntFX = TRUE
	self.OptTauntPing = TRUE
	self.OptTauntFocus = TRUE
	self.OptDebug = FALSE

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnInit()
{handle startup and reset}

	self.ResetMod_Values()
	Debug.Notification("I Am Your Shield has Started")
	Return
EndEvent

Function OnGameReload()
{things that have to be done when you launch the game. this is called by the
OnGameReload event in the MCM script since it is already working.}

	If(self.TankerActor != None)
		;; the tanker alias is resetting to default null when you restart the
		;; game, which strangely is not a thing i noticed before.
		self.Tanker.ForceRefTo(self.TankerActor)
	EndIf

	If(self.PlayerRef == None)
		;; an update crutch so people don't have to reset when updating from
		;; before i had PlayerRef in there.
		self.PlayerRef.ForceRefTo(self.Player)
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function SetActiveTank(Actor Who)
{update who is the current tank.}

	If(Who != None)
		self.Tanker.ForceRefTo(Who)
	Else
		self.Tanker.Clear()
	EndIf

	If(Who == self.Player)
		Debug.Notification("Your companions are looking to you to keep enemies busy.")
	ElseIf(Who == None)
		Debug.Notification("YOLO")
	Else
		Debug.Notification(Who.GetDisplayName() + " nods and will attempt to draw aggro.")
	EndIf

	self.TankerActor = Who
	Return
EndFunction

Bool Function WouldAttack(Actor Target, Actor Taunter)
{determine if the target and taunter would normally fight each other on sight
so we can attempt to prevent taunting friendly or neutral targets.}

	If(Target.IsDead())
		self.PrintDebug(Target.GetDisplayName() + " would not attack " + Taunter.GetDisplayName() + " due to being dead.")
		Return FALSE
	EndIf

	;;;;;;;;
	;;;;;;;;

	If(Taunter == self.Tanker.GetActorReference() || Taunter == self.Player)
		If(Target.IsHostileToActor(self.Player))
			Return TRUE
		EndIf

		If(Target.IsPlayerTeammate())
			self.PrintDebug(Target.GetDisplayName() + " would not attack " + Taunter.GetDisplayName() + " due to being player teammate.")
			Return FALSE
		EndIf

		If(Target.GetFactionReaction(self.Player) != 1)
			self.PrintDebug(Target.GetDisplayName() + " would not attack " + Taunter.GetDisplayName() + " due to faction rank.")
			Return FALSE
		EndIf

		If(Target.GetRelationshipRank(self.Player) >= 0)
			self.PrintDebug(Target.GetDisplayName() + " would not attack " + Taunter.GetDisplayName() + " due to relationship rank.")
			Return FALSE
		EndIf
	EndIf

	Return TRUE
EndFunction
