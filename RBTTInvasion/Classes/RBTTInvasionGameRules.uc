/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class RBTTInvasionGameRules extends GameRules

	config(RBTTInvasion);

struct MonsterNames
{
	var string 				MonsterName;		// The name of the monster, so we can set it's name in the PRI
	var string 				MonsterClassName;	// The class of the monster as a string
	var class<UTPawn> 			MonsterClass;		// The dynamically loaded class of the corresponding MonsterClassName
};
var Array<MonsterNames> 			MonsterTable;		// Hold all monsternames and classes

struct PortalStruct
{
	var class<MonsterSpawner>		PortalClass;		// The class of the portal
	var array<Class<UTPawn> > 		SpawnArray;		// The array that holds the monsters it's gonna spawn
	var int 				SpawnInterval;		// Spawn a monster per X seconds
	var int 				WhenToSpawn;		// Time in seconds from the beginning of the wave
};
var Array<PortalStruct>				PortalTable;		// Holds all the different portals

struct WaveTable
{
	var array<int> 				MonsterNum;		// MonsterTable[MonsterNum];
	var array<int> 				PortalNum;		// PortalTable[PortalNum];
	var array<bool>				bPortalSpawned;		// Has the portal been spawned yet?
	var int					WaveLength;		// How many monsters should be in this wave?
	var int					WaveCountdown;		// Wave countdown per wave!
	var class<UTLocalMessage >		WaveCountdownAnnouncer; // Handles the countdown messages/sounds
	var float 				MonstersPerPlayer;	// Monster per player ratio
	
	structdefaultproperties
	{
		WaveLength = 10
		WaveCountdown = 10
		WaveCountdownAnnouncer = Class'RBTTTimerMessage'
		MonstersPerPlayer = 3
	}
};
var array<WaveTable>				WaveConfig;		// Wave configuration. When to spawn what monsters/portals

var array<int> 					WaveLength; 		// Cheap-ass monstertable, it only holds the wave length (ammount of monsters each wave
var int 					NumMonsters;		// Current number of monsters
var int						NumPortals;		// Current number of portals
var int						MaxMonsters; 		// Maximum monsters in the level at the same time
var int						CurrentWave;		// The current wave number
var int 					WaveMonsters; 		// The ammount of monsters that have been killed in a wave
var float					LastPortalTime;		// The last time a portal (monsterspawner) was spawned
var int						PortalSpawnInterval;	// How many second between each portal spawn

var array<NavigationPoint> 			MonsterSpawnPoints;	// Holds the spots where monsters can spawn

var array<UTPlayerReplicationInfo> 		Queue; 			// This array holds dead players for ressurecting them
var Mutator 					InvasionMut; 		// The mutator, might be handy to cache it

var class<UTTeamAI> 				MonsterTeamAIType;	// decides the squads and spawns the squad ai i believe
var class<UTTeamInfo> 				MonsterEnemyRosterClass;// The monsters team info responsible for spawning the team ai
var UTTeamInfo 					Teams[2];		// an array of team infos held within UTGame 

var int 					BetweenWavesCountdown;	// Goes from 10 to 0 every wave begin

function PostBeginPlay()
{
	local int i;

	Super.PostBeginPlay();
	LogInternal(">>>>>>>>>>>>>>>>>>RBTTInvasionGameRules Spawned<<<<<<<<<<<<<<<<<<<<");

	LogInternal(">>>>>>>>>>>>>>>>>>MonsterTable.length:"@MonsterTable.Length);
	for(i=0;i < MonsterTable.length;i++)
	{
		LogInternal("#####Loading monster"@i@": "@MonsterTable[i].MonsterClassName);
		MonsterTable[i].MonsterClass = class<UTPawn>(DynamicLoadObject(MonsterTable[i].MonsterClassName,class'Class'));
	}
	WorldInfo.Game.GoalScore = 0;			// 0 means no goalscore
}

