Scriptname dcc_tank_EffectFocus extends ActiveMagicEffect

dcc_tank_QuestController Property Main Auto

Event OnEffectStart(Actor Target, Actor Source)

	Int Iter

	;; give the taunt a moment to attempt.
	Utility.Wait(0.25)

	Iter = 0
	While(Iter < 10)
		If(Target.GetCombatTarget() != Source)
			;;Debug.Notification(Target.GetDisplayname() + " => " + Source.GetDisplayName())

			;; break their attention
			Target.StopCombat()

			;; start combat if they havent.
			Target.StartCombat(Source)
		EndIf

		Utility.Wait(0.25)
		Iter += 1
	EndWhile

	Return
EndEvent
