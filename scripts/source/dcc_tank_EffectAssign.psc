Scriptname dcc_tank_EffectAssign extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_tank_QuestController Property Main Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor Target, Actor Source)

	Actor Current = Main.Tanker.GetActorRef()
	Int Result = Main.dcc_tank_MsgTankSwap.Show()

	;;;;;;;;
	;;;;;;;;

	If(Target.IsHostileToActor(Source) || !Target.IsPlayerTeammate())
		;; like bad guys give a shit what you want.
		Debug.Notification(Target.GetDisplayName() + " laughs at you.")
		Return
	EndIf

	;;;;;;;;
	;;;;;;;;

	If(Result == 0)
		Main.SetActiveTank(Target)
	ElseIf(Result == 1)
		Main.SetActiveTank(Source)
	ElseIf(Result == 2)
		Main.SetActiveTank(None)
	EndIf		

	Return
EndEvent