function MatchStarting()
{
	//local UTTeamGame Game;
	local PathNode NavPoint;
	local int i;
	
	//#### GET SPAWNPOINTS FOR MONSTERS ####\\
	i = 0;
	foreach WorldInfo.AllNavigationPoints(class'PathNode', NavPoint)
	{
		MonsterSpawnPoints[i] = NavPoint;
		i++;
	}
	
	//Game = UTTeamGame(WorldInfo.Game);
	//RBTTInvasionGameRules(Game.GameRulesModifiers).NumMonsters = 0; // lol? WTF? xD
	CreateMonsterTeam();
	SetTimer(1, true, 'InvasionTimer'); 		// InvasionTimer gets called once every second
	LastPortalTime = WorldInfo.TimeSeconds;	 	// Spawn portal after PortalSpawnInterval seconds
	//WorldInfo.Game.GoalScore = 0;			// 0 means no goalscore
	GotoState('BetweenWaves'); 			// Initially start counting down for the first wave.
}

function InvasionTimer()
{
	//#### END-OF-WAVE ####\\
	if ( WaveMonsters >= WaveConfig[CurrentWave].WaveLength && NumPortals <= 0 ){
		LogInternal("Wave "@CurrentWave@" over!!");
		CurrentWave++;
		if( CurrentWave >= WaveConfig.length ) // You beat the last wave!
		{
			ClearTimer('InvasionTimer'); // Stop this timer, game's over anyway...
			EndInvasionGame("triggered"); // Game's over, end the game.
			return;
		}	
		WaveMonsters=0;
		LogInternal("In Wave "@CurrentWave@" Now!");
		GotoState('BetweenWaves'); return;
	}

	//#### AddMonsters ####\\ if there aren't enough monsters in the game
	if (NumMonsters < MaxMonsters)
		if ( NumMonsters < WaveConfig[CurrentWave].MonstersPerPlayer * (WorldInfo.Game.NumPlayers + WorldInfo.Game.NumBots) 
		  && (NumMonsters + WaveMonsters) < WaveConfig[CurrentWave].WaveLength)
			AddMonster();
	
	if(LastPortalTime + PortalSpawnInterval < WorldInfo.TimeSeconds)
	{
		SpawnPortal();
		LastPortalTime = WorldInfo.TimeSeconds;
	}
}

function SpawnPortal()
{
	local NavigationPoint StartSpot;
	local MonsterSpawner MonsterPortal;

	StartSpot = MonsterSpawnPoints[Rand(MonsterSpawnPoints.length)];
	if ( StartSpot == None )
		return;
	
	MonsterPortal = Spawn(Class'MonsterSpawner',,,StartSpot.Location);
	if(MonsterPortal != None)
	{
		MonsterPortal.SpawnArray = PortalTable[0].SpawnArray;
		MonsterPortal.Initialize(PortalTable[0].SpawnInterval);
		NumPortals++;
	}
}

function AddMonster()
{
	local NavigationPoint StartSpot;
	local Class<UTPawn> NewMonsterPawnClass;
		
	LogInternal(">>>>>>>>>>>>>>>>>> ADD MONSTER FUNCTION CALLED <<<<<<<<<<<<<<<<<<<<<");
	StartSpot = MonsterSpawnPoints[Rand(MonsterSpawnPoints.length)];
	//StartSpot = WorldInfo.Game.FindPlayerStart(None,1);
	//StartSpot = ChooseMonsterStart();
	
	if ( StartSpot == None )
		return;

	
	
	NewMonsterPawnClass = MonsterTable[WaveConfig[CurrentWave].MonsterNum[Rand(WaveConfig[CurrentWave ].MonsterNum.length)]].MonsterClass;
	//NewMonsterPawnClass = MonsterTable[Rand(MonsterTable.Length)].MonsterClass;
	SpawnMonster(NewMonsterPawnClass, StartSpot.Location, StartSpot.Rotation);
}

