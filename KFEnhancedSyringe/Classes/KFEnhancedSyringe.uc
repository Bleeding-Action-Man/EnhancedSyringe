//=============================================================================
// Base Mutator by Vel-San - Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//=============================================================================

class KFEnhancedSyringe extends Mutator;

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();
    log("Enhanced Syringe has been enabled!");
    EnforceEnhancedSyringe();
}

function EnforceEnhancedSyringe(){
  local EnhancedHumanPawn Player;

  foreach DynamicActors(Class'EnhancedHumanPawn',Player)
  {
    Player.ReplaceSyringe();
  }
}

defaultproperties
{
    // Mut Info
    GroupName="KF-EnhancedSyringe"
    FriendlyName="Enhanced Syringe Mutator"
    Description="An Enhanced version of the Med Syringe; - By Vel-San"

    // Mandatory Vars
	  bAddToServerPackages=true
    bAlwaysRelevant=True
    RemoteRole=ROLE_SimulatedProxy
}