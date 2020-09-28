//=============================================================================
// Base Mutator by Vel-San - Contact on Steam using the following Profile Link
// for more information, feedback, questions or requests
// https://steamcommunity.com/id/Vel-San/
//=============================================================================

class KFEnhancedSyringe extends Mutator Config(KFEnhancedSyringe);

var() config int iBoostWhen, iBoostPower, iBoostDuration;
var() config string sBoostMessage;
var() config bool bDebug;

var int BoostWhen, BoostPower, BoostDuration;
var string BoostMessage;
var bool Debug;

replication
{
	unreliable if (Role == ROLE_Authority)
		iBoostWhen, iBoostPower, iBoostDuration, sBoostMessage, bDebug,
        BoostWhen, BoostPower, BoostDuration, BoostMessage, Debug;
}

function PostBeginPlay()
{
    TimeStampLog("-----|| Server Vars Replicated & Initialized ||-----");
	BoostWhen = iBoostWhen;
    BoostPower = iBoostPower;
	BoostDuration = iBoostDuration;
    BoostMessage = sBoostMessage;
    Debug = bDebug;

    // Color Message
    ReplaceText(BoostMessage, "%BD", BoostDuration);
    SetColor(BoostMessage);
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);
    PlayInfo.AddSetting("KFEnhancedSyringe", "iBoostWhen", "Start Boost if HP less than", 0, 1, "text");
    PlayInfo.AddSetting("KFEnhancedSyringe", "iBoostPower", "Boost Power", 0, 2, "text");
    PlayInfo.AddSetting("KFEnhancedSyringe", "iBoostDuration", "Duration of Boost (seconds)", 0, 3, "text");
    PlayInfo.AddSetting("KFEnhancedSyringe", "sBoostMessage", "Boost Message", 0, 4, "text");
    PlayInfo.AddSetting("KFEnhancedSyringe", "bDebug", "Debug", 0, 5, "check");
}

static function string GetDescriptionText(string SettingName)
{
	switch(SettingName)
	{
		case "iBoostWhen":
			return "If player's HP is less than the given value, then the Boost is activated, default is 50hp";
        case "iBoostPower":
			return "Amount of Boost to be given, default game base speed is 200, default mutator speed is 300";
        case "iBoostDuration":
			return "Duration of the Boost, in seconds, default is 2";
         case "sBoostMessage":
			return "Message to show for players when they are boosted";
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
            MutLog("-----|| DEBUG - KF-Enhanced Syringe - Other: " $GetItemName(String(other))$ " ||-----");
        }

        if ( GetItemName(String(other)) == "Syringe" )
		{
            ReplaceWith( Other, "KFEnhancedSyringe.EnhancedSyringe" );

            if(Debug){
                MutLog("-----|| DEBUG - Other: " $String(other)$ " ||-----");
                MutLog("-----|| DEBUG - Exit CheckReplacement ||-----");
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
    FriendlyName="Enhanced Syringe Mutator - v3.1"
    Description="An Enhanced version of the Med Syringe, gives you a 'Customizable' sprint boost to save your sorry ass life from being Pounded by a FleshPound; - By Vel-San"

    // Mut Vars
	iBoostWhen=50   // If HP less than
	iBoostPower=300
	iBoostDuration=2
    sBoostMessage="You've been fucking %rboosted%w for %g%BD%w seconds! Run the %bFuck%w Away!"
    bDebug=False
}