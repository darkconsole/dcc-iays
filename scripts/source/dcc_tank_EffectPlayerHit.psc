Scriptname dcc_tank_EffectPlayerHit extends ActiveMagicEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_tank_QuestController Property Main Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnEffectStart(Actor Target, Actor Source)
{the player has hit something...}

	If(Target == None)
		Return
	EndIf

	If(Main.Player.GetEquippedItemType(0) == 7)
		self.OnEffectStart_HitWithBow(Target,Main.Player)
	EndIf

	Return
EndEvent

Function OnEffectStart_HitWithBow(Actor Target, Actor Source)
{... with a bow.}

	Actor Tank = Main.Tanker.GetActorReference()

	If(Tank == None || Tank == Source)
		Return
	EndIf

	If(Target.IsPlayerTeammate())
		Return
	EndIf

	If(Source.HasMagicEffect(Main.dcc_tank_EffectMisdirect))
		Source.DispelSpell(Main.dcc_tank_SpellMisdirect)

		If(!Tank.IsInCombat())
		;;	Debug.SendAnimationEvent(Tank,"IdleBlowHornImperial")
		;;	Main.dcc_tank_SoundHornBlow.Play(Tank)
		EndIf

		Main.dcc_tank_SpellTauntTarget.Cast(Target,Tank)
		Main.dcc_tank_SpellTauntAOE1.Cast(Tank,Target)
	EndIf

	Return
EndFunction
