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

	Int   Iter = 0
	Int   TauntCount = 0
	Actor Taunter
	Actor Tank = Main.Tanker.GetActorReference()
	Actor TargetTarget = Target.GetCombatTarget()

	;; if this effect originated from a spell then we will use the spell Source
	;; as the tank, as we are forcing a taunt one way or another. if it came
	;; from a combat hit via the player perk then we will use the active tank.
	;; (spells must set the UseSource property to true.)

	If(!self.UseSource)
		Taunter = Main.Tanker.GetActorReference()
	Else
		Taunter = Source
	EndIf

	;;;;;;;;
	;;;;;;;;

	If(Taunter == None)
		Main.PrintDebug("Nobody appears to be tanking.")
		Return
	EndIf

	If(!Main.WouldAttack(Target,Taunter))
		Main.PrintDebug("Skipping " + Target.GetDisplayName() + " for being non hostile.")
		Return
	Endif

	;;;;;;;;
	;;;;;;;;

	Main.PrintDebug(Taunter.GetDisplayName() + " attempting to pull " + Target.GetDisplayName())

	;; we let this effect hit targets we already have aggro on, but we only
	;; visually display it when the aggro is not confirmed.

	If(Main.OptTauntFX && TargetTarget != Taunter)
		Main.dcc_tank_SpellHitEffect.Cast(Target,Target)
	EndIf

	;; throw a fear effect on the target of the target to get them out of the
	;; way to make the tank look more delicious.

	If(Main.OptTauntTargetFearOnTaunt && TargetTarget != None)
		;; however the player and the tank are immune.
		If(TargetTarget != Main.Player && TargetTarget != Tank && Target != Tank)
			Main.PrintDebug("Fearing " + TargetTarget.GetDisplayName())
			Main.dcc_tank_SpellFear.Cast(Target,TargetTarget)
		EndIf
	EndIf

	;; throw out another spell which will attract our followers to attack this
	;; target. the spell effect itself has a condition for IsSneaking, which
	;; means the key to this is to crouch+bash as the signal to focus fire.

	If(Main.OptTauntFocus && Taunter == Main.Player)
		Main.dcc_tank_SpellFocus.Cast(Target,Target)
	EndIf

	If(Main.OptFollowerTauntSay)
		Taunter.Say(Main.TopicTaunts)
	EndIf

	;;;;;;;;
	;;;;;;;;

	;; begin the actual attempt at aggro. this will make an effort to focus
	;; the attention of the target multiple times until it appears it may
	;; have succeeded.


	Iter = 0
	TauntCount = 0
	While(Iter < 2 && !Target.IsDead() && !Taunter.IsDead())
		If(Target.GetCombatTarget() != Taunter)

			;; break their attention
			Target.StopCombat()

			;; ping them for low damage to try and steal their attention.
			If(Main.OptTauntPing)
				Main.dcc_tank_SpellPing.Cast(Taunter,Target)
			EndIf

			;; start combat if they have not.
			Target.StartCombat(Taunter)
			TauntCount += 1
		EndIf

		Utility.Wait(1)
		Iter += 1
	EndWhile

	Main.PrintDebug("Taunt took " + TauntCount + " iterations")

	Return
EndEvent
