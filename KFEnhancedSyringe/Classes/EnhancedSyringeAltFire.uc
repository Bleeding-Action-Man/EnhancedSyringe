//=============================================================================
// EnhancedSyringeAltFire
// Self Healing Fire
// Gives boost to players when they heal below a threshold
//=============================================================================

class EnhancedSyringeAltFire extends SyringeAltFire;

var float LastTimeBoosted, EndBoostAt;

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

	GiveBoost();
}

Function GiveBoost()
{
	if(Instigator.Health <= class'KFEnhancedSyringe'.default.Mut.BoostWhen)
	{
		if( PlayerController(Instigator.Controller) != none )
    	{
			PlayerController(Instigator.controller).ClientMessage(class'KFEnhancedSyringe'.default.Mut.BoostMessage, 'CriticalEvent');
		}

    	class'KFEnhancedSyringe'.default.Mut.MutLog("-----|| Boost Activated! ||-----");

		if(class'KFEnhancedSyringe'.default.Mut.Debug){
			class'KFEnhancedSyringe'.default.Mut.MutLog("-----|| DEBUG - Ground Speed before boost: " $Instigator.Groundspeed$ " ||-----");
		}

		Instigator.default.Groundspeed = class'KFEnhancedSyringe'.default.Mut.BoostPower;
		LastTimeBoosted = Level.TimeSeconds;
		EndBoostAt = LastTimeBoosted + float(class'KFEnhancedSyringe'.default.Mut.BoostDuration);
		class'KFEnhancedSyringe'.default.Mut.GetSeconds(EndBoostAt);
		if(class'KFEnhancedSyringe'.default.Mut.Debug){
			class'KFEnhancedSyringe'.default.Mut.MutLog("-----|| DEBUG - Ground Speed after boost: " $Instigator.default.Groundspeed$ " ||-----");
			class'KFEnhancedSyringe'.default.Mut.MutLog("-----|| DEBUG - Boost Started at: " $LastTimeBoosted$ " ||-----");
			class'KFEnhancedSyringe'.default.Mut.MutLog("-----|| DEBUG - Boost will end at: " $EndBoostAt$ " ||-----");
		}
	}
}

defaultproperties
{
	FireRate = 0.2
    FireAnimRate = 5
}