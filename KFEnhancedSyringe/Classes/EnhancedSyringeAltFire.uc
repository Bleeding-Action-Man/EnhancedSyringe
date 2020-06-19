//=============================================================================
// EnhancedSyringeAltFire
// Everything written in this class is edited and should be different than the
// original values
// Self Healing Fire
//=============================================================================

class EnhancedSyringeAltFire extends SyringeAltFire Config(KFEnhancedSyringe);

var() config int boostWhen;
var() config int boostBy;
var() config int boostFor;

Function Timer()
{
	local float HealSum;

	HealSum = Syringe(Weapon).HealBoostAmount;

	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		HealSum *= KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.Static.GetHealPotency(KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo));
	}

    Weapon.ConsumeAmmo(ThisModeNum, AmmoPerFire);
	Instigator.GiveHealth(HealSum, 100);

	/////////////// Vel ///////////////
	if(Instigator.Health <= boostWhen)
	{
		// @todo Activate this feature
		// Log("Ground Speed before boost: " $Instigator.Groundspeed);
		// Instigator.Groundspeed *= boostBy;
		// Log("Ground Speed after boost: " $Instigator.Groundspeed);
		// end @todo
		if( PlayerController(Instigator.Controller) != none )
    	{
			PlayerController(Instigator.controller).ClientMessage("You gained ~ +" $boostBy$ " ~ sprint boost for: " $boostFor$ " seconds, now RUN", 'CriticalEvent');
		}
	}
}

defaultproperties{
	// If HP less than
	boostWhen=50
	// Boost Power
	boostBy=2
	// Boost Duration, seconds
	boostFor=2
}