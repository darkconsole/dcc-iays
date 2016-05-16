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
	Main.PrintDebug(Target.GetDisplayName() + " is now tanking.")

	;; if we are not the player then we will register for the hit animation
	;; event to cast a small aoe taunt. if we are the player then instead
	;; the perk will handle the taunting on bash.
	If(Target != Game.GetPlayer())
		self.RegisterForAnimationEvent(Target,"hitFrame")
	EndIf

	Return
EndEvent

Event OnEffectFinish(Actor Target, Actor Source)
	Main.PrintDebug(Target.GetDisplayName() + " is no longer tanking.")
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnAnimationEvent(ObjectReference Who, String What)
	
	If(What == "HitFrame" || What == "hitFrame")
		If(self.HitFrameIter == 1)
			If(Main.OptFollowerTauntSay)
				Who.Say(Main.TopicTaunts)
			EndIf
			
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
