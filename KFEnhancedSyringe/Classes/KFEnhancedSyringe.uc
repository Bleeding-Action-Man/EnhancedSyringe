//=============================================================================
// Base Mutator by Vel-San - Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
// TODO: Add a config support to change FoV of the Zoom
//=============================================================================

class KFEnhancedSyringe extends Mutator;


simulated function PostBeginPlay()
{
    super.PostNetBeginPlay();
    Log("KFEnhancedSyringe Enabled - Weapon will be given on StartUp!");
    ReplaceDefaultSyringe();
}

function ReplaceDefaultSyringe()
{
    local EnhancedHumanPawn Player;

    foreach DynamicActors(class'KFEnhancedSyringe.EnhancedHumanPawn', Player)
        Player.ReplaceSyringe();
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