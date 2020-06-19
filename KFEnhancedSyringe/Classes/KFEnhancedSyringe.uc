//=============================================================================
// Base Mutator by Vel-San - Contact on Steam using the following Profile Link:
// https://steamcommunity.com/id/Vel-San/
//=============================================================================

class KFEnhancedSyringe extends Mutator;

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    if ( Other.IsA('Weapon') )
	{
        // For Debugging Weapon Names
        // Log("Other :" $ String(other));
        if ( String(Other) == "KF-WestLondon.Syringe" )
		{
            ReplaceWith( Other, "KFEnhancedSyringe.EnhancedSyringe" );
            // Just to confirm the replacement
            Log("Other : " $ String(other));
            Log("Exit CheckReplacement");
            return false;
        }
    }
    return true;
}

function ModifyPlayer(Pawn Player)
{
     Super.ModifyPlayer(Player);
     Log("KF-EnhancedSyringe Mut Enabled - Weapon will be replaced on StartUp!");
     Player.GiveWeapon("KFEnhancedSyringe.EnhancedSyringe");
}

defaultproperties
{
    // Mut Info
    GroupName="KF-EnhancedSyringe"
    FriendlyName="Enhanced Syringe Mutator"
    Description="An Enhanced version of the Med Syringe; - By Vel-San"

    // Mandatory Vars
	bAddToServerPackages=True
    bAlwaysRelevant=True
    RemoteRole=ROLE_SimulatedProxy
}