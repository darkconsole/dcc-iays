Scriptname dcc_tank_BookTaunt_Read extends ObjectReference

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_tank_QuestController Property Main Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnRead()

	If(!Main.Player.HasSpell(Main.dcc_tank_ShoutTaunt))
		Main.Player.AddShout(Main.dcc_tank_ShoutTaunt)
		Game.TeachWord(Main.dcc_tank_WordTauntTarget)
		Game.TeachWord(Main.dcc_tank_WordTauntAOE1)
		Game.TeachWord(Main.dcc_tank_WordTauntAOE2)
		Game.UnlockWord(Main.dcc_tank_WordTauntTarget)
		Game.UnlockWord(Main.dcc_tank_WordTauntAOE1)
		Game.UnlockWord(Main.dcc_tank_WordTauntAOE2)
		Debug.MessageBox("You now have a shout for taunting.")
	EndIf

	if(!Main.Player.HasSpell(Main.dcc_tank_SpellAssign))
		Main.Player.AddSpell(Main.dcc_tank_SpellAssign)
		Debug.MessageBox("You now have a lesser power to target a follower with and decide who is the tank.")
	EndIf

	if(!Main.Player.HasSpell(Main.dcc_tank_SpellMisdirect))
		Main.Player.AddSpell(Main.dcc_tank_SpellMisdirect)
		Debug.MessageBox("You now have a lesser power for ranged misdirection.")
	EndIf

	Return
EndEvent
