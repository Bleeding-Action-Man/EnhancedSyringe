//=============================================================================
// EnhancedSyringeAltFire
// Self Healing Fire
// Gives boost to players when they heal below a threshold
//=============================================================================

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

  GiveBoost();
}

Function GiveBoost()
{
  local float LastTimeBoosted, EndBoostAt;
  local PlayerController PC;
  local KFHumanPawn KFP;

  if(Instigator.Health <= class'KFEnhancedSyringe'.default.Mut.BoostWhen)
  {
    if( PlayerController(Instigator.Controller) != none )
    {
      PlayerController(Instigator.controller).ClientMessage(class'KFEnhancedSyringe'.default.Mut.BoostMessage, 'CriticalEvent');
    }

    PC = PlayerController(Instigator.Controller);
    KFP = KFHumanPawn(PC.Pawn);

    class'KFEnhancedSyringe'.default.Mut.MutLog("-----|| Boost Activated for: " $PC.PlayerReplicationInfo.PlayerName$ " ||-----");
    class'KFEnhancedSyringe'.default.Mut.BroadcastMSG("-----|| Sprint Boost Activated for " $PC.PlayerReplicationInfo.PlayerName$ " ||-----");

    if(class'KFEnhancedSyringe'.default.Mut.Debug){
      class'KFEnhancedSyringe'.default.Mut.MutLog("-----|| Ground Speed before boost: " $KFP.default.Groundspeed$ " ||-----");
    }

    KFP.default.Groundspeed = class'KFEnhancedSyringe'.default.Mut.BoostPower;

    LastTimeBoosted = Level.TimeSeconds;
    EndBoostAt = LastTimeBoosted + float(class'KFEnhancedSyringe'.default.Mut.BoostDuration);

    class'KFEnhancedSyringe'.default.Mut.GetPlayerController(PC);
    class'KFEnhancedSyringe'.default.Mut.GetSeconds(EndBoostAt);

    if(class'KFEnhancedSyringe'.default.Mut.Debug){
      class'KFEnhancedSyringe'.default.Mut.MutLog("-----|| Ground Speed after boost: " $KFP.default.Groundspeed$ " ||-----");
      class'KFEnhancedSyringe'.default.Mut.MutLog("-----|| Boost Started at: " $LastTimeBoosted$ " ||-----");
      class'KFEnhancedSyringe'.default.Mut.MutLog("-----|| Boost will end at: " $EndBoostAt$ " ||-----");
    }
  }
}

defaultproperties
{
  FireRate = 0.2
  FireAnimRate = 5
}