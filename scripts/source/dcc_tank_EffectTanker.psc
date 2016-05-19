Scriptname dcc_tank_EffectTanker extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_tank_QuestController Property Main Auto

;; npcs will only taunt every x hits. this is a counter for tracking that.
;; taunts execute when it rolls over back to 1.
Int Property HitFrameIter = 1 Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor Target, Actor Source)
{this effect sits upon the active tank.}

	;; if we are not the player then we will register for the hit animation
	;; event to cast a small aoe taunt. if we are the player then instead
	;; the perk will handle the taunting on bash.
	If(Target != Game.GetPlayer())
		self.RegisterForAnimationEvent(Target,"hitFrame")
	EndIf

	Main.PrintDebug(Target.GetDisplayName() + " is now tanking.")
	Return
EndEvent

Event OnEffectFinish(Actor Target, Actor Source)
{cleanup for when someething is no longer a tank.}

	If(Target.IsDead())
		Debug.Notification(Target.GetDisplayName() + " has fallen!")
		Main.SetActiveTank(None)
	EndIf

	Main.PrintDebug(Target.GetDisplayName() + " is no longer tanking.")
	Return
EndEvent

Event OnCombatStateChanged(Actor Target, Int CombatState)
{handle when this actor drops in and out of combat. only fires for npcs.}

	If(CombatState == 0)
		;; reset the hit counter after combat so that the first swing always
		;; does a taunt.
		self.HitFrameIter = 1
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnAnimationEvent(ObjectReference Who, String What)
{handle attacking animation event.}

	If(Main.OptFollowerTauntAttackCount == 0)
		Return
	EndIf
	
	If(What == "HitFrame" || What == "hitFrame")
		If(self.HitFrameIter == 1)
			If(Main.OptFollowerTauntFX)
				Main.dcc_tank_SpellTauntAOE1.Cast(Who,Who)
			Else
				Main.dcc_tank_SpellTauntAOE1_NoFX.Cast(Who,Who)
			EndIf
		EndIf

		self.HitFrameIter += 1
		If(self.HitFrameIter > Main.OptFollowerTauntAttackCount)
			self.HitFrameIter = 1
		EndIf
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
