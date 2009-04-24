/**
 * Copyright 1998-2007 Epic Games, Inc. All Rights Reserved.
 */

class RBTTGasBagFamilyInfo extends UTFamilyInfo
	abstract;



//okie here we need to add new UTGib_HumanAccessories  which will have shoulder pads and other such sweet things

defaultproperties
{
   FamilyID="GasBag"
   Faction="RBTTMonster"
   AnimSets(0)=None
   BloodSplatterDecalMaterial=MaterialInstanceTimeVarying'T_FX.DecalMaterials.MITV_FX_OilDecal_Small01'
   Gibs(0)=(BoneName="Root",GibClass=Class'UTGame.UTGib_RobotArm')
   Gibs(1)=(BoneName="Root",GibClass=Class'UTGame.UTGib_RobotHand',bHighDetailOnly=True)
   Gibs(2)=(BoneName="Root",GibClass=Class'UTGame.UTGib_RobotLeg')
   Gibs(3)=(BoneName="Root",GibClass=Class'UTGame.UTGib_RobotLeg')
   Gibs(4)=(BoneName="Root",GibClass=Class'UTGame.UTGib_RobotTorso')
   Gibs(5)=(BoneName="Root",GibClass=Class'UTGame.UTGib_RobotChunk',bHighDetailOnly=True)
   Gibs(6)=(BoneName="Root",GibClass=Class'UTGame.UTGib_RobotChunk',bHighDetailOnly=True)
   Gibs(7)=(BoneName="Root",GibClass=Class'UTGame.UTGib_RobotChunk',bHighDetailOnly=True)
   Gibs(8)=(BoneName="Root",GibClass=Class'UTGame.UTGib_RobotArm',bHighDetailOnly=True)
   DeathMeshNumMaterialsToSetResident=1
   SkeletonBurnOutMaterials(0)=MaterialInstanceTimeVarying'CH_Skeletons.Materials.MITV_CH_Skeletons_Human_01_BO'
   HeadShotEffect=ParticleSystem'T_FX.Effects.P_FX_HeadShot_Corrupt'
   BloodEffects(0)=(Template=ParticleSystem'T_FX.Effects.P_FX_Bloodhit_Corrupt_Far')
   BloodEffects(1)=(Template=ParticleSystem'T_FX.Effects.P_FX_Bloodhit_Corrupt_Mid')
   BloodEffects(2)=(Template=ParticleSystem'T_FX.Effects.P_FX_Bloodhit_Corrupt_Near')
   Name="Default__RBTTGasBagFamilyInfo"
   ObjectArchetype=UTFamilyInfo'UTGame.Default__UTFamilyInfo'
}
