/**
 * Copyright 1998-2007 Epic Games, Inc. All Rights Reserved.
 */

class RBTTInfernalFamilyInfo extends UTFamilyInfo;



//okie here we need to add new UTGib_HumanAccessories  which will have shoulder pads and other such sweet things

defaultproperties
{
   FamilyID="HumanSkeleton"
   Faction="RBTTMonster"
   PhysAsset=PhysicsAsset'CH_Skeletons.Mesh.SK_CH_Skeleton_Human_Male_Physics'
   AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
   MasterSkeleton=SkeletalMesh'CH_Skeletons.Mesh.SK_CH_Skeleton_Human_Male'
   FamilyEmotes(0)=(EmoteName="Spróbuj szczęścia")
   FamilyEmotes(1)=(EmoteName="Hulahop")
   FamilyEmotes(2)=(EmoteName="Dymanie")
   FamilyEmotes(3)=(EmoteName="Kulka w łeb")
   FamilyEmotes(4)=(EmoteName="Podejdź")
   FamilyEmotes(5)=(EmoteName="Poderżnięcie gardła")
   FamilyEmotes(6)=(EmoteName="Atakuj")
   FamilyEmotes(7)=(EmoteName="Broń")
   FamilyEmotes(8)=(EmoteName="Trzymaj pozycję")
   FamilyEmotes(9)=(EmoteName="Osłaniaj mnie")
   FamilyEmotes(10)=(EmoteName="Wolny strzelec")
   FamilyEmotes(11)=(EmoteName="Upuść flagę/Orb")
   FamilyEmotes(12)=(EmoteName="Upuść orb")
   FamilyEmotes(15)=(EmoteName="Potwierdzono")
   FamilyEmotes(16)=(EmoteName="Na pozycji")
   FamilyEmotes(17)=(EmoteName="Atakowany")
   FamilyEmotes(18)=(EmoteName="Teren zabezpieczony")
   FamilyEmotes(19)=(CategoryName="SpecialMove",EmoteTag="ThrowPlasma",EmoteAnim="hoverboardjumpland",bTopHalfEmote=True)
   DeathMeshPhysAsset=PhysicsAsset'CH_Skeletons.Mesh.SK_CH_Skeleton_Human_Male_Physics'
   DeathMeshNumMaterialsToSetResident=1
   DeathMeshBreakableJoints(0)="b_LeftArm"
   DeathMeshBreakableJoints(1)="b_RightArm"
   DeathMeshBreakableJoints(2)="b_LeftLegUpper"
   DeathMeshBreakableJoints(3)="b_RightLegUpper"
   SkeletonBurnOutMaterials(0)=None
   Name="Default__RBTTInfernalFamilyInfo"
   ObjectArchetype=UTFamilyInfo'UTGame.Default__UTFamilyInfo'
}