// This function will force a monster into the game
function bool InsertMonster(class<UTPawn> UTP, Vector SpawnLocation, optional Rotator SpawnRotation, optional bool bIgnoreMaxMonsters)
{
	if(!bIgnoreMaxMonsters
	   && ((NumMonsters >= MaxMonsters)
	   || (NumMonsters >= 3 * (WorldInfo.Game.NumPlayers + WorldInfo.Game.NumBots))))
		return False;

	WaveMonsters--; // Make sure an extra monster has to be killed (this one, that is)
	if(!SpawnMonster(UTP, SpawnLocation, SpawnRotation))
	{
		WaveMonsters++; //If the monster fails to spawn, it doesn't need to be killed
		return False;
	}
	
	return True;
}

// Do all the checks before spawning a monster
function bool SafeSpawnMonster(class<UTPawn> UTP, Vector SpawnLocation, optional Rotator SpawnRotation)
{
	if (NumMonsters < MaxMonsters) 
		if ( NumMonsters < 3 * (WorldInfo.Game.NumPlayers + WorldInfo.Game.NumBots) 
		  && (NumMonsters + WaveMonsters) < WaveConfig[CurrentWave].WaveLength)
			return SpawnMonster(UTP, SpawnLocation, SpawnRotation);
	
	return false;
}

// Spawn a monster of given class at given location
function bool SpawnMonster(class<UTPawn> UTP, Vector SpawnLocation, optional Rotator SpawnRotation)
{
	local UTPawn NewMonster;
	local UTTeamGame Game;
	local Controller Bot;
	local CharacterInfo MonsterBotInfo;
	local UTTeamInfo RBTTMonsterTeamInfo;
	local PlayerReplicationInfo PRI;
	local string MonsterName;
	
	LogInternal(">>>>>>>>>>>>>>>>>> SPAWN MONSTER FROM SPAWNMONSTER <<<<<<<<<<<<<<<<<<<<<");
	//LogInternal(">>>>>>>>>>>>>>>>>> NumMonsters("@NumMonsters@") < MaxMonsters("@MaxMonsters@") <<<<<<<<<<<<<<<<<<<<<");
	NewMonster = Spawn(UTP,,,SpawnLocation+(UTP.Default.CylinderComponent.CollisionHeight)* vect(0,0,1), SpawnRotation);
	
	if (NewMonster != None)
	{
		PRI = NewMonster.PlayerReplicationInfo;
		Game = UTTeamGame(WorldInfo.Game);
		
		if( Game == None )
		{
			return false;
			NewMonster.Destroy();
		}
		
		if ( NewMonster.IsA('RBTTMonster') )
		{
			MonsterName = RBTTMonster(NewMonster).MonsterName;
			Bot = NewMonster.Controller;
			MonsterBotInfo = RBTTMonsterTeamInfo(Game.GameReplicationInfo.teams[1]).GetBotInfo(MonsterName);
			RBTTMonsterController(Bot).Initialize(RBTTMonster(NewMonster).MonsterSkill, MonsterBotInfo);
			PRI.PlayerName = MonsterName;
			LogInternal("Setting MonsterName to" @ MonsterBotInfo.CharName @ "Was Successful");
		}
		
		if(PRI != None)
		{
			RBTTMonsterTeamInfo=UTTeamInfo(Game.GameReplicationInfo.teams[1]);
			RBTTMonsterTeamInfo.AddToTeam(Bot);
			LogInternal("PRI.Team.TeamIndex = "@PRI.Team.TeamIndex@"");
			RBTTMonsterTeamInfo.SetBotOrders(UTBot(Bot));
		}
		
		NumMonsters++;
		NewMonster.SpawnTransEffect(0);
		LogInternal("This many monsters in the game now:"@NumMonsters);
		return True;
	}
	else
		return false;
}
	
function CreateMonsterTeam()
{
	local class<UTTeamInfo> RosterClass;
	local UTTeamGame Game;
	Game = UTTeamGame(WorldInfo.Game);
	Game.Teams[1].Destroy();

	RosterClass = MonsterEnemyRosterClass;
	LogInternal(">>>>>>>>>>>>>>>> RosterClass = " @RosterClass@ " <<<<<<<<<<<<<<<<<");
	Teams[1] = spawn(RosterClass);
	//Teams[1].Faction = TeamFactions[1];//this is somthing i have in mind for later
	Teams[1].Initialize(1);
	Teams[1].AI = Spawn(MonsterTeamAIType);
	Teams[1].AI.Team = Teams[1];
	Game.Teams[1] = Teams[1];
	Game.GameReplicationInfo.SetTeam(1, Teams[1]);
	Game.Teams[1].AI.SetObjectiveLists();
}

