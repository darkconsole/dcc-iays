Scriptname dcc_tank_EffectHit extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_tank_QuestController Property Main Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Property UseSource = FALSE Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor Target, Actor Source)
	
	Actor Who
	Int Iter

	If(!self.UseSource)
		Who = Main.Tanker.GetActorRef()
	Else
		Who = Source
	EndIf

	;;;;;;;;
	;;;;;;;;

	If(Who == None)
		;; do nothing if we failed finding a tank.
		Main.PrintDebug("Nobody appears to be tanking.")
		Return
	EndIf

	If(!Target.IsHostileToActor(Who) || Target.IsDead() || Target.IsPlayerTeammate())
		;; don't pull good guys.
		Main.PrintDebug("Skipping " + Target.GetDisplayName() + " for not being hostile.")
		Return
	EndIf

	If(Target.GetCombatTarget() == Who)
		;; we already have aggro.
		Main.PrintDebug("Skipping " + Target.GetDisplayName() + " for already having aggro.")

		;; get our followers to all attack the same thing.
		If(Main.OptTauntFocus && Who == Main.Player)
			Main.dcc_tank_SpellFocus.Cast(Target,Target)
		EndIf

		Return
	EndIf

	;;;;;;;;
	;;;;;;;;

	Main.PrintDebug(Who.GetDisplayName() + " attempting to pull " + Target.GetDisplayName())

	;; throw a visual on what was taunted.
	If(Main.OptTauntFX)
		Main.dcc_tank_SpellHitEffect.Cast(Who,Target)
	EndIf

	;; throw a fear effect on their current target to get them to gtfo
	If(Main.OptTauntTargetFearOnTaunt)
		Main.dcc_tank_SpellFear.Cast(Target,Target.GetCombatTarget())
	EndIf

	;; get our followers to all attack the same thing.
	;; the spell has a condition for you must be crouched and bashed.
	If(Main.OptTauntFocus && Who == Main.Player)
		Main.dcc_tank_SpellFocus.Cast(Target,Target)
	EndIf

	;;;;;;;;
	;;;;;;;;

	Iter = 0
	While(Iter < 10)
		If(Target.GetCombatTarget() != Who)

			;; break their attention
			Target.StopCombat()

			;; ping them for low damage to try and steal their attention.
			If(Main.OptTauntPing)
				Main.dcc_tank_SpellPing.Cast(Who,Target)
			EndIf

			;; start combat if they havent.
			Target.StartCombat(Who)
		EndIf

		Utility.Wait(0.1)
		Iter += 1
	EndWhile

	Return
EndEvent
