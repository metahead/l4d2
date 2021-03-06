public Action:Timer_ZeroGravity(Handle:timer, any:client) {

	if (IsLegitimateClientAlive(client)) {

		ModifyGravity(client);
	}
	//ZeroGravityTimer[client] = INVALID_HANDLE;
	return Plugin_Stop;
}

public Action:Timer_ResetCrushImmunity(Handle:timer, any:client) {

	if (IsLegitimateClient(client)) bIsCrushCooldown[client] = false;
	return Plugin_Stop;
}

public Action:Timer_ResetBurnImmunity(Handle:timer, any:client) {

	if (IsLegitimateClient(client)) bIsBurnCooldown[client] = false;
	return Plugin_Stop;
}

public Action:Timer_HealImmunity(Handle:timer, any:client) {

	if (IsLegitimateClient(client)) {

		HealImmunity[client] = false;
	}
	return Plugin_Stop;
}

public Action:Timer_IsMeleeCooldown(Handle:timer, any:client) {

	if (IsLegitimateClient(client)) {

		bIsMeleeCooldown[client] = false;
	}
	return Plugin_Stop;
}

stock CheckDifficulty() {

	decl String:Difficulty[64];
	GetConVarString(FindConVar("z_difficulty"), Difficulty, sizeof(Difficulty));
	if (!StrEqual(Difficulty, "impossible", false)) SetConVarString(FindConVar("z_difficulty"), "impossible");
}

public Action:Timer_DisplayHUD(Handle:timer) {

	if (!b_IsActiveRound) return Plugin_Stop;

	static iRotation = 0;
	for (new i = 1; i <= MaxClients; i++) {

		if (IsLegitimateClientAlive(i) && !IsFakeClient(i)) DisplayHUD(i, iRotation);
	}
	if (iRotation != 1) iRotation = 1;
	else iRotation = 0;

	return Plugin_Continue;
}

public Action:Timer_ShowHUD(Handle:timer) {

	//CheckGamemode();

	//RaidInfectedBotLimit();
	SetSurvivorsAliveHostname();
	static bool:IsDark = false;
	static bool:IsWeak = false;

	static RoundSeconds = 0;

	static String:text[64];
	static EnrageCount		= 0;
	if (EnrageCount == 0) EnrageCount = iEnrageTime;
	static Counter = -1;
	if (Counter == -1) {

		if (ReadyUp_GetGameMode() == 3) Counter = iSurvivalRoundTime;
		else Counter = 0;
	}
	else {

		if (IsSurvivalMode) Counter--;
		else {

			Counter++;
			if (Counter >= HostNameTime) {

				Counter = 0;
				PrintToChatAll("%t", "playing in server name", orange, blue, Hostname, orange, blue, MenuCommand, orange);
			}
		}
	}
	if (Counter == 0 && IsSurvivalMode) {

		for (new i = 1; i <= MaxClients; i++) {

			if (IsLegitimateClient(i) && (GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i))) {

				IsSpecialAmmoEnabled[i][0] = 0.0;

				if (IsPlayerAlive(i)) AwardExperience(i, _, _, true);
				else {

					Defibrillator(i, _, true);
				}
			}
			/*else if (IsLegitimateClientAlive(i) && IsFakeClient(i) && GetClientTeam(i) == TEAM_INFECTED) {

				CalculateInfectedDamageAward(i);
			}*/
		}
		// these two segments are commented out because i decided that we won't kill everything on the battle-field - this can cause adverse effects on maps that heavily rely on scripts.
		// but also because it was pretty immersion-breaking having everything just die every few minutes, and on survival maps like serioussamurai's helm's deep, it breaks the tension.
		/*for (new i = 0; i <= GetArraySize(Handle:CommonInfected); i++) {

			if (IsCommonInfected(i)) {

				if (!IsSpecialCommon(i)) OnCommonCreated(i, true);
				else ClearSpecialCommon(i);
				i--;
			}
		}*/
		Counter = iSurvivalRoundTime;
		bIsSettingsCheck = true;
	}
	if (!b_IsActiveRound) {

		Counter = -1;
		SetSurvivorsAliveHostname();
		return Plugin_Stop;
	}

	static ZeTankCount = 0;
	ZeTankCount = ActiveTanks();
	new ThisRoundTime = 0;
	ThisRoundTime = RPGRoundTime();
	new mymaxhealth = -1;
	new Float:healregenamount = 0.0;
	decl String:ClassRoles[64];
	//new DeathState		= 0;
	//new BurnState		= 0;
	//new bool:IsTankNearDeath		= false;
	//new bool:IsTankWeak = false;

	RoundSeconds = RPGRoundTime(true);

	for (new i = 1; i <= MaxClients; i++) {

		if (!IsLegitimateClient(i)) continue;
		if ((GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i)) && !b_IsLoaded[i]) continue;

		if (IsLegitimateClientAlive(i) && GetClientTeam(i) != TEAM_SPECTATOR) {

			if ((GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i)) && CurrentRPGMode >= 1) {

				if (IsLegitimateClass(i)) {

					if (StrContains(ActiveClass[i], "warrior", false) != -1) {

						//ToggleTank(i);
					}

					if (GetClientStance(i, 1) && !ISBILED[i] && AnyTanksNearby(i, 256.0)) {

						GetMenuOfTalent(i, ActiveClass[i], ClassRoles, sizeof(ClassRoles));
						if (StrContains(ClassRoles, "Tank", false) != -1) {

							// In this version of class rpg, players have to be in tanking stance to be biled.
							SDKCall(g_hCallVomitOnPlayer, i, i, true);
							//IsCoveredInVomit(i, i);
							ISBILED[i] = true;
						}
					}

					/*if (StrContains(ActiveClass[i], "death", false) != -1 && ZeTankCount > 0 && !IsCoveredInVomit(i) && !b_IsFinaleActive) {

						SDKCall(g_hCallVomitOnPlayer, i, i, true);
						IsCoveredInVomit(i, i);
					}
					else if (StrContains(ActiveClass[i], "crusader", false) != -1 && ZeTankCount < 1 && !IsCoveredInVomit(i) && !b_IsFinaleActive) {

						SDKCall(g_hCallVomitOnPlayer, i, i, true);
						IsCoveredInVomit(i, i);
					}*/
				}
				
				if (L4D2_GetInfectedAttacker(i) == -1) {

					healregenamount = GetAbilityStrengthByTrigger(i, _, 'p', FindZombieClass(i), 0, _, _, "h");	// activator, target, trigger ability, effects, zombieclass, damage
					//if (!IsFakeClient(i)) PrintToChatAll("heal amount: %3.3f", healregenamount);
					HealPlayer(i, i, healregenamount, 'h', true);
				}

				ModifyHealth(i, GetAbilityStrengthByTrigger(i, i, 'p', FindZombieClass(i), 0, _, _, "H"), 0.0);
				mymaxhealth = GetMaximumHealth(i);
				if (GetClientHealth(i) > mymaxhealth) SetEntityHealth(i, mymaxhealth);

				/*if (StrContains(ActiveClass[i], "healer", false) != -1 && healregenamount > 0.0 && GetTalentStrength(i, "healing ammo") > 0) {	// when a healers health regen tics, it heals all teammates nearby, too.

					healregenrange = GetSpecialAmmoStrength(i, "healing ammo", 3) * 2.0;
					CreateRing(i, healregenrange, "green:ignore", "20.0:30.0", false, 0.5);	// healer aura is always present on classes that support it.
					GetClientAbsOrigin(i, healerpos);
					for (new y = 1; y <= MaxClients; y++) {

						//if (y == i) continue;	// client doesn't get double heal.
						//if (IsLegitimateClient(y)) {

						//	if (!IsFakeClient(y)) CreateRing(y, healregenrange, "green:ignore", "20.0:30.0", false, 1.0);	// healer aura is always present on classes that support it.
						//}
						if (y == i) continue;	// client doesn't get double heal.
						if (IsLegitimateClientAlive(y) && GetClientTeam(y) == TEAM_SURVIVOR && bIsInCombat[y]) {

							GetClientAbsOrigin(y, targetpos);
							if (GetVectorDistance(healerpos, targetpos) > healregenrange / 2) continue;

							HealPlayer(y, i, healregenamount, 'h', true);
						}
					}
				}*/
			}
			RemoveStoreTime(i);
			LastPlayLength[i]++;
			if (ReadyUpGameMode != 3 && CurrentRPGMode >= 1 && ThisRoundTime >= EnrageCount) {

				if (SurvivorEnrage[i][1] == 0.0) {

					EnrageBlind(i, 100);
					SurvivorEnrage[i][1] = 1.0;
				}
				else {

					//EnrageBlind(i, 00);
					SurvivorEnrage[i][1] = 0.0;
				}
			}
		}
	}
	for (new i = 1; i <= MaxClients; i++) {

		if (IsLegitimateClientAlive(i) && GetClientTeam(i) == TEAM_INFECTED && FindZombieClass(i) == ZOMBIECLASS_TANK) {

			if (IsClientInRangeSpecialAmmo(i, "W") == -2.0) IsDark = true;
			else IsDark = false;
			if (IsSpecialCommonInRange(i, 'w')) IsWeak = true;
			else IsWeak = false;

			if (IsWeak && IsDark) {

				ClearArray(Handle:TankState_Array[i]);
				SetEntityRenderMode(i, RENDER_TRANSCOLOR);
				SetEntityRenderColor(i, 255, 255, 255, 200);
			}
		}
	}

	new LivingSerfs = LivingSurvivors();
	if (LivingSerfs < 1 || LivingSerfs == LedgedSurvivors() || NoHealthySurvivors()) {	// this way we don't force a scenario to end prematurely.

		// scenario will not end if there are bots alive because dead players can take control of them.
		ForceServerCommand("scenario_end");
		CallRoundIsOver();
		return Plugin_Stop;
	}

	if (RoundSeconds > 0 && ThisRoundTime < EnrageCount && (RoundSeconds % iEnrageAdvertisement) == 0) {

		TimeUntilEnrage(text, sizeof(text));
		PrintToChatAll("%t", "enrage in...", orange, green, text, orange);
	}

	return Plugin_Continue;
}