function ScoreKill(Controller Killer, Controller Other)
{
	local UTPlayerReplicationInfo PRI;
	local Controller C;
	local int AlivePlayerCount, i;

	Super.ScoreKill(Killer, Other);
	
	PRI = UTPlayerReplicationInfo(Other.PlayerReplicationInfo);

	LogInternal(">>>>>>>>>>>>>>> SCOREKILL CALLED <<<<<<<<<<<<<<<<");

	if(PRI != None && PRI.Team.TeamIndex != 1)
	{
		foreach WorldInfo.AllControllers(class'Controller', C)
			if((C.IsA('UTPlayerController') || C.class == Class'UTGame.UTBot')
				&& C != Other)
			{
				for(i=Queue.length-1;i >= 0; i--)
					if(Queue[i] == UTPlayerReplicationInfo(C.PlayerReplicationInfo))
						break;
						
				if(i >= 0 && Queue[i] == UTPlayerReplicationInfo(C.PlayerReplicationInfo))
					continue;
						
				AlivePlayerCount++;
			}
				
		LogInternal(">>>>>>AlivePlayerCount="@AlivePlayerCount@"<<<<<<<");
		if(AlivePlayerCount <= 0)
		{
			EndInvasionGame("TimeLimit"); // you lost actually..
		}
		
		LogInternal(">>>>>>>>>>>>>> ADDING PLAYER TO QUEUE <<<<<<<<<<<<<");
		AddToQueue(PRI);
	}	
	else
	{
		NumMonsters--;
		WaveMonsters++;
		LogInternal(">>>>>>>>>>>>>>>>>>>>> MONSTER KILLED <<<<<<<<<<<<<<<<<<<<<<<");
		if(Rand(2) == 1)
			DropItemFrom(Other.Pawn, class'Pickup_Health', 10);
		else
			DropItemFrom(Other.Pawn, class'Pickup_Armor', 10, 1);
		LogInternal("Monster was killed, number of monsters now:"@NumMonsters);
		LogInternal("This wave's max monsters:"@WaveConfig[CurrentWave].WaveLength);
		LogInternal("WaveMonsters = "@WaveMonsters);		
	}
}

function DropItemFrom(Pawn P, Class<Actor> PickupClass, optional int MiscOption1, optional int MiscOption2)
{
	local Actor MonsterDrop;
	local vector	POVLoc, TossVel;
	local rotator	POVRot;
	local Vector	X,Y,Z;

	P.GetActorEyesViewPoint(POVLoc, POVRot);
	TossVel = Vector(POVRot);
	TossVel = TossVel * ((Velocity Dot TossVel) + 500) + Vect(0,0,200);

	GetAxes(Rotation, X, Y, Z);
	
	MonsterDrop = Spawn(PickupClass,,, P.Location + 0.8 * P.CylinderComponent.CollisionRadius * X - 0.5 * P.CylinderComponent.CollisionRadius * Y);
	if( MonsterDrop == None )
	{
		return;
	}

	if(Pickup_Base(MonsterDrop) != None && (MiscOption1 != 0 || MiscOption2 != 0))
	{
		Pickup_Base(MonsterDrop).MiscOption1 = MiscOption1;
		Pickup_Base(MonsterDrop).MiscOption2 = MiscOption2;
	}
	MonsterDrop.SetPhysics(PHYS_Falling);
	//MonsterDrop.InventoryClass = PF;
	MonsterDrop.Velocity = TossVel;
	MonsterDrop.Instigator = P.Instigator;
	//MonsterDrop.SetPickupMesh(PF.default.PickupMesh);
}

