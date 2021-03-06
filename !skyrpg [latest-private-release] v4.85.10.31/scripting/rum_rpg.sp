 /**
 * =============================================================================
 * Ready Up - RPG (C)2017 Michael toth
 * =============================================================================
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * As a special exception, AlliedModders LLC gives you permission to link the
 * code of this program (as well as its derivative works) to "Half-Life 2," the
 * "Source Engine," the "SourcePawn JIT," and any Game MODs that run on software
 * by the Valve Corporation.  You must obey the GNU General Public License in
 * all respects for all other code used.  Additionally, AlliedModders LLC grants
 * this exception to all derivative works.  AlliedModders LLC defines further
 * exceptions, found in LICENSE.txt (as of this writing, version JULY-31-2007),
 * or <http://www.sourcemod.net/license.php>.
 */

/*
	Credits:

	AtomikStryker (biletheworld reference on how to traceray)
	panxiaoxiao ?? man im sorry if i butchered that
	mr.zero stocks has been invaluable
	Asherkin <3 my bae invaluable resource for learning

	// 4.1

	Further optimization for survivor bots.
	Players get health proper on incap.
	Hostname now displays to people; people have asked what server they play in, and RPG allows each server to set individual hostnames.
	Survivors Bots fully-supported in Helms-Deep
	shortened class effect vars
	Healers now heal with bullets.
	Shamans can heal with melee attacks.

	// 4.0.3
	// Added customizable database. If one isn't specified with the "db record?" keyvalue, one of these will be picked by default

	4.0.1
	- Action bars are implemented!
	- Magic system revamped!

	4.0

	1.	Revamped the Common Affix System to be more robust.
		a.	How we display common affixes has been expanded to make room for new affixes.
		b.	Also to make room for survivor auras, we don't want people getting more confused than they will already be.
		c.	Maybe support for multiple affixes on a common?
		d.	Level restrictions for certain common affixes as well as level ranges for others!
	2.	Elemental damage
		a.	Special commons and Special infected will have a halo above their heads in the colour associated
			with the elemental damage they spawned with. Common infected are always physical damage.
	3.	Survivor Auras
		These are essentially spells. A player can have one active at any time and change the active aura with the
		shortcut command for the aura they wish to change to. This can be done only when aura switch is not on cooldown.
		Players can reduce this interval by stacking Agility in the new CARTEL system...
	4.	SLATE -> CARTEL
		Slate is being replaced with the newer and more robust CARTEL system.
		Upgrade points are either spent on talents OR on a CARTEL point. CARTEL points affect everything, so a point in
		one of these categories is much more valuable than stacking into a single talent. This adds another layer of
		strategy that players will have to adapt to.

	3.9.2
	1.	Preparing for 4.0 major changes coming.
	2.	Changed witch damage / level to be a linear increase.

	3.9.1
	1.	New Special Common Classes.
	2.	Common Infected have received health pools.
	3.	Special/Standard Common Infected now affected by damage talents.
	4.	RPG now properly loads on a server startup!
	5.	HUD has been redesigned: Status Effects added for the Buffer/Hexer roles.

	3.8.6.2
	1.	Special Common Infected added. (Formerly affixes, formerly auras)
	2.	Fixed some issues with talent points and level-ups.
	3.	Respec now resets SLATE as well, since they will be important in the survivor skills update.
	4.	If the experience requirements ever change and a player doesn't line up, it will automatically adjust them and refund everything for them.
	5.	Due to abuse, free weapons now are removed when purchased. If you want to give someone something, use the !drop command.
	6.	Due to the new system, players can again spend talents when alive.

	3.8.6.1
	1.	Added AoE Healing (Defensive & Offensive) Abilities.
	2.	Added Abilities that damage/kill/affect Common Infected.
	3.	Added Healing Role Support.
	4.	Corrected some minor issues (like experience debt triggering multiple times / death)

	3.8.5
	1.	Added a tanking experience reward. Players can now choose to play a role as a damage dealer, tank, or both.
		Players receive tanking experience when the damage received is greater than their damage contributed but
		the player must still meet the minimum damage contribution requirement.

	3.8.4, 3.8.3
	1.	Miscellaneous fixes and updates for Quality of Life

	3.8.2
	1.	Fixed an issue that eliminated worldspawn damage triggers.

	3.8.1
	1.	Locked Talent upgrades to dead players or during pre-game.
	2.	Upgrades Available replaces the old, archaic, manual upgrade system.

	3.7.5
	1.	Discovered a bug that a user in the community had been exploiting for insane experience rewards; simply, weapon talents would affect
		all weapons when you trigger the talent and just switch weapons. Now, for damage bonus talents, the damage is applied immediately
		and no multiplier that can be exploited is used.
	2.	Fixed an issue that rewarded players with points and experience for overkill damage.
	3.	Potential bug fix for tank death anim bug. Valve, why are your programmers so fucking shitty that they can't patch a bug that has been
		in the game for over 7 years????
	4.	BaseDamageMultiplier system removed; it was buggy, and simply replaced with a better system.
	5.	Redundancies in place for SDHHook and new health pool systems; sometimes players are not properly connected to it and it creates adverse
		effects on the player experience.
	6.	Low-level handicapping has been removed as it caused issues.
	7.	Corrected an issue that allowed special infected to pre-death before they were killed in any instance.
	8.	Hard-coded special infected life to always reset to a set value whenever they take damage since damage is stored in variables, and not by the game.
	2\left4dead2\models\props_urban\metal_pole001.mdl

	3.7.4
	1.	Infected point and experience earning has been updated.
		Infected players (and bots) will earn experience and points in real-time as they hurt survivors
		instead of having to wait until after they die, which should hopefully create better balance between survivors and infected.


	3.7.3
	1.	To combat higher-level players who like to just rush, knowing that they have respawn abilities and death is not a punishment
		I have now added the dreaded experience debt to the game. Rejoice, hell is here.


	3.7.2
	1.	Added Required Ranges for certain weapons; sniper rifles, for instance, will actually receive damage penalties when
		a player uses them when too close to special infected. This prevents players from no-scoping sniper rifle shots while
		dancing, essentially to distinctly classify shotguns and snipers into their own groups.

	3.7.1
	1.	Damage System Redesign

		The damage system has been redesigned due to SDKHooks providing a more
		reliable solution versus the player_hurt event.
		AURAS REMOVED IN 3.7.1 - Let's focus on player skills & equipment instead.


	2.	Menu System Expanded

		The main menu system has been expanded to support new entries in the config files.
		"menu name?"	->	Which sub-menu of the main-menu should be open; "main" is hard-coded for main menu.
		"target menu?"	->	Which sub-menu of the main-menu does this open call?

		Ability chance has been re-balanced. Since talents either come with the option to require ability chance
		or not require ability chance, but can't use their own, I wrote a work-around until I can go back and
		redesign that system. if the talent is in menu named "shotgun talents" and requires ability chance, then
		you must also have an ability chance talent in the menu named "shotgun talents" as all talents in the same
		menu will feed from the same ability chance. This lets us weight different categories completely different.

	3.	Macroable talent upgrade system

		Adds new command: talentupgrade <id#> <value>
		Using this command with / or ! a user can instantly fill specific talents with specific values.
		Allows for unlimited build diversity, and should help reduce time players spend manually inserting points
		in endgame when they have thousands of upgrade points.

	4.	Survival support
		Official Support for survival is added. Yep... go ham.

	3.6.2
	Contribution system tweaked;
	Player Level determines:
	1. Upgrades Limits
	2. Outgoing (and incoming) damage.

	Sky Level determines:
	1. Item drop chances.
	2. Special Infected / Witch Health pools.

	3.6.1
	Contribution system added.
*/




 /*
 	List:InfectedHealth[MAXPLAYERS + 1];
 	block 0 - entity id.
 	block 1 - true health (infectedhealth - (infectedhealth * teamPercentage))
 	block 2 - each individual player contribution
 	block 3 - player damage taken from the special infected (for tank xp bonus)
 	block 4 - player healing done // deprecated in v0.9.9 (Survivor buffs and then full release.)
 	block 5 - infected health original - used to determine how much tanking rating to give (this - tankingdone)

 	The idea is instead of directly sharing health with mobs that each player
 	fights a mob of their own health pool. This design eliminates the issue that
 	lower level (and higher level) players have with zombies that either have
 	too little or too much health, allowing players of multiple level ranges
 	to co-exist on the same server together.

 	Both health bars are shown to the player, so they have a general idea of how
 	fast they're killing the mob, comparatively to the group effort.

 	When the group effort reaches 100% of the mob health, the mob is killed and
 	players earn the full range of experience for their contribution.
*/

#define NICK_MODEL				"models/survivors/survivor_gambler.mdl"
#define ROCHELLE_MODEL			"models/survivors/survivor_producer.mdl"
#define COACH_MODEL				"models/survivors/survivor_coach.mdl"
#define ELLIS_MODEL				"models/survivors/survivor_mechanic.mdl"
#define ZOEY_MODEL				"models/survivors/survivor_teenangst.mdl"
#define FRANCIS_MODEL			"models/survivors/survivor_biker.mdl"
#define LOUIS_MODEL				"models/survivors/survivor_manager.mdl"
#define BILL_MODEL				"models/survivors/survivor_namvet.mdl"

#define TEAM_SPECTATOR		1
#define TEAM_SURVIVOR		2
#define TEAM_INFECTED		3

#define MAX_ENTITIES		2048
#define MAX_CHAT_LENGTH		1024

#define COOPRECORD_DB				"db_season_coop"
#define SURVRECORD_DB				"db_season_surv"

#define PLUGIN_VERSION				"v4.85.10.31"
#define CLASS_VERSION				"v1.0"
#define PROFILE_VERSION				"v1.3"
#define LOOT_VERSION				"v0.0"

#define PLUGIN_CONTACT				""
#define PLUGIN_NAME					"RPG"
#define PLUGIN_DESCRIPTION			"RPG of Class"
#define PLUGIN_URL					"github.com/MissexSkye"

#define CONFIG_EVENTS				"rpg/events.cfg"
#define CONFIG_MAINMENU				"rpg/mainmenu.cfg"
#define CONFIG_MENUTALENTS			"rpg/talentmenu.cfg"
#define CONFIG_POINTS				"rpg/points.cfg"
#define CONFIG_MAPRECORDS			"rpg/maprecords.cfg"
#define CONFIG_STORE				"rpg/store.cfg"
#define CONFIG_TRAILS				"rpg/trails.cfg"
#define CONFIG_CHATSETTINGS			"rpg/chatsettings.cfg"
#define CONFIG_PETS					"rpg/pets.cfg"
#define CONFIG_WEAPONS				"rpg/weapondamages.cfg"
#define CONFIG_COMMONAFFIXES		"rpg/commonaffixes.cfg"

#define LOGFILE						"rum_rpg.txt"
#define JETPACK_AUDIO				"ambient/gas/steam2.wav"

/*
	==========
				*/

#define DEBUG				false
/*
	==========
				*/

#define CVAR_SHOW			FCVAR_NOTIFY | FCVAR_PLUGIN
#define DMG_HEADSHOT		2147483648

#define ZOMBIECLASS_SMOKER											1
#define ZOMBIECLASS_BOOMER											2
#define ZOMBIECLASS_HUNTER											3
#define ZOMBIECLASS_SPITTER											4
#define ZOMBIECLASS_JOCKEY											5
#define ZOMBIECLASS_CHARGER											6
#define ZOMBIECLASS_WITCH											7
#define ZOMBIECLASS_TANK											8
#define ZOMBIECLASS_SURVIVOR										0
#define TANKSTATE_TIRED												0
#define TANKSTATE_REFLECT											1
#define TANKSTATE_FIRE												2
#define TANKSTATE_DEATH												3
#define TANKSTATE_TELEPORT											4
#define TANKSTATE_HULK												5

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <smlib>
#include <l4d2_direct>

#include "wrap.inc"
#include "left4downtown.inc"
#include "l4d_stocks.inc"

#undef REQUIRE_PLUGIN
#include <readyup>
#define REQUIRE_PLUGIN

public Plugin:myinfo = {
	name = PLUGIN_NAME,
	author = PLUGIN_CONTACT,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL,
};