stock LedgedSurvivors() {

	new count = 0;
	for (new i = 1; i <= MaxClients; i++) {

		if (IsLegitimateClientAlive(i) && GetClientTeam(i) == TEAM_SURVIVOR && IsLedged(i)) count++;
	}
	return count;
}

stock bool:NoHealthySurvivors() {

	for (new i = 1; i <= MaxClients; i++) {

		if (IsLegitimateClientAlive(i) && !IsIncapacitated(i) && GetClientTeam(i) == TEAM_SURVIVOR) return false;
	}
	return true;
}

stock HumanSurvivors() {

	new count = 0;
	for (new i = 1; i <= MaxClients; i++) {

		if (IsClientInGame(i) && !IsFakeClient(i) && GetClientTeam(i) == TEAM_SURVIVOR) count++;
	}
	return count;
}

public Action:Timer_TeleportRespawn(Handle:timer, any:client) {

	if (b_IsActiveRound && IsLegitimateClient(client)) {

		new target = MyRespawnTarget[client];

		if (target != client && IsLegitimateClientAlive(target)) {

			GetClientAbsOrigin(target, DeathLocation[target]);
			TeleportEntity(client, DeathLocation[target], NULL_VECTOR, NULL_VECTOR);
			MyRespawnTarget[client] = client;
		}
		else TeleportEntity(client, DeathLocation[client], NULL_VECTOR, NULL_VECTOR);
	}
	return Plugin_Stop;
}

public Action:Timer_GiveMaximumHealth(Handle:timer, any:client) {

	if (IsLegitimateClientAlive(client)) {

		GiveMaximumHealth(client);		// So instant heal doesn't put a player above their maximum health pool.
	}

	return Plugin_Stop;
}

public Action:Timer_DestroyCombustion(Handle:timer, any:entity)
{
	if (!IsValidEntity(entity)) return Plugin_Stop;
	AcceptEntityInput(entity, "Kill");
	return Plugin_Stop;
}

/*public Action:Timer_DestroyDiscoveryItem(Handle:timer, any:entity) {

	if (IsValidEntity(entity)) {

		new client				= FindAnyRandomClient();

		if (client == -1) return Plugin_Stop;

		decl String:EName[64];
		GetEntPropString(entity, Prop_Data, "m_iName", EName, sizeof(EName));
		if (StrEqual(EName, "slate") || IsStoreItem(client, EName) || IsTalentExists(EName)) {

			if (!AcceptEntityInput(entity, "Kill")) RemoveEdict(entity);
		}
	}

	return Plugin_Stop;
}*/

public Action:Timer_SlowPlayer(Handle:timer, any:client) {

	if (IsLegitimateClientAlive(client)) {

		SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", SpeedMultiplierBase[client]);
	}
	//SlowMultiplierTimer[client] = INVALID_HANDLE;
	return Plugin_Stop;
}

/*public Action:Timer_AwardSkyPoints(Handle:timer) {

	if (!b_IsActiveRound) return Plugin_Stop;

	for (new i = 1; i <= MaxClients; i++) {

		if (IsClientInGame(i) && !IsFakeClient(i) && GetClientTeam(i) != TEAM_SPECTATOR) {

			CheckSkyPointsAward(i);
		}
	}

	return Plugin_Continue;
}

stock CheckSkyPointsAward(client) {

	new SkyPointsAwardTime		=	GetConfigValueInt("sky points awarded _");
	new SkyPointsAwardValue		=	GetConfigValueInt("sky points time required?");
	new SkyPointsAwardAmount	=	GetConfigValueInt("sky points award amount?");

	new seconds					=	0;
	new minutes					=	0;
	new hours					=	0;
	new days					=	0;
	new oldminutes				=	0;
	new oldhours				=	0;
	new olddays					=	0;

	seconds				=	TimePlayed[client];
	while (seconds >= 86400) {

		olddays++;
		seconds -= 86400;
	}
	while (seconds >= 3600) {

		oldhours++;
		seconds -= 3600;
	}
	while (seconds >= 60) {

		oldminutes++;
		seconds -= 60;
	}

	TimePlayed[client]++;

	seconds = TimePlayed[client];

	while (seconds >= 86400) {

		days++;
		seconds -= 86400;
	}
	while (seconds >= 3600) {

		hours++;
		seconds -= 3600;
	}
	while (seconds >= 60) {

		minutes++;
		seconds -= 60;

	}
	if (SkyPointsAwardTime == 2 && days != olddays && days % SkyPointsAwardValue == 0) AwardSkyPoints(client, SkyPointsAwardAmount);
	if (SkyPointsAwardTime == 1 && hours != oldhours && hours % SkyPointsAwardValue == 0) AwardSkyPoints(client, SkyPointsAwardAmount);
	if (SkyPointsAwardTime == 0 && minutes != oldminutes && minutes % SkyPointsAwardValue == 0) AwardSkyPoints(client, SkyPointsAwardAmount);
}*/

