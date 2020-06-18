// Self Healing Fire //
class EnhancedSyringeAltFire extends SyringeAltFire;

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

	/////////////// VS ///////////////
	if( PlayerController(Instigator.Controller) != none )
    {
        PlayerController(Instigator.controller).ClientMessage("This is a test message, @@øSPEED BOOST GOES HERE!", 'CriticalEvent');
    }
}