//=============================================================================
// EnhancedSyringeAltFire
// Self Healing Fire
// Gives boost to players when they heal below a threshold
//=============================================================================

class EnhancedSyringeAltFire extends SyringeAltFire;

var KFEnhancedSyringe MasterHandler;
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

	GiveBoost(Instigator.Health);
}

Function GiveBoost(int PlayerHealth)
{
	if(PlayerHealth <= MasterHandler.BoostWhen)
	{
		if( PlayerController(Instigator.Controller) != none )
    	{
			PlayerController(Instigator.controller).ClientMessage(MasterHandler.BoostMessage, 'CriticalEvent');
		}
		if(MasterHandler.Debug){
			MutLog("-----|| DEBUG - Ground Speed before boost: " $Instigator.Groundspeed$ " ||-----");
		}

		Instigator.Groundspeed = MasterHandler.BoostPower;
		LastTimeBoosted = Level.TimeSeconds;
		EndBoostAt = LastTimeBoosted + MasterHandler.BoostDuration;
	}
}

simulated function Tick(float DeltaTime){
	if (EndBoostAt < Level.TimeSeconds){
		if(MasterHandler.Debug){
			MutLog("-----|| DEBUG - Boost Ended ||-----");
		}

		Instigator.Groundspeed = Instigator.default.Groundspeed;

		if(MasterHandler.Debug){
			MutLog("-----|| DEBUG - Ground Speed after boost: " $Instigator.Groundspeed$ " ||-----");
		}
	}
}

defaultproperties
{
	FireRate=0.2
    FireAnimRate = 5
}