/*public Action:Timer_SpeedIncrease(Handle:timer, any:client) {

	if (IsLegitimateClientAlive(client)) {

		SpeedIncrease(client);
	}
	//SpeedMultiplierTimer[client] = INVALID_HANDLE;
	return Plugin_Stop;
}*/

public Action:Timer_BlindPlayer(Handle:timer, any:client) {

	if (IsLegitimateClient(client)) BlindPlayer(client);
	return Plugin_Stop;
}

public Action:Timer_FrozenPlayer(Handle:timer, any:client) {

	if (IsLegitimateClient(client)) FrozenPlayer(client, _, 0);
	return Plugin_Stop;
}

public Action:Timer_Blinder(Handle:timer, any:client) {

	if (ISBLIND[client] == INVALID_HANDLE) return Plugin_Stop;

	if (!b_IsActiveRound || !IsLegitimateClient(client) || !IsSpecialCommonInRange(client, 'l')) {

		BlindPlayer(client);
		KillTimer(ISBLIND[client]);
		ISBLIND[client] = INVALID_HANDLE;
		//CloseHandle(ISBLIND[client]);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:Timer_Freezer(Handle:timer, any:client) {

	if (ISFROZEN[client] == INVALID_HANDLE) return Plugin_Stop;

	if (!b_IsActiveRound || !IsLegitimateClient(client) || IsLegitimateClient(client) && !IsPlayerAlive(client) || !IsSpecialCommonInRange(client, 'r') || (ISEXPLODE[client] != INVALID_HANDLE)) {

		/*

			If the client is scorched, they no longer freeze.
		*/
		if (IsLegitimateClient(client)) FrozenPlayer(client, _, 0);
		KillTimer(ISFROZEN[client]);
		ISFROZEN[client] = INVALID_HANDLE;
		//CloseHandle(ISBLIND[client]);
		return Plugin_Stop;
	}
	new Float:Velocity[3];
	SetEntityMoveType(client, MOVETYPE_WALK);
	Velocity[0]	=	GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
	Velocity[1]	=	GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
	Velocity[2]	=	GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
	Velocity[2] += 32.0;
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, Velocity);
	SetEntityMoveType(client, MOVETYPE_NONE);
	return Plugin_Continue;
}

public ReadyUp_FwdChangeTeam(client, team) {

	if (IsLegitimateClient(client)) {

		if (team == TEAM_SURVIVOR) {

			ChangeHook(client, true);
			if (!b_IsLoading[client] && !b_IsLoaded[client]) OnClientLoaded(client);
		}
		else if (team != TEAM_SURVIVOR) {

			//LogToFile(LogPathDirectory, "%N is no longer a survivor, unhooking.", client);
			if (bIsInCombat[client]) {

				IncapacitateOrKill(client, _, _, true, false, true);
			}
			ChangeHook(client);
		}
	}
}

