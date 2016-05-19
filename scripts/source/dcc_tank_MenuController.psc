Scriptname dcc_tank_MenuController extends SKI_ConfigBase

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_tank_QuestController Property Main Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int Function GetVersion()
	Return 1
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnGameReload()
{things to do when the game is loaded from disk.}

	parent.OnGameReload()

	Int Ver = dcc_tank_QuestController.GetVersion()
	If(Main.VersionCheck != Ver)
		Debug.MessageBox("It appears you have updated. The internal quest is going to be restarted to complete the update. You will need to re-assign your tank afterwards.")
		Main.ResetMod()
		Return		
	EndIf

	Main.OnGameReload()
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnConfigInit()
{things to do when the menu initalises (is opening)}

	self.Pages = new String[3]
	
	self.Pages[0] = "General"
	self.Pages[1] = "Debug"
	self.Pages[2] = "Splash"

	Return
EndEvent

Event OnConfigRegister()
	Main.ResetMod()
	Return
EndEvent

Event OnConfigOpen()
{things to do when the menu actually opens.}

	self.OnConfigInit()
	Return
EndEvent

Event OnConfigClose()
{things to do when the menu closes.}

	Return
EndEvent

Event OnPageReset(string page)
{when a different tab is selected in the menu.}

	self.UnloadCustomContent()

	If(Page == "Splash")
		self.ShowPageIntro()
	ElseIf(Page == "General")
		self.ShowPageGeneral()
	ElseIf(Page == "Debug")
		self.ShowPageDebug()
	Else
		self.ShowPageIntro()
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionSelect(Int Item)
	Bool Val = FALSE

	If(Item == ItemResetMod)
		self.SetToggleOptioNValue(Item,TRUE)
		Debug.MessageBox("Close out of the menus to begin the reset.")
		Utility.Wait(0.25)
		Main.ResetMod()
		Return
	EndIf

	If(Item == ItemTauntTargetFearOnTaunt)
		Main.OptTauntTargetFearOnTaunt = !Main.OptTauntTargetFearOnTaunt
		Val = Main.OptTauntTargetFearOnTaunt
	ElseIf(Item == ItemFollowerTauntFX)
		Main.OptFollowerTauntFX = !Main.OptFollowerTauntFX
		Val = Main.OptFollowerTauntFX
	ElseIf(Item == ItemFollowerTauntSay)
		Main.OptFollowerTauntSay = !Main.OptFollowerTauntSay
		Val = Main.OptFollowerTauntSay
	ElseIf(Item == ItemFollowerTauntOnHit)
		Main.OptFollowerTauntOnHit = !Main.OptFollowerTauntOnHit
		Val = Main.OptFollowerTauntOnHit
	ElseIf(Item == ItemTauntFX)
		Main.OptTauntFX = !Main.OptTauntFX
		Val = Main.OptTauntFX
	ElseIf(Item == ItemTauntPing)
		Main.OptTauntPing = !Main.OptTauntPing
		Val = Main.OptTauntPing
	ElseIf(Item == ItemTauntFocus)
		Main.OptTauntFocus = !Main.OptTauntFocus
		Val = Main.OptTauntFocus
	ElseIf(Item == ItemDebug)
		Main.OptDebug = !Main.OptDebug
		Val = Main.OptDebug
	EndIf

	self.SetToggleOptionValue(Item,Val)
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionSliderOpen(Int Item)
	Float Val = 0.0
	Float Min = 0.0
	Float Max = 0.0
	Float Interval = 0.0

	If(Item == ItemFollowerTauntAttackCount)
		Val = Main.OptFollowerTauntAttackCount
		Min = 0
		Max = 10
		Interval = 1.0
	ElseIf(Item == ItemFollowerTauntOnHitDistance)
		Val = Main.OptFollowerTauntOnHitDistance / 21.3
		Min = 8
		Max = 128
		Interval = 1.0
	EndIf

	SetSliderDialogStartValue(Val)
	SetSliderDialogRange(Min,Max)
	SetSliderDialogInterval(Interval)
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionSliderAccept(Int Item, Float Val)
	String Fmt = "{0}"

	If(Item == ItemFollowerTauntAttackCount)
		Main.OptFollowerTauntAttackCount = Val as Int
	ElseIf(Item == ItemFollowerTauntOnHitDistance)
		Main.OptFollowerTauntOnHitDistance = (Val * 21.3) as Int
		Fmt = "{0}ft"
	EndIf

	self.SetSliderOptionValue(Item,Val,Fmt)
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionHighlight(Int Item)

	If(Item == ItemTauntTargetFearOnTaunt)
		self.SetInfoText("When an enemy is successfully taunted their current target will run away for 2 seconds. This will help get them out of the way so they don't get retargeted.")
	ElseIf(Item == ItemFollowerTauntAttackCount)
		self.SetInfoText("Followers will perform a small AOE taunt (12ft) every X swings of their weapon. If you are using a fast attacking follower it is suggested you raise this to 5 or more, while 3 for slow swingers. Set to 0 to disable.")
	ElseIf(Item == ItemFollowerTauntFX)
		self.SetInfoText("A small AOE FX burst occurs when followers taunt.")
	ElseIf(Item == ItemFollowerTauntSay)
		self.SetInfoText("Followers will yell insulting things when they taunt targets.")
	ElseIf(Item == ItemFollowerTauntOnHit)
		self.SetInfoText("Followers will taunt off you when you are hit.")
	ElseIf(Item == ItemFollowerTauntOnHitDistance)
		self.SetInfoText("How close to a follower you must be before they will taunt off you when you are hit.")
	ElseIf(Item == ItemTauntFX)
		self.SetInfoText("A small visual burst occurs on targets that are taunted.")
	ElseIf(Item == ItemTauntPing)
		self.SetInfoText("A 1 health/sec@10sec DOT is placed on taunted targets to help maintain aggro. 10 free damage won't break your gameplay, and it really helps because Skyrim AI has the attention span of a cat on crack.")
	ElseIf(Item == ItemTauntFocus)
		self.SetInfoText("If you bash someone while crouching all your followers within 32ft will refocus their attention onto that specific target. Only works if the player is the tank.")
	ElseIf(Item == ItemDebug)
		self.SetInfoText("Spams the screen with debugging messages.")
	Else
		self.SetInfoText("Tanking Mod")
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function ShowPageIntro()
	LoadCustomContent("dcc-tanking/splash.dds")
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int ItemTauntTargetFearOnTaunt
Int ItemFollowerTauntAttackCount
Int ItemFollowerTauntFX
Int ItemFollowerTauntSay
Int ItemFollowerTauntOnHit
Int ItemFollowerTauntOnHitDistance
Int ItemTauntFX
Int ItemTauntPing
Int ItemTauntFocus