new iDropsEnabled;
new Float:fDeathPenalty;
new iHardcoreMode;
new iDeathPenaltyPlayers;
new Handle:RoundStatistics;
new bool:IsLoadingClassData[MAXPLAYERS + 1];
new bool:bRushingNotified[MAXPLAYERS + 1];
new bool:bHasTeleported[MAXPLAYERS + 1];
new bool:IsAirborne[MAXPLAYERS + 1];
new Handle:RandomSurvivorClient;
new eBackpack[MAXPLAYERS + 1];
new bool:b_IsFinaleTanks;
new String:RatingType[64];
new bool:bJumpTime[MAXPLAYERS + 1];
new Float:JumpTime[MAXPLAYERS + 1];
new Handle:AbilityConfigKeys[MAXPLAYERS + 1];
new Handle:AbilityConfigValues[MAXPLAYERS + 1];
new Handle:AbilityConfigSection[MAXPLAYERS + 1];
new bool:IsGroupMember[MAXPLAYERS + 1];
new Handle:GetAbilityKeys[MAXPLAYERS + 1];
new Handle:GetAbilityValues[MAXPLAYERS + 1];
new Handle:GetAbilitySection[MAXPLAYERS + 1];
new Handle:IsAbilityKeys[MAXPLAYERS + 1];
new Handle:IsAbilityValues[MAXPLAYERS + 1];
new Handle:IsAbilitySection[MAXPLAYERS + 1];
new bool:bIsSprinting[MAXPLAYERS + 1];
new Handle:CheckAbilityKeys[MAXPLAYERS + 1];
new Handle:CheckAbilityValues[MAXPLAYERS + 1];
new StrugglePower[MAXPLAYERS + 1];
new Handle:GetTalentStrengthKeys[MAXPLAYERS + 1];
new Handle:GetTalentStrengthValues[MAXPLAYERS + 1];
new Handle:CastKeys[MAXPLAYERS + 1];
new Handle:CastValues[MAXPLAYERS + 1];
new Handle:CastSection[MAXPLAYERS + 1];
new ActionBarSlot[MAXPLAYERS + 1];
new Handle:ActionBar[MAXPLAYERS + 1];
new bool:DisplayActionBar[MAXPLAYERS + 1];
new ConsecutiveHits[MAXPLAYERS + 1];
new MyVomitChase[MAXPLAYERS + 1];
new Float:JetpackRecoveryTime[MAXPLAYERS + 1];
new bool:b_IsHooked[MAXPLAYERS + 1];
new IsPvP[MAXPLAYERS + 1];
new bool:bJetpack[MAXPLAYERS + 1];
new ServerLevelRequirement;
new Handle:TalentsAssignedKeys[MAXPLAYERS + 1];
new Handle:TalentsAssignedValues[MAXPLAYERS + 1];
new Handle:CartelValueKeys[MAXPLAYERS + 1];
new Handle:CartelValueValues[MAXPLAYERS + 1];
new ReadyUpGameMode;
new bool:b_IsLoaded[MAXPLAYERS + 1];
new bool:LoadDelay[MAXPLAYERS + 1];
new LoadTarget[MAXPLAYERS + 1];
new String:CompanionNameQueue[MAXPLAYERS + 1][64];
new bool:HealImmunity[MAXPLAYERS + 1];
new String:Hostname[64];
new String:sHostname[64];
new String:ClassLoadQueue[MAXPLAYERS + 1][64];
new String:ProfileLoadQueue[MAXPLAYERS + 1][64];
new bool:bIsSettingsCheck;
new Handle:SuperCommonQueue;
new bool:bIsCrushCooldown[MAXPLAYERS + 1];
new bool:bIsBurnCooldown[MAXPLAYERS + 1];
//new InfectedLevel;
new Rating[MAXPLAYERS + 1];
new String:MyAmmoEffects[MAXPLAYERS + 1];
new Float:RoundExperienceMultiplier[MAXPLAYERS + 1];
new BonusContainer[MAXPLAYERS + 1];
new CurrentMapPosition;
new DoomTimer;
new CleanseStack[MAXPLAYERS + 1];
new Float:CounterStack[MAXPLAYERS + 1];
new MultiplierStack[MAXPLAYERS + 1];
new String:BuildingStack[MAXPLAYERS + 1];
//new LastTarget[MAXPLAYERS + 1];
//new SurvivalRoundCounter;
new Handle:TempAttributes[MAXPLAYERS + 1];
new Handle:TempTalents[MAXPLAYERS + 1];
new Handle:PlayerProfiles[MAXPLAYERS + 1];
new String:LoadoutName[MAXPLAYERS + 1][64];
new bool:b_IsSurvivalIntermission;
new Float:ISDAZED[MAXPLAYERS + 1];
//new Float:ExplodeTankTimer[MAXPLAYERS + 1];
new TankState[MAXPLAYERS + 1];
//new LastAttacker[MAXPLAYERS + 1];
new bool:b_IsFloating[MAXPLAYERS + 1];
new Float:JumpPosition[MAXPLAYERS + 1][2][3];
new Float:LastDeathTime[MAXPLAYERS + 1];
new Float:SurvivorEnrage[MAXPLAYERS + 1][2];
new bool:bHasWeakness[MAXPLAYERS + 1];
new HexingContribution[MAXPLAYERS + 1];
new BuffingContribution[MAXPLAYERS + 1];
new HealingContribution[MAXPLAYERS + 1];
new TankingContribution[MAXPLAYERS + 1];
new CleansingContribution[MAXPLAYERS + 1];
new Float:PointsContribution[MAXPLAYERS + 1];
new DamageContribution[MAXPLAYERS + 1];
new Float:ExplosionCounter[MAXPLAYERS + 1][2];
new Handle:CoveredInVomit;
new bool:AmmoTriggerCooldown[MAXPLAYERS + 1];
new Handle:SpecialAmmoEffectKeys[MAXPLAYERS + 1];
new Handle:SpecialAmmoEffectValues[MAXPLAYERS + 1];
new Handle:ActiveAmmoCooldownKeys[MAXPLAYERS +1];
new Handle:ActiveAmmoCooldownValues[MAXPLAYERS + 1];
new Handle:PlayActiveAbilities[MAXPLAYERS + 1];
new Handle:PlayerActiveAmmo[MAXPLAYERS + 1];
new Handle:SpecialAmmoKeys[MAXPLAYERS + 1];
new Handle:SpecialAmmoValues[MAXPLAYERS + 1];
new Handle:SpecialAmmoSection[MAXPLAYERS + 1];
new Handle:DrawSpecialAmmoKeys[MAXPLAYERS + 1];
new Handle:DrawSpecialAmmoValues[MAXPLAYERS + 1];
new Handle:SpecialAmmoStrengthKeys[MAXPLAYERS + 1];
new Handle:SpecialAmmoStrengthValues[MAXPLAYERS + 1];
new Handle:WeaponLevel[MAXPLAYERS + 1];
new Handle:ExperienceBank[MAXPLAYERS + 1];
new Handle:MenuPosition[MAXPLAYERS + 1];
new Handle:IsClientInRangeSAKeys[MAXPLAYERS + 1];
new Handle:IsClientInRangeSAValues[MAXPLAYERS + 1];
new Handle:SpecialAmmoData;
new Handle:SpecialAmmoSave;
new Float:MovementSpeed[MAXPLAYERS + 1];
new IsPlayerDebugMode[MAXPLAYERS + 1];
new String:ActiveSpecialAmmo[MAXPLAYERS + 1][64];
new Float:IsSpecialAmmoEnabled[MAXPLAYERS + 1][4];
new bool:bIsInCombat[MAXPLAYERS + 1];
new Float:CombatTime[MAXPLAYERS + 1];
new Handle:AKKeys[MAXPLAYERS + 1];
new Handle:AKValues[MAXPLAYERS + 1];
new Handle:AKSection[MAXPLAYERS + 1];
new bool:bIsSurvivorFatigue[MAXPLAYERS + 1];
new SurvivorStamina[MAXPLAYERS + 1];
new Float:SurvivorConsumptionTime[MAXPLAYERS + 1];
new Float:SurvivorStaminaTime[MAXPLAYERS + 1];
new Handle:ISSLOW[MAXPLAYERS + 1];
new Handle:ISFROZEN[MAXPLAYERS + 1];
new Float:ISEXPLODETIME[MAXPLAYERS + 1];
new Handle:ISEXPLODE[MAXPLAYERS + 1];
new Handle:ISBLIND[MAXPLAYERS + 1];
new bool:ISBILED[MAXPLAYERS + 1];
new Handle:EntityOnFire;
new Handle:CommonInfected;
new Handle:CommonInfectedDamage[MAXPLAYERS + 1];
new Handle:RCAffixes[MAXPLAYERS + 1];
new Handle:h_CommonKeys;
new Handle:h_CommonValues;
new Handle:SearchKey_Section;
new Handle:h_CAKeys;
new Handle:h_CAValues;
new Handle:CommonList;
new Handle:CommonAffixes;			// the array holding the common entity id and the affix associated with the common infected. If multiple affixes, multiple keyvalues for the entity id will be created instead of multiple entries.
new Handle:a_CommonAffixes;			// the array holding the config data
new Handle:CommonAffixesCooldown[MAXPLAYERS + 1];		// the array holding cooldown information for common affix damages.
new UpgradesAwarded[MAXPLAYERS + 1];
new UpgradesAvailable[MAXPLAYERS + 1];
new Handle:InfectedAuraKeys[MAXPLAYERS + 1];
new Handle:InfectedAuraValues[MAXPLAYERS + 1];
new Handle:InfectedAuraSection[MAXPLAYERS + 1];
new bool:b_IsDead[MAXPLAYERS + 1];
new ExperienceDebt[MAXPLAYERS + 1];
new Handle:TalentUpgradeKeys[MAXPLAYERS + 1];
new Handle:TalentUpgradeValues[MAXPLAYERS + 1];
new Handle:TalentUpgradeSection[MAXPLAYERS + 1];
new Handle:InfectedHealth[MAXPLAYERS + 1];
new Handle:SpecialCommon[MAXPLAYERS + 1];
new Handle:WitchList;
new Handle:WitchDamage[MAXPLAYERS + 1];
//new IncapacitatedHealth[MAXPLAYERS + 1];
new Handle:Give_Store_Keys;
new Handle:Give_Store_Values;
new Handle:Give_Store_Section;
new bool:bIsMeleeCooldown[MAXPLAYERS + 1];
new Handle:a_WeaponDamages;
new Handle:MeleeKeys[MAXPLAYERS + 1];
new Handle:MeleeValues[MAXPLAYERS + 1];
new Handle:MeleeSection[MAXPLAYERS + 1];
new String:Public_LastChatUser[64];
new String:Infected_LastChatUser[64];
new String:Survivor_LastChatUser[64];
new String:Spectator_LastChatUser[64];
new String:currentCampaignName[64];
//new Float:g_MapFlowDistance;
new Handle:h_KilledPosition_X[MAXPLAYERS + 1];
new Handle:h_KilledPosition_Y[MAXPLAYERS + 1];
new Handle:h_KilledPosition_Z[MAXPLAYERS + 1];
new bool:bIsEligibleMapAward[MAXPLAYERS + 1];
new String:ChatSettingsName[MAXPLAYERS + 1][64];
new Handle:a_ChatSettings;
new Handle:ChatSettings[MAXPLAYERS + 1];
new bool:b_ConfigsExecuted;
new bool:b_FirstLoad;
new bool:b_MapStart;
new bool:b_HardcoreMode[MAXPLAYERS + 1];
new PreviousRoundIncaps[MAXPLAYERS + 1];
new RoundIncaps[MAXPLAYERS + 1];
//new RoundDeaths[MAXPLAYERS + 1];
new String:CONFIG_MAIN[64];
new bool:b_IsCampaignComplete;
new bool:b_IsRoundIsOver;
new RatingHandicap[MAXPLAYERS + 1];
new bool:bIsHandicapLocked[MAXPLAYERS + 1];
new bool:b_IsCheckpointDoorStartOpened;
//new bool:b_IsSavingInfectedBotData;
//new bool:b_IsLoadingInfectedBotData;
new resr[MAXPLAYERS + 1];
new LastPlayLength[MAXPLAYERS + 1];
new RestedExperience[MAXPLAYERS + 1];
//new bool:bIsLoadedBotData;
new MapRoundsPlayed;
new String:LastSpoken[MAXPLAYERS + 1][512];
new Handle:RPGMenuPosition[MAXPLAYERS + 1];
new bool:b_IsInSaferoom[MAXPLAYERS + 1];
new Handle:hDatabase												=	INVALID_HANDLE;
new String:ConfigPathDirectory[64];
new String:LogPathDirectory[64];
new String:PurchaseSurvEffects[MAXPLAYERS + 1][64];
new String:PurchaseTalentName[MAXPLAYERS + 1][64];
new PurchaseTalentPoints[MAXPLAYERS + 1];
new Handle:a_Trails;
new Handle:TrailsKeys[MAXPLAYERS + 1];
new Handle:TrailsValues[MAXPLAYERS + 1];
new bool:b_IsFinaleActive;
new RoundDamage[MAXPLAYERS + 1];
//new String:MVPName[64];
//new MVPDamage;
new RoundDamageTotal;
new SpecialsKilled;
new Handle:LockedTalentKeys;
new Handle:LockedTalentValues;
new Handle:LockedTalentSection;
new Handle:MOTKeys[MAXPLAYERS + 1];
new Handle:MOTValues[MAXPLAYERS + 1];
new Handle:MOTSection[MAXPLAYERS + 1];
new Handle:DamageKeys[MAXPLAYERS + 1];
new Handle:DamageValues[MAXPLAYERS + 1];
new Handle:DamageSection[MAXPLAYERS + 1];
new Handle:BoosterKeys[MAXPLAYERS + 1];
new Handle:BoosterValues[MAXPLAYERS + 1];
new Handle:StoreChanceKeys[MAXPLAYERS + 1];
new Handle:StoreChanceValues[MAXPLAYERS + 1];
new Handle:StoreItemNameSection[MAXPLAYERS + 1];
new Handle:StoreItemSection[MAXPLAYERS + 1];
new String:PathSetting[64];
new Handle:SaveSection[MAXPLAYERS + 1];
new OriginalHealth[MAXPLAYERS + 1];
new bool:b_IsLoadingStore[MAXPLAYERS + 1];
//new LoadPosStore[MAXPLAYERS + 1];
new Handle:LoadStoreSection[MAXPLAYERS + 1];
new SlatePoints[MAXPLAYERS + 1];
new FreeUpgrades[MAXPLAYERS + 1];
new Handle:StoreTimeKeys[MAXPLAYERS + 1];
new Handle:StoreTimeValues[MAXPLAYERS + 1];
new Handle:StoreKeys[MAXPLAYERS + 1];
new Handle:StoreValues[MAXPLAYERS + 1];
new Handle:StoreMultiplierKeys[MAXPLAYERS + 1];
new Handle:StoreMultiplierValues[MAXPLAYERS + 1];
new Handle:a_Store_Player[MAXPLAYERS + 1];
new bool:b_IsLoadingTrees[MAXPLAYERS + 1];
new bool:b_IsArraysCreated[MAXPLAYERS + 1];
new Handle:a_Store;
new PlayerUpgradesTotal[MAXPLAYERS + 1];
new Float:f_TankCooldown;
new Float:DeathLocation[MAXPLAYERS + 1][3];
new TimePlayed[MAXPLAYERS + 1];
new bool:b_IsLoading[MAXPLAYERS + 1];
new LastLivingSurvivor;
new Float:f_OriginStart[MAXPLAYERS + 1][3];
new t_Distance[MAXPLAYERS + 1];
new t_Healing[MAXPLAYERS + 1];
new bool:b_IsActiveRound;
new bool:b_IsFirstPluginLoad;
new String:s_rup[32];
new Handle:MainKeys;
new Handle:MainValues;
new Handle:a_Menu_Talents;
new Handle:a_Menu_Main;
new Handle:a_Events;
new Handle:a_Points;
new Handle:a_Pets;
new Handle:a_ClassNames;
new Handle:a_Database_Talents;
new Handle:a_Database_Talents_Defaults;
new Handle:a_Database_Talents_Defaults_Name;
new Handle:MenuKeys[MAXPLAYERS + 1];
new Handle:MenuValues[MAXPLAYERS + 1];
new Handle:MenuSection[MAXPLAYERS + 1];
new Handle:TriggerKeys[MAXPLAYERS + 1];
new Handle:TriggerValues[MAXPLAYERS + 1];
new Handle:TriggerSection[MAXPLAYERS + 1];
new Handle:AbilityKeys[MAXPLAYERS + 1];
new Handle:AbilityValues[MAXPLAYERS + 1];
new Handle:AbilitySection[MAXPLAYERS + 1];
new Handle:ChanceKeys[MAXPLAYERS + 1];
new Handle:ChanceValues[MAXPLAYERS + 1];
new Handle:ChanceSection[MAXPLAYERS + 1];
new Handle:PurchaseKeys[MAXPLAYERS + 1];
new Handle:PurchaseValues[MAXPLAYERS + 1];
new Handle:EventSection;
new Handle:HookSection;
new Handle:CallKeys;
new Handle:CallValues;
//new Handle:CallSection;
new Handle:DirectorKeys;
new Handle:DirectorValues;
//new Handle:DirectorSection;
new Handle:DatabaseKeys;
new Handle:DatabaseValues;
new Handle:DatabaseSection;
new Handle:a_Database_PlayerTalents_Bots;
new Handle:PlayerAbilitiesCooldown_Bots;
new Handle:PlayerAbilitiesImmune_Bots;
new Handle:BotSaveKeys;
new Handle:BotSaveValues;
new Handle:BotSaveSection;
new Handle:LoadDirectorSection;
new Handle:QueryDirectorKeys;
new Handle:QueryDirectorValues;
new Handle:QueryDirectorSection;
new Handle:FirstDirectorKeys;
new Handle:FirstDirectorValues;
new Handle:FirstDirectorSection;
new Handle:a_Database_PlayerTalents[MAXPLAYERS + 1];
new Handle:a_Database_PlayerTalents_Experience[MAXPLAYERS + 1];
new Handle:PlayerAbilitiesName;
new Handle:PlayerAbilitiesCooldown[MAXPLAYERS + 1];
//new Handle:PlayerAbilitiesImmune[MAXPLAYERS + 1][MAXPLAYERS + 1];
new Handle:PlayerInventory[MAXPLAYERS + 1];
new Handle:PlayerEquipped[MAXPLAYERS + 1];
new Handle:a_DirectorActions;
new Handle:a_DirectorActions_Cooldown;
new PlayerLevel[MAXPLAYERS + 1];
new PlayerLevelUpgrades[MAXPLAYERS + 1];
new TotalTalentPoints[MAXPLAYERS + 1];
new ExperienceLevel[MAXPLAYERS + 1];
new SkyPoints[MAXPLAYERS + 1];
new String:MenuSelection[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
new String:MenuSelection_p[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
new String:MenuName_c[MAXPLAYERS + 1][PLATFORM_MAX_PATH];
new Float:Points[MAXPLAYERS + 1];
new DamageAward[MAXPLAYERS + 1][MAXPLAYERS + 1];
new DefaultHealth[MAXPLAYERS + 1];
new String:white[4];
new String:green[4];
new String:blue[4];
new String:orange[4];
new bool:b_IsBlind[MAXPLAYERS + 1];
new bool:b_IsImmune[MAXPLAYERS + 1];
new Float:SpeedMultiplier[MAXPLAYERS + 1];
new Float:SpeedMultiplierBase[MAXPLAYERS + 1];
new bool:b_IsJumping[MAXPLAYERS + 1];
new Handle:g_hEffectAdrenaline = INVALID_HANDLE;
new Handle:g_hCallVomitOnPlayer = INVALID_HANDLE;
new Handle:hRoundRespawn = INVALID_HANDLE;
new Handle:g_hCreateAcid = INVALID_HANDLE;
new Float:GravityBase[MAXPLAYERS + 1];
new bool:b_GroundRequired[MAXPLAYERS + 1];
new CoveredInBile[MAXPLAYERS + 1][MAXPLAYERS + 1];
new CommonKills[MAXPLAYERS + 1];
new CommonKillsHeadshot[MAXPLAYERS + 1];
new String:OpenedMenu_p[MAXPLAYERS + 1][512];
new String:OpenedMenu[MAXPLAYERS + 1][512];
new ExperienceOverall[MAXPLAYERS + 1];
//new String:CurrentTalentLoading_Bots[128];
//new Handle:a_Database_PlayerTalents_Bots;
//new Handle:PlayerAbilitiesCooldown_Bots;				// Because [designation] = ZombieclassID
new ExperienceLevel_Bots;
//new ExperienceOverall_Bots;
//new PlayerLevelUpgrades_Bots;
new PlayerLevel_Bots;
//new TotalTalentPoints_Bots;
new Float:Points_Director;
new Handle:CommonInfectedQueue;
new g_oAbility = 0;
new Handle:g_hSetClass = INVALID_HANDLE;
new Handle:g_hCreateAbility = INVALID_HANDLE;
new Handle:gd = INVALID_HANDLE;
//new Handle:DirectorPurchaseTimer = INVALID_HANDLE;
new bool:b_IsDirectorTalents[MAXPLAYERS + 1];
//new LoadPos_Bots;
new LoadPos[MAXPLAYERS + 1];
new LoadPos_Director;
new Handle:g_Steamgroup;
new Handle:g_Gamemode;
new RoundTime;
new g_iSprite = 0;
new g_BeaconSprite = 0;
//new bool:b_FirstClientLoaded;
new bool:b_HasDeathLocation[MAXPLAYERS + 1];
new bool:b_IsMissionFailed;
new Handle:CCASection;
new Handle:CCAKeys;
new Handle:CCAValues;
new LastWeaponDamage[MAXPLAYERS + 1];
new Float:UseItemTime[MAXPLAYERS + 1];
new Handle:NewUsersRound;
new bool:bIsSoloHandicap;
new Handle:MenuStructure[MAXPLAYERS + 1];
new Handle:TankState_Array[MAXPLAYERS + 1];
new bool:bIsGiveIncapHealth[MAXPLAYERS + 1];
new String:ActiveClass[MAXPLAYERS + 1][64];
new Handle:ClassKeys[MAXPLAYERS + 1];
new Handle:ClassValues[MAXPLAYERS + 1];
new Handle:ClassSection[MAXPLAYERS + 1];
new Handle:TheLeaderboards[MAXPLAYERS + 1];
new Handle:TheLeaderboardsData[MAXPLAYERS + 1];
new TheLeaderboardsPage[MAXPLAYERS + 1];		// 10 entries at a time, until the end of time.
new bool:bIsMyRanking[MAXPLAYERS + 1];
new TheLeaderboardsPageSize[MAXPLAYERS + 1];
new CurrentRPGMode;
new bool:IsSurvivalMode = false;
new BestRating[MAXPLAYERS + 1];
new MyRespawnTarget[MAXPLAYERS + 1];
new bool:RespawnImmunity[MAXPLAYERS + 1];
new String:TheDBPrefix[64];
new LastAttackedUser[MAXPLAYERS + 1];
new Handle:LoggedUsers;
new Handle:TalentTreeKeys[MAXPLAYERS + 1];
new Handle:TalentTreeValues[MAXPLAYERS + 1];
new Handle:TalentExperienceKeys[MAXPLAYERS + 1];
new Handle:TalentExperienceValues[MAXPLAYERS + 1];
new Handle:TalentActionKeys[MAXPLAYERS + 1];
new Handle:TalentActionValues[MAXPLAYERS + 1];
new Handle:TalentActionSection[MAXPLAYERS + 1];
new bool:bIsTalentTwo[MAXPLAYERS + 1];
new Handle:CommonDrawKeys;
new Handle:CommonDrawValues;
new bool:bAutoRevive[MAXPLAYERS + 1];
new bool:bIsClassAbilities[MAXPLAYERS + 1];
new bool:bIsDisconnecting[MAXPLAYERS + 1];
new Handle:LegitClassSection[MAXPLAYERS + 1];
new LoadProfileRequestName[MAXPLAYERS + 1];
//new String:LoadProfileRequest[MAXPLAYERS + 1];
new String:TheCurrentMap[64];
new bool:IsEnrageNotified;
new bool:bIsNewClass[MAXPLAYERS + 1];
new ClientActiveStance[MAXPLAYERS + 1];
new bool:b_RescueIsHere;
new Handle:SurvivorsIgnored[MAXPLAYERS + 1];
new bool:HasSeenCombat[MAXPLAYERS + 1];
new MyBirthday[MAXPLAYERS + 1];
/*

	Main config static variables.
*/
new iSuperCommonLimit;
new Float:fBurnPercentage;
new iTankRush;
new iTanksAlways;
new Float:fSprintSpeed;
new iRPGMode;
new Float:fTankMultiplier;
new iTankPlayerCount;
new DirectorWitchLimit;
new iCommonQueueLimit;
new Float:fDirectorThoughtDelay;
new Float:fDirectorThoughtHandicap;
new iSurvivalRoundTime;
new Float:fDazedDebuffEffect;
new ConsumptionInt;
new Float:fStamSprintInterval;
new Float:fStamRegenTime;
new Float:fStamRegenTimeAdren;
new Float:fBaseMovementSpeed;
new Float:fFatigueMovementSpeed;
new iPlayerStartingLevel;
new Float:fOutOfCombatTime;
new iWitchDamageInitial;
new Float:fWitchDamageScaleLevel;
new Float:fSurvivorDamageBonus;
new iEnrageTime;
new Float:fWitchDirectorPoints;
new Float:fEnrageDirectorPoints;
new Float:fCommonDamageLevel;
new iBotLevelType;
new Float:fCommonDirectorPoints;
new iDisplayHealthBars;
new iMaxDifficultyLevel;
new Float:fDamagePlayerLevel[7];
new Float:fHealthPlayerLevel[7];
new Float:fPointsMultiplierInfected;
new Float:fPointsMultiplier;
new Float:fHealingMultiplier;
new Float:fBuffingMultiplier;
new Float:fHexingMultiplier;
new Float:TanksNearbyRange;
new iCommonAffixes;
new BroadcastType;
new iDoomTimer;
new iSurvivorStaminaMax;
new Float:fRatingMultSpecials;
new Float:fRatingMultSupers;
new Float:fRatingMultCommons;
new Float:fRatingMultTank;
new Float:fTeamworkExperience;
new Float:fItemMultiplierLuck;
new Float:fItemMultiplierTeam;
new String:sQuickBindHelp[64];
new Float:fPointsCostLevel;
new PointPurchaseType;
new iTankLimitVersus;
new Float:fHealRequirementTeam;
new iSurvivorBaseHealth;
new String:spmn[64];
new Float:fHealthSurvivorRevive;
new String:RestrictedWeapons[1024];
new iMaxLevel;
new iExperienceStart;
new Float:fExperienceMultiplier;
new String:sBotTeam[64];
new iActionBarSlots;
new String:MenuCommand[64];
new HostNameTime;
new DoomSUrvivorsRequired;
new DoomKillTimer;
new Float:fVersusTankNotice;
new AllowedCommons;
new AllowedMegaMob;
new AllowedMobSpawn;
new AllowedMobSpawnFinale;
new AllowedPanicInterval;
new RespawnQueue;
new MaximumPriority;
new Float:ConsMult;
new Float:AgilMult;
new Float:ResiMult;
new Float:TechMult;
new Float:EnduMult;
new Float:fUpgradeExpCost;
new iHandicapLevelDifference;
new iWitchHealthBase;
new Float:fWitchHealthMult;
new RatingPerLevel;
new iCommonBaseHealth;
new Float:fCommonRaidHealthMult;
new Float:fCommonLevelHealthMult;
new iServerLevelRequirement;
new iRoundStartWeakness;
new Float:GroupMemberBonus;
new Float:FinSurvBon;
new RaidLevMult;
new iTrailsEnabled;
new iInfectedLimit;
new Float:SurvivorExperienceMult;
new Float:SurvivorExperienceMultTank;
new Float:SurvivorExperienceMultHeal;
new Float:fDamageContribution;
new Float:TheScorchMult;
new Float:TheInfernoMult;
new Float:fAmmoHighlightTime;
new Float:fAdrenProgressMult;
new Float:DirectorTankCooldown;
new DisplayType;
new String:sDirectorTeam[64];
new Float:fRestedExpMult;
new Float:fSurvivorExpMult;
new iIsPvpServer;
new iDebuffLimit;
new iRatingSpecialsRequired;
new iRatingTanksRequired;
new String:sDbLeaderboards[64];
new iIsLifelink;
new RatingPerHandicap;
new Handle:ItemDropArray;
new String:sItemModel[512];
new iSurvivorGroupMinimum;

new Float:fDropChanceSpecial;
new Float:fDropChanceCommon;
new Float:fDropChanceWitch;
new Float:fDropChanceTank;
new Float:fDropChanceInfected;

new Handle:PreloadKeys;
new Handle:PreloadValues;
new Handle:ItemDropKeys;
new Handle:ItemDropValues;
new Handle:ItemDropSection;
new Handle:persistentCirculation;

new iItemExpireDate;
new iRarityMax;
new iEnrageAdvertisement;
new iNotifyEnrage;
new String:sBackpackModel[64];

new String:ItemDropArraySize[64];
new bool:bIsNewPlayer[MAXPLAYERS + 1];

new Handle:MyGroup[MAXPLAYERS + 1];
new iCommonsLimitUpper;
new bool:bIsInCheckpoint[MAXPLAYERS + 1];
new Float:fCoopSurvBon;

public Action:CMD_DropWeapon(client, args) {

	new CurrentEntity			=	GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");

	if (!IsValidEntity(CurrentEntity) || CurrentEntity < 1) return Plugin_Handled;
	decl String:EntityName[64];

	GetEdictClassname(CurrentEntity, EntityName, sizeof(EntityName));
	if (StrContains(EntityName, "melee", false) != -1) return Plugin_Handled;

	new Entity					=	CreateEntityByName(EntityName);
	DispatchSpawn(Entity);

	new Float:Origin[3];
	GetClientAbsOrigin(client, Origin);
	Origin[2] += 64.0;

	TeleportEntity(Entity, Origin, NULL_VECTOR, NULL_VECTOR);
	SetEntityMoveType(Entity, MOVETYPE_VPHYSICS);

	if (GetWeaponSlot(Entity) < 2) SetEntProp(Entity, Prop_Send, "m_iClip1", GetEntProp(CurrentEntity, Prop_Send, "m_iClip1"));
	AcceptEntityInput(CurrentEntity, "Kill");

	return Plugin_Handled;
}

public Action:CMD_IAmStuck(client, args) {

	if (L4D2_GetInfectedAttacker(client) == -1 && !AnyTanksNearby(client, 512.0)) {

		new target = FindAnyRandomClient(true, client);
		if (target > 0) {

			GetClientAbsOrigin(target, Float:DeathLocation[client]);
			TeleportEntity(client, DeathLocation[client], NULL_VECTOR, NULL_VECTOR);
			SetEntityMoveType(client, MOVETYPE_WALK);
		}
	}

	return Plugin_Handled;
}

public Action:CMD_OpenRPGMenu(client, args) {
	
	ClearArray(Handle:MenuStructure[client]);	// keeps track of the open menus.

	VerifyAllActionBars(client);	// Because.
	if (LoadProfileRequestName[client] != -1) {

		if (!IsLegitimateClient(LoadProfileRequestName[client])) LoadProfileRequestName[client] = -1;
	}

	BuildMenu(client, "main");
	//SteamWorks_GetUserGroupStatus(client, 26026802);
	//SaveAndClear(-1, true);
	return Plugin_Handled;
}

/*public Action:CMD_LoadData(client, args) {

	decl String:key[64];
	GetClientAuthString(client, key, sizeof(key));
	ClearAndLoad(key);
	return Plugin_Handled;
}

public Action:CMD_SaveData(client, args) {

	SaveAndClear(client);
	return Plugin_Handled;
}*/

public OnPluginStart() {

	CreateConVar("rum_rpg", PLUGIN_VERSION, "version header", CVAR_SHOW);
	SetConVarString(FindConVar("rum_rpg"), PLUGIN_VERSION);
	CreateConVar("rum_rpg_profile", PROFILE_VERSION, "RPG Profile Editor Module", CVAR_SHOW);
	SetConVarString(FindConVar("rum_rpg_profile"), PROFILE_VERSION);
	CreateConVar("rum_rpg_contact", PLUGIN_CONTACT, "SkyRPG contact", CVAR_SHOW);
	SetConVarString(FindConVar("rum_rpg_contact"), PLUGIN_CONTACT);
	CreateConVar("rum_rpg_url", PLUGIN_URL, "SkyRPG url", CVAR_SHOW);
	SetConVarString(FindConVar("rum_rpg_url"), PLUGIN_URL);

	g_Steamgroup = FindConVar("sv_steamgroup");
	SetConVarFlags(g_Steamgroup, GetConVarFlags(g_Steamgroup) & ~FCVAR_NOTIFY);
	//g_Tags = FindConVar("sv_tags");
	//SetConVarFlags(g_Tags, GetConVarFlags(g_Tags) & ~FCVAR_NOTIFY);
	g_Gamemode = FindConVar("mp_gamemode");

	/*SetConVarFlags(FindConVar("z_common_limit"), GetConVarFlags(FindConVar("z_common_limit")) & ~FCVAR_NOTIFY);
	SetConVarFlags(FindConVar("z_reserved_wanderers"), GetConVarFlags(FindConVar("z_reserved_wanderers")) & ~FCVAR_NOTIFY);
	SetConVarFlags(FindConVar("z_mega_mob_size"), GetConVarFlags(FindConVar("z_mega_mob_size")) & ~FCVAR_NOTIFY);
	SetConVarFlags(FindConVar("z_mob_spawn_max_size"), GetConVarFlags(FindConVar("z_mob_spawn_max_size")) & ~FCVAR_NOTIFY);
	SetConVarFlags(FindConVar("z_mob_spawn_finale_size"), GetConVarFlags(FindConVar("z_mob_spawn_finale_size")) & ~FCVAR_NOTIFY);
	SetConVarFlags(FindConVar("z_mega_mob_spawn_max_interval"), GetConVarFlags(FindConVar("z_mega_mob_spawn_max_interval")) & ~FCVAR_NOTIFY);
	SetConVarFlags(FindConVar("director_no_death_check"), GetConVarFlags(FindConVar("director_no_death_check")) & ~FCVAR_NOTIFY);
	SetConVarFlags(FindConVar("z_tank_health"), GetConVarFlags(FindConVar("z_tank_health")) & ~FCVAR_NOTIFY);
	SetConVarFlags(FindConVar("z_difficulty"), GetConVarFlags(FindConVar("z_difficulty")) & ~FCVAR_NOTIFY);*/

	//LoadTranslations("common.phrases");
	LoadTranslations("skyrpg.phrases");

	BuildPath(Path_SM, ConfigPathDirectory, sizeof(ConfigPathDirectory), "configs/readyup/");
	if (!DirExists(ConfigPathDirectory)) CreateDirectory(ConfigPathDirectory, 777);

	BuildPath(Path_SM, LogPathDirectory, sizeof(LogPathDirectory), "logs/readyup/rpg/");
	if (!DirExists(LogPathDirectory)) CreateDirectory(LogPathDirectory, 777);
	BuildPath(Path_SM, LogPathDirectory, sizeof(LogPathDirectory), "logs/readyup/rpg/%s", LOGFILE);
	if (!FileExists(LogPathDirectory)) SetFailState("[SKYRPG LOGGING] please create file at %s", LogPathDirectory);

	RegAdminCmd("resettpl", Cmd_ResetTPL, ADMFLAG_KICK);
	RegAdminCmd("origin", Cmd_GetOrigin, ADMFLAG_KICK);
	// These are mandatory because of quick commands, so I hardcode the entries.
	RegConsoleCmd("say", CMD_ChatCommand);
	RegConsoleCmd("say_team", CMD_TeamChatCommand);
	RegConsoleCmd("callvote", CMD_BlockVotes);
	RegConsoleCmd("vote", CMD_BlockVotes);
	RegConsoleCmd("talentupgrade", CMD_TalentUpgrade);
	RegConsoleCmd("loadoutname", CMD_LoadoutName);
	RegConsoleCmd("stuck", CMD_IAmStuck);
	RegConsoleCmd("ff", CMD_TogglePvP);
	RegConsoleCmd("revive", CMD_RespawnYumYum);
	RegConsoleCmd("abar", CMD_ActionBar);
	RegConsoleCmd("handicap", CMD_Handicap);

	RegAdminCmd("firesword", CMD_FireSword, ADMFLAG_KICK);
	RegAdminCmd("fbegin", CMD_FBEGIN, ADMFLAG_KICK);
	RegAdminCmd("witches", CMD_WITCHESCOUNT, ADMFLAG_KICK);
	Format(white, sizeof(white), "\x01");
	Format(orange, sizeof(orange), "\x04");
	Format(green, sizeof(green), "\x05");
	Format(blue, sizeof(blue), "\x03");

	gd = LoadGameConfigFile("rum_rpg");
	if (gd != INVALID_HANDLE)
	{		
		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(gd, SDKConf_Signature, "SetClass");
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		g_hSetClass = EndPrepSDKCall();

		StartPrepSDKCall(SDKCall_Static);
		PrepSDKCall_SetFromConf(gd, SDKConf_Signature, "CreateAbility");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
		g_hCreateAbility = EndPrepSDKCall();

		g_oAbility = GameConfGetOffset(gd, "oAbility");

		StartPrepSDKCall(SDKCall_Entity);
		PrepSDKCall_SetFromConf(gd, SDKConf_Signature, "CSpitterProjectile_Detonate");
		g_hCreateAcid = EndPrepSDKCall();

		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(gd, SDKConf_Signature, "CTerrorPlayer_OnAdrenalineUsed");
		PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
		g_hEffectAdrenaline = EndPrepSDKCall();

		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(gd, SDKConf_Signature, "CTerrorPlayer_OnVomitedUpon");
		PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
		PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
		g_hCallVomitOnPlayer = EndPrepSDKCall();

		StartPrepSDKCall(SDKCall_Player);
		PrepSDKCall_SetFromConf(gd, SDKConf_Signature, "RoundRespawn");
		hRoundRespawn = EndPrepSDKCall();
	}
	else {

		SetFailState("Error: Unable to load Gamedata rum_rpg.txt");
	}
	CheckDifficulty();
}

public Action:CMD_WITCHESCOUNT(client, args) {

	PrintToChat(client, "Witches: %d", GetArraySize(WitchList));
	return Plugin_Handled;
}

public Action:CMD_FBEGIN(client, args) {

	ReadyUpEnd_Complete();
}

public Action:Cmd_GetOrigin(client, args) {

	new Float:OriginP[3];
	GetClientAbsOrigin(client, OriginP);
	PrintToChat(client, "[0] %3.3f [1] %3.3f [2] %3.3f", OriginP[0], OriginP[1], OriginP[2]);
	return Plugin_Handled;
}

public Action:CMD_BlockVotes(client, args) {



	return Plugin_Handled;
}

public ReadyUp_GetMaxSurvivorCount(count) {

	if (count <= 1) bIsSoloHandicap = true;
	else bIsSoloHandicap = false;
}

stock UnhookAll() {

	for (new i = 1; i <= MaxClients; i++) {

		if (IsLegitimateClient(i)) {

			SDKUnhook(i, SDKHook_OnTakeDamage, OnTakeDamage);
			b_IsHooked[i] = false;
		}
	}
}

public ReadyUp_TrueDisconnect(client) {

	if (bIsInCombat[client]) IncapacitateOrKill(client, _, _, true, true, true);

	//ChangeHook(client);

	DisplayActionBar[client] = false;
	IsPvP[client] = 0;
	b_IsFloating[client] = false;
	b_IsLoading[client] = false;
	b_HardcoreMode[client] = false;
	//WipeDebuffs(_, client, true);
	SaveAndClear(client, true);
	IsPlayerDebugMode[client] = 0;
	CleanseStack[client] = 0;
	CounterStack[client] = 0.0;
	MultiplierStack[client] = 0;
	LoadTarget[client] = -1;
	b_IsLoaded[client] = false;		// only set to false if a REAL player leaves - this way bots don't repeatedly load their data.
	Format(ClassLoadQueue[client], sizeof(ClassLoadQueue[]), "none");
	Format(ProfileLoadQueue[client], sizeof(ProfileLoadQueue[]), "none");
	Format(BuildingStack[client], sizeof(BuildingStack[]), "none");
	Format(LoadoutName[client], sizeof(LoadoutName[]), "none");

	//CreateTimer(1.0, Timer_RemoveSaveSafety, client, TIMER_FLAG_NO_MAPCHANGE);
	bIsSettingsCheck = true;
}

/*public ReadyUp_FwdChangeTeam(client, team) {

	if (team == TEAM_SPECTATOR) {

		if (bIsInCombat[client]) {

			IncapacitateOrKill(client, _, _, true, true);
		}

		b_IsHooked[client] = false;
		SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	}
	else if (team == TEAM_SURVIVOR && !b_IsHooked[client]) {

		b_IsHooked[client] = true;
		SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	}
}*/

//stock LoadConfigValues() {

//}



public OnAllPluginsLoaded() {

	OnMapStartFunc();
	CheckDifficulty();
}

stock OnMapStartFunc() {

	if (!b_MapStart) {
		
		b_MapStart								= true;

		//LoadConfigValues();
		LogMessage("=====\t\tLOADING RPG\t\t=====");

		if (a_ClassNames == INVALID_HANDLE || !b_FirstLoad) a_ClassNames = CreateArray(32);
		if (LoggedUsers == INVALID_HANDLE || !b_FirstLoad) LoggedUsers = CreateArray(32);
		if (SuperCommonQueue == INVALID_HANDLE || !b_FirstLoad) SuperCommonQueue = CreateArray(32);
		if (CommonInfectedQueue == INVALID_HANDLE || !b_FirstLoad) CommonInfectedQueue = CreateArray(32);
		if (CoveredInVomit == INVALID_HANDLE || !b_FirstLoad) CoveredInVomit = CreateArray(32);
		if (NewUsersRound == INVALID_HANDLE || !b_FirstLoad) NewUsersRound = CreateArray(32);
		if (SpecialAmmoData == INVALID_HANDLE || !b_FirstLoad) SpecialAmmoData = CreateArray(32);
		if (SpecialAmmoSave == INVALID_HANDLE || !b_FirstLoad) SpecialAmmoSave = CreateArray(32);
		if (MainKeys == INVALID_HANDLE || !b_FirstLoad) MainKeys = CreateArray(32);
		if (MainValues == INVALID_HANDLE || !b_FirstLoad) MainValues = CreateArray(32);
		if (a_Menu_Talents == INVALID_HANDLE || !b_FirstLoad) a_Menu_Talents = CreateArray(3);
		if (a_Menu_Main == INVALID_HANDLE || !b_FirstLoad) a_Menu_Main = CreateArray(3);
		if (a_Events == INVALID_HANDLE || !b_FirstLoad) a_Events = CreateArray(3);
		if (a_Points == INVALID_HANDLE || !b_FirstLoad) a_Points = CreateArray(3);
		if (a_Pets == INVALID_HANDLE || !b_FirstLoad) a_Pets = CreateArray(3);
		if (a_Store == INVALID_HANDLE || !b_FirstLoad) a_Store = CreateArray(3);
		if (a_Trails == INVALID_HANDLE || !b_FirstLoad) a_Trails = CreateArray(3);
		if (a_Database_Talents == INVALID_HANDLE || !b_FirstLoad) a_Database_Talents = CreateArray(32);
		if (a_Database_Talents_Defaults == INVALID_HANDLE || !b_FirstLoad) a_Database_Talents_Defaults 	= CreateArray(32);
		if (a_Database_Talents_Defaults_Name == INVALID_HANDLE || !b_FirstLoad) a_Database_Talents_Defaults_Name				= CreateArray(32);
		if (EventSection == INVALID_HANDLE || !b_FirstLoad) EventSection									= CreateArray(32);
		if (HookSection == INVALID_HANDLE || !b_FirstLoad) HookSection										= CreateArray(32);
		if (CallKeys == INVALID_HANDLE || !b_FirstLoad) CallKeys										= CreateArray(32);
		if (CallValues == INVALID_HANDLE || !b_FirstLoad) CallValues										= CreateArray(32);
		if (DirectorKeys == INVALID_HANDLE || !b_FirstLoad) DirectorKeys									= CreateArray(32);
		if (DirectorValues == INVALID_HANDLE || !b_FirstLoad) DirectorValues									= CreateArray(32);
		if (DatabaseKeys == INVALID_HANDLE || !b_FirstLoad) DatabaseKeys									= CreateArray(32);
		if (DatabaseValues == INVALID_HANDLE || !b_FirstLoad) DatabaseValues									= CreateArray(32);
		if (DatabaseSection == INVALID_HANDLE || !b_FirstLoad) DatabaseSection									= CreateArray(32);
		if (a_Database_PlayerTalents_Bots == INVALID_HANDLE || !b_FirstLoad) a_Database_PlayerTalents_Bots					= CreateArray(32);
		if (PlayerAbilitiesCooldown_Bots == INVALID_HANDLE || !b_FirstLoad) PlayerAbilitiesCooldown_Bots					= CreateArray(32);
		if (PlayerAbilitiesImmune_Bots == INVALID_HANDLE || !b_FirstLoad) PlayerAbilitiesImmune_Bots						= CreateArray(32);
		if (BotSaveKeys == INVALID_HANDLE || !b_FirstLoad) BotSaveKeys										= CreateArray(32);
		if (BotSaveValues == INVALID_HANDLE || !b_FirstLoad) BotSaveValues									= CreateArray(32);
		if (BotSaveSection == INVALID_HANDLE || !b_FirstLoad) BotSaveSection									= CreateArray(32);
		if (LoadDirectorSection == INVALID_HANDLE || !b_FirstLoad) LoadDirectorSection								= CreateArray(32);
		if (QueryDirectorKeys == INVALID_HANDLE || !b_FirstLoad) QueryDirectorKeys								= CreateArray(32);
		if (QueryDirectorValues == INVALID_HANDLE || !b_FirstLoad) QueryDirectorValues								= CreateArray(32);
		if (QueryDirectorSection == INVALID_HANDLE || !b_FirstLoad) QueryDirectorSection							= CreateArray(32);
		if (FirstDirectorKeys == INVALID_HANDLE || !b_FirstLoad) FirstDirectorKeys								= CreateArray(32);
		if (FirstDirectorValues == INVALID_HANDLE || !b_FirstLoad) FirstDirectorValues								= CreateArray(32);
		if (FirstDirectorSection == INVALID_HANDLE || !b_FirstLoad) FirstDirectorSection							= CreateArray(32);
		if (PlayerAbilitiesName == INVALID_HANDLE || !b_FirstLoad) PlayerAbilitiesName								= CreateArray(32);
		if (a_DirectorActions == INVALID_HANDLE || !b_FirstLoad) a_DirectorActions								= CreateArray(3);
		if (a_DirectorActions_Cooldown == INVALID_HANDLE || !b_FirstLoad) a_DirectorActions_Cooldown						= CreateArray(32);
		if (a_ChatSettings == INVALID_HANDLE || !b_FirstLoad) a_ChatSettings								= CreateArray(3);
		if (LockedTalentKeys == INVALID_HANDLE || !b_FirstLoad) LockedTalentKeys							= CreateArray(32);
		if (LockedTalentValues == INVALID_HANDLE || !b_FirstLoad) LockedTalentValues						= CreateArray(32);
		if (LockedTalentSection == INVALID_HANDLE || !b_FirstLoad) LockedTalentSection						= CreateArray(32);
		if (Give_Store_Keys == INVALID_HANDLE || !b_FirstLoad) Give_Store_Keys							= CreateArray(32);
		if (Give_Store_Values == INVALID_HANDLE || !b_FirstLoad) Give_Store_Values							= CreateArray(32);
		if (Give_Store_Section == INVALID_HANDLE || !b_FirstLoad) Give_Store_Section							= CreateArray(32);
		if (a_WeaponDamages == INVALID_HANDLE || !b_FirstLoad) a_WeaponDamages = CreateArray(32);
		if (a_CommonAffixes == INVALID_HANDLE || !b_FirstLoad) a_CommonAffixes = CreateArray(32);
		if (CommonList == INVALID_HANDLE || !b_FirstLoad) CommonList = CreateArray(32);
		if (WitchList == INVALID_HANDLE || !b_FirstLoad) WitchList				= CreateArray(32);
		if (CommonAffixes == INVALID_HANDLE || !b_FirstLoad) CommonAffixes	= CreateArray(32);
		if (h_CAKeys == INVALID_HANDLE || !b_FirstLoad) h_CAKeys = CreateArray(32);
		if (h_CAValues == INVALID_HANDLE || !b_FirstLoad) h_CAValues = CreateArray(32);
		if (SearchKey_Section == INVALID_HANDLE || !b_FirstLoad) SearchKey_Section = CreateArray(32);
		if (CCASection == INVALID_HANDLE || !b_FirstLoad) CCASection = CreateArray(32);
		if (CCAKeys == INVALID_HANDLE || !b_FirstLoad) CCAKeys = CreateArray(32);
		if (CCAValues == INVALID_HANDLE || !b_FirstLoad) CCAValues = CreateArray(32);
		if (h_CommonKeys == INVALID_HANDLE || !b_FirstLoad) h_CommonKeys = CreateArray(32);
		if (h_CommonValues == INVALID_HANDLE || !b_FirstLoad) h_CommonValues = CreateArray(32);
		if (CommonInfected == INVALID_HANDLE || !b_FirstLoad) CommonInfected = CreateArray(32);
		if (EntityOnFire == INVALID_HANDLE || !b_FirstLoad) EntityOnFire = CreateArray(32);
		if (CommonDrawKeys == INVALID_HANDLE || !b_FirstLoad) CommonDrawKeys = CreateArray(32);
		if (CommonDrawValues == INVALID_HANDLE || !b_FirstLoad) CommonDrawValues = CreateArray(32);
		if (ItemDropArray == INVALID_HANDLE || !b_FirstLoad) ItemDropArray = CreateArray(32);
		
		if (PreloadKeys == INVALID_HANDLE || !b_FirstLoad) PreloadKeys = CreateArray(32);
		if (PreloadValues == INVALID_HANDLE || !b_FirstLoad) PreloadValues = CreateArray(32);
		if (ItemDropKeys == INVALID_HANDLE || !b_FirstLoad) ItemDropKeys = CreateArray(32);
		if (ItemDropValues == INVALID_HANDLE || !b_FirstLoad) ItemDropValues = CreateArray(32);
		if (ItemDropSection == INVALID_HANDLE || !b_FirstLoad) ItemDropSection = CreateArray(32);
		if (persistentCirculation == INVALID_HANDLE || !b_FirstLoad) persistentCirculation = CreateArray(32);
		if (RandomSurvivorClient == INVALID_HANDLE || !b_FirstLoad) RandomSurvivorClient = CreateArray(32);
		if (RoundStatistics == INVALID_HANDLE || !b_FirstLoad) RoundStatistics = CreateArray(16);

		for (new i = 1; i <= MAXPLAYERS; i++) {

			LastDeathTime[i] = 0.0;
			MyVomitChase[i] = -1;
			b_IsFloating[i] = false;
			DisplayActionBar[i] = false;
			ActionBarSlot[i] = -1;

			if (AbilityConfigKeys[i] == INVALID_HANDLE || !b_FirstLoad) AbilityConfigKeys[i] = CreateArray(32);
			if (AbilityConfigValues[i] == INVALID_HANDLE || !b_FirstLoad) AbilityConfigValues[i] = CreateArray(32);
			if (AbilityConfigSection[i] == INVALID_HANDLE || !b_FirstLoad) AbilityConfigSection[i] = CreateArray(32);
			if (GetAbilityKeys[i] == INVALID_HANDLE || !b_FirstLoad) GetAbilityKeys[i] = CreateArray(32);
			if (GetAbilityValues[i] == INVALID_HANDLE || !b_FirstLoad) GetAbilityValues[i] = CreateArray(32);
			if (GetAbilitySection[i] == INVALID_HANDLE || !b_FirstLoad) GetAbilitySection[i] = CreateArray(32);
			if (IsAbilityKeys[i] == INVALID_HANDLE || !b_FirstLoad) IsAbilityKeys[i] = CreateArray(32);
			if (IsAbilityValues[i] == INVALID_HANDLE || !b_FirstLoad) IsAbilityValues[i] = CreateArray(32);
			if (IsAbilitySection[i] == INVALID_HANDLE || !b_FirstLoad) IsAbilitySection[i] = CreateArray(32);
			if (CheckAbilityKeys[i] == INVALID_HANDLE || !b_FirstLoad) CheckAbilityKeys[i] = CreateArray(32);
			if (CheckAbilityValues[i] == INVALID_HANDLE || !b_FirstLoad) CheckAbilityValues[i] = CreateArray(32);
			if (GetTalentStrengthKeys[i] == INVALID_HANDLE || !b_FirstLoad) GetTalentStrengthKeys[i] = CreateArray(32);
			if (GetTalentStrengthValues[i] == INVALID_HANDLE || !b_FirstLoad) GetTalentStrengthValues[i] = CreateArray(32);
			if (CastKeys[i] == INVALID_HANDLE || !b_FirstLoad) CastKeys[i] = CreateArray(32);
			if (CastValues[i] == INVALID_HANDLE || !b_FirstLoad) CastValues[i] = CreateArray(32);
			if (CastSection[i] == INVALID_HANDLE || !b_FirstLoad) CastSection[i] = CreateArray(32);
			if (ActionBar[i] == INVALID_HANDLE || !b_FirstLoad) ActionBar[i] = CreateArray(32);
			if (TalentsAssignedKeys[i] == INVALID_HANDLE || !b_FirstLoad) TalentsAssignedKeys[i] = CreateArray(32);
			if (TalentsAssignedValues[i] == INVALID_HANDLE || !b_FirstLoad) TalentsAssignedValues[i] = CreateArray(32);
			if (CartelValueKeys[i] == INVALID_HANDLE || !b_FirstLoad) CartelValueKeys[i] = CreateArray(32);
			if (CartelValueValues[i] == INVALID_HANDLE || !b_FirstLoad) CartelValueValues[i] = CreateArray(32);
			if (LegitClassSection[i] == INVALID_HANDLE || !b_FirstLoad) LegitClassSection[i] = CreateArray(32);
			if (TalentActionKeys[i] == INVALID_HANDLE || !b_FirstLoad) TalentActionKeys[i] = CreateArray(32);
			if (TalentActionValues[i] == INVALID_HANDLE || !b_FirstLoad) TalentActionValues[i] = CreateArray(32);
			if (TalentActionSection[i] == INVALID_HANDLE || !b_FirstLoad) TalentActionSection[i] = CreateArray(32);
			if (TalentExperienceKeys[i] == INVALID_HANDLE || !b_FirstLoad) TalentExperienceKeys[i] = CreateArray(32);
			if (TalentExperienceValues[i] == INVALID_HANDLE || !b_FirstLoad) TalentExperienceValues[i] = CreateArray(32);
			if (TalentTreeKeys[i] == INVALID_HANDLE || !b_FirstLoad) TalentTreeKeys[i] = CreateArray(32);
			if (TalentTreeValues[i] == INVALID_HANDLE || !b_FirstLoad) TalentTreeValues[i] = CreateArray(32);
			if (TheLeaderboards[i] == INVALID_HANDLE || !b_FirstLoad) TheLeaderboards[i] = CreateArray(32);
			if (TheLeaderboardsData[i] == INVALID_HANDLE || !b_FirstLoad) TheLeaderboardsData[i] = CreateArray(32);
			if (TankState_Array[i] == INVALID_HANDLE || !b_FirstLoad) TankState_Array[i] = CreateArray(32);
			if (PlayerInventory[i] == INVALID_HANDLE || !b_FirstLoad) PlayerInventory[i] = CreateArray(32);
			if (PlayerEquipped[i] == INVALID_HANDLE || !b_FirstLoad) PlayerEquipped[i] = CreateArray(32);
			if (MenuStructure[i] == INVALID_HANDLE || !b_FirstLoad) MenuStructure[i] = CreateArray(32);
			if (TempAttributes[i] == INVALID_HANDLE || !b_FirstLoad) TempAttributes[i] = CreateArray(32);
			if (TempTalents[i] == INVALID_HANDLE || !b_FirstLoad) TempTalents[i] = CreateArray(32);
			if (PlayerProfiles[i] == INVALID_HANDLE || !b_FirstLoad) PlayerProfiles[i] = CreateArray(32);
			if (SpecialAmmoEffectKeys[i] == INVALID_HANDLE || !b_FirstLoad) SpecialAmmoEffectKeys[i] = CreateArray(32);
			if (SpecialAmmoEffectValues[i] == INVALID_HANDLE || !b_FirstLoad) SpecialAmmoEffectValues[i] = CreateArray(32);
			if (ActiveAmmoCooldownKeys[i] == INVALID_HANDLE || !b_FirstLoad) ActiveAmmoCooldownKeys[i] = CreateArray(32);
			if (ActiveAmmoCooldownValues[i] == INVALID_HANDLE || !b_FirstLoad) ActiveAmmoCooldownValues[i] = CreateArray(32);
			if (PlayActiveAbilities[i] == INVALID_HANDLE || !b_FirstLoad) PlayActiveAbilities[i] = CreateArray(32);
			if (PlayerActiveAmmo[i] == INVALID_HANDLE || !b_FirstLoad) PlayerActiveAmmo[i] = CreateArray(32);
			if (SpecialAmmoKeys[i] == INVALID_HANDLE || !b_FirstLoad) SpecialAmmoKeys[i] = CreateArray(32);
			if (SpecialAmmoValues[i] == INVALID_HANDLE || !b_FirstLoad) SpecialAmmoValues[i] = CreateArray(32);
			if (SpecialAmmoSection[i] == INVALID_HANDLE || !b_FirstLoad) SpecialAmmoSection[i] = CreateArray(32);
			if (DrawSpecialAmmoKeys[i] == INVALID_HANDLE || !b_FirstLoad) DrawSpecialAmmoKeys[i] = CreateArray(32);
			if (DrawSpecialAmmoValues[i] == INVALID_HANDLE || !b_FirstLoad) DrawSpecialAmmoValues[i] = CreateArray(32);
			if (SpecialAmmoStrengthKeys[i] == INVALID_HANDLE || !b_FirstLoad) SpecialAmmoStrengthKeys[i] = CreateArray(32);
			if (SpecialAmmoStrengthValues[i] == INVALID_HANDLE || !b_FirstLoad) SpecialAmmoStrengthValues[i] = CreateArray(32);
			if (WeaponLevel[i] == INVALID_HANDLE || !b_FirstLoad) WeaponLevel[i] = CreateArray(32);
			if (ExperienceBank[i] == INVALID_HANDLE || !b_FirstLoad) ExperienceBank[i] = CreateArray(32);
			if (MenuPosition[i] == INVALID_HANDLE || !b_FirstLoad) MenuPosition[i] = CreateArray(32);
			if (IsClientInRangeSAKeys[i] == INVALID_HANDLE || !b_FirstLoad) IsClientInRangeSAKeys[i] = CreateArray(32);
			if (IsClientInRangeSAValues[i] == INVALID_HANDLE || !b_FirstLoad) IsClientInRangeSAValues[i] = CreateArray(32);
			if (CommonInfectedDamage[i] == INVALID_HANDLE || !b_FirstLoad) CommonInfectedDamage[i] = CreateArray(32);
			if (InfectedAuraKeys[i] == INVALID_HANDLE || !b_FirstLoad) InfectedAuraKeys[i] = CreateArray(32);
			if (InfectedAuraValues[i] == INVALID_HANDLE || !b_FirstLoad) InfectedAuraValues[i] = CreateArray(32);
			if (InfectedAuraSection[i] == INVALID_HANDLE || !b_FirstLoad) InfectedAuraSection[i] = CreateArray(32);
			if (TalentUpgradeKeys[i] == INVALID_HANDLE || !b_FirstLoad) TalentUpgradeKeys[i] = CreateArray(32);
			if (TalentUpgradeValues[i] == INVALID_HANDLE || !b_FirstLoad) TalentUpgradeValues[i] = CreateArray(32);
			if (TalentUpgradeSection[i] == INVALID_HANDLE || !b_FirstLoad) TalentUpgradeSection[i] = CreateArray(32);
			if (InfectedHealth[i] == INVALID_HANDLE || 	!b_FirstLoad) InfectedHealth[i] = CreateArray(32);
			if (WitchDamage[i] == INVALID_HANDLE || !b_FirstLoad) WitchDamage[i]	= CreateArray(32);
			if (SpecialCommon[i] == INVALID_HANDLE || !b_FirstLoad) SpecialCommon[i] = CreateArray(32);
			if (MenuKeys[i] == INVALID_HANDLE || !b_FirstLoad) MenuKeys[i]								= CreateArray(32);
			if (MenuValues[i] == INVALID_HANDLE || !b_FirstLoad) MenuValues[i]							= CreateArray(32);
			if (MenuSection[i] == INVALID_HANDLE || !b_FirstLoad) MenuSection[i]							= CreateArray(32);
			if (TriggerKeys[i] == INVALID_HANDLE || !b_FirstLoad) TriggerKeys[i]							= CreateArray(32);
			if (TriggerValues[i] == INVALID_HANDLE || !b_FirstLoad) TriggerValues[i]						= CreateArray(32);
			if (TriggerSection[i] == INVALID_HANDLE || !b_FirstLoad) TriggerSection[i]						= CreateArray(32);
			if (AbilityKeys[i] == INVALID_HANDLE || !b_FirstLoad) AbilityKeys[i]							= CreateArray(32);
			if (AbilityValues[i] == INVALID_HANDLE || !b_FirstLoad) AbilityValues[i]						= CreateArray(32);
			if (AbilitySection[i] == INVALID_HANDLE || !b_FirstLoad) AbilitySection[i]						= CreateArray(32);
			if (ChanceKeys[i] == INVALID_HANDLE || !b_FirstLoad) ChanceKeys[i]							= CreateArray(32);
			if (ChanceValues[i] == INVALID_HANDLE || !b_FirstLoad) ChanceValues[i]							= CreateArray(32);
			if (PurchaseKeys[i] == INVALID_HANDLE || !b_FirstLoad) PurchaseKeys[i]						= CreateArray(32);
			if (PurchaseValues[i] == INVALID_HANDLE || !b_FirstLoad) PurchaseValues[i]						= CreateArray(32);
			if (ChanceSection[i] == INVALID_HANDLE || !b_FirstLoad) ChanceSection[i]						= CreateArray(32);
			if (a_Database_PlayerTalents[i] == INVALID_HANDLE || !b_FirstLoad) a_Database_PlayerTalents[i]				= CreateArray(32);
			if (a_Database_PlayerTalents_Experience[i] == INVALID_HANDLE || !b_FirstLoad) a_Database_PlayerTalents_Experience[i] = CreateArray(32);
			if (PlayerAbilitiesCooldown[i] == INVALID_HANDLE || !b_FirstLoad) PlayerAbilitiesCooldown[i]				= CreateArray(32);
			/*if (PlayerAbilitiesImmune[i][i] == INVALID_HANDLE || !b_FirstLoad) {	//[i][i] will NEVER be occupied.

				for (new y = 0; y <= MAXPLAYERS; y++) PlayerAbilitiesImmune[i][y]				= CreateArray(32);
			}*/

			if (a_Store_Player[i] == INVALID_HANDLE || !b_FirstLoad) a_Store_Player[i]						= CreateArray(32);
			if (StoreKeys[i] == INVALID_HANDLE || !b_FirstLoad) StoreKeys[i]							= CreateArray(32);
			if (StoreValues[i] == INVALID_HANDLE || !b_FirstLoad) StoreValues[i]							= CreateArray(32);
			if (StoreMultiplierKeys[i] == INVALID_HANDLE || !b_FirstLoad) StoreMultiplierKeys[i]					= CreateArray(32);
			if (StoreMultiplierValues[i] == INVALID_HANDLE || !b_FirstLoad) StoreMultiplierValues[i]				= CreateArray(32);
			if (StoreTimeKeys[i] == INVALID_HANDLE || !b_FirstLoad) StoreTimeKeys[i]						= CreateArray(32);
			if (StoreTimeValues[i] == INVALID_HANDLE || !b_FirstLoad) StoreTimeValues[i]						= CreateArray(32);
			if (LoadStoreSection[i] == INVALID_HANDLE || !b_FirstLoad) LoadStoreSection[i]						= CreateArray(32);
			if (SaveSection[i] == INVALID_HANDLE || !b_FirstLoad) SaveSection[i]							= CreateArray(32);
			if (StoreChanceKeys[i] == INVALID_HANDLE || !b_FirstLoad) StoreChanceKeys[i]						= CreateArray(32);
			if (StoreChanceValues[i] == INVALID_HANDLE || !b_FirstLoad) StoreChanceValues[i]					= CreateArray(32);
			if (StoreItemNameSection[i] == INVALID_HANDLE || !b_FirstLoad) StoreItemNameSection[i]					= CreateArray(32);
			if (StoreItemSection[i] == INVALID_HANDLE || !b_FirstLoad) StoreItemSection[i]						= CreateArray(32);
			if (TrailsKeys[i] == INVALID_HANDLE || !b_FirstLoad) TrailsKeys[i]							= CreateArray(32);
			if (TrailsValues[i] == INVALID_HANDLE || !b_FirstLoad) TrailsValues[i]							= CreateArray(32);
			if (DamageKeys[i] == INVALID_HANDLE || !b_FirstLoad) DamageKeys[i]						= CreateArray(32);
			if (DamageValues[i] == INVALID_HANDLE || !b_FirstLoad) DamageValues[i]					= CreateArray(32);
			if (DamageSection[i] == INVALID_HANDLE || !b_FirstLoad) DamageSection[i]				= CreateArray(32);
			if (MOTKeys[i] == INVALID_HANDLE || !b_FirstLoad) MOTKeys[i] = CreateArray(32);
			if (MOTValues[i] == INVALID_HANDLE || !b_FirstLoad) MOTValues[i] = CreateArray(32);
			if (MOTSection[i] == INVALID_HANDLE || !b_FirstLoad) MOTSection[i] = CreateArray(32);
			if (BoosterKeys[i] == INVALID_HANDLE || !b_FirstLoad) BoosterKeys[i]							= CreateArray(32);
			if (BoosterValues[i] == INVALID_HANDLE || !b_FirstLoad) BoosterValues[i]						= CreateArray(32);
			if (RPGMenuPosition[i] == INVALID_HANDLE || !b_FirstLoad) RPGMenuPosition[i]						= CreateArray(32);
			if (ChatSettings[i] == INVALID_HANDLE || !b_FirstLoad) ChatSettings[i]						= CreateArray(32);
			if (h_KilledPosition_X[i] == INVALID_HANDLE || !b_FirstLoad) h_KilledPosition_X[i]				= CreateArray(32);
			if (h_KilledPosition_Y[i] == INVALID_HANDLE || !b_FirstLoad) h_KilledPosition_Y[i]				= CreateArray(32);
			if (h_KilledPosition_Z[i] == INVALID_HANDLE || !b_FirstLoad) h_KilledPosition_Z[i]				= CreateArray(32);
			if (MeleeKeys[i] == INVALID_HANDLE || !b_FirstLoad) MeleeKeys[i]						= CreateArray(32);
			if (MeleeValues[i] == INVALID_HANDLE || !b_FirstLoad) MeleeValues[i]					= CreateArray(32);
			if (MeleeSection[i] == INVALID_HANDLE || !b_FirstLoad) MeleeSection[i]					= CreateArray(32);
			if (CommonAffixesCooldown[i] == INVALID_HANDLE || !b_FirstLoad) CommonAffixesCooldown[i] = CreateArray(32);
			if (RCAffixes[i] == INVALID_HANDLE || !b_FirstLoad) RCAffixes[i] = CreateArray(32);
			if (AKKeys[i] == INVALID_HANDLE || !b_FirstLoad) AKKeys[i]						= CreateArray(32);
			if (AKValues[i] == INVALID_HANDLE || !b_FirstLoad) AKValues[i]					= CreateArray(32);
			if (AKSection[i] == INVALID_HANDLE || !b_FirstLoad) AKSection[i]					= CreateArray(32);
			if (ClassKeys[i] == INVALID_HANDLE || !b_FirstLoad) ClassKeys[i]			= CreateArray(32);
			if (ClassValues[i] == INVALID_HANDLE || !b_FirstLoad) ClassValues[i]		= CreateArray(32);
			if (ClassSection[i] == INVALID_HANDLE || !b_FirstLoad) ClassSection[i]		= CreateArray(32);
			if (SurvivorsIgnored[i] == INVALID_HANDLE || !b_FirstLoad) SurvivorsIgnored[i] = CreateArray(32);
			if (MyGroup[i] == INVALID_HANDLE || !b_FirstLoad) MyGroup[i] = CreateArray(32);
			//ResetValues(i);
		}

		if (!b_FirstLoad) b_FirstLoad = true;
		//LogMessage("AWAITING PARAMETERS");

		if (!b_ConfigsExecuted) {

			b_ConfigsExecuted = true;
			CreateTimer(1.0, Timer_ExecuteConfig, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			CreateTimer(10.0, Timer_GetCampaignName, _, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	ReadyUp_NtvIsCampaignFinale();
}

public ReadyUp_GetCampaignStatus(mapposition) {

	CurrentMapPosition = mapposition;
}

public OnMapStart() {

	// When the server restarts, for any reason, RPG will properly load.
	//if (!b_FirstLoad) OnMapStartFunc();
	// This can call more than once, and we only want it to fire once.
	// The variable resets to false when a map ends.
	PrecacheModel("models/infected/common_male_riot.mdl", true);
	PrecacheModel("models/infected/common_male_mud.mdl", true);
	PrecacheModel("models/infected/common_male_jimmy.mdl", true);
	PrecacheModel("models/infected/common_male_roadcrew.mdl", true);
	PrecacheModel("models/infected/witch_bride.mdl", true);
	PrecacheModel("models/infected/witch.mdl", true);
	PrecacheModel("models/props_interiors/toaster.mdl", true);
	PrecacheSound(JETPACK_AUDIO, true);



	g_iSprite = PrecacheModel("materials/sprites/laserbeam.vmt");
	g_BeaconSprite = PrecacheModel("materials/sprites/halo01.vmt");

	b_IsActiveRound = false;
	MapRoundsPlayed = 0;

	b_IsCampaignComplete			= false;
	b_IsRoundIsOver					= true;
	b_IsCheckpointDoorStartOpened	= false;
	b_IsMissionFailed				= false;

	GetCurrentMap(TheCurrentMap, sizeof(TheCurrentMap));
	Format(CONFIG_MAIN, sizeof(CONFIG_MAIN), "%srpg/%s.cfg", ConfigPathDirectory, TheCurrentMap);
	//LogMessage("CONFIG_MAIN DEFAULT: %s", CONFIG_MAIN);
	if (!FileExists(CONFIG_MAIN)) Format(CONFIG_MAIN, sizeof(CONFIG_MAIN), "rpg/config.cfg");
	else Format(CONFIG_MAIN, sizeof(CONFIG_MAIN), "rpg/%s.cfg", TheCurrentMap);

	SetConVarInt(FindConVar("director_no_death_check"), 1);
	SetConVarInt(FindConVar("sv_rescue_disabled"), 0);
	SetConVarInt(FindConVar("z_common_limit"), 0);	// there are no commons until the round starts in all game modes to give players a chance to move.

	CheckDifficulty();
	UnhookAll();
}

stock ResetValues(client) {

	// Yep, gotta do this *properly*
	b_HasDeathLocation[client] = false;
}

public OnMapEnd() {

	ClearArray(Handle:NewUsersRound);
}

public Action:Timer_GetCampaignName(Handle:timer) {

	ReadyUp_NtvGetCampaignName();
	return Plugin_Stop;
}

public OnConfigsExecuted() {

	if (!b_ConfigsExecuted) {

		b_ConfigsExecuted = true;
		CreateTimer(1.0, Timer_ExecuteConfig, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer(10.0, Timer_GetCampaignName, _, TIMER_FLAG_NO_MAPCHANGE);
	}
}

stock CheckGamemode() {

	decl String:TheGamemode[64];
	GetConVarString(g_Gamemode, TheGamemode, sizeof(TheGamemode));
	decl String:TheRequiredGamemode[64];
	GetConfigValue(TheRequiredGamemode, sizeof(TheRequiredGamemode), "gametype?");
	if (!StrEqual(TheGamemode, TheRequiredGamemode, false)) {

		LogMessage("Gamemode did not match, changing to %s", TheRequiredGamemode);
		SetConVarString(g_Gamemode, TheRequiredGamemode);
		decl String:TheMapname[64];
		GetCurrentMap(TheMapname, sizeof(TheMapname));
		ServerCommand("changelevel %s", TheMapname);
	}
}

public Action:Timer_ExecuteConfig(Handle:timer) {

	if (ReadyUp_NtvConfigProcessing() == 0) {

		ReadyUp_ParseConfig(CONFIG_MAIN);
		ReadyUp_ParseConfig(CONFIG_EVENTS);
		ReadyUp_ParseConfig(CONFIG_MENUTALENTS);
		ReadyUp_ParseConfig(CONFIG_POINTS);
		ReadyUp_ParseConfig(CONFIG_STORE);
		ReadyUp_ParseConfig(CONFIG_TRAILS);
		ReadyUp_ParseConfig(CONFIG_CHATSETTINGS);
		ReadyUp_ParseConfig(CONFIG_MAINMENU);
		ReadyUp_ParseConfig(CONFIG_WEAPONS);
		ReadyUp_ParseConfig(CONFIG_PETS);
		ReadyUp_ParseConfig(CONFIG_COMMONAFFIXES);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:Timer_AutoRes(Handle:timer) {

	if (b_IsCheckpointDoorStartOpened) return Plugin_Stop;
	for (new i = 1; i <= MaxClients; i++) {

		if (IsLegitimateClient(i) && (GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i))) {

			if (!IsPlayerAlive(i)) SDKCall(hRoundRespawn, i);
			else if (IsIncapacitated(i)) ExecCheatCommand(i, "give", "health");
		}
	}
	return Plugin_Continue;
}

stock bool:AnyHumans() {

	for (new i = 1; i <= MaxClients; i++) {

		if (IsLegitimateClient(i) && !IsFakeClient(i)) return true;
	}

	return false;
}

public ReadyUp_ReadyUpStart() {

	CheckDifficulty();
	if (!AnyHumans()) CheckGamemode();
	RoundTime = 0;
	b_IsRoundIsOver = true;
	SetSurvivorsAliveHostname();
	CreateTimer(1.0, Timer_AutoRes, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

	/*
	When a new round starts, we want to forget who was the last person to speak on different teams.
	*/
	Format(Public_LastChatUser, sizeof(Public_LastChatUser), "none");
	Format(Spectator_LastChatUser, sizeof(Spectator_LastChatUser), "none");
	Format(Survivor_LastChatUser, sizeof(Survivor_LastChatUser), "none");
	Format(Infected_LastChatUser, sizeof(Infected_LastChatUser), "none");

	for (new i = 1; i <= MaxClients; i++) {

		if (IsClientInGame(i)) {

			if (GetClientTeam(i) == TEAM_SURVIVOR && !b_IsLoaded[i]) IsClientLoadedEx(i);

			bIsEligibleMapAward[i] = true;
			HealingContribution[i] = 0;
			TankingContribution[i] = 0;
			DamageContribution[i] = 0;
			PointsContribution[i] = 0.0;
			HexingContribution[i] = 0;
			BuffingContribution[i] = 0;
			b_IsFloating[i] = false;
			ISDAZED[i] = 0.0;
			bIsInCombat[i] = false;
			b_IsInSaferoom[i] = true;
			// Anti-Farm/Anti-Camping system stuff.
			ClearArray(h_KilledPosition_X[i]);		// We clear all positions from the array.
			ClearArray(h_KilledPosition_Y[i]);
			ClearArray(h_KilledPosition_Z[i]);

			/*if (b_IsMissionFailed && GetClientTeam(i) == TEAM_SURVIVOR && IsFakeClient(i)) {

				if (!b_IsLoading[i]) {

					b_IsLoaded[i] = false;
					OnClientLoaded(i);
				}
			}*/
		}
	}
	RefreshSurvivorBots();
}

public ReadyUp_ReadyUpEnd() {

	ReadyUpEnd_Complete();

}

public Action:Timer_Defibrillator(Handle:timer, any:client) {

	if (IsLegitimateClient(client) && !IsPlayerAlive(client)) Defibrillator(0, client);
	return Plugin_Stop;
}

public ReadyUpEnd_Complete() {

	/*PrintToChatAll("DOor opened");
	b_IsCheckpointDoorStartOpened = true;
	b_IsActiveRound = true;*/
	if (b_IsRoundIsOver) {

		CheckDifficulty();
		b_IsMissionFailed = false;
		//if (ReadyUp_GetGameMode() == 3) {

		b_IsRoundIsOver = false;
			//b_IsSurvivalIntermission = true;
			//CreateTimer(5.0, Timer_AutoRes, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		//}
		//RoundTime					=	GetTime();
		b_IsCheckpointDoorStartOpened = false;
		for (new i = 1; i <= MaxClients; i++) {

			if (IsSurvivorBot(i) && !b_IsLoaded[i]) IsClientLoadedEx(i);
		}

		if (iRoundStartWeakness == 1) {

			for (new i = 1; i <= MaxClients; i++) {

				if (IsLegitimateClient(i) && (GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i))) {

					bHasWeakness[i] = true;
					SurvivorEnrage[i][0] = 0.0;
					SurvivorEnrage[i][1] = 0.0;
					ISDAZED[i] = 0.0;
					//if (!IsFakeClient(i)) {
						//stupify
					//SurvivorStamina[i] = GetPlayerStamina(i);
					if (b_IsLoaded[i] && IsLegitimateClass(i)) {

						SurvivorStamina[i] = GetPlayerStamina(i) - 1;
						SetMaximumHealth(i);
					}
					else if (!b_IsLoading[i]) OnClientLoaded(i);
					//}

					bIsSurvivorFatigue[i] = false;
					LastWeaponDamage[i] = 1;
					HealingContribution[i] = 0;
					TankingContribution[i] = 0;
					DamageContribution[i] = 0;
					PointsContribution[i] = 0.0;
					HexingContribution[i] = 0;
					BuffingContribution[i] = 0;
					b_IsFloating[i] = false;
					bIsHandicapLocked[i] = false;
				}
			}
		}
	}
}

stock TimeUntilEnrage(String:TheText[], TheSize) {

	if (!IsEnrageActive()) {

		new Seconds = (iEnrageTime * 60) - (GetTime() - RoundTime);
		new Minutes = 0;
		while (Seconds >= 60) {

			Seconds -= 60;
			Minutes++;
		}
		Format(TheText, TheSize, "%dm%ds", Minutes, Seconds);
	}
	else Format(TheText, TheSize, "ACTIVE");
}

stock RPGRoundTime(bool:IsSeconds = false) {

	new Seconds = GetTime() - RoundTime;
	if (IsSeconds) return Seconds;
	new Minutes = 0;
	while (Seconds >= 60) {

		Minutes++;
		Seconds -= 60;
	}
	return Minutes;
}

stock bool:IsEnrageActive() {

	if (!b_IsActiveRound || IsSurvivalMode) return false;

	//if (b_IsFinaleActive) return true;
	
	if (RPGRoundTime() < iEnrageTime) return false;
	if (!IsEnrageNotified && iNotifyEnrage == 1) {

		IsEnrageNotified = true;
		PrintToChatAll("%t", "enrage period", orange, blue, orange);
	}
	return true;
}

stock bool:PlayerHasWeakness(client) {

	if (!IsLegitimateClientAlive(client)) return false;

	if (StrContains(ActiveClass[client], "death", false) != -1) {

		return true;
	}
	else {

		if (IsSpecialCommonInRange(client, 'w')) return true;
		if (IsClientInRangeSpecialAmmo(client, "C", true) == -2.0) return true;
	}

	if (!b_IsCheckpointDoorStartOpened || DoomTimer != 0) return true;
	if (LastDeathTime[client] > GetEngineTime()) return true;
	if (IsClientInRangeSpecialAmmo(client, "W", true) == -2.0) return true;	// the player is not weak if inside cleansing ammo.*

	return false;
}

public ReadyUp_CheckpointDoorStartOpened() {

	if (!b_IsCheckpointDoorStartOpened) {

		b_IsCheckpointDoorStartOpened		= true;
		b_RescueIsHere = false;
		b_IsActiveRound = true;
		bIsSettingsCheck = true;
		IsEnrageNotified = false;
		b_IsFinaleTanks = false;

		ClearArray(Handle:persistentCirculation);
		ClearArray(Handle:CoveredInVomit);
		if (GetArraySize(RoundStatistics) < 5) ResizeArray(RoundStatistics, 5);
		for (new i = 0; i < 5; i++) {

			SetArrayCell(Handle:RoundStatistics, i, 0);
			if (CurrentMapPosition == 0) SetArrayCell(Handle:RoundStatistics, i, 0, 1);	// first map of campaign, reset the total.
		}

		//DestroyCommons();

		decl String:pct[4];
		Format(pct, sizeof(pct), "%");

		decl String:text[64];

		for (new i = 1; i <= MaxClients; i++) {

			if (IsLegitimateClient(i)) {

				//ChangeHook(i, true);

				if (!IsFakeClient(i)) {

					if (iTankRush == 1) RatingHandicap[i] = RatingPerLevel;

					if (IsGroupMember[i]) PrintToChat(i, "%T", "group member bonus", i, blue, GroupMemberBonus * 100.0, pct, green, orange);
					else PrintToChat(i, "%T", "group member benefit", i, orange, blue, GroupMemberBonus * 100.0, pct, green, blue);
				}
			}
		}

		if (CurrentMapPosition != 0 || ReadyUpGameMode == 3) CheckDifficulty();

		RoundTime					=	GetTime();

		new ent = -1;
		if (ReadyUpGameMode != 3) {

			while ((ent = FindEntityByClassname(ent, "witch")) != -1) {

				// Some maps, like Hard Rain pre-spawn a ton of witches - we want to add them to the witch table.
				OnWitchCreated(ent);
			}
		}
		else {

			IsSurvivalMode = true;

			for (new i = 1; i <= MaxClients; i++) {

				if (IsLegitimateClientAlive(i) && (GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i))) {

					Rating[i] = 1;
					RespawnImmunity[i] = false;
				}
			}
			decl String:TheCurr[64];
			GetCurrentMap(TheCurr, sizeof(TheCurr));
			if (StrContains(TheCurr, "helms_deep", false) != -1) {

				// the bot has to be teleported to the machine gun, because samurai blocks the teleportation in the actual map scripting

				new Float:TeleportBots[3];
				TeleportBots[0] = 1572.749146;
				TeleportBots[1] = -871.468811;
				TeleportBots[2] = 62.031250;

				decl String:TheModel[64];
				for (new i = 1; i <= MaxClients; i++) {

					if (IsLegitimateClientAlive(i) && IsFakeClient(i)) {

						GetClientModel(i, TheModel, sizeof(TheModel));
						if (StrEqual(TheModel, LOUIS_MODEL)) TeleportEntity(i, TeleportBots, NULL_VECTOR, NULL_VECTOR);
					}
				}
				PrintToChatAll("\x04Man the gun, Louis!");
			}
		}


		b_IsCampaignComplete				= false;
		if (ReadyUpGameMode != 3) b_IsRoundIsOver						= false;
		//PrintToChatAll("%t", "Round Statistics", white, green, AddCommasToString(CommonsKilled), orange, green, AddCommasToString(SpecialsKilled), blue, green, AddCommasToString(SurvivorsKilled), white, green, AddCommasToString(RoundDamageTotal), white, blue, MVPName, white, green, AddCommasToString(MVPDamage));
		if (ReadyUpGameMode == 2) MapRoundsPlayed = 0;	// Difficulty leniency does not occur in versus.

		SpecialsKilled				=	0;
		RoundDamageTotal			=	0;
		//MVPDamage					=	0;
		b_IsFinaleActive			=	false;

		if (GetConfigValueInt("director save priority?") == 1) PrintToChatAll("%t", "Director Priority Save Enabled", white, green);
		decl String:thetext[64];
		GetConfigValue(thetext, sizeof(thetext), "path setting?");

		if (ReadyUpGameMode != 3 && !StrEqual(thetext, "none")) {

			if (!StrEqual(thetext, "random")) ServerCommand("sm_forcepath %s", thetext);
			else {

				if (StrEqual(PathSetting, "none")) {

					new random = GetRandomInt(1, 100);
					if (random <= 33) Format(PathSetting, sizeof(PathSetting), "easy");
					else if (random <= 66) Format(PathSetting, sizeof(PathSetting), "medium");
					else Format(PathSetting, sizeof(PathSetting), "hard");
				}
				ServerCommand("sm_forcepath %s", PathSetting);
			}
		}




		//new RatingLevelMultiplier = GetConfigValueInt("rating level multiplier?");
		for (new i = 1; i <= MaxClients; i++) {

			if (IsLegitimateClient(i) && (GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i))) {

				if (!IsSurvivorBot(i) && !IsPlayerAlive(i)) SDKCall(hRoundRespawn, i);
				if (Rating[i] < 1) Rating[i] = 1;
				HealImmunity[i] = false;

				//DefaultHealth[i] = StringToInt(GetConfigValue("survivor health?"));
				//PlayerSpawnAbilityTrigger(i);
				//RefreshSurvivor(i);
				//SetClientMovementSpeed(i);
				//ResetCoveredInBile(i);
				//BlindPlayer(i);
				//GiveMaximumHealth(i);

				if (b_IsLoaded[i]) GiveMaximumHealth(i);
				else if (!b_IsLoading[i]) OnClientLoaded(i);
			}
		}
		
		f_TankCooldown				=	-1.0;
		ResetCDImmunity(-1);
		DoomTimer = 0;

		if (ReadyUpGameMode != 2) {

			// It destroys itself when a round ends.
			CreateTimer(1.0, Timer_DirectorPurchaseTimer, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		if (!bIsSoloHandicap && RespawnQueue > 0) CreateTimer(1.0, Timer_RespawnQueue, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		RaidInfectedBotLimit();
		CreateTimer(1.0, Timer_ShowHUD, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer(0.5, Timer_DisplayHUD, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		//CreateTimer(1.0, Timer_AwardSkyPoints, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer(1.0, Timer_CheckIfHooked, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer(GetConfigValueFloat("settings check interval?"), Timer_SettingsCheck, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer(0.2, Timer_AmmoActiveTimer, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		if (DoomSUrvivorsRequired != 0) CreateTimer(1.0, Timer_Doom, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer(0.2, Timer_SpecialAmmoData, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		CreateTimer(0.2, Timer_EntityOnFire, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);		// Fire status effect
		if (GetConfigValueInt("common affixes?") == 1) {

			ClearArray(Handle:CommonAffixes);
			CreateTimer(0.5, Timer_CommonAffixes, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}

		ClearRelevantData();
		LastLivingSurvivor = 1;
		new size = GetArraySize(a_DirectorActions);
		ResizeArray(a_DirectorActions_Cooldown, size);
		for (new i = 0; i < size; i++) SetArrayString(a_DirectorActions_Cooldown, i, "0");
		//if (CommonInfectedQueue == INVALID_HANDLE) CommonInfectedQueue = CreateArray(32);
		//ClearArray(CommonInfectedQueue);
		if (LivingSurvivorCount() > 1) PrintToChatAll("%t", "teammate bonus experience", blue, green, ((LivingSurvivors() - 1) * GetConfigValueFloat("survivor experience bonus?")) * 100.0, pct);
		RefreshSurvivorBots();

		TimeUntilEnrage(text, sizeof(text));
		PrintToChatAll("%t", "enrage in...", orange, green, text, orange);
	}
}

stock RefreshSurvivorBots() {

	for (new i = 1; i <= MaxClients; i++) {

		if (IsSurvivorBot(i)) {

			//if (!IsPlayerAlive(i)) SDKCall(hRoundRespawn, i);
			RefreshSurvivor(i);
		}
	}
}

stock SetClientMovementSpeed(client) {

	if (IsValidEntity(client)) SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", fBaseMovementSpeed);
}

stock ResetCoveredInBile(client) {

	for (new i = 1; i <= MaxClients; i++) {

		if (IsLegitimateClient(i)) {

			CoveredInBile[client][i] = -1;
			CoveredInBile[i][client] = -1;
		}
	}
}

stock FindTargetClient(client, String:arg[]) {

	decl String:target_name[MAX_TARGET_LENGTH];
	decl target_list[MAXPLAYERS], target_count, bool:tn_is_ml;
	new targetclient;
	if ((target_count = ProcessTargetString(
		arg,
		client,
		target_list,
		MAXPLAYERS,
		COMMAND_FILTER_CONNECTED,
		target_name,
		sizeof(target_name),
		tn_is_ml)) > 0)
	{
		for (new i = 0; i < target_count; i++) targetclient = target_list[i];
	}
	return targetclient;
}

stock CMD_CastAction(client, args) {

	decl String:actionpos[64];
	GetCmdArg(1, actionpos, sizeof(actionpos));
	if (StrContains(actionpos, "action", false) != -1) {

		CastActionEx(client, actionpos, sizeof(actionpos));
	}
}

stock CastActionEx(client, String:t_actionpos[] = "none", TheSize, pos = -1) {

	new ActionSlots = iActionBarSlots;
	decl String:actionpos[64];

	if (pos == -1) pos = StringToInt(t_actionpos[strlen(t_actionpos) - 1]) - 1;//StringToInt(actionpos[strlen(actionpos) - 1]);
	if (pos >= 0 && pos < ActionSlots) {

		//pos--;	// shift down 1 for the array.
		GetArrayString(Handle:ActionBar[client], pos, actionpos, sizeof(actionpos));
		if (IsTalentExists(actionpos)) { //PrintToChat(client, "%T", "Action Slot Empty", client, white, orange, blue, pos+1);
		//else {

			new size =	GetArraySize(a_Menu_Talents);
			new RequiresTarget = 0;
			new AbilityTalent = 0;
			decl String:tTargetPos[3][64];
			new Float:TargetPos[3];
			decl String:TalentName[64];

			for (new i = 0; i < size; i++) {

				CastKeys[client]			= GetArrayCell(a_Menu_Talents, i, 0);
				CastValues[client]			= GetArrayCell(a_Menu_Talents, i, 1);
				CastSection[client]			= GetArrayCell(a_Menu_Talents, i, 2);

				GetArrayString(Handle:CastSection[client], 0, TalentName, sizeof(TalentName));
				if (!StrEqual(TalentName, actionpos)) continue;
				AbilityTalent = GetKeyValueInt(CastKeys[client], CastValues[client], "is ability?");
				if (GetKeyValueInt(CastKeys[client], CastValues[client], "passive only?") == 1) continue;
				if (AbilityTalent != 1 && GetTalentStrength(client, actionpos) < 1) {

					// talent exists but user has no points in it from a respec or whatever so we remove it.
					// we don't tell them either, next time they use it they'll find out.

					Format(actionpos, TheSize, "none");
					SetArrayString(Handle:ActionBar[client], pos, actionpos);
				}
				else {


					RequiresTarget = GetKeyValueInt(CastKeys[client], CastValues[client], "is single target?");
					if (RequiresTarget > 0) {

						GetClientAimTargetEx(client, actionpos, TheSize, true);
						RequiresTarget = StringToInt(actionpos);
						if (IsLegitimateClientAlive(RequiresTarget)) {

							if (AbilityTalent != 1) CastSpell(client, RequiresTarget, TalentName, TargetPos);
							else {

								UseAbility(client, RequiresTarget, TalentName, CastKeys[client], CastValues[client], TargetPos);
							}
						}
					}
					else {

						GetClientAimTargetEx(client, actionpos, TheSize);
						ExplodeString(actionpos, " ", tTargetPos, 3, 64);
						TargetPos[0] = StringToFloat(tTargetPos[0]);
						TargetPos[1] = StringToFloat(tTargetPos[1]);
						TargetPos[2] = StringToFloat(tTargetPos[2]);

						if (AbilityTalent != 1) CastSpell(client, _, TalentName, TargetPos);
						else {

							UseAbility(client, _, TalentName, CastKeys[client], CastValues[client], TargetPos);
						}
					}
				}
				break;
			}
		}
	}
	else {

		PrintToChat(client, "%T", "Action Slot Range", client, white, blue, ActionSlots, white);
	}
}








public Action:CMD_ChatTag(client, args) {

	if (IsReserve(client) && args > 0 || GetConfigValueInt("all players chat settings?") == 1) {

		decl String:arg[64];
		GetCmdArg(1, arg, sizeof(arg));
		if (strlen(arg) > GetConfigValueInt("tag name max length?")) PrintToChat(client, "%T", "Tag Name Too Long", client, GetConfigValueInt("tag name max length?"));
		else if (strlen(arg) > 1) {
		
			ReplaceString(arg, sizeof(arg), "+", " ");
			SetArrayString(ChatSettings[client], 1, arg);
			PrintToChat(client, "%T", "Tag Name Set", client, arg);
		}
		else {

			//GetArrayString(Handle:ChatSettings[client], 1, arg, sizeof(arg));
			GetClientName(client, arg, sizeof(arg));
			SetArrayString(ChatSettings[client], 1, arg);
			PrintToChat(client, "%T", "Tag Name Set", client, arg);
		}
	}
	return Plugin_Handled;
}

stock MySurvivorCompanion(client) {

	decl String:SteamId[64], String:CompanionSteamId[64];
	GetClientAuthString(client, SteamId, sizeof(SteamId));

	for (new i = 1; i <= MaxClients; i++) {

		if (IsLegitimateClient(i) && GetClientTeam(i) == TEAM_SURVIVOR && IsSurvivorBot(i)) {

			GetEntPropString(i, Prop_Data, "m_iName", CompanionSteamId, sizeof(CompanionSteamId));
			if (StrEqual(CompanionSteamId, SteamId, false)) return i;
		}
	}


	return -1;
}

public Action:CMD_CompanionOptions(client, args) {

	/*if (GetClientTeam(client) != TEAM_SURVIVOR) return Plugin_Handled;
	decl String:TheCommand[64], String:TheName[64], String:tquery[512], String:thetext[64], String:SteamId[64];
	GetCmdArg(1, TheCommand, sizeof(TheCommand));
	if (args > 1) {

		new companion = MySurvivorCompanion(client);

		if (companion == -1) {	// no companion active.

			if (StrEqual(TheCommand, "create", false)) {	// creates a companion.

				if (args == 2) {

					GetCmdArg(2, TheName, sizeof(TheName));
					ReplaceString(TheName, sizeof(TheName), "+", " ");

					Format(CompanionNameQueue[client], sizeof(CompanionNameQueue[]), "%s", TheName);
					GetClientAuthString(client, SteamId, sizeof(SteamId));

					Format(tquery, sizeof(tquery), "SELECT COUNT(*) FROM `%s` WHERE `companionowner` = '%s';", TheDBPrefix, SteamId);
					SQL_TQuery(hDatabase, Query_CheckCompanionCount, tquery, client);
				}
				else {

					GetConfigValue(thetext, sizeof(thetext), "companion command?");
					PrintToChat(client, "!%s create <name>", thetext);
				}
			}
			else if (StrEqual(TheCommand, "load", false)) {	// opens the comapnion load menu.

			}
		}
		else {	// player has a companion active.

			if (StrEqual(TheCommand, "delete", false)) {	// we delete the companion.

			}
			else if (StrEqual(TheCommand, "edit", false)) {	// opens the talent menu for the companion.

			}
			else if (StrEqual(TheCommand, "save", false)) {	// saves the companion, you should always do this before loading a new one.

			}
		}
	}
	else {

		// display the available commands to the user.
	}*/

	return Plugin_Handled;
}

public Action:CMD_TogglePvP(client, args) {

	new TheTime = RoundToCeil(GetEngineTime());
	if (IsPvP[client] != 0) {

		if (IsPvP[client] + 30 <= TheTime) {

			IsPvP[client] = 0;
			PrintToChat(client, "%T", "PvP Disabled", client, white, orange);
		}
	}
	else {

		IsPvP[client] = TheTime + 30;
		PrintToChat(client, "%T", "PvP Enabled", client, white, blue);
	}

	return Plugin_Handled;
}

public Action:CMD_GiveLevel(client, args) {

	decl String:thetext[64];
	GetConfigValue(thetext, sizeof(thetext), "give player level flags?");

	if ((HasCommandAccess(client, thetext) || client == 0) && args > 1) {

		decl String:arg[MAX_NAME_LENGTH], String:arg2[64], String:arg3[64];
		GetCmdArg(1, arg, sizeof(arg));
		GetCmdArg(2, arg2, sizeof(arg2));
		GetCmdArg(3, arg3, sizeof(arg3));
		new targetclient = FindTargetClient(client, arg);
		if (args < 3) {

			if (IsLegitimateClient(targetclient) && PlayerLevel[targetclient] != StringToInt(arg2)) {

				SetTotalExperienceByLevel(targetclient, StringToInt(arg2));
				decl String:Name[64];
				GetClientName(targetclient, Name, sizeof(Name));
				if (client > 0) PrintToChat(client, "%T", "client level set", client, Name, green, white, blue, PlayerLevel[targetclient]);
				else PrintToServer("set %N level to %d", Name, PlayerLevel[targetclient]);
			}
		}
		else {

			if (IsLegitimateClient(targetclient)) {

				if (StrContains(arg3, "rating", false) != -1) Rating[targetclient] = StringToInt(arg2);
				else ModifyCartelValue(targetclient, arg3, StringToInt(arg2));
			}
		}
	}


	return Plugin_Handled;
}

stock GetPlayerLevel(client) {

	new iExperienceOverall = ExperienceOverall[client];
	new iLevel = 1;
	new ExperienceRequirement = CheckExperienceRequirement(client, false, iLevel);
	while (iExperienceOverall >= ExperienceRequirement && iLevel < iMaxLevel) {

		iExperienceOverall -= ExperienceRequirement;
		iLevel++;
		ExperienceRequirement = CheckExperienceRequirement(client, false, iLevel);
	}

	return iLevel;
}

stock SetTotalExperienceByLevel(client, newlevel) {

	new oldlevel = PlayerLevel[client];
	ExperienceOverall[client] = 0;
	ExperienceLevel[client] = 0;
	PlayerLevel[client] = newlevel;
	for (new i = 1; i <= newlevel; i++) {

		if (newlevel == i) break;
		ExperienceOverall[client] += CheckExperienceRequirement(client, false, i);
	}

	ExperienceOverall[client]++;
	ExperienceLevel[client]++;	// i don't like 0 / level, so i always do 1 / level as the minimum.
	if (oldlevel > PlayerLevel[client]) ChallengeEverything(client);
	else if (PlayerLevel[client] > oldlevel) {

		FreeUpgrades[client] += (PlayerLevel[client] - oldlevel);
	}
}

public Action:CMD_ReloadConfigs(client, args) {

	decl String:thetext[64];
	GetConfigValue(thetext, sizeof(thetext), "reload configs flags?");

	if (HasCommandAccess(client, thetext)) {

		CreateTimer(1.0, Timer_ExecuteConfig, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		PrintToChat(client, "Reloading Config.");
	}

	return Plugin_Handled;
}

public ReadyUp_FirstClientLoaded() {

	//CreateTimer(1.0, Timer_ShowHUD, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	OnMapStartFunc();
	RefreshSurvivorBots();
	ReadyUpGameMode = ReadyUp_GetGameMode();
}

public Action:CMD_SharePoints(client, args) {

	if (args < 2) {

		decl String:thetext[64];
		GetConfigValue(thetext, sizeof(thetext), "reload configs flags?");

		PrintToChat(client, "%T", "Share Points Syntax", client, orange, white, thetext);
		return Plugin_Handled;
	}

	decl String:arg[MAX_NAME_LENGTH], String:arg2[10];
	GetCmdArg(1, arg, sizeof(arg));
	GetCmdArg(2, arg2, sizeof(arg2));
	new Float:SharePoints = 0.0;
	if (StrContains(arg2, ".", false) == -1) SharePoints = StringToInt(arg2) * 1.0;
	else SharePoints = StringToFloat(arg2);

	if (SharePoints > Points[client]) return Plugin_Handled;

	new targetclient = FindTargetClient(client, arg);
	if (!IsLegitimateClient(targetclient)) return Plugin_Handled;

	decl String:Name[MAX_NAME_LENGTH];
	GetClientName(targetclient, Name, sizeof(Name));
	decl String:GiftName[MAX_NAME_LENGTH];
	GetClientName(client, GiftName, sizeof(GiftName));

	Points[client] -= SharePoints;
	Points[targetclient] += SharePoints;

	PrintToChatAll("%t", "Share Points Given", blue, GiftName, white, green, SharePoints, white, blue, Name); 
	return Plugin_Handled;
}

stock GetMaxHandicap(client) {

	new iMaxHandicap = RatingPerHandicap;
	iMaxHandicap *= PlayerLevel[client];
	iMaxHandicap += RatingPerLevel;

	return iMaxHandicap;
}

stock VerifyHandicap(client) {

	new iMaxHandicap = GetMaxHandicap(client);
	new iMinHandicap = RatingPerLevel;

	if (RatingHandicap[client] < iMinHandicap) RatingHandicap[client] = iMinHandicap;
	if (RatingHandicap[client] > iMaxHandicap) RatingHandicap[client] = iMaxHandicap;
}

public Action:CMD_Handicap(client, args) {

	new iMaxHandicap = GetMaxHandicap(client);
	new iMinHandicap = RatingPerLevel;
	if (RatingHandicap[client] < iMinHandicap) RatingHandicap[client] = iMinHandicap;
	if (RatingHandicap[client] > iMaxHandicap) RatingHandicap[client] = iMaxHandicap;
	if (args < 1) {

		PrintToChat(client, "%T", "handicap range", client, white, orange, iMinHandicap, white, orange, iMaxHandicap);
	}
	else {

		if (!bIsHandicapLocked[client]) {

			decl String:arg[10];
			GetCmdArg(1, arg, sizeof(arg));
			new iSetHandicap = StringToInt(arg);

			if (iSetHandicap >= iMinHandicap && iSetHandicap <= iMaxHandicap) {

				RatingHandicap[client] = iSetHandicap;
			}
			else if (iSetHandicap < iMinHandicap) RatingHandicap[client] = iMinHandicap;
			else if (iSetHandicap > iMaxHandicap) RatingHandicap[client] = iMaxHandicap;
		}
		else {

			PrintToChat(client, "%T", "player handicap locked", client, orange);
		}
	}

	PrintToChat(client, "%T", "player handicap", client, blue, orange, green, RatingHandicap[client]);
	return Plugin_Handled;
}

public Action:CMD_ActionBar(client, args) {

	if (!DisplayActionBar[client]) {

		PrintToChat(client, "%T", "action bar displayed", client, white, blue);
		DisplayActionBar[client] = true;
	}
	else {

		PrintToChat(client, "%T", "action bar hidden", client, white, orange);
		DisplayActionBar[client] = false;
		ActionBarSlot[client] = -1;
	}

	return Plugin_Handled;
}

public Action:CMD_GiveStorePoints(client, args) {

	decl String:thetext[64];
	GetConfigValue(thetext, sizeof(thetext), "give store points flags?");

	if (!HasCommandAccess(client, thetext)) { PrintToChat(client, "You don't have access."); return Plugin_Handled; }
	if (args < 2) {

		PrintToChat(client, "%T", "Give Store Points Syntax", client, orange, white);
		return Plugin_Handled;
	}

	decl String:arg[MAX_NAME_LENGTH], String:arg2[4];
	GetCmdArg(1, arg, sizeof(arg));

	if (args > 1) {

		GetCmdArg(2, arg2, sizeof(arg2));
	}
	
	new targetclient = FindTargetClient(client, arg);
	decl String:Name[MAX_NAME_LENGTH];
	GetClientName(targetclient, Name, sizeof(Name));
	SkyPoints[targetclient] += StringToInt(arg2);

	PrintToChat(client, "%T", "Store Points Award Given", client, white, green, arg2, white, orange, Name);
	PrintToChat(targetclient, "%T", "Store Points Award Received", client, white, green, arg2, white);

	return Plugin_Handled;
}

public ReadyUp_CampaignComplete() {

	if (!b_IsCampaignComplete) {

		b_IsCampaignComplete			= true;
		CallRoundIsOver();
		WipeDebuffs(true);
	}
}


public Action:CMD_CollectBonusExperience(client, args) {

	if (CurrentMapPosition != 0 && RoundExperienceMultiplier[client] > 0.0 && BonusContainer[client] > 0 && b_IsInSaferoom[client]) {

		new RewardWaiting = RoundToCeil(BonusContainer[client] * RoundExperienceMultiplier[client]);

		ExperienceLevel[client] += RewardWaiting;
		ExperienceOverall[client] += RewardWaiting;
		decl String:Name[64];
		GetClientName(client, Name, sizeof(Name));
		PrintToChatAll("%t", "collected bonus container", blue, Name, white, green, blue, AddCommasToString(RewardWaiting));
		BonusContainer[client] = 0;
		RoundExperienceMultiplier[client] = 0.0;
		ConfirmExperienceAction(client);
	}

	return Plugin_Handled;
}

public ReadyUp_RoundIsOver(gamemode) {

	CallRoundIsOver();
}



public Action:Timer_SaveAndClear(Handle:timer) {

	new LivingSurvs = TotalHumanSurvivors();
	for (new i = 1; i <= MaxClients; i++) {

		if (IsLegitimateClient(i) && (GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i))) {

			//ToggleTank(i, true);
			if (b_IsMissionFailed && LivingSurvs > 0) {

				RoundExperienceMultiplier[i] = 0.0;
				BonusContainer[i] = 0;

				// So, the round ends due a failed mission, whether it's coop or survival, and we reset all players ratings.
				Rating[i] = 1;
			}
			SaveAndClear(i);
		}
	}


	return Plugin_Stop;
}

stock CallRoundIsOver() {

	if (!b_IsRoundIsOver) {

		for (new i = 0; i < 5; i++) {

			SetArrayCell(Handle:RoundStatistics, i, GetArrayCell(RoundStatistics, i) + GetArrayCell(RoundStatistics, i, 1), 1);
		}

		new pEnt = -1;

		decl String:pText[2][64];
		decl String:text[64];
		
		new pSize = GetArraySize(persistentCirculation);
		for (new i = 0; i < pSize; i++) {

			GetArrayString(persistentCirculation, i, text, sizeof(text));
			ExplodeString(text, ":", pText, 2, 64);
			pEnt = StringToInt(pText[0]);

			if (IsValidEntity(pEnt)) AcceptEntityInput(pEnt, "Kill");
		}
		ClearArray(persistentCirculation);

		b_IsRoundIsOver					= true;
		b_RescueIsHere = false;
		if (b_IsActiveRound) b_IsActiveRound = false;

		SetSurvivorsAliveHostname();

		if (!b_IsMissionFailed) {

			//InfectedLevel = HumanSurvivorLevels();

			if (!IsSurvivalMode) {

				for (new i = 1; i <= MaxClients; i++) {

					if (IsLegitimateClient(i) && (GetClientTeam(i) == TEAM_SURVIVOR || IsSurvivorBot(i))) {

						bIsInCombat[i] = false;
					
						if (IsPlayerAlive(i)) {

							if (Rating[i] < 1 && CurrentMapPosition != 1) Rating[i] = 1;
							if (RoundExperienceMultiplier[i] < 0.0) RoundExperienceMultiplier[i] = 0.0;
							if (CurrentMapPosition != 1) RoundExperienceMultiplier[i] += fCoopSurvBon;
							AwardExperience(i, _, _, true);
						}
					}
				}
			}
		}


		CreateTimer(1.0, Timer_SaveAndClear, _, TIMER_FLAG_NO_MAPCHANGE);

		//PrintToChatAll("%t", "Data Saved", white, orange);

		//new IsItEnabled = StringToInt(GetConfigValue("handicap enabled?"));
		//ClearArray(Handle:EntityOnFire);
		b_IsCheckpointDoorStartOpened	= false;
		RemoveImmunities(-1);

		ClearArray(Handle:LoggedUsers);		// when a round ends, logged users are removed.
		b_IsActiveRound = false;
		MapRoundsPlayed++;

		new Seconds			= GetTime() - RoundTime;
		new Minutes			= 0;
		while (Seconds >= 60) {

			Minutes++;
			Seconds -= 60;
		}

		PrintToChatAll("%t", "Round Time", orange, blue, Minutes, white, blue, Seconds, white);
		if (CurrentMapPosition != 1) {

			PrintToChatAll("%t", "round statistics", green, orange, blue, AddCommasToString(GetArrayCell(RoundStatistics, 0)), orange, blue, AddCommasToString(GetArrayCell(RoundStatistics, 1)), orange, blue, AddCommasToString(GetArrayCell(RoundStatistics, 2)), orange, blue, AddCommasToString(GetArrayCell(RoundStatistics, 3)), orange, blue, AddCommasToString(GetArrayCell(RoundStatistics, 4)), orange, green, AddCommasToString(GetArrayCell(RoundStatistics, 0) + GetArrayCell(RoundStatistics, 1) + GetArrayCell(RoundStatistics, 2) + GetArrayCell(RoundStatistics, 3) + GetArrayCell(RoundStatistics, 4)));
		}
		else {

			PrintToChatAll("%t", "campaign statistics", green, orange, blue, AddCommasToString(GetArrayCell(RoundStatistics, 0, 1)), orange, blue, AddCommasToString(GetArrayCell(RoundStatistics, 1, 1)), orange, blue, AddCommasToString(GetArrayCell(RoundStatistics, 2, 1)), orange, blue, AddCommasToString(GetArrayCell(RoundStatistics, 3, 1)), orange, blue, AddCommasToString(GetArrayCell(RoundStatistics, 4, 1)), orange, green, AddCommasToString(GetArrayCell(RoundStatistics, 0, 1) + GetArrayCell(RoundStatistics, 1, 1) + GetArrayCell(RoundStatistics, 2, 1) + GetArrayCell(RoundStatistics, 3, 1) + GetArrayCell(RoundStatistics, 4, 1)));
		}
		
		ResetArray(Handle:CommonInfected);
		ResetArray(Handle:WitchList);
		ResetArray(Handle:CommonList);
		/*ClearArray(Handle:CommonInfected);
		ClearArray(Handle:WitchList);
		ClearArray(Handle:CommonList);*/
		ClearArray(Handle:EntityOnFire);
		ClearArray(Handle:CommonInfectedQueue);
		ClearArray(Handle:SuperCommonQueue);

		if (b_IsMissionFailed && StrContains(TheCurrentMap, "zerowarn", false) != -1) CreateTimer(3.0, Timer_ResetMap, _, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action:Timer_ResetMap(Handle:timer) {

	ServerCommand("changelevel %s", TheCurrentMap);
	return Plugin_Stop;
}

stock ResetArray(Handle:TheArray) {

	ClearArray(Handle:TheArray);
}

public ReadyUp_ParseConfigFailed(String:config[], String:error[]) {

	if (StrEqual(config, CONFIG_MAIN) ||
		StrEqual(config, CONFIG_EVENTS) ||
		StrEqual(config, CONFIG_MENUTALENTS) ||
		StrEqual(config, CONFIG_MAINMENU) ||
		StrEqual(config, CONFIG_POINTS) ||
		StrEqual(config, CONFIG_STORE) ||
		StrEqual(config, CONFIG_TRAILS) ||
		StrEqual(config, CONFIG_CHATSETTINGS) ||
		StrEqual(config, CONFIG_WEAPONS) ||
		StrEqual(config, CONFIG_PETS) ||
		StrEqual(config, CONFIG_COMMONAFFIXES)) {
	
		SetFailState("%s , %s", config, error);
	}
}

public ReadyUp_LoadFromConfigEx(Handle:key, Handle:value, Handle:section, String:configname[], keyCount) {

	//PrintToChatAll("Size: %d config: %s", GetArraySize(Handle:key), configname);

	if (!StrEqual(configname, CONFIG_MAIN) &&
		!StrEqual(configname, CONFIG_EVENTS) &&
		!StrEqual(configname, CONFIG_MENUTALENTS) &&
		!StrEqual(configname, CONFIG_MAINMENU) &&
		!StrEqual(configname, CONFIG_POINTS) &&
		!StrEqual(configname, CONFIG_STORE) &&
		!StrEqual(configname, CONFIG_TRAILS) &&
		!StrEqual(configname, CONFIG_CHATSETTINGS) &&
		!StrEqual(configname, CONFIG_WEAPONS) &&
		!StrEqual(configname, CONFIG_PETS) &&
		!StrEqual(configname, CONFIG_COMMONAFFIXES)) return;

	decl String:s_key[64];
	decl String:s_value[64];
	decl String:s_section[64];

	new Handle:TalentKeys		=					CreateArray(32);
	new Handle:TalentValues		=					CreateArray(32);
	new Handle:TalentSection	=					CreateArray(32);

	new lastPosition = 0;
	new counter = 0;

	if (keyCount > 0) {

		if (StrEqual(configname, CONFIG_MENUTALENTS)) ResizeArray(a_Menu_Talents, keyCount);
		else if (StrEqual(configname, CONFIG_MAINMENU)) ResizeArray(a_Menu_Main, keyCount);
		else if (StrEqual(configname, CONFIG_EVENTS)) ResizeArray(a_Events, keyCount);
		else if (StrEqual(configname, CONFIG_POINTS)) ResizeArray(a_Points, keyCount);
		else if (StrEqual(configname, CONFIG_PETS)) ResizeArray(a_Pets, keyCount);
		else if (StrEqual(configname, CONFIG_STORE)) ResizeArray(a_Store, keyCount);
		else if (StrEqual(configname, CONFIG_TRAILS)) ResizeArray(a_Trails, keyCount);
		else if (StrEqual(configname, CONFIG_CHATSETTINGS)) ResizeArray(a_ChatSettings, keyCount);
		else if (StrEqual(configname, CONFIG_WEAPONS)) ResizeArray(a_WeaponDamages, keyCount);
		else if (StrEqual(configname, CONFIG_COMMONAFFIXES)) ResizeArray(a_CommonAffixes, keyCount);
	}

	new a_Size						= GetArraySize(key);

	for (new i = 0; i < a_Size; i++) {

		GetArrayString(Handle:key, i, s_key, sizeof(s_key));
		GetArrayString(Handle:value, i, s_value, sizeof(s_value));

		PushArrayString(TalentKeys, s_key);
		PushArrayString(TalentValues, s_value);

		if (StrEqual(configname, CONFIG_MAIN)) {

			PushArrayString(Handle:MainKeys, s_key);
			PushArrayString(Handle:MainValues, s_value);
			if (StrEqual(s_key, "rpg mode?")) {

				CurrentRPGMode = StringToInt(s_value);
				LogMessage("=====\t\tRPG MODE SET TO %d\t\t=====", CurrentRPGMode);
			}
		}
		//} else {
		if (StrEqual(s_key, "EOM")) {

			GetArrayString(Handle:section, i, s_section, sizeof(s_section));
			PushArrayString(TalentSection, s_section);

			if (StrEqual(configname, CONFIG_MENUTALENTS)) SetConfigArrays(configname, a_Menu_Talents, TalentKeys, TalentValues, TalentSection, GetArraySize(a_Menu_Talents), lastPosition - counter);
			else if (StrEqual(configname, CONFIG_MAINMENU)) SetConfigArrays(configname, a_Menu_Main, TalentKeys, TalentValues, TalentSection, GetArraySize(a_Menu_Main), lastPosition - counter);
			else if (StrEqual(configname, CONFIG_EVENTS)) SetConfigArrays(configname, a_Events, TalentKeys, TalentValues, TalentSection, GetArraySize(a_Events), lastPosition - counter);
			else if (StrEqual(configname, CONFIG_POINTS)) SetConfigArrays(configname, a_Points, TalentKeys, TalentValues, TalentSection, GetArraySize(a_Points), lastPosition - counter);
			else if (StrEqual(configname, CONFIG_PETS)) SetConfigArrays(configname, a_Pets, TalentKeys, TalentValues, TalentSection, GetArraySize(a_Pets), lastPosition - counter);
			else if (StrEqual(configname, CONFIG_STORE)) SetConfigArrays(configname, a_Store, TalentKeys, TalentValues, TalentSection, GetArraySize(a_Store), lastPosition - counter);
			else if (StrEqual(configname, CONFIG_TRAILS)) SetConfigArrays(configname, a_Trails, TalentKeys, TalentValues, TalentSection, GetArraySize(a_Trails), lastPosition - counter);
			else if (StrEqual(configname, CONFIG_CHATSETTINGS)) SetConfigArrays(configname, a_ChatSettings, TalentKeys, TalentValues, TalentSection, GetArraySize(a_ChatSettings), lastPosition - counter);
			else if (StrEqual(configname, CONFIG_WEAPONS)) SetConfigArrays(configname, a_WeaponDamages, TalentKeys, TalentValues, TalentSection, GetArraySize(a_WeaponDamages), lastPosition - counter);
			else if (StrEqual(configname, CONFIG_COMMONAFFIXES)) SetConfigArrays(configname, a_CommonAffixes, TalentKeys, TalentValues, TalentSection, GetArraySize(a_CommonAffixes), lastPosition - counter);
			
			lastPosition = i + 1;
		}
	}
	if (StrEqual(configname, CONFIG_POINTS)) {

		if (a_DirectorActions != INVALID_HANDLE) ClearArray(a_DirectorActions);
		a_DirectorActions			=	CreateArray(3);
		if (a_DirectorActions_Cooldown != INVALID_HANDLE) ClearArray(a_DirectorActions_Cooldown);
		a_DirectorActions_Cooldown	=	CreateArray(32);

		new size						=	GetArraySize(a_Points);
		new Handle:Keys					=	CreateArray(32);
		new Handle:Values				=	CreateArray(32);
		new Handle:Section				=	CreateArray(32);
		new sizer						=	0;

		for (new i = 0; i < size; i++) {

			Keys						=	GetArrayCell(a_Points, i, 0);
			Values						=	GetArrayCell(a_Points, i, 1);
			Section						=	GetArrayCell(a_Points, i, 2);

			new size2					=	GetArraySize(Keys);
			for (new ii = 0; ii < size2; ii++) {

				GetArrayString(Handle:Keys, ii, s_key, sizeof(s_key));
				GetArrayString(Handle:Values, ii, s_value, sizeof(s_value));

				if (StrEqual(s_key, "model?")) PrecacheModel(s_value, false);
				else if (StrEqual(s_key, "director option?") && StrEqual(s_value, "1")) {

					sizer				=	GetArraySize(a_DirectorActions);

					ResizeArray(a_DirectorActions, sizer + 1);
					SetArrayCell(a_DirectorActions, sizer, Keys, 0);
					SetArrayCell(a_DirectorActions, sizer, Values, 1);
					SetArrayCell(a_DirectorActions, sizer, Section, 2);
					ResizeArray(a_DirectorActions_Cooldown, sizer + 1);
					SetArrayString(a_DirectorActions_Cooldown, sizer, "0");						// 0 means not on cooldown. 1 means on cooldown. This resets every map.
				}
			}
		}
		// We only attempt connection to the database in the instance that there are no open connections.
		//if (hDatabase == INVALID_HANDLE) {

		//	MySQL_Init();
		//}
	}

	decl String:thetext[64];
	if (StrEqual(configname, CONFIG_MAIN) && !b_IsFirstPluginLoad) {

		b_IsFirstPluginLoad = true;
		if (hDatabase == INVALID_HANDLE) {

			MySQL_Init();
		}
		LoadMainConfig();

		GetConfigValue(thetext, sizeof(thetext), "rpg menu command?");

		new ExplodeCount = GetDelimiterCount(thetext, ",") + 1;
		decl String:t_Effects[ExplodeCount][64];
		ExplodeString(thetext, ",", t_Effects, ExplodeCount, 64);
		for (new i = 0; i < ExplodeCount; i++) {

			RegConsoleCmd(t_Effects[i], CMD_OpenRPGMenu);
		}

		GetConfigValue(thetext, sizeof(thetext), "drop weapon command?");
		RegConsoleCmd(thetext, CMD_DropWeapon);
		GetConfigValue(thetext, sizeof(thetext), "director talent command?");
		RegConsoleCmd(thetext, CMD_DirectorTalentToggle);
		GetConfigValue(thetext, sizeof(thetext), "rpg data erase?");
		RegConsoleCmd(thetext, CMD_DataErase);
		GetConfigValue(thetext, sizeof(thetext), "rpg bot data erase?");
		RegConsoleCmd(thetext, CMD_DataEraseBot);
		//GetConfigValue(thetext, sizeof(thetext), "give store points command?");
		//RegConsoleCmd(thetext, CMD_GiveStorePoints);
		GetConfigValue(thetext, sizeof(thetext), "give level command?");
		RegConsoleCmd(thetext, CMD_GiveLevel);
		GetConfigValue(thetext, sizeof(thetext), "chat tag naming command?");
		RegConsoleCmd(thetext, CMD_ChatTag);
		GetConfigValue(thetext, sizeof(thetext), "share points command?");
		RegConsoleCmd(thetext, CMD_SharePoints);
		/*GetConfigValue(thetext, sizeof(thetext), "toggle ammo command?");
		RegConsoleCmd(thetext, CMD_ToggleAmmo);
		GetConfigValue(thetext, sizeof(thetext), "cycle ammo forward command?");
		RegConsoleCmd(thetext, CMD_CycleForwardAmmo);
		GetConfigValue(thetext, sizeof(thetext), "cycle ammo backward command?");*/
		//RegConsoleCmd(thetext, CMD_CycleBackwardAmmo);
		GetConfigValue(thetext, sizeof(thetext), "buy menu command?");
		RegConsoleCmd(thetext, CMD_BuyMenu);
		RegConsoleCmd("collect", CMD_CollectBonusExperience);
		GetConfigValue(thetext, sizeof(thetext), "companion command?");
		RegConsoleCmd(thetext, CMD_CompanionOptions);
		GetConfigValue(thetext, sizeof(thetext), "load profile command?");
		RegConsoleCmd(thetext, CMD_LoadProfileEx);
		//RegConsoleCmd("backpack", CMD_Backpack);
	}

	if (StrEqual(configname, CONFIG_EVENTS)) SubmitEventHooks(1);
	ReadyUp_NtvGetHeader();

	if (StrEqual(configname, CONFIG_MAIN)) {

		GetConfigValue(thetext, sizeof(thetext), "item drop model?");
		PrecacheModel(thetext, true);
		GetConfigValue(thetext, sizeof(thetext), "backpack model?");
		PrecacheModel(thetext, true);
	}

	/*

		We need to preload an array full of all the positions of item drops.
		Faster than searching every time.
	*/
	if (StrEqual(configname, CONFIG_MENUTALENTS)) {

		ClearArray(ItemDropArray);
		new mySize = GetArraySize(a_Menu_Talents);
		new curSize= -1;
		new pos = 0;

		for (new i = 0; i <= iRarityMax; i++) {

			for (new j = 0; j < mySize; j++) {

				PreloadKeys				= GetArrayCell(a_Menu_Talents, j, 0);
				PreloadValues			= GetArrayCell(a_Menu_Talents, j, 1);
				if (GetKeyValueInt(PreloadKeys, PreloadValues, "is item?") == 1) {

					//PushArrayCell(ItemDropArray, i);
					if (GetKeyValueInt(PreloadKeys, PreloadValues, "rarity?") == i) {

						curSize = GetArraySize(ItemDropArray);
						if (pos == curSize) ResizeArray(ItemDropArray, curSize + 1);
						SetArrayCell(ItemDropArray, pos, j, i);
						pos++;
					}
				}
			}

			if (i == 0) Format(ItemDropArraySize, sizeof(ItemDropArraySize), "%d", pos);
			else Format(ItemDropArraySize, sizeof(ItemDropArraySize), "%s,%d", ItemDropArraySize, pos);
			pos = 0;
		}
	}
}

/*

	These specific variables can be called the same way, every time, so we declare them globally.
	These are all from the config.cfg (main config file)

	We don't load other variables in this way because they are dynamically loaded and unloaded.
*/
stock LoadMainConfig() {

	iHardcoreMode				= GetConfigValueInt("hardcore mode?");
	fDeathPenalty				= GetConfigValueFloat("death penalty?");
	iDeathPenaltyPlayers		= GetConfigValueInt("death penalty players required?");
	iTankRush					= GetConfigValueInt("tank rush?");
	iTanksAlways				= GetConfigValueInt("tanks always active?");
	
	fSprintSpeed				= GetConfigValueFloat("sprint speed?");
	iRPGMode					= GetConfigValueInt("rpg mode?");
	fTankMultiplier				= GetConfigValueFloat("director tanks player multiplier?");
	iTankPlayerCount			= GetConfigValueInt("director tanks per _ players?");
	DirectorWitchLimit			= GetConfigValueInt("director witch limit?");
	iCommonQueueLimit			= GetConfigValueInt("common queue limit?");
	fDirectorThoughtDelay		= GetConfigValueFloat("director thought process delay?");
	fDirectorThoughtHandicap	= GetConfigValueFloat("director thought process handicap?");
	iSurvivalRoundTime			= GetConfigValueInt("survival round time?");
	fDazedDebuffEffect			= GetConfigValueFloat("dazed debuff effect?");
	ConsumptionInt				= GetConfigValueInt("stamina consumption interval?");
	fStamSprintInterval			= GetConfigValueFloat("stamina sprint interval?");
	fStamRegenTime				= GetConfigValueFloat("stamina regeneration time?");
	fStamRegenTimeAdren			= GetConfigValueFloat("stamina regeneration time adren?");
	fBaseMovementSpeed			= GetConfigValueFloat("base movement speed?");
	fFatigueMovementSpeed		= GetConfigValueFloat("fatigue movement speed?");
	iPlayerStartingLevel		= GetConfigValueInt("new player starting level?");
	fOutOfCombatTime			= GetConfigValueFloat("out of combat time?");
	iWitchDamageInitial			= GetConfigValueInt("witch damage initial?");
	fWitchDamageScaleLevel		= GetConfigValueFloat("witch damage scale level?");
	fSurvivorDamageBonus		= GetConfigValueFloat("survivor damage bonus?");
	iEnrageTime					= GetConfigValueInt("enrage time?");
	fWitchDirectorPoints		= GetConfigValueFloat("witch director points?");
	fEnrageDirectorPoints		= GetConfigValueFloat("enrage director points?");
	fCommonDamageLevel			= GetConfigValueFloat("common damage scale level?");
	iBotLevelType				= GetConfigValueInt("infected bot level type?");
	fCommonDirectorPoints		= GetConfigValueFloat("common infected director points?");
	iDisplayHealthBars			= GetConfigValueInt("display health bars?");
	iMaxDifficultyLevel			= GetConfigValueInt("max difficulty level?");

	decl String:text[64], String:text2[64];
	for (new i = 0; i < 7; i++) {

		if (i == 6) {

			Format(text, sizeof(text), "(%d) damage player level?", i + 2);
			Format(text2, sizeof(text2), "(%d) infected health bonus", i + 2);
		}
		else {

			Format(text, sizeof(text), "(%d) damage player level?", i + 1);
			Format(text2, sizeof(text2), "(%d) infected health bonus", i + 1);
		}
		fDamagePlayerLevel[i]	= GetConfigValueFloat(text);
		fHealthPlayerLevel[i]	= GetConfigValueFloat(text2);
	}

	fPointsMultiplierInfected	= GetConfigValueFloat("points multiplier infected?");
	fPointsMultiplier			= GetConfigValueFloat("points multiplier survivor?");
	fHealingMultiplier			= GetConfigValueFloat("experience multiplier healing?");
	fBuffingMultiplier			= GetConfigValueFloat("experience multiplier buffing?");
	fHexingMultiplier			= GetConfigValueFloat("experience multiplier hexing?");

	TanksNearbyRange			= GetConfigValueFloat("tank nearby ability deactivate?");
	iCommonAffixes				= GetConfigValueInt("common affixes?");
	BroadcastType				= GetConfigValueInt("hint text type?");
	iDoomTimer					= GetConfigValueInt("doom kill timer?");
	iSurvivorStaminaMax			= GetConfigValueInt("survivor stamina?");

	fRatingMultSpecials			= GetConfigValueFloat("rating multiplier specials?");
	fRatingMultSupers			= GetConfigValueFloat("rating multiplier supers?");
	fRatingMultCommons			= GetConfigValueFloat("rating multiplier commons?");
	fRatingMultTank				= GetConfigValueFloat("rating multiplier tank?");
	fTeamworkExperience			= GetConfigValueInt("maximum teamwork experience?") * 1.0;
	fItemMultiplierLuck			= GetConfigValueFloat("buy item luck multiplier?");
	fItemMultiplierTeam			= GetConfigValueInt("buy teammate item multiplier?") * 1.0;

	GetConfigValue(sQuickBindHelp, sizeof(sQuickBindHelp), "quick bind help?");

	fPointsCostLevel			= GetConfigValueFloat("points cost increase per level?");
	PointPurchaseType			= GetConfigValueInt("points purchase type?");
	iTankLimitVersus			= GetConfigValueInt("versus tank limit?");
	fHealRequirementTeam		= GetConfigValueFloat("teammate heal health requirement?");
	iSurvivorBaseHealth			= GetConfigValueInt("survivor health?");

	GetConfigValue(spmn, sizeof(spmn), "sky points menu name?");

	fHealthSurvivorRevive		= GetConfigValueFloat("survivor revive health?");

	GetConfigValue(RestrictedWeapons, sizeof(RestrictedWeapons), "restricted weapons?");

	iMaxLevel					= GetConfigValueInt("max level?");
	iExperienceStart			= GetConfigValueInt("experience start?");
	fExperienceMultiplier		= GetConfigValueFloat("requirement multiplier?");

	GetConfigValue(sBotTeam, sizeof(sBotTeam), "survivor team?");

	iActionBarSlots				= GetConfigValueInt("action bar slots?");

	GetConfigValue(MenuCommand, sizeof(MenuCommand), "rpg menu command?");
	ReplaceString(MenuCommand, sizeof(MenuCommand), ",", " or ", true);

	HostNameTime				= GetConfigValueInt("display server name time?");

	DoomSUrvivorsRequired		= GetConfigValueInt("doom survivors ignored?");
	DoomKillTimer				= GetConfigValueInt("doom kill timer?");
	fVersusTankNotice			= GetConfigValueFloat("versus tank notice?");
	AllowedCommons				= GetConfigValueInt("common limit base?");
	AllowedMegaMob				= GetConfigValueInt("mega mob limit base?");
	AllowedMobSpawn				= GetConfigValueInt("mob limit base?");
	AllowedMobSpawnFinale		= GetConfigValueInt("mob finale limit base?");
	AllowedPanicInterval		= GetConfigValueInt("mega mob max interval base?");
	RespawnQueue				= GetConfigValueInt("survivor respawn queue?");
	MaximumPriority				= GetConfigValueInt("director priority maximum?");
	ConsMult					= GetConfigValueFloat("constitution ab multiplier?");
	AgilMult					= GetConfigValueFloat("agility ab multiplier?");
	ResiMult					= GetConfigValueFloat("resilience ab multiplier?");
	TechMult					= GetConfigValueFloat("technique ab multiplier?");
	EnduMult					= GetConfigValueFloat("endurance ab multiplier?");
	fUpgradeExpCost				= GetConfigValueFloat("upgrade experience cost?");
	iHandicapLevelDifference	= GetConfigValueInt("handicap level difference required?");
	iWitchHealthBase			= GetConfigValueInt("base witch health?");
	fWitchHealthMult			= GetConfigValueFloat("level witch multiplier?");
	//RatingPerLevel				= GetConfigValueInt("rating level multiplier?");
	iCommonBaseHealth			= GetConfigValueInt("common base health?");
	fCommonRaidHealthMult		= GetConfigValueFloat("common raid health multiplier?");
	fCommonLevelHealthMult		= GetConfigValueFloat("common level health?");
	//iServerLevelRequirement		= GetConfigValueInt("server level requirement?");
	iRoundStartWeakness			= GetConfigValueInt("weakness on round start?");
	GroupMemberBonus			= GetConfigValueFloat("steamgroup bonus?");

	RaidLevMult					= GetConfigValueInt("raid level multiplier?");
	iTrailsEnabled				= GetConfigValueInt("trails enabled?");
	iInfectedLimit				= GetConfigValueInt("ensnare infected limit?");

	SurvivorExperienceMult		= GetConfigValueFloat("experience multiplier survivor?");
	SurvivorExperienceMultTank	= GetConfigValueFloat("experience multiplier tanking?");
	SurvivorExperienceMultHeal	= GetConfigValueFloat("experience multiplier healing?");
	fDamageContribution			= GetConfigValueFloat("damage contribution?");
	TheScorchMult				= GetConfigValueFloat("scorch multiplier?");
	TheInfernoMult				= GetConfigValueFloat("inferno multiplier?");
	fAmmoHighlightTime			= GetConfigValueFloat("special ammo highlight time?");
	fAdrenProgressMult			= GetConfigValueFloat("adrenaline progress multiplier?");
	DirectorTankCooldown		= GetConfigValueFloat("director tank cooldown?");
	DisplayType					= GetConfigValueInt("survivor reward display?");
	GetConfigValue(sDirectorTeam, sizeof(sDirectorTeam), "director team name?");
	fRestedExpMult				= GetConfigValueFloat("rested experience multiplier?");
	fSurvivorExpMult			= GetConfigValueFloat("survivor experience bonus?");
	iIsPvpServer				= GetConfigValueInt("pvp server?");
	iDebuffLimit				= GetConfigValueInt("debuff limit?");
	iRatingSpecialsRequired		= GetConfigValueInt("specials rating required?");
	iRatingTanksRequired		= GetConfigValueInt("tank rating required?");
	GetConfigValue(sDbLeaderboards, sizeof(sDbLeaderboards), "db record?");
	iIsLifelink					= GetConfigValueInt("lifelink enabled?");
	RatingPerHandicap			= GetConfigValueInt("rating level handicap?");

	GetConfigValue(sItemModel, sizeof(sItemModel), "item drop model?");

	fDropChanceSpecial			= GetConfigValueFloat("item chance supers?");
	fDropChanceCommon			= GetConfigValueFloat("item chance commons?");
	fDropChanceWitch			= GetConfigValueFloat("item chance witch?");
	fDropChanceTank				= GetConfigValueFloat("item chance tank?");
	fDropChanceInfected			= GetConfigValueFloat("item chance infected?");
	iDropsEnabled				= GetConfigValueInt("item drop enabled?");

	iItemExpireDate				= GetConfigValueInt("item expire date?");
	iRarityMax					= GetConfigValueInt("item rarity max?");

	iEnrageAdvertisement		= GetConfigValueInt("enrage advertise time?");
	iNotifyEnrage				= GetConfigValueInt("enrage notification?");

	GetConfigValue(sBackpackModel, sizeof(sBackpackModel), "backpack model?");

	iSurvivorGroupMinimum		= GetConfigValueInt("group member minimum?");

	fBurnPercentage				= GetConfigValueFloat("burn debuff percentage?");
	iSuperCommonLimit			= GetConfigValueInt("super common limit?");
	iCommonsLimitUpper			= GetConfigValueInt("commons limit max?");

	FinSurvBon					= GetConfigValueFloat("finale survival bonus?");
	fCoopSurvBon 				= GetConfigValueFloat("coop round survival bonus?");

	LogMessage("Main Config Loaded.");
}

//public Action:CMD_Backpack(client, args) { EquipBackpack(client); return Plugin_Handled; }

public Action:CMD_BuyMenu(client, args) {

	if (iRPGMode < 0 || iRPGMode == 1) return Plugin_Handled;

	//if (StringToInt(GetConfigValue("rpg mode?")) != 1) 
	BuildPointsMenu(client, "Buy Menu", "rpg/points.cfg");
	
	return Plugin_Handled;
}

public Action:CMD_ToggleAmmo(client, args) {

	if (HasSpecialAmmo(client) && !bIsSurvivorFatigue[client]) {

		if (IsSpecialAmmoEnabled[client][0] == 1.0) {

			IsSpecialAmmoEnabled[client][0] = 0.0;
			//LastTarget[client] = -1;
			PrintToChat(client, "%T", "Special Ammo Disabled", client, white, orange);
		}
		else {

			IsSpecialAmmoEnabled[client][0] = 1.0;
			PrintToChat(client, "%T", "Special Ammo Enabled", client, white, green);
		}
	}
	else {

		//	If the user doesn't have special ammo...
		PrintToChat(client, "%T", "No Special Ammo", client, white, orange, white);
		IsSpecialAmmoEnabled[client][0] = 0.0;
	}
	return Plugin_Handled;
}

public Action:CMD_CycleForwardAmmo(client, args) {

	if (HasSpecialAmmo(client) && !bIsSurvivorFatigue[client]) CycleSpecialAmmo(client, true);
	return Plugin_Handled;
}

public Action:CMD_CycleBackwardAmmo(client, args) {

	if (HasSpecialAmmo(client) && !bIsSurvivorFatigue[client]) CycleSpecialAmmo(client, false);
	return Plugin_Handled;
}

public Action:CMD_DataErase(client, args) {

	decl String:arg[MAX_NAME_LENGTH];
	decl String:thetext[64];
	GetConfigValue(thetext, sizeof(thetext), "delete bot flags?");

	if (args > 0 && HasCommandAccess(client, thetext)) {

		GetCmdArg(1, arg, sizeof(arg));
	
		new targetclient = FindTargetClient(client, arg);
		if (IsLegitimateClient(targetclient) && GetClientTeam(targetclient) != TEAM_INFECTED) DeleteAndCreateNewData(targetclient);
	}
	else DeleteAndCreateNewData(client);
	return Plugin_Handled;
}


public Action:CMD_DataEraseBot(client, args) {

	DeleteAndCreateNewData(client, true);
	return Plugin_Handled;
}

stock DeleteAndCreateNewData(client, bool:IsBot = false) {

	decl String:thetext[64];
	GetConfigValue(thetext, sizeof(thetext), "database prefix?");

	decl String:key[64];
	decl String:tquery[1024];
	decl String:text[64];
	decl String:pct[4];
	Format(pct, sizeof(pct), "%");

	if (!IsBot) {
	
		GetClientAuthString(client, key, sizeof(key));
		Format(tquery, sizeof(tquery), "DELETE FROM `%s` WHERE `steam_id` = '%s';", thetext, key);
		SQL_TQuery(hDatabase, QueryResults, tquery, client);

		new size = GetArraySize(a_ClassNames);
		for (new i = 0; i < size; i++) {

			GetArrayString(a_ClassNames, i, text, sizeof(text));
			Format(tquery, sizeof(tquery), "DELETE FROM `%s` WHERE `steam_id` LIKE '%s%s%s%s';", thetext, pct, key, text, pct);
			SQL_TQuery(hDatabase, QueryResults, tquery, client);
		}
		ResetData(client);
		CreateNewPlayerEx(client);

		PrintToChat(client, "data erased, new data created.");	// not bothering with a translation here, since it's a debugging command.
	}
	else {

		GetConfigValue(text, sizeof(text), "delete bot flags?");
		if (HasCommandAccess(client, text)) {

			for (new i = 1; i <= MaxClients; i++) {

				if (IsSurvivorBot(i)) KickClient(i);
			}

			GetConfigValue(key, sizeof(key), "survivor team?");
			Format(tquery, sizeof(tquery), "DELETE FROM `%s` WHERE `steam_id` LIKE '%s%s%s';", thetext, pct, key, pct);
			LogMessage(tquery);
			SQL_TQuery(hDatabase, QueryResults, tquery, client);

			PrintToChatAll("%t", "bot data deleted", orange, blue);
		}
	}
}

public Action:CMD_DirectorTalentToggle(client, args) {

	decl String:thetext[64];
	GetConfigValue(thetext, sizeof(thetext), "director talent flags?");

	if (HasCommandAccess(client, thetext)) {

		if (b_IsDirectorTalents[client]) {

			b_IsDirectorTalents[client]			= false;
			PrintToChat(client, "%T", "Director Talents Disabled", client, white, green);
		}
		else {

			b_IsDirectorTalents[client]			= true;
			PrintToChat(client, "%T", "Director Talents Enabled", client, white, green);
		}
	}

	return Plugin_Handled;
}

stock SetConfigArrays(String:Config[], Handle:Main, Handle:Keys, Handle:Values, Handle:Section, size, last) {

	decl String:text[64];
	//GetArrayString(Section, 0, text, sizeof(text));

	new Handle:TalentKey = CreateArray(32);
	new Handle:TalentValue = CreateArray(32);
	new Handle:TalentSection = CreateArray(32);

	decl String:key[64];
	decl String:value[64];
	new a_Size = GetArraySize(Keys);

	for (new i = last; i < a_Size; i++) {

		GetArrayString(Handle:Keys, i, key, sizeof(key));
		GetArrayString(Handle:Values, i, value, sizeof(value));

		PushArrayString(TalentKey, key);
		PushArrayString(TalentValue, value);
	}

	GetArrayString(Handle:Section, size, text, sizeof(text));
	PushArrayString(TalentSection, text);

	if (StrEqual(Config, CONFIG_MENUTALENTS)) PushArrayString(a_Database_Talents, text);

	ResizeArray(Main, size + 1);
	SetArrayCell(Main, size, TalentKey, 0);
	SetArrayCell(Main, size, TalentValue, 1);
	SetArrayCell(Main, size, TalentSection, 2);
}

public ReadyUp_FwdGetHeader(const String:header[]) {

	strcopy(s_rup, sizeof(s_rup), header);
}

public ReadyUp_FwdGetCampaignName(const String:mapname[]) {

	strcopy(currentCampaignName, sizeof(currentCampaignName), mapname);
}

public ReadyUp_CoopMapFailed(iGamemode) {

	if (!b_IsMissionFailed) {

		b_IsMissionFailed	= true;
		Points_Director = 0.0;
	}
}

stock bool:IsCommonRegistered(entity) {

	if (FindListPositionByEntity(entity, Handle:CommonList) >= 0 ||
		FindListPositionByEntity(entity, Handle:CommonInfected) >= 0) return true;
	return false;
}

stock bool:IsSpecialCommon(entity) {

	if (FindListPositionByEntity(entity, Handle:CommonList) >= 0) {

		if (IsCommonInfected(entity)) return true;
		else ClearSpecialCommon(entity, false);
	}
	return false;
}

/*stock FindClientWithAuth(authid) {

	decl String:AuthString[64];
	decl String:AuthComp[64];

	for (new i = 1; i <= MaxClients; i++) {
		
		if (!IsLegitimateClient(i)) continue;

		GetClientAuthId(i, AuthIdType:AuthId_Steam3, AuthString, 64);
		IntToString(authid, AuthComp, sizeof(AuthComp));

		if (StrContains(AuthString, AuthComp) != -1) return i;
	}
	return -1;
}*/

//GetClientAuthId(client, AuthIdType:AuthId_Steam3, String:AuthString, maxlen, bool:validate=true);

#include "rpg/rpg_menu.sp"
#include "rpg/rpg_menu_points.sp"
#include "rpg/rpg_menu_store.sp"
#include "rpg/rpg_menu_chat.sp"
#include "rpg/rpg_menu_director.sp"
#include "rpg/rpg_timers.sp"
#include "rpg/rpg_functions.sp"
#include "rpg/rpg_events.sp"
#include "rpg/rpg_database.sp"