stock ChangeHook(client, bool:bHook = false) {

	b_IsHooked[client] = bHook;
	SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	if (b_IsHooked[client]) SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

/*public ReadyUp_FwdChangeTeam(client, team) {

	if (team != TEAM_SURVIVOR) {

		if (bIsInCombat[client]) {

			IncapacitateOrKill(client, _, _, true, false, true);
		}

		b_IsHooked[client] = false;
		SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	}
	else if (team == TEAM_SURVIVOR && !b_IsHooked[client]) {

		b_IsHooked[client] = true;
		SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	}
}*/

public Action:Timer_DetectGroundTouch(Handle:timer, any:client) {

	if (IsClientHuman(client) && IsPlayerAlive(client)) {

		if (GetClientTeam(client) == TEAM_SURVIVOR && !(GetEntityFlags(client) & FL_ONGROUND) && b_IsJumping[client] && L4D2_GetInfectedAttacker(client) == -1 && !AnyTanksNearby(client)) return Plugin_Continue;
		b_IsJumping[client] = false;
		ModifyGravity(client);
	}
	return Plugin_Stop;
}

public Action:Timer_ResetGravity(Handle:timer, any:client) {

	if (IsLegitimateClientAlive(client)) ModifyGravity(client);
	return Plugin_Stop;
}

public Action:Timer_CloakingDeviceBreakdown(Handle:timer, any:client) {

	if (IsLegitimateClientAlive(client)) {

		SetEntityRenderMode(client, RENDER_NORMAL);
		SetEntityRenderColor(client, 255, 255, 255, 255);
	}
	return Plugin_Stop;
}

public Action:Timer_ResetPlayerHealth(Handle:timer, any:client) {

	if (IsLegitimateClientAlive(client)) {

		LoadHealthMaximum(client);
		GiveMaximumHealth(client);
	}
	return Plugin_Stop;
}

/*public Action:Timer_RemoveImmune(Handle:timer, Handle:packy) {

	ResetPack(packy);
	new client			=	ReadPackCell(packy);
	new pos				=	ReadPackCell(packy);
	new owner			=	ReadPackCell(packy);

	if (client != -1 && IsClientActual(client) && !IsFakeClient(client)) {

		SetArrayString(PlayerAbilitiesImmune[client], pos, "0");
	}
	else {

		SetArrayString(PlayerAbilitiesImmune_Bots, pos, "0");
	}
	if (IsLegitimateClient(owner)) SetArrayString(PlayerAbilitiesImmune[owner][client], pos, "0");

	return Plugin_Stop;
}*/


stock ResetCDImmunity(client) {

	new size = 0;
	/*for (new i = 1; i <= MaxClients; i++) {

		if (!IsLegitimateClient(i)) continue;

		size = GetArraySize(PlayerAbilitiesImmune[client][i]);
		for (new y = 0; y < size; y++) {

			SetArrayString(PlayerAbilitiesImmune[client][i], y, "0");
		}
	}*/

	/*for (new i = 1; i <= MAXPLAYERS; i++) {

		//if (!IsLegitimateClient(i)) continue;
		for (new y = 1; y <= MAXPLAYERS; y++) {

			//if (!IsLegitimateClient(y)) continue;
			size = GetArraySize(PlayerAbilitiesImmune[i][y]);
			for (new z = 0; z < size; z++) {

				SetArrayString(PlayerAbilitiesImmune[i][y], z, "0");
			}
		}
	}*/

	if (IsLegitimateClient(client) && ((GetClientTeam(client) == TEAM_SURVIVOR || IsSurvivorBot(client)) || !IsFakeClient(client))) {

		size = GetArraySize(PlayerAbilitiesCooldown[client]);
		for (new i = 0; i < size; i++) {

			SetArrayString(PlayerAbilitiesCooldown[client], i, "0");
		}
		/*size = GetArraySize(PlayerAbilitiesImmune[client]);
		for (new i = 0; i < size; i++) {

			SetArrayString(PlayerAbilitiesImmune[client], i, "0");
		}*/
	}
	else if (client == -1) {

		size = GetArraySize(PlayerAbilitiesCooldown_Bots);
		for (new i = 0; i < size; i++) {

			SetArrayString(PlayerAbilitiesCooldown_Bots, i, "0");
		}
		size = GetArraySize(PlayerAbilitiesImmune_Bots);
		for (new i = 0; i < size; i++) {

			SetArrayString(PlayerAbilitiesImmune_Bots, i, "0");
		}
	}
}

/*public Action:Timer_CreateCooldown(Handle:timer, Handle:packttt) {

	ResetPack(packttt);
	new client				=	ReadPackCell(packttt);
	decl String:TalentName[64];
	ReadPackString(packttt, TalentName, sizeof(TalentName));
	new Float:f_Cooldown	= ReadPackFloat(packttt);

	if (IsLegitimateClientAlive(client)) {

		CreateCooldown(client, GetTalentPosition(client, TalentName), f_Cooldown);
	}

	return Plugin_Stop;
}*/

public Action:Timer_IsIncapacitated(Handle:timer, any:client) {

	static attacker					=	0;

	if (IsLegitimateClientAlive(client) && IsIncapacitated(client)) {
	
		if (attacker == 0) attacker	=	L4D2_GetInfectedAttacker(client);
	
		if (L4D2_GetInfectedAttacker(client) == -1) {
		
			if (attacker == -1) attacker			=	0;
			GetAbilityStrengthByTrigger(client, attacker, 'n', FindZombieClass(client), 0);
			if (attacker > 0 && IsClientInGame(attacker)) GetAbilityStrengthByTrigger(attacker, client, 'M', FindZombieClass(attacker), 0);
			attacker								=	0;
			return Plugin_Stop;
		}
		return Plugin_Continue;
	}
	attacker						=	0;
	return Plugin_Stop;
}

public Action:Timer_Slow(Handle:timer, any:client) {

	if (b_IsActiveRound && IsLegitimateClientAlive(client)) {

		SetEntityMoveType(client, MOVETYPE_WALK);
		SetSpeedMultiplierBase(client);
	}
	if (IsLegitimateClient(client)) {

		KillTimer(ISSLOW[client]);
		ISSLOW[client] = INVALID_HANDLE;
	}
	return Plugin_Stop;
}

public Action:Timer_Explode(Handle:timer, Handle:packagey) {

	ResetPack(packagey);

	new client 		= ReadPackCell(packagey);
	if (!IsLegitimateClientAlive(client)) {

		ISEXPLODETIME[client] = 0.0;
		KillTimer(ISEXPLODE[client]);
		ISEXPLODE[client] = INVALID_HANDLE;
		//CloseHandle(ISBLIND[client]);
		return Plugin_Stop;
	}

	new Float:ClientPosition[3];
	GetClientAbsOrigin(client, ClientPosition);

	new Float:flStrengthAura = ReadPackCell(packagey) * 1.0;
	new Float:flStrengthTarget = ReadPackFloat(packagey);
	new Float:flStrengthLevel = ReadPackFloat(packagey);
	new Float:flRangeMax = ReadPackFloat(packagey);
	new Float:flDeathMultiplier = ReadPackFloat(packagey);
	new Float:flDeathBaseTime = ReadPackFloat(packagey);
	new Float:flDeathInterval = ReadPackFloat(packagey);
	new Float:flDeathMaxTime = ReadPackFloat(packagey);
	decl String:StAuraColour[64];
	decl String:StAuraPos[64];
	ReadPackString(packagey, StAuraColour, sizeof(StAuraColour));
	ReadPackString(packagey, StAuraPos, sizeof(StAuraPos));
	new iLevelRequired = ReadPackCell(packagey);

	new NumLivingEntities = LivingEntitiesInRange(client, ClientPosition, flRangeMax);

	if (!b_IsActiveRound || !IsLegitimateClient(client) || IsLegitimateClient(client) && !IsPlayerAlive(client) || ISEXPLODETIME[client] >= flDeathBaseTime && NumLivingEntities < 1 || ISEXPLODETIME[client] >= flDeathMaxTime) {

		ISEXPLODETIME[client] = 0.0;
		KillTimer(ISEXPLODE[client]);
		ISEXPLODE[client] = INVALID_HANDLE;
		//CloseHandle(ISBLIND[client]);
		return Plugin_Stop;
	}
	new Float:flStrengthTotal = flStrengthAura + ((flStrengthTarget * NumLivingEntities) + (flStrengthLevel * PlayerLevel[client]));

	new Float:TargetPosition[3];
	flStrengthTotal *= flDeathMultiplier;

	if (FindZombieClass(client) == ZOMBIECLASS_TANK && ISBILED[client]) {

		ISEXPLODETIME[client] += flDeathInterval;
		return Plugin_Continue;
	}
	CreateRing(client, flRangeMax, StAuraColour, StAuraPos);
	CreateExplosion(client);
	ScreenShake(client);
	new ReflectDebuff = 0;
	if (IsClientInRangeSpecialAmmo(client, "d") == -2.0) flStrengthTotal += (flStrengthTotal * IsClientInRangeSpecialAmmo(client, "d", false, _, flStrengthTotal));
	if (IsClientInRangeSpecialAmmo(client, "E") == -2.0) flStrengthTotal += (flStrengthTotal * IsClientInRangeSpecialAmmo(client, "E", false, _, flStrengthTotal));
	if (IsClientInRangeSpecialAmmo(client, "D") == -2.0) flStrengthTotal = (flStrengthTotal * (1.0 - IsClientInRangeSpecialAmmo(client, "D", false, _, flStrengthTotal)));

	new DamageValue = RoundToCeil(flStrengthTotal);
	SetClientTotalHealth(client, DamageValue);

	for (new i = 1; i <= MaxClients; i++) {

		if (!IsLegitimateClientAlive(i) || i == client || IsSurvivorBot(i)) continue;
		if (GetClientTeam(i) == TEAM_SURVIVOR && PlayerLevel[i] < iLevelRequired) continue;	// we add infected later.

		GetClientAbsOrigin(i, TargetPosition);
		if (GetVectorDistance(ClientPosition, TargetPosition) > (flRangeMax / 2)) continue;

		CreateExplosion(i);	// boom boom audio and effect on the location.
		if (!IsFakeClient(i)) ScreenShake(i);

		//if (DamageValue > GetClientHealth(i)) IncapacitateOrKill(i);
		//else SetEntityHealth(i, GetClientHealth(i) - DamageValue);
		if (GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i)) {

			if (IsClientInRangeSpecialAmmo(i, "D") == -2.0) SetClientTotalHealth(i, RoundToCeil(DamageValue * (1.0 - IsClientInRangeSpecialAmmo(i, "D", false, _, DamageValue * 1.0))));
			else SetClientTotalHealth(i, DamageValue);
			if (IsClientInRangeSpecialAmmo(i, "R") == -2.0) {

				ReflectDebuff = RoundToCeil(DamageValue * IsClientInRangeSpecialAmmo(i, "R", false, _, DamageValue * 1.0));
				SetClientTotalHealth(client, ReflectDebuff);
				CreateAndAttachFlame(i, ReflectDebuff, 3.0, 0.5, i, "reflect");
			}
		}
		else if (GetClientTeam(i) == TEAM_INFECTED) {

			if (IsSpecialCommonInRange(i, 'd')) {

				if (IsClientInRangeSpecialAmmo(client, "D") == -2.0) {

					ReflectDebuff = RoundToCeil(DamageValue * (1.0 - IsClientInRangeSpecialAmmo(client, "D", false, _, DamageValue * 1.0)));
					CreateAndAttachFlame(client, ReflectDebuff, 3.0, 0.5, i, "reflect");
				}
				else CreateAndAttachFlame(client, DamageValue, 3.0, 0.5, i, "reflect");
			}
			else AddSpecialInfectedDamage(client, i, DamageValue);
		}
	}
	new ent = -1;
	new SuperReflect = 0;
	decl String:AuraEffect[10];
	for (new i = 0; i < GetArraySize(Handle:CommonInfected); i++) {

		ent = GetArrayCell(Handle:CommonInfected, i);
		if (ent != client && IsCommonInfected(ent) && !IsSpecialCommon(ent)) {

			GetEntPropVector(ent, Prop_Send, "m_vecOrigin", TargetPosition);
			if (GetVectorDistance(ClientPosition, TargetPosition) <= (flRangeMax / 2)) {

				//OnCommonInfectedCreated(ent, true);
				if (!IsSpecialCommonInRange(ent, 'd')) {

					if (!IsSpecialCommon(ent)) AddCommonInfectedDamage(client, ent, DamageValue);
					else {

						// We check what kind of special common the entity is
						GetCommonValue(AuraEffect, sizeof(AuraEffect), ent, "aura effect?");
						if (StrContains(AuraEffect, "d", true) == -1 || IsClientInRangeSpecialAmmo(client, "R") == -2.0) {

							if (IsClientInRangeSpecialAmmo(client, "R") == -2.0) AddSpecialCommonDamage(client, ent, RoundToCeil(DamageValue * IsClientInRangeSpecialAmmo(client, "R", false, _, DamageValue * 1.0)));
							else AddSpecialCommonDamage(client, ent, DamageValue);
						}
						else {	// if a player tries to reflect damage at a reflector, it's moot (ie reflects back to the player) so in this case the player takes double damage, though that's after mitigations.

							if (IsClientInRangeSpecialAmmo(client, "D") == -2.0) {

								SuperReflect = RoundToCeil(DamageValue * (1.0 - IsClientInRangeSpecialAmmo(client, "D", false, _, DamageValue * 1.0)));
								SetClientTotalHealth(client, SuperReflect);
								ReceiveCommonDamage(client, ent, SuperReflect);
							}
							else {

								SetClientTotalHealth(client, DamageValue);
								ReceiveCommonDamage(client, ent, DamageValue);
							}
						}
					}
				}
			}
		}
	}
	for (new i = 0; i < GetArraySize(Handle:WitchList); i++) {

		ent = GetArrayCell(Handle:WitchList, i);
		if (ent != client && IsWitch(ent)) {

			GetEntPropVector(ent, Prop_Send, "m_vecOrigin", TargetPosition);
			if (GetVectorDistance(ClientPosition, TargetPosition) <= (flRangeMax / 2)) {

				if (!IsSpecialCommonInRange(ent, 'd')) AddWitchDamage(client, ent, DamageValue);
				else {

					SetClientTotalHealth(client, DamageValue);
					ReceiveWitchDamage(client, ent, DamageValue);
				}
			}
		}
	}
	ISEXPLODETIME[client] += flDeathInterval;

	return Plugin_Continue;
}

