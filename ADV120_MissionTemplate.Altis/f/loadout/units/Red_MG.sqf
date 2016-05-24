removeAllWeapons player;
removeAllItems player;
removeAllAssignedItems player;
removeUniform player;
removeVest player;
removeBackpack player;
removeHeadgear player;
removeGoggles player;

player forceAddUniform "CUP_U_O_CHDKZ_Kam_02";
for "_i" from 1 to 2 do {player addItemToUniform "FirstAidKit";};
player addVest "CUP_V_BAF_Osprey_Mk2_DPM_Scout";
for "_i" from 1 to 2 do {player addItemToVest "HandGrenade";};
for "_i" from 1 to 4 do {player addItemToVest "SmokeShell";};
player addBackpack "CUP_B_CivPack_WDL";
for "_i" from 1 to 3 do {player addItemToBackpack "CUP_100Rnd_TE4_LRT4_762x54_PK_Tracer_Green_M";};
player addHeadgear "CUP_H_SLA_Helmet";

player addWeapon "CUP_lmg_PKM";
removeAllPrimaryWeaponItems player;

if (s_loadout_map == 0) then {
    player linkItem "ItemMap";
    if (s_loadout_gps == 0) then {player linkItem "ItemGPS";};
};
player linkItem "ItemCompass";
player linkItem "ItemWatch";
if (s_loadout_radio == 0) then {
    player linkItem "ItemRadio";
};

missionNamespace setVariable ["phx_loadoutAssigned",true]; //Place this at the end of the loadout script so other scripts can tell when the player's loadout has been set.
