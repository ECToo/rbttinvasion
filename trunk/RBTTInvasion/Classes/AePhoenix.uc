class AePhoenix extends RBTTScarySkull;

// /////////// WEAPON STUFZZZ ///////////////////////////////// //
function byte BestMode(){	return 0;	}

simulated function float GetFireInterval( byte FireModeNum ){	return 0.5;	}

simulated function float GetTraceRange()
{
	return GetCollisionRadius() + 64;
}

function float SuggestAttackStyle() {	return 1.00;	}

simulated function InstantFire()
{
	if(VSize(Controller.Enemy.Location - Location) > GetCollisionRadius() + 64)
	{
		return; // enemy too far away to punch it in teh face!
	}
	
	LogInternal(">> Animation duration::"@FullBodyAnimSlot.PlayCustomAnim('Sting', 1.0, 0.2, 0.2, FALSE, TRUE));
		
	super.InstantFire();
}

defaultproperties
{
   MonsterName="AePhoenix"
   bEmptyHanded=True
   Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment ObjName=MyLightEnvironment Archetype=DynamicLightEnvironmentComponent'RBTTInvasion.Default__RBTTScarySkull:MyLightEnvironment'
      ObjectArchetype=DynamicLightEnvironmentComponent'RBTTInvasion.Default__RBTTScarySkull:MyLightEnvironment'
   End Object
   LightEnvironment=MyLightEnvironment
   Begin Object Class=ParticleSystemComponent Name=GooDeath ObjName=GooDeath Archetype=ParticleSystemComponent'RBTTInvasion.Default__RBTTScarySkull:GooDeath'
      ObjectArchetype=ParticleSystemComponent'RBTTInvasion.Default__RBTTScarySkull:GooDeath'
   End Object
   BioBurnAway=GooDeath
   Begin Object Class=DynamicLightEnvironmentComponent Name=DeathVisionLightEnv ObjName=DeathVisionLightEnv Archetype=DynamicLightEnvironmentComponent'RBTTInvasion.Default__RBTTScarySkull:DeathVisionLightEnv'
      ObjectArchetype=DynamicLightEnvironmentComponent'RBTTInvasion.Default__RBTTScarySkull:DeathVisionLightEnv'
   End Object
   FirstPersonDeathVisionLightEnvironment=DeathVisionLightEnv
   Begin Object Class=UTSkeletalMeshComponent Name=FirstPersonArms ObjName=FirstPersonArms Archetype=UTSkeletalMeshComponent'RBTTInvasion.Default__RBTTScarySkull:FirstPersonArms'
      Begin Object Class=AnimNodeSequence Name=MeshSequenceA ObjName=MeshSequenceA Archetype=AnimNodeSequence'RBTTInvasion.Default__RBTTScarySkull:FirstPersonArms.MeshSequenceA'
         ObjectArchetype=AnimNodeSequence'RBTTInvasion.Default__RBTTScarySkull:FirstPersonArms.MeshSequenceA'
      End Object
      Animations=AnimNodeSequence'RBTTInvasion.Default__AePhoenix:FirstPersonArms.MeshSequenceA'
      ObjectArchetype=UTSkeletalMeshComponent'RBTTInvasion.Default__RBTTScarySkull:FirstPersonArms'
   End Object
   ArmsMesh(0)=FirstPersonArms
   Begin Object Class=UTSkeletalMeshComponent Name=FirstPersonArms2 ObjName=FirstPersonArms2 Archetype=UTSkeletalMeshComponent'RBTTInvasion.Default__RBTTScarySkull:FirstPersonArms2'
      Begin Object Class=AnimNodeSequence Name=MeshSequenceB ObjName=MeshSequenceB Archetype=AnimNodeSequence'RBTTInvasion.Default__RBTTScarySkull:FirstPersonArms2.MeshSequenceB'
         ObjectArchetype=AnimNodeSequence'RBTTInvasion.Default__RBTTScarySkull:FirstPersonArms2.MeshSequenceB'
      End Object
      Animations=AnimNodeSequence'RBTTInvasion.Default__AePhoenix:FirstPersonArms2.MeshSequenceB'
      ObjectArchetype=UTSkeletalMeshComponent'RBTTInvasion.Default__RBTTScarySkull:FirstPersonArms2'
   End Object
   ArmsMesh(1)=FirstPersonArms2
   Begin Object Class=UTAmbientSoundComponent Name=AmbientSoundComponent ObjName=AmbientSoundComponent Archetype=UTAmbientSoundComponent'RBTTInvasion.Default__RBTTScarySkull:AmbientSoundComponent'
      ObjectArchetype=UTAmbientSoundComponent'RBTTInvasion.Default__RBTTScarySkull:AmbientSoundComponent'
   End Object
   PawnAmbientSound=AmbientSoundComponent
   Begin Object Class=UTAmbientSoundComponent Name=AmbientSoundComponent2 ObjName=AmbientSoundComponent2 Archetype=UTAmbientSoundComponent'RBTTInvasion.Default__RBTTScarySkull:AmbientSoundComponent2'
      ObjectArchetype=UTAmbientSoundComponent'RBTTInvasion.Default__RBTTScarySkull:AmbientSoundComponent2'
   End Object
   WeaponAmbientSound=AmbientSoundComponent2
   Begin Object Class=SkeletalMeshComponent Name=OverlayMeshComponent0 ObjName=OverlayMeshComponent0 Archetype=SkeletalMeshComponent'RBTTInvasion.Default__RBTTScarySkull:OverlayMeshComponent0'
      ObjectArchetype=SkeletalMeshComponent'RBTTInvasion.Default__RBTTScarySkull:OverlayMeshComponent0'
   End Object
   OverlayMesh=OverlayMeshComponent0
   Begin Object Class=DynamicLightEnvironmentComponent Name=XRayEffectLightEnv ObjName=XRayEffectLightEnv Archetype=DynamicLightEnvironmentComponent'RBTTInvasion.Default__RBTTScarySkull:XRayEffectLightEnv'
      ObjectArchetype=DynamicLightEnvironmentComponent'RBTTInvasion.Default__RBTTScarySkull:XRayEffectLightEnv'
   End Object
   XRayEffectLightEnvironment=XRayEffectLightEnv
   DefaultFamily=Class'RBTTInvasion.AePhoenixFamilyInfo'
   AccelRate=1000.000000
   Begin Object Class=SkeletalMeshComponent Name=WPawnSkeletalMeshComponent ObjName=WPawnSkeletalMeshComponent Archetype=SkeletalMeshComponent'UTGame.Default__UTPawn:WPawnSkeletalMeshComponent'
      AnimTreeTemplate=None
      AnimSets(0)=None
      Scale3D=(X=5.000000,Y=5.000000,Z=5.000000)
      ObjectArchetype=SkeletalMeshComponent'UTGame.Default__UTPawn:WPawnSkeletalMeshComponent'
   End Object
   Mesh=WPawnSkeletalMeshComponent
   Begin Object Class=CylinderComponent Name=CollisionCylinder ObjName=CollisionCylinder Archetype=CylinderComponent'UTGame.Default__UTPawn:CollisionCylinder'
      ObjectArchetype=CylinderComponent'UTGame.Default__UTPawn:CollisionCylinder'
   End Object
   CylinderComponent=CollisionCylinder
   Components(0)=CollisionCylinder
   Begin Object Class=ArrowComponent Name=Arrow ObjName=Arrow Archetype=ArrowComponent'RBTTInvasion.Default__RBTTScarySkull:Arrow'
      ObjectArchetype=ArrowComponent'RBTTInvasion.Default__RBTTScarySkull:Arrow'
   End Object
   Components(1)=Arrow
   Components(2)=MyLightEnvironment
   Components(3)=WPawnSkeletalMeshComponent
   Components(4)=AmbientSoundComponent
   Components(5)=AmbientSoundComponent2
   Components(6)=MyLightEnvironment
   Components(8)=CollisionCylinder
   CollisionComponent=CollisionCylinder
   Name="Default__AePhoenix"
}