public Action:Timer_IsNotImmune(Handle:timer, any:client) {

	if (IsLegitimateClient(client)) b_IsImmune[client] = false;
	return Plugin_Stop;
}

public Action:Timer_CheckIfHooked(Handle:timer) {

	if (!b_IsActiveRound) {

		return Plugin_Stop;
	}
	static CurRPG = -2;
	if (CurRPG == -2) CurRPG = iRPGMode;

	for (new i = 1; i <= MaxClients; i++) {

		if (CurRPG >= 1 && IsLegitimateClientAlive(i) && (GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i))) {

			if (PlayerHasWeakness(i) || StrContains(ActiveClass[i], "death", false) != -1) {

				SetEntityRenderMode(i, RENDER_TRANSCOLOR);
				if (StrContains(ActiveClass[i], "death", false) != -1) SetEntityRenderColor(i, 0, 0, 0, 200);
				else SetEntityRenderColor(i, 0, 0, 0, 255);
			}
			else {

				if (IsLegitimateClass(i)) {

					if (StrContains(ActiveClass[i], "healer", false) != -1) {

						SetEntityRenderMode(i, RENDER_TRANSCOLOR);
						SetEntityRenderColor(i, 0, 255, 0, 255);
					}
					else if (StrContains(ActiveClass[i], "shaman", false) != -1) {

						SetEntityRenderMode(i, RENDER_TRANSCOLOR);
						SetEntityRenderColor(i, 0, 255, 50, 150);
					}
					else if (StrContains(ActiveClass[i], "druid", false) != -1) {

						SetEntityRenderMode(i, RENDER_TRANSCOLOR);
						SetEntityRenderColor(i, 50, 200, 50, 255);
					}
					else if (StrContains(ActiveClass[i], "warrior", false) != -1) {

						SetEntityRenderMode(i, RENDER_TRANSCOLOR);
						SetEntityRenderColor(i, 255, 0, 0, 255);
					}
					else if (StrContains(ActiveClass[i], "paladin", false) != -1 || StrContains(ActiveClass[i], "crusader", false) != -1) {

						SetEntityRenderMode(i, RENDER_TRANSCOLOR);
						SetEntityRenderColor(i, 255, 0, 255, 255);
					}
					else if (StrContains(ActiveClass[i], "ranger", false) != -1 || StrContains(ActiveClass[i], "brawler", false) != -1) {

						SetEntityRenderMode(i, RENDER_TRANSCOLOR);
						SetEntityRenderColor(i, 0, 0, 255, 255);
					}
					else if (StrContains(ActiveClass[i], "assassin", false) != -1 || StrContains(ActiveClass[i], "monk", false) != -1) {

						SetEntityRenderMode(i, RENDER_TRANSCOLOR);
						SetEntityRenderColor(i, 255, 255, 0, 255);
					}
					else if (StrContains(ActiveClass[i], "hemomancer", false) != -1) {

						SetEntityRenderMode(i, RENDER_TRANSCOLOR);
						SetEntityRenderColor(i, 0, 0, 0, 200);
					}
				}
				else {

					SetEntityRenderMode(i, RENDER_NORMAL);
					SetEntityRenderColor(i, 255, 255, 255, 255);
				}

				if (!IsFakeClient(i)) StopSound(i, SNDCHAN_AUTO, "player/heartbeatloop.wav");
				SetEntProp(i, Prop_Send, "m_bIsOnThirdStrike", 0);
			}
		}
	}
	return Plugin_Continue;
}

