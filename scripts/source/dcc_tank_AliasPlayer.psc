Scriptname dcc_tank_AliasPlayer extends ReferenceAlias
{This script sits upon the QuestController PlayerRef alias to detect when the
player performs various actions.}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dcc_tank_QuestController Property Main Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnHit(ObjectReference Asshole, Form With, Projectile Bullet, Bool WasPower, Bool WasSneak, Bool WasBash, Bool Blocked)
{Detect when the player has been hit.}

	Actor Tank = Main.Tanker.GetActorReference()
	Actor Attacker = Asshole as Actor
	Actor Me = self.GetActorReference()

	If(Main.OptFollowerTauntOnHit)
		self.OnHit_FollowerTauntOnHit(Attacker,With,Tank,Me)
	EndIf

	Return
EndEvent

Function OnHit_FollowerTauntOnHit(Actor Attacker, Form With, Actor Tank, Actor Me)
{handle on-hit taunting.}

	If(Attacker == None || Tank == None || Tank == Me)
		;; nobody is tanking or you are tanking.
		Return
	EndIf

	If(!Attacker.IsHostileToActor(Me))
		;; don't trigger on friendly fire or non-hostile damage.
		Return
	EndIf

	If((With as Spell) && !(With as Spell).IsHostile())
		;; don't trigger on non-hostile actions.
		Return
	EndIf

	If(!Tank.Is3dLoaded() || Tank.GetDistance(Me) > Main.OptFollowerTauntOnHitDistance)
		;; you are too far from your tank.
		Return
	EndIf

	;; if we made it, then we want our tank to taunt this target.
	Main.dcc_tank_SpellTauntTarget.Cast(Tank,Attacker)

	Return
EndFunction
