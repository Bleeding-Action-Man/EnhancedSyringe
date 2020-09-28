//=============================================================================
// Base Mutator by Vel-San - Contact on Steam using the following Profile Link
// for more information, feedback, questions or requests
// https://steamcommunity.com/id/Vel-San/
//=============================================================================

class KFEnhancedSyringe extends Mutator Config(KFEnhancedSyringe);

var() config int iBoostWhen, iBoost, iBoostFor;
var() config bool bDebug;

var int BoostWhen, Boost, BoostFor;
var bool Debug;

var int iCurrentTime;

replication
{
	unreliable if (Role == ROLE_Authority)
		iBoostWhen, iBoost, iBoostFor, bDebug,
        BoostWhen, Boost, BoostFor, Debug;
}

simulated function PostNetBeginPlay()
{
    super.PostNetBeginPlay();
	// Future code goes here if values needed from the server
}

simulated function PostBeginPlay()
{
    TimeStampLog("-----|| Server Vars Replicated & Initialized ||-----");
	BoostWhen = iBoostWhen;
    Boost = iBoost;
	BoostFor = iBoostFor;
    Debug = bDebug;
}

simulated function Tick( float Delta )
{
  iCurrentTime = Level.TimeSeconds;
  if (iCurrentTime > class'EnhancedSyringeAltFire'.default.end_boost_at_seconds)
  {
    // Uncomment LOG for Debugging | This WILL Spam your Logs
    // MutLog("Current Mut Timer Seconds: " $iCurrentTime );
    // MutLog("Default GroundSpeed from MUT Timer Before Reset: " $class'KFHumanPawn'.default.GroundSpeed);
    // MutLog("Boost Duration Ended, reverting back to 200");
    class'KFHumanPawn'.default.GroundSpeed = 200;
    // MutLog("Default GroundSpeed from MUT Timer After Reset: " $class'KFHumanPawn'.default.GroundSpeed);
  }
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("KFEnhancedSyringe", "iBoostWhen", "Start Boost if HP less than", 0, 1, "text");
    PlayInfo.AddSetting("KFEnhancedSyringe", "iBoost", "Boost Power", 0, 2, "text");
    PlayInfo.AddSetting("KFEnhancedSyringe", "iBoostFor", "Duration of Boost (seconds)", 0, 3, "text");
    PlayInfo.AddSetting("KFEnhancedSyringe", "bDebug", "Debug", 0, 4, "text");
}

static function string GetDescriptionText(string SettingName)
{
	switch(SettingName)
	{
		case "iBoostWhen":
			return "If player's HP is less than the given value, then the iBoost is activated, default is 50hp";
        case "iBoost":
			return "Amount of Boost to be given, default game base speed is 200, default mutator speed is 300";
        case "iBoostFor":
			return "Duration of the iBoost, in seconds, default is 2";
        case "bDebug":
			return "Enable debug logs";
		default:
			return Super.GetDescriptionText(SettingName);
	}
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
    if ( Other.IsA('Weapon') )
	{
        if(Debug){
            MutLog("KF-Enhanced Syringe - Other: " $GetItemName(String(other)));
        }

        if ( GetItemName(String(other)) == "Syringe" )
		{
            ReplaceWith( Other, "KFEnhancedSyringe.EnhancedSyringe" );

            if(Debug){
                MutLog("Other: " $String(other));
                MutLog("Exit CheckReplacement");
            }

            return false;
        }
    }
    return true;
}

function ModifyPlayer(Pawn Player)
{
     Super.ModifyPlayer(Player);
     MutLog("KF-EnhancedSyringe Mut Enabled - Syringe will be replaced on StartUp!");
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

/////////////////////////////////////////////////////////////////////////
// BELOW SECTION IS CREDITED FOR NikC //

// Apply Color Tags To Message
function SetColor(out string Msg)
{
  local int i;
  for(i=0; i<ColorList.Length; i++)
  {
    if(ColorList[i].ColorTag!="" && InStr(Msg, ColorList[i].ColorTag)!=-1)
    {
      ReplaceText(Msg, ColorList[i].ColorTag, FormatTagToColorCode(ColorList[i].ColorTag, ColorList[i].Color));
    }
  }
}

// Format Color Tag to ColorCode
function string FormatTagToColorCode(string Tag, Color Clr)
{
  Tag=Class'GameInfo'.Static.MakeColorCode(Clr);
  Return Tag;
}

function string RemoveColor(string S)
{
  local int P;
  P=InStr(S,Chr(27));
  While(P>=0)
  {
    S=Left(S,P)$Mid(S,P+4);
    P=InStr(S,Chr(27));
  }
  Return S;
}
//////////////////////////////////////////////////////////////////////

defaultproperties
{
    // Mut Info
    GroupName="KF-EnhancedSyringe"
    FriendlyName="Enhanced Syringe Mutator - v3.0"
    Description="An Enhanced version of the Med Syringe, gives you a 'customizable' speed boost if you go below 'customizable' HP for 'customizable' duration; - By Vel-San"

    // Mut Vars
    // If HP less than
	iBoostWhen=50
	// Boost Power
	iBoost=300
	// Boost Duration, seconds
	iBoostFor=2
}