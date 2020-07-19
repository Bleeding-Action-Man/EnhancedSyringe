//=============================================================================
// EnhancedSyringeAltFire
// Everything written in this class is edited and should be different than the
// original values
// Self Healing Fire
//=============================================================================

class EnhancedSyringeAltFire extends SyringeAltFire;

var int boostWhen, boost, boostFor, current_time_seconds, end_boost_at_seconds;

var color AquaC, WhiteC, PurpleC, RedC;

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
	boost = class'KFEnhancedSyringe'.default.boost;
	boostFor = class'KFEnhancedSyringe'.default.boostFor;
	boostWhen = class'KFEnhancedSyringe'.default.boostWhen;

	end_boost_at_seconds = Level.TimeSeconds + boostFor;
	current_time_seconds = end_boost_at_seconds - boostFor;
	
	MutLog("Current Time Seconds: " $current_time_seconds);
	MutLog("Boost should end at: " $end_boost_at_seconds);
	
	if(Instigator.Health <= boostWhen)
	{
		if( PlayerController(Instigator.Controller) != none )
    	{
			PlayerController(Instigator.controller).ClientMessage("You gained ~ " $ColorInt(boost, AquaC)$ColorString(" ~ sprint boost for: ", WhiteC)$ColorInt(boostFor, PurpleC)$ColorString(" seconds, because you're below ", WhiteC)$ColorInt(boostWhen, RedC)$ColorString(" HP, now RUN!", WhiteC), 'CriticalEvent');
		}
		MutLog("Ground Speed before boost: " $Instigator.Groundspeed);
		MutLog("Default Ground Speed before boost: " $Instigator.default.Groundspeed);

		Instigator.default.Groundspeed = boost;
		default.end_boost_at_seconds = end_boost_at_seconds;
		
		MutLog("Ground Speed after boost: " $Instigator.Groundspeed);
		MutLog("Default Ground Speed after boost: " $Instigator.default.Groundspeed);
	}
}

// Thanks to PoosH, taken from ScrN for easier color encoding instead of copy/paste from ServerColor.exe
// Slightly edited to my needs
static final function string ColorInt(int i, color c)
{
    return chr(27)$chr(max(c.R,1))$chr(max(c.G,1))$chr(max(c.B,1))$i;
}
static final function string ColorString(string s, color c)
{
    return chr(27)$chr(max(c.R,1))$chr(max(c.G,1))$chr(max(c.B,1))$s;
}

simulated function MutLog(string s)
{
    log(s, 'EnhancedSyringe');
}

defaultproperties{
	// end_boost_at_seconds
	end_boost_at_seconds=0
	// FireRate
	FireRate=0.2
	// FireAnimeRate
    FireAnimRate = 5
	// FireEndAnimRate=4
	
	// ClientMessage Colors
	AquaC = (R=0,G=255,B=255,A=255)
	PurpleC = (R=255,G=0,B=255,A=255)
	RedC = (R=255,G=0,B=0,A=255)
	WhiteC = (R=255,G=255,B=255,A=255)
}