Function ShowPageGeneral()
	self.SetTitleText("General Settings")
	self.SetCursorFillMode(TOP_TO_BOTTOM)

	self.SetCursorPosition(0)
	self.AddHeaderOption("General Tanking Options")
	ItemTauntTargetFearOnTaunt = self.AddToggleOption("Enemy Target Flee On Taunt",Main.OptTauntTargetFearOnTaunt)
	ItemTauntPing = self.AddToggleOption("Enemy Health Ping On Taunt",Main.OptTauntPing)
	ItemTauntFX = self.AddToggleOption("Enemy FX On Taunt",Main.OptTauntFX)
	ItemTauntFocus = self.AddToggleOption("Focus Followers On CrouchBash",Main.OptTauntFocus)

	self.SetCursorPosition(1)
	self.AddHeaderOption("Follower Tanking Options")
	ItemFollowerTauntAttackCount = self.AddSliderOption("Taunt Every X Attacks",Main.OptFollowerTauntAttackCount,"{0}")
	ItemFollowerTauntOnHit = self.AddToggleOption("Taunt Off When Player Hit",Main.OptFollowerTauntOnHit)
	ItemFollowerTauntOnHitDistance = self.AddSliderOption("Taunt Off Distance",(Main.OptFollowerTauntOnHitDistance / 21.3),"{0}ft")
	ItemFollowerTauntFX = self.AddToggleOption("AOE FX On Taunt",Main.OptFollowerTauntFX)
	ItemFollowerTauntSay = self.AddToggleOption("Vocal Taunt On Taunt",Main.OptFollowerTauntSay)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int ItemDebug
Int ItemResetMod

Function ShowPageDebug()
	self.SetTitleText("Debugging & Repair")
	self.SetCursorFillMode(LEFT_TO_RIGHT)
	self.SetCursorPosition(0)

	ItemResetMod = self.AddToggleOption("Reset Mod",FALSE)
	ItemDebug = self.AddToggleOption("Debug Messages",Main.OptDebug)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
