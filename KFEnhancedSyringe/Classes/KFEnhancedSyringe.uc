//=============================================================================
// Base Mutator by Vel-San - Contact on Steam using the following Profile Link
// for more information, feedback, questions or requests please contact
// https://steamcommunity.com/id/Vel-San/
//=============================================================================

class KFEnhancedSyringe extends Mutator Config(KFEnhancedSyringe);

var() config int boostWhen;
var() config int boostBy;
var() config int boostFor;

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("KFEnhancedSyringe", "boostWhen", "Start Boost if HP less than", 0, 0, "text");
    PlayInfo.AddSetting("KFEnhancedSyringe", "boostBy", "Boost Power Multiplier", 0, 0, "text");
    PlayInfo.AddSetting("KFEnhancedSyringe", "boostFor", "Duration of Boost (seconds)", 0, 0, "text");

}

static function string GetDescriptionText(string SettingName)
{
	switch(SettingName)
	{
		case "boostWhen":
			return "If player's HP is less than the given value, then the boost is activated, default is 50hp";
        case "boostBy":
			return "Amount of Boost to be given, default is 2";
        case "boostFor":
			return "Duration of the boost, in seconds, default is 2";
		default:
			return Super.GetDescriptionText(SettingName);
	}
}

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

    // Mut Vars
    // If HP less than
	boostWhen=50
	// Boost Power
	boostBy=2
	// Boost Duration, seconds
	boostFor=2

    // Mandatory Vars
	bAddToServerPackages=True
    bAlwaysRelevant=True
    RemoteRole=ROLE_SimulatedProxy
}