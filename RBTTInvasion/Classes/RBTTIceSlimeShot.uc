class RBTTIceSlimeShot extends UTProj_BioShot;

// Vars for freezing people!!
var float IceTime;
var int IceDamage;
var float IceDamageInterval;

function FreezeVictim(Pawn P)
{
	class'RBTTIceSlime'.static.AttachIce(P, InstigatorController, WorldInfo, IceTime, IceDamage, IceDamageInterval);
}

defaultproperties
{
	IceTime = 2
	IceDamage = 0.f
	IceDamageInterval = 0.f


	Speed=2000.0
	Damage=21.0
	MomentumTransfer=40000
	MyDamageType=class'UTDmgType_BioGoo'
	LifeSpan=12.0
	RotationRate=(Pitch=50000)
	DesiredRotation=(Pitch=30000)
	bCollideWorld=true
	TossZ=0.0
	MaxEffectDistance=7000.0
	Buoyancy=1.5

	RestTime=3.0
	DripTime=1.8
	CheckRadius=40.0


	//	ProjFlightTemplate=ParticleSystem'Envy_Effects.FX.Bio_Splat'
	ProjExplosionTemplate=ParticleSystem'RBTTSlime.Particles.Ice_Bio_Primary_PoP'
	HitPawnTemplate=ParticleSystem'RBTTSlime.Particles.Ice_Bio_Player_Hit'
	HitBioTemplate=ParticleSystem'RBTTSlime.Particles.Ice_Bio_Blob_hits_Blob_Burst'
	ExplosionLightClass=class'UTGame.UTBioExplosionLight'

	Explosionsound=SoundCue'A_Weapon_BioRifle.Weapon.A_BioRifle_FireImpactExplode_Cue'
	ImpactSound=SoundCue'A_Weapon_BioRifle.Weapon.A_BioRifle_FireImpactExplode_Cue'
	Physics=PHYS_Falling

	Begin Object Name=CollisionCylinder
		CollisionRadius=0
		CollisionHeight=0
		CollideActors=true
	End Object

	Begin Object Name=ProjectileMesh
		StaticMesh=StaticMesh'WP_BioRifle.Mesh.S_Bio_Ball'
		CullDistance=12000
		CollideActors=false
		CastShadow=false
		bAcceptsLights=false
		BlockRigidBody=false
		BlockActors=false
		bUseAsOccluder=FALSE
		Materials(0)=MaterialInterface'RBTTSlime.IceSlimeMaterial'
	End Object
	Components.Add(ProjectileMesh)
	GooMesh=ProjectileMesh

	WallHit=ParticleSystem'RBTTSlime.Particles.Ice_Bio_Impact_Primary_Wall';
	FloorHit=ParticleSystem'RBTTSlime.Particles.Ice_Bio_Impact_Primary_Floor';
	CeilingHit=ParticleSystem'RBTTSlime.Particles.Ice_Bio_Impact_Primary_Ceiling';

	WallThreshold = 0.3f;
	GooDecalTemplate=MaterialInterface'RBTTSlime.Materials.Ice_Bio_Splat_DecalBio_Splat_Decal'
	bWaitForEffects=false

	GooDecalChoices[0]=MaterialInterface'RBTTSlime.Materials.Ice_Bio_Splat_DecalBio_Splat_Decal'
	GooDecalChoices[1]=MaterialInterface'RBTTSlime.Materials.Ice_Bio_Splat_DecalBio_Splat_Decal'
	SteppedInSound=SoundCue'A_Weapon_BioRifle.Weapon.A_BioRifle_FireImpactFizzle_Cue'
	HitMode=HIT_None
}