function EndInvasionGame(Optional string Reason)
{
	local RBTTMonsterController MC;
	
	foreach WorldInfo.AllControllers(class'RBTTMonsterController', MC)
		MC.Destroy();
	
	if(Reason ~= "TimeLimit")
	{
		WorldInfo.Game.GameReplicationInfo.Winner = Teams[1]; // Monsters' team
		Teams[1].Score = 9999;
		Teams[0].Score = 0;
	}
	
	Reason = (Reason == "")?"triggered":Reason;
	WorldInfo.Game.EndGame(None,Reason);
	ClearTimer('InvasionTimer');
}


/** removes a player from the queue, sets it up to play, and returns the Controller
 * @note: doesn't spawn the player in (i.e. doesn't call RestartPlayer()), calling code is responsible for that
 */

function Controller GetPlayerFromQueue(int Index)
{
	local Controller C;
	local UTPlayerReplicationInfo PRI;
	local UTTeamInfo NewTeam;

	PRI = Queue[Index];
	Queue.Remove(Index, 1);

	// after a seamless travel some players might still have the old TeamInfo from the previous level
	// so we need to manually count instead of using Size

	NewTeam = UTTeamGame(WorldInfo.Game).Teams[0];
	C = Controller(PRI.Owner);
	//SetTeam(C, NewTeam, false);
	if( C != None )
	{
		if (C.IsA('UTBot'))
			NewTeam.SetBotOrders(UTBot(C));
		return C;
	}
	
	return None;
	
}


function AddToQueue(UTPlayerReplicationInfo Who)
{
	local PlayerController PC;
	local int i;

	// Add the player to the end of the queue
	i = Queue.Length;
	LogInternal(">>>>>>>>>>Queue.Length = "@i@"<<<<<<<<<<<");
	//Queue.Length = i + 1;
	Queue.AddItem(Who);
	LogInternal(">>>>>>>>>>>>Player"@Who@" Added to Queue[]<<<<<<<<<<");
	LogInternal(">>>>>>>>>>>Queue["@i@"] = "@Queue[i]@"<<<<<<<<<<");
	//Queue[i].QueuePosition = i;

	//WorldInfo.Game.GameReplicationInfo.SetTeam(Controller(Who.Owner), None, false);
	if (!WorldInfo.Game.bGameEnded)
	{
		Who.Owner.GotoState('InQueue');
		PC = PlayerController(Who.Owner);
		if (PC != None)
		{
			PC.ClientGotoState('InQueue');
		
		}
	}
}

function RestartPlayer(Controller aPlayer)
{

	WorldInfo.Game.RestartPlayer(aPlayer);

}
state BetweenWaves
{
	function InvasionTimer()
	{
		local UTPlayerController PC;
		
		if(BetweenWavesCountDown <= 0) // Timer reached zero, let the wave begin.
		{	GotoState(''); return; 	}
		
		foreach WorldInfo.AllControllers(class'UTPlayerController', PC)
		{
			//PC.ClientPlayAnnouncement(class'RBTTTimerMessage',BetweenWavesCountdown);
			PC.ReceiveLocalizedMessage( WaveConfig[CurrentWave].WaveCountdownAnnouncer, BetweenWavesCountdown);
			//UTHUD(PC.myHUD).DisplayHUDMessage("wutwutwut!");
		}	
		
		LogInternal(BetweenWavesCountDown@"Seconds before next wave!");
		BetweenWavesCountdown--; // 1 second less left
		//UTHUD(PlayerController(InvasionMut.Instigator.Controller).myHUD).DisplayHUDMessage("wutwutwut!"); //, optional float XOffsetPct = 0.05, optional float YOffsetPct = 0.05)
		
	}

	function BeginState(Name PreviousStateName)
	{
		local Controller C;
		local int i;
		
		for(i = Queue.length-1; i >= 0; i--)
		{
			C = GetPlayerFromQueue(i);
			if(C != None)
				RestartPlayer(C);
		}
		
		BetweenWavesCountdown = WaveConfig[CurrentWave].WaveCountdown;
	}
	
	function bool InsertMonster(class<UTPawn> UTP, Vector SpawnLocation, optional Rotator SpawnRotation, optional bool bIgnoreMaxMonsters)
	{
		GotoState('MatchInProgress');
		return Global.InsertMonster(UTP, SpawnLocation, SpawnRotation, bIgnoreMaxMonsters);	
	}
	
	function bool SafeSpawnMonster(class<UTPawn> UTP, Vector SpawnLocation, optional Rotator SpawnRotation)
	{
		return false; // This function is not allowed to spawn monsters between waves
	}
}


