Scriptname dcc_tank_QuestController extends Quest Conditional

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int Function GetVersion() Global
{get the mod version.}

	Return 100
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; so it appears ForceRefTo does not get saved, as my tanker alias is getting
;; reset to its default state of None when the Game is relaunched. so now i
;; have to track the actor and reapply it on game load.

ReferenceAlias Property Tanker Auto Conditional
Actor Property TankerActor Auto Hidden Conditional

Actor Property Player Auto
Topic Property TopicTaunts Auto

Message Property dcc_tank_MsgTankSwap Auto
Spell Property dcc_tank_SpellAssign Auto
Spell Property dcc_tank_SpellHitEffect Auto
Spell Property dcc_tank_SpellFear Auto
Spell Property dcc_tank_SpellFocus Auto
Spell Property dcc_tank_SpellPing Auto
Spell Property dcc_tank_SpellTauntAOE1 Auto
Spell Property dcc_tank_SpellTauntAOE1_NoFX Auto
Spell Property dcc_tank_SpellTauntAOE2 Auto
Shout Property dcc_tank_ShoutTaunt Auto
WordOfPower Property dcc_tank_WordTauntTarget Auto
WordOfPower Property dcc_tank_WordTauntAOE1 Auto
WordOfPower Property dcc_tank_WordTauntAOE2 Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int  Property OptFollowerTauntAttackCount = 5 Auto Hidden
Bool Property OptFollowerTauntFX = TRUE Auto Hidden
Bool Property OptFollowerTauntSay = TRUE Auto Hidden
Bool Property OptFollowerTauntOnHit = FALSE Auto Hidden
Int  Property OptFollowerTauntOnHitDistance = 512 Auto Hidden
Bool Property OptTauntTargetFearOnTaunt = TRUE Auto Hidden
Bool Property OptTauntFX = TRUE Auto Hidden
Bool Property OptTauntPing = TRUE Auto Hidden
Bool Property OptTauntFocus = TRUE Auto Hidden
Bool Property OptDebug = TRUE Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function PrintDebug(String Msg)
{print debug notifications}

	If(self.OptDebug)
		Debug.Notification("[IAYS] " + Msg)
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

	self.OptTauntTargetFearOnTaunt = TRUE
	self.OptFollowerTauntAttackCount = 5
	self.OptFollowerTauntFX = TRUE
	self.OptFollowerTauntSay = TRUE
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
	Debug.Notification("Tanker Mod has started.")
	Return
EndEvent

Function OnGameReload()
{things that have to be done when you launch the game. this is called by the
OnGameReload event in the MCM script since it is already working.}

	
	self.SetActiveTank(self.TankerActor)

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