public Action:Timer_Doom(Handle:timer) {

	if (!b_IsActiveRound || DoomSUrvivorsRequired == 0) {

		DoomTimer = 0;
		return Plugin_Stop;
	}
	new SurvivorCount = LivingSurvivors();
	if (DoomSUrvivorsRequired == -1 && SurvivorCount != TotalSurvivors() ||
		DoomSUrvivorsRequired > 0 && SurvivorCount < DoomSUrvivorsRequired) {

		if (DoomTimer == 0) PrintToChatAll("%t", "you are doomed", orange);
		DoomTimer++;
	}
	else DoomTimer = 0;

	if (DoomTimer >= DoomKillTimer) {

		for (new i = 1; i <= MaxClients; i++) {

			if (IsLegitimateClientAlive(i) && (GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i))) {

				if (IsClientInRangeSpecialAmmo(i, "C", true) == -2.0) continue;
				HealingContribution[i] = 0;
				PointsContribution[i] = 0.0;
				TankingContribution[i] = 0;
				DamageContribution[i] = 0;
				BuffingContribution[i] = 0;
				HexingContribution[i] = 0;

				ForcePlayerSuicide(i);
			}
		}
		if (DoomTimer == DoomKillTimer) PrintToChatAll("%t", "survivors are doomed", orange);
		if (LivingHumanSurvivors() < 1) return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:Timer_TankCooldown(Handle:timer) {

	static Float:Counter								=	0.0;

	if (!b_IsActiveRound) {

		Counter											=	0.0;
		return Plugin_Stop;
	}
	Counter												+=	1.0;
	f_TankCooldown										-=	1.0;
	if (f_TankCooldown < 1.0) {

		Counter											=	0.0;
		f_TankCooldown									=	-1.0;
		for (new i = 1; i <= MaxClients; i++) {

			if (IsClientInGame(i) && !IsFakeClient(i) && (GetClientTeam(i) == TEAM_INFECTED || ReadyUp_GetGameMode() != 2)) {

				PrintToChat(i, "%T", "Tank Cooldown Complete", i, orange, white);
			}
		}

		return Plugin_Stop;
	}
	if (Counter >= fVersusTankNotice) {

		Counter											=	0.0;
		for (new i = 1; i <= MaxClients; i++) {

			if (IsClientInGame(i) && !IsFakeClient(i) && (GetClientTeam(i) == TEAM_INFECTED || ReadyUp_GetGameMode() != 2)) {

				PrintToChat(i, "%T", "Tank Cooldown Remaining", i, green, f_TankCooldown, white, orange, white);
			}
		}
	}

	return Plugin_Continue;
}

public Action:Timer_SettingsCheck(Handle:timer) {

	if (!b_IsActiveRound) {

		SetConVarInt(FindConVar("z_common_limit"), 0);	// no commons unless active round.
		return Plugin_Stop;
	}

	static RaidLevelCounter		= 0;
	//static RageCommonLimit		= 0;

	if (!bIsSettingsCheck) return Plugin_Continue;
	bIsSettingsCheck = false;

	//if (!IsSurvivalMode) 
	//if (!IsSurvivalMode) 
	if (iTankRush != 1 || b_IsFinaleActive) {

		RaidLevelCounter = RaidCommonBoost();

		// we force a common limit on the tank rush servers
		if (iTankRush == 1 && RaidLevelCounter < 30) RaidLevelCounter = 30;
	}
	else RaidLevelCounter = 0;
	//else RaidLevelCounter = 0;
	//else RaidLevelCounter = 0;

	if (AllowedPanicInterval - RaidLevelCounter < 60) AllowedPanicInterval = 60;

	new CommonAllowed = (AllowedCommons + RaidLevelCounter);
	if (CommonAllowed <= iCommonsLimitUpper) SetConVarInt(FindConVar("z_common_limit"), AllowedCommons + RaidLevelCounter);
	else SetConVarInt(FindConVar("z_common_limit"), iCommonsLimitUpper);
	if (iTankRush != 1) SetConVarInt(FindConVar("z_reserved_wanderers"), RaidLevelCounter);
	else {

		//if (AllowedCommons + RaidLevelCounter)

		SetConVarInt(FindConVar("z_reserved_wanderers"), 0);
		SetConVarInt(FindConVar("director_always_allow_wanderers"), 0);
	}
	SetConVarInt(FindConVar("z_mega_mob_size"), AllowedMegaMob + RaidLevelCounter);
	SetConVarInt(FindConVar("z_mob_spawn_max_size"), AllowedMobSpawn + RaidLevelCounter);
	SetConVarInt(FindConVar("z_mob_spawn_finale_size"), AllowedMobSpawnFinale + RaidLevelCounter);
	if (iTankRush != 1) SetConVarInt(FindConVar("z_mega_mob_spawn_max_interval"), AllowedPanicInterval - RaidLevelCounter);
	else SetConVarInt(FindConVar("z_mega_mob_spawn_max_interval"), 60);

	return Plugin_Continue;
}

public Action:Timer_RespawnQueue(Handle:timer) {

	static Counter										=	-1;
	static TimeRemaining								=	0;
	static RandomClient									=	-1;
	static String:text[64];

	if (!b_IsActiveRound) {

		Counter = -1;
		return Plugin_Stop;
	}
	Counter++;
	TimeRemaining = RespawnQueue - Counter;
	if (TimeRemaining <= 0) RandomClient = FindAnyRandomClient(true);

	for (new i = 1; i <= MaxClients; i++) {

		if (!IsLegitimateClient(i) || GetClientTeam(i) != TEAM_SURVIVOR || IsPlayerAlive(i)) continue;
		if (TimeRemaining > 0) {

			if (!IsFakeClient(i)) {

				Format(text, sizeof(text), "%T", "respawn queue", i, TimeRemaining);
				PrintHintText(i, text);
			}
		}
		else if (IsLegitimateClientAlive(RandomClient)) {

			GetClientAbsOrigin(RandomClient, Float:DeathLocation[i]);
			SDKCall(hRoundRespawn, i);
			b_HasDeathLocation[i] = true;
			CreateTimer(1.0, Timer_TeleportRespawn, i, TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(1.0, Timer_GiveMaximumHealth, i, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	if (Counter >= RespawnQueue) Counter = 0;
	return Plugin_Continue;
}

public Action:Timer_DirectorPurchaseTimer(Handle:timer) {

	static Counter										=	-1;
	static Float:DirectorHandicap						=	-1.0;
	static Float:DirectorDelay							=	0.0;

	if (!b_IsActiveRound) {

		Counter											=	-1;
		return Plugin_Stop;
	}
	static theClient									=	-1;
	static theTankStartTime								=	-1;
	new iTankCount = GetInfectedCount(ZOMBIECLASS_TANK);
	new iTankLimit = GetSpecialInfectedLimit(true);
	new iInfectedCount = GetInfectedCount();
	new iSurvivors = TotalHumanSurvivors();
	new iSurvivorBots = TotalSurvivors() - iSurvivors;
	new LivingSerfs = LivingSurvivorCount();
	if (iSurvivorBots >= 2) iSurvivorBots /= 2;
	theClient = FindAnyRandomClient();
	if (iTankRush == 1 && !b_IsFinaleActive && iTankCount < (iSurvivors + iSurvivorBots)) {

		if (IsLegitimateClientAlive(theClient))	ExecCheatCommand(theClient, "z_spawn_old", "tank auto");
	}
	else if (iTankRush == 0) {

		if (iInfectedCount < (iSurvivors + iSurvivorBots)) {

			SpawnAnyInfected(theClient);
		}
	}
	if (iTanksAlways > 0) {

		if (theTankStartTime == -1) theTankStartTime = GetRandomInt(30, 60);
		if (theTankStartTime == 0 || RPGRoundTime(true) >= theTankStartTime) {

			theTankStartTime = 0;

			if (iInfectedCount - iTankCount < (iSurvivors + iSurvivorBots)) SpawnAnyInfected(theClient);
			if (!b_IsFinaleActive && iTankCount < iTankLimit && iTankCount < iTanksAlways) {

				if (IsLegitimateClientAlive(theClient))	ExecCheatCommand(theClient, "z_spawn_old", "tank auto");
			}
		}
	}
	/*if (HumanPlayersInGame() < 1) {

		Counter = -1;
		CallRoundIsOver();
		return Plugin_Stop;
	}*/
	if (DirectorHandicap == -1.0) {

		DirectorHandicap = fDirectorThoughtHandicap;
		DirectorDelay	 = fDirectorThoughtDelay;
	}
	if (Counter == -1 || b_IsSurvivalIntermission || LivingSurvivorCount() < 1) {

		Counter = GetTime() + RoundToCeil(DirectorDelay - (LivingHumanSurvivors() * DirectorHandicap));
		return Plugin_Continue;
	}
	else if (Counter > GetTime()) {

		// We still spawn specials, out of range of players to enforce the active special limit.
		return Plugin_Continue;
	}
	//PrintToChatAll("%t", "Director Think Process", orange, white);


	Counter = GetTime() + RoundToCeil(DirectorDelay - (LivingSerfs * DirectorHandicap));

	new size				=	GetArraySize(a_DirectorActions);

	for (new i = 1; i <= MaximumPriority; i++) { CheckDirectorActionPriority(i, size); }

	return Plugin_Continue;
}

stock CheckDirectorActionPriority(pos, size) {

	decl String:text[64];
	for (new i = 0; i < size; i++) {

		if (i < GetArraySize(a_DirectorActions_Cooldown)) GetArrayString(a_DirectorActions_Cooldown, i, text, sizeof(text));
		else break;
		if (StringToInt(text) > 0) continue;			// Purchase still on cooldown.
		
		DirectorKeys					=	GetArrayCell(a_DirectorActions, i, 0);
		DirectorValues					=	GetArrayCell(a_DirectorActions, i, 1);

		if (GetKeyValueInt(DirectorKeys, DirectorValues, "priority?") != pos || !DirectorPurchase_Valid(DirectorKeys, DirectorValues, i)) continue;
		DirectorPurchase(DirectorKeys, DirectorValues, i);
	}
}

stock bool:DirectorPurchase_Valid(Handle:Keys, Handle:Values, pos) {

	new Float:PointCost		=	0.0;
	new Float:PointCostMin	=	0.0;
	decl String:Cooldown[64];

	GetArrayString(a_DirectorActions_Cooldown, pos, Cooldown, sizeof(Cooldown));
	if (StringToInt(Cooldown) > 0) return false;

	PointCost				=	GetKeyValueFloat(Keys, Values, "point cost?") + (GetKeyValueFloat(Keys, Values, "cost handicap?") * LivingHumanSurvivors());
	if (PointCost > 1.0) PointCost = 1.0;
	PointCostMin			=	GetKeyValueFloat(Keys, Values, "point cost minimum?") + (GetKeyValueFloat(Keys, Values, "min cost handicap?") * LivingHumanSurvivors());

	if (Points_Director > 0.0) PointCost *= Points_Director;
	if (PointCost < PointCostMin) PointCost = PointCostMin;

	if (Points_Director >= PointCost) return true;
	return false;
}

stock bool:bIsDirectorTankEligible() {

	if (ActiveTanks() < DirectorTankLimit()) return true;
	return false;
}

stock ActiveTanks() {

	new Count = 0;
	for (new i = 1; i <= MaxClients; i++) {

		if (IsClientInGame(i) && GetClientTeam(i) == TEAM_INFECTED && IsPlayerAlive(i) && FindZombieClass(i) == ZOMBIECLASS_TANK) Count++;
	}

	return Count;
}

stock DirectorTankLimit() {

	new Float:count = (LivingSurvivors() / fTankMultiplier) * iTankPlayerCount;
	if (count < 1.0) count = 1.0;

	return RoundToCeil(count);
}

stock GetWitchCount() {

	new count = 0;
	new ent = -1;
	while ((ent = FindEntityByClassname(ent, "witch")) != INVALID_ENT_REFERENCE) {

		// Some maps, like Hard Rain pre-spawn a ton of witches - we want to add them to the witch table.
		count++;
	}
	return count;
}

stock DirectorPurchase(Handle:Keys, Handle:Values, pos) {

	decl String:Command[64];
	decl String:Parameter[64];
	decl String:Model[64];
	new IsPlayerDrop		=	0;
	new Count				=	0;

	new Float:PointCost		=	0.0;
	new Float:PointCostMin	=	0.0;

	new Float:MinimumDelay	=	0.0;

	PointCost				=	GetKeyValueFloat(Keys, Values, "point cost?") + (GetKeyValueFloat(Keys, Values, "cost handicap?") * LivingHumanSurvivors());
	PointCostMin			=	GetKeyValueFloat(Keys, Values, "point cost minimum?") + (GetKeyValueFloat(Keys, Values, "min cost handicap?") * LivingHumanSurvivors());
	Format(Parameter, sizeof(Parameter), "%s", GetKeyValue(Keys, Values, "parameter?"));
	Count					=	GetKeyValueInt(Keys, Values, "count?");
	Format(Command, sizeof(Command), "%s", GetKeyValue(Keys, Values, "command?"));
	IsPlayerDrop			=	GetKeyValueInt(Keys, Values, "drop?");
	Format(Model, sizeof(Model), "%s", GetKeyValue(Keys, Values, "model?"));
	MinimumDelay			=	GetKeyValueFloat(Keys, Values, "minimum delay?");

	if (PointCost > 1.0) {

		PointCost			=	1.0;
	}

	//if (ReadyUp_GetGameMode() != 3 && b_IsFinaleActive && StrContains(Parameter, "witch", false) == -1 && StrContains(Parameter, "tank", false) == -1) return;

	if (DirectorWitchLimit == 0) DirectorWitchLimit = LivingSurvivorCount();


	if (StrContains(Parameter, "witch", false) != -1 && (IsSurvivalMode || GetWitchCount() >= DirectorWitchLimit || GetArraySize(Handle:WitchList) + 1 >= DirectorWitchLimit)) return;
	if (StrContains(Parameter, "tank", false) != -1 && (IsSurvivalMode || ActiveTanks() >= DirectorTankLimit() || f_TankCooldown != -1.0)) return;

	if (StrEqual(Parameter, "common")) {

		if (GetArraySize(CommonInfectedQueue) + Count >= iCommonQueueLimit) {

			return;
		}
	}

	/*if ((StrEqual(Command, "director_force_panic_event") || IsPlayerDrop) && b_IsFinaleActive) {

		return;
	}*/
	//if (!IsEnrageActive() && StrEqual(Command, "director_force_panic_event")) return;

	if (Points_Director > 0.0) PointCost *= Points_Director;
	if (PointCost < PointCostMin) PointCost = PointCostMin;

	if (Points_Director < PointCost) return;

	if (LivingSurvivorCount() < GetKeyValueInt(Keys, Values, "living survivors?")) return;

	new Client				=	FindLivingSurvivor();
	if (Client < 1) return;
	Points_Director -= PointCost;

	if (!IsEnrageActive() && MinimumDelay > 0.0) {

		SetArrayString(a_DirectorActions_Cooldown, pos, "1");
		MinimumDelay = MinimumDelay - (LivingHumanSurvivors() * fDirectorThoughtHandicap) - (GetKeyValueFloat(Keys, Values, "delay handicap?") * LivingHumanSurvivors());
		if (MinimumDelay < 0.0) MinimumDelay = 0.0;
		CreateTimer((fDirectorThoughtDelay - (LivingHumanSurvivors() * fDirectorThoughtHandicap)) + MinimumDelay, Timer_DirectorActions_Cooldown, pos, TIMER_FLAG_NO_MAPCHANGE);
	}

	if (!StrEqual(Parameter, "common")) ExecCheatCommand(Client, Command, Parameter);
	else SpawnCommons(Client, Count, Command, Parameter, Model, IsPlayerDrop, GetKeyValue(Keys, Values, "supercommon?"));
}

/*stock InsertInfected(survivor, infected) {

	CreateListPositionByEntity(survivor, infected, InfectedHealth[survivor]);
	new isArraySize = GetArraySize(Handle:InfectedHealth[survivor]);
	new t_InfectedHealth = 0;
	ResizeArray(Handle:InfectedHealth[survivor], isArraySize + 1);
	SetArrayCell(Handle:InfectedHealth[survivor], isArraySize, infected, 0);

	//An infected wasn't added on spawn to this player, so we add it now based on class.
	if (FindZombieClass(infected) == ZOMBIECLASS_TANK) t_InfectedHealth = 4000;
	else if (FindZombieClass(infected) == ZOMBIECLASS_HUNTER || FindZombieClass(infected) == ZOMBIECLASS_SMOKER) t_InfectedHealth = 250;
	else if (FindZombieClass(infected) == ZOMBIECLASS_BOOMER) t_InfectedHealth = 50;
	else if (FindZombieClass(infected) == ZOMBIECLASS_SPITTER) t_InfectedHealth = 100;
	else if (FindZombieClass(infected) == ZOMBIECLASS_CHARGER) t_InfectedHealth = 600;
	else if (FindZombieClass(infected) == ZOMBIECLASS_JOCKEY) t_InfectedHealth = 325;

	decl String:ss_InfectedHealth[64];
	Format(ss_InfectedHealth, sizeof(ss_InfectedHealth), "(%d) infected health bonus", FindZombieClass(infected));

	if (StringToInt(GetConfigValue("infected bot level type?")) == 1) t_InfectedHealth += t_InfectedHealth * RoundToCeil(HumanSurvivorLevels() * StringToFloat(GetConfigValue(ss_InfectedHealth)));
	else t_InfectedHealth += t_InfectedHealth * RoundToCeil(PlayerLevel[survivor] * StringToFloat(GetConfigValue(ss_InfectedHealth)));
	if (HandicapLevel[survivor] > 0) t_InfectedHealth += t_InfectedHealth * RoundToCeil(HandicapLevel[survivor] * StringToFloat(GetConfigValue("handicap health increase?")));

	SetArrayCell(Handle:InfectedHealth[survivor], isArraySize, t_InfectedHealth, 1);
	SetArrayCell(Handle:InfectedHealth[survivor], isArraySize, 0, 2);
	SetArrayCell(Handle:InfectedHealth[survivor], isArraySize, 0, 3);
	if (isArraySize == 0) return -1;
	return isArraySize;
}*/

stock SpawnCommons(Client, Count, String:Command[], String:Parameter[], String:Model[], IsPlayerDrop, String:SuperCommon[] = "none") {

	new TargetClient				=	-1;
	new CommonQueueLimit = iCommonQueueLimit;
	if (StrContains(Model, ".mdl", false) != -1) {

		for (new i = Count; i > 0 && GetArraySize(CommonInfectedQueue) < CommonQueueLimit; i--) {

			if (IsPlayerDrop == 1) {

				ResizeArray(Handle:CommonInfectedQueue, GetArraySize(Handle:CommonInfectedQueue) + 1);
				ShiftArrayUp(Handle:CommonInfectedQueue, 0);
				SetArrayString(Handle:CommonInfectedQueue, 0, Model);
				TargetClient		=	FindLivingSurvivor();
				if (StrContains(SuperCommon, "-", false) == -1 && !StrEqual(SuperCommon, "none", false)) PushArrayString(Handle:SuperCommonQueue, SuperCommon);
				if (TargetClient > 0) ExecCheatCommand(TargetClient, Command, Parameter);
			}
			else PushArrayString(Handle:CommonInfectedQueue, Model);
		}
	}
}

stock FindLivingSurvivor() {


	/*new Client = -1;
	while (Client == -1 && LivingSurvivorCount() > 0) {

		Client = GetRandomInt(1, MaxClients);
		if (!IsClientInGame(Client) || !IsClientHuman(Client) || !IsPlayerAlive(Client) || GetClientTeam(Client) != TEAM_SURVIVOR) Client = -1;
	}
	return Client;*/
	for (new i = LastLivingSurvivor; i <= MaxClients && LivingSurvivorCount() > 0; i++) {

		if (IsLegitimateClientAlive(i) && GetClientTeam(i) == TEAM_SURVIVOR) {

			LastLivingSurvivor = i;
			return i;
		}
	}
	LastLivingSurvivor = 1;
	if (LivingSurvivorCount() < 1) return -1;
	return -1;
}

stock LivingSurvivorCount(ignore = -1) {

	new Count = 0;
	for (new i = 1; i <= MaxClients; i++) {

		if (IsLegitimateClientAlive(i) && (GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i)) && (ignore == -1 || i != ignore)) Count++;
	}
	return Count;
}

public Action:Timer_DirectorActions_Cooldown(Handle:timer, any:pos) {

	SetArrayString(a_DirectorActions_Cooldown, pos, "0");
	return Plugin_Stop;
}