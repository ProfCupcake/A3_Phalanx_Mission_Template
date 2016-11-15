/*
    Sets the default clothing items for a side. If you want to have a certain class of unit have a unique clothing item, redefine these variables in that class's loadout script above the call to 'phx_fnc_loadout_handleClothing'.

    If the values are not redefined, the values in this file will be used.
*/

private _uniform = ["phx_loadout_blufor_uniform",0] call BIS_fnc_getParamValue;
_uniform = switch (_uniform) do {
    case 0: { // US MARPAT WD
        phx_loadout_uniform = "rhs_uniform_FROG01_wd";
        phx_loadout_vest = "rhsusf_spc_rifleman";
        phx_loadout_backpack = "rhsusf_assault_eagleaiii_coy";
        phx_loadout_headgear = "rhsusf_lwh_helmet_marpatwd";
    };
    case 1: {
        phx_loadout_uniform = "rhs_uniform_FROG01_wd";
        phx_loadout_vest = "rhsusf_spc_rifleman";
        phx_loadout_backpack = "rhsusf_assault_eagleaiii_coy";
        phx_loadout_headgear = "rhsusf_lwh_helmet_marpatwd";
    };
    default {
        phx_loadout_uniform = "rhs_uniform_FROG01_wd";
        phx_loadout_vest = "rhsusf_spc_rifleman";
        phx_loadout_backpack = "rhsusf_assault_eagleaiii_coy";
        phx_loadout_headgear = "rhsusf_lwh_helmet_marpatwd";
    };
};
