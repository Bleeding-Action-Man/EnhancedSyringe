//=============================================================================
// Base Mutator by Vel-San - Contact on Steam using the following Profile Link
// for more information, feedback, questions or requests
// https://steamcommunity.com/id/Vel-San/
//=============================================================================

class KFEnhancedSyringe extends Mutator Config(KFEnhancedSyringe);

var config int boostWhen, boost, boostFor;

var int current_time_seconds;

replication
{
	unreliable if (Role == ROLE_Authority)
		boostWhen, boost, boostFor;
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();
	// Future code goes here if values needed from the server
}

simulated function PostNetReceive()
{
    super.PostNetReceive();
    TimeStampLog("-----|| Server Vars Replicated ||-----");
	default.boostWhen = boostWhen;
    default.boost = boost;
	default.boostFor = boostFor;
}

simulated function Tick( float Delta )
{
  current_time_seconds = Level.TimeSeconds;
  if (current_time_seconds > class'EnhancedSyringeAltFire'.default.end_boost_at_seconds)
  {
    // Uncomment LOG for Debugging | This WILL Spam your Logs 
    // MutLog("Current Mut Timer Seconds: " $current_time_seconds );
    // MutLog("Default GroundSpeed from MUT Timer Before Reset: " $class'KFHumanPawn'.default.GroundSpeed);
    // MutLog("Boost Duration Ended, reverting back to 200");
    class'KFHumanPawn'.default.GroundSpeed = 200;
    // MutLog("Default GroundSpeed from MUT Timer After Reset: " $class'KFHumanPawn'.default.GroundSpeed);
  }
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("KFEnhancedSyringe", "boostWhen", "Start Boost if HP less than", 0, 0, "text");
    PlayInfo.AddSetting("KFEnhancedSyringe", "boost", "Boost Power", 0, 0, "text");
    PlayInfo.AddSetting("KFEnhancedSyringe", "boostFor", "Duration of Boost (seconds)", 0, 0, "text");
}

static function string GetDescriptionText(string SettingName)
{
	switch(SettingName)
	{
		case "boostWhen":
			return "If player's HP is less than the given value, then the boost is activated, default is 50hp";
        case "boost":
			return "Amount of Boost to be given, default game base speed is 200, default mutator speed is 300";
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
        // MutLog("KF-Enhanced Syringe - Other: " $GetItemName(String(other)));
        if ( GetItemName(String(other)) == "Syringe" )
		{
            ReplaceWith( Other, "KFEnhancedSyringe.EnhancedSyringe" );
            // Just to confirm the replacement
            MutLog("Other: " $String(other));
            MutLog("Exit CheckReplacement");
            return false;
        }
    }
    return true;
}

function ModifyPlayer(Pawn Player)
{
     Super.ModifyPlayer(Player);
     MutLog("KF-EnhancedSyringe Mut Enabled - Weapon will be replaced on StartUp!");
     Player.GiveWeapon("KFEnhancedSyringe.EnhancedSyringe");
}

simulated function TimeStampLog(coerce string s)
{
    log("["$Level.TimeSeconds$"s]" @ s, 'EnhancedSyringe');
}

simulated function MutLog(string s)
{
    log(s, 'EnhancedSyringe');
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

defaultproperties
{
    // Mut Info
    GroupName="KF-EnhancedSyringe"
    FriendlyName="Enhanced Syringe Mutator - v3.0"
    Description="An Enhanced version of the Med Syringe, gives you a customizable speed boost if you go below customizable hp for customizable duration; - By Vel-San"

    // Mut Vars
    // If HP less than
	boostWhen=50
	// Boost Power
	boost=300
	// Boost Duration, seconds
	boostFor=2

    // Mandatory Vars
	bAddToServerPackages=True
    bAlwaysRelevant=True
    RemoteRole=ROLE_SimulatedProxy
    bNetNotify=True
}