/* For TeamGame, tell teams about kills rather than each individual bot
*/
function NotifyKilled(Controller Killer, Controller KilledPlayer, Pawn KilledPawn)
{
	Teams[0].AI.NotifyKilled(Killer,KilledPlayer,KilledPawn);
	Teams[1].AI.NotifyKilled(Killer,KilledPlayer,KilledPawn);
}

defaultproperties
{
   MonsterEnemyRosterClass=class'RBTTMonsterTeamInfo'
   MonsterTeamAIType=Class'UTMonsterTeamAI'

   PortalSpawnInterval = 60 //Portal spawns every 60 seconds!

	MonsterTable(0)=(MonsterName="SkullCrab",MonsterClassName="RBTTInvasion.RBTTSkullCrab")
	MonsterTable(1)=(MonsterName="HumanSkeleton",MonsterClassName="RBTTInvasion.RBTTHumanSkeleton")
	MonsterTable(2)=(MonsterName="KrallSkeleton",MonsterClassName="RBTTInvasion.RBTTKrallSkeleton")
	MonsterTable(3)=(MonsterName="MiningRobot",MonsterClassName="RBTTInvasion.RBTTMiningRobot")
	MonsterTable(4)=(MonsterName="WeldingRobot",MonsterClassName="RBTTInvasion.RBTTWeldingRobot")
	MonsterTable(5)=(MonsterName="Spider",MonsterClassName="RBTTInvasion.RBTTSpider")
	MonsterTable(6)=(MonsterName="Raptor",MonsterClassName="JR.JRRaptor")
	MonsterTable(7)=(MonsterName="Rex",MonsterClassName="JR.JRRex")
   
   WaveConfig(0)=(MonsterNum=(1,2,4,6),WaveLength=10,WaveCountdown=10)
   WaveConfig(1)=(MonsterNum=(0,5,0,6),WaveLength=15,WaveCountdown=15)
   WaveConfig(2)=(MonsterNum=(0,3,6),WaveLength=20,WaveCountdown=20)
   WaveConfig(3)=(MonsterNum=(0,1,2,3,4,5),WaveLength=50,WaveCountdown=20,MonstersPerPlayer=10)
   
   //WaveConfig(0)=(MonsterNum=(0),WaveLength=10,WaveCountdown=10)
   //WaveConfig(1)=(MonsterNum=(0),WaveLength=10,WaveCountdown=10)
   //WaveConfig(2)=(MonsterNum=(0),WaveLength=10,WaveCountdown=10)
   //WaveConfig(3)=(MonsterNum=(0),WaveLength=10,WaveCountdown=10)
   
   
   PortalTable(0)=(PortalClass=Class'MonsterSpawner',SpawnArray=(Class'RBTTMiningRobot',Class'RBTTSpider',Class'RBTTMiningRobot',Class'RBTTMiningRobot',Class'RBTTSpider',Class'RBTTMiningRobot'),SpawnInterval=5)
   PortalTable(1)=(PortalClass=Class'MonsterSpawner',SpawnArray=(Class'RBTTSkullCrab',Class'RBTTSkullCrab',Class'RBTTSkullCrab',Class'RBTTSkullCrab',Class'RBTTSkullCrab',Class'RBTTSkullCrab',Class'RBTTSkullCrab'),SpawnInterval=5)
   
   Begin Object Name=Sprite ObjName=Sprite Archetype=SpriteComponent'Engine.Default__GameRules:Sprite'
      ObjectArchetype=SpriteComponent'Engine.Default__GameRules:Sprite'
   End Object
   Components(0)=Sprite
   
   
   MaxMonsters=16
   Name="Default__RBTTInvasionGameRules"
   ObjectArchetype=GameRules'Engine.Default__GameRules'
}
