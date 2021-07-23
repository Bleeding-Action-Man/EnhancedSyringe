//=============================================================================
// Base Mutator by Vel-San - Contact on Steam using the following Profile Link
// for more information, feedback, questions or requests
// https://steamcommunity.com/id/Vel-San/
//=============================================================================

class KFEnhancedSyringe extends Mutator Config(KFEnhancedSyringe);

var() config int iBoostWhen, iBoostPower, iBoostDuration;
var() config string sBoostMessage;
var() config bool bDebug;

var PlayerController TmpPC;
var KFHumanPawn TmpKFP;
var int BoostWhen, BoostPower, BoostDuration;
var float BoostEndInSeconds;
var string BoostMessage;
var bool Debug;

var KFEnhancedSyringe Mut;

// Colors from Config
struct ColorRecord
{
  var config string ColorName; // Color name, for comfort
  var config string ColorTag; // Color tag
  var config Color Color; // RGBA values
};
var() config array<ColorRecord> ColorList; // Color list

replication
{
  unreliable if (Role == ROLE_Authority)
    iBoostWhen, iBoostPower, iBoostDuration, sBoostMessage, bDebug,
    BoostWhen, BoostPower, BoostDuration, BoostMessage, Debug;
}

function PostBeginPlay()
{
  TimeStampLog("-----|| Server Vars Replicated & Initialized ||-----");
   // Start with Tick Disabled
  Disable('Tick');
  BoostWhen = iBoostWhen;
  BoostPower = iBoostPower;
  BoostDuration = iBoostDuration;
  BoostMessage = sBoostMessage;
  Debug = bDebug;

  // Color Message
  ReplaceText(BoostMessage, "%BD", string(BoostDuration));
  SetColor(BoostMessage);

  // Pointer To self
  Mut = self;
  default.Mut = self;
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
      MutLog("-----|| Enhanced Syringe Name: " $GetItemName(String(other))$ " ||-----");
    }

    if ( GetItemName(String(other)) == "Syringe" )
    {
      ReplaceWith( Other, "KFEnhancedSyringe.EnhancedSyringe" );
      if(Debug){
        MutLog("-----|| Other: " $String(other)$ " ||-----");
        MutLog("-----|| Exit CheckReplacement ||-----");
      }

      return false;
    }
  }
  return true;
}

function ModifyPlayer(Pawn Player)
{
  Super.ModifyPlayer(Player);
  MutLog("-----|| EnhancedSyringe Mut Enabled - Syringe will be replaced on StartUp! ||-----");
  Player.GiveWeapon("KFEnhancedSyringe.EnhancedSyringe");
}

function float GetSeconds(float TmpBoostEndTime){
  BoostEndInSeconds = TmpBoostEndTime;
  Enable('Tick');
  return BoostEndInSeconds;
}

function GetPlayerController(PlayerController PC){
  TmpPC = PC;
  TmpKFP = KFHumanPawn(TmpPC.Pawn);
}

simulated function Tick(float DeltaTime)
{
  if (BoostEndInSeconds < Level.TimeSeconds)
  {
    if (TmpKFP != None)
    {
      TmpKFP.default.GroundSpeed = 200;
      TmpKFP.ModifyVelocity(DeltaTime, Velocity);
      if(Debug){
        MutLog("-----|| Ground Speed after boost-end: " $TmpKFP.default.GroundSpeed$ " ||-----");
      }
      Disable('Tick');
      }
  }
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
// BELOW SECTION IS CREDITED FOR ServerAdsKF Mutator | NikC	& DeeZNutZ //

// Send MSG to Players
event BroadcastMSG(coerce string Msg)
{
  local PlayerController pc;
  local Controller c;
  local string strTemp;

  for(c = level.controllerList; c != none; c = c.nextController)
  {
  // Allow only player controllers
  if(!c.isA('PlayerController'))
    continue;

  pc = PlayerController(c);
  if(pc == none)
    continue;

  // Remove colors for server log and WebAdmin
  if(pc.PlayerReplicationInfo.PlayerID == 0)
  {
    strTemp = RemoveColor(Msg);
    pc.teamMessage(none, strTemp, 'EnhancedSyringe');
    continue;
  }

  pc.teamMessage(none, Msg, 'EnhancedSyringe');
  }
}

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
  FriendlyName="Enhanced Syringe - v4.2"
  Description="An Enhanced version of the Med Syringe, gives you a 'Customizable' sprint boost on low 'Customizable' HP; - By Vel-San"
  bAddToServerPackages=True
  bAlwaysRelevant=True
  RemoteRole=ROLE_SimulatedProxy
  bNetNotify=True

  // Mut Vars
  iBoostWhen=50   // If HP less than
  iBoostPower=350
  iBoostDuration=2
  sBoostMessage="%wYou've been %rboosted%w for %g%BD%w seconds! Run the %bFuck%w Away!"
  bDebug=False
}