class EnhancedHumanPawn extends KFHumanPawn;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    ReplaceSyringe();
}

function ReplaceSyringe(){
    RequiredEquipment[3] = String(class'KFEnhancedSyringe.EnhancedSyringe');
}