// Add clothing
player forceAddUniform "U_O_CombatUniform_ocamo";
player addVest "V_PlateCarrier1_blk";
player addBackpack "B_TacticalPack_ocamo";
player addHeadgear "H_HelmetO_ocamo";

// Add gear
for "_i" from 1 to 2 do {player addItemToUniform "FirstAidKit";};
for "_i" from 1 to 4 do {player addItemToUniform "SmokeShell";};
for "_i" from 1 to 2 do {player addItemToVest "HandGrenade";};
for "_i" from 1 to 2 do {player addItemToBackpack "150Rnd_93x64_Mag";};
player addWeapon "MMG_01_hex_F";
player removeWeapon "Binocular";

// Add items
if (phx_loadout_map isEqualTo 0) then {
    ["ItemMap"] call phx_fnc_loadout_addItem;
    if (phx_loadout_gps isEqualTo 0) then {
        ["ItemGPS"] call phx_fnc_loadout_addItem;
    } else {player unlinkItem "ItemGPS";};
} else {player unlinkItem "ItemMap";player unlinkItem "ItemGPS";};
if (phx_loadout_radio isEqualTo 0) then {
    ["ItemRadio"] call phx_fnc_loadout_addItem;
} else {player unlinkItem "ItemRadio";};

missionNamespace setVariable ["phx_loadoutAssigned",true]; //Place this at the end of the loadout script so other scripts can tell when the player's loadout has been set.
