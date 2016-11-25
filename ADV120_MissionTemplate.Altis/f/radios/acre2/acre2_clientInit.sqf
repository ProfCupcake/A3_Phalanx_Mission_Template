// F3 - ACRE Clientside Initialisation
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS

private ["_presetName","_ret","_unit"];
f_var_debugMode = 0;

// ====================================================================================

// Set up the radio presets according to side.
_presetName = switch(side player) do {
	case west:{"default2"};
	case east:{"default3"};
	case resistance:{"default4"};
	default {"default"};
};
if (f_radios_settings_acre2_disableFrequencySplit) then {
	_presetName = "default";
};

_ret = ["ACRE_PRC343", _presetName ] call acre_api_fnc_setPreset;
_ret = ["ACRE_PRC148", _presetName ] call acre_api_fnc_setPreset;
_ret = ["ACRE_PRC152", _presetName ] call acre_api_fnc_setPreset;
_ret = ["ACRE_PRC117F", _presetName ] call acre_api_fnc_setPreset;
_ret = ["ItemRadio", _presetName ] call acre_api_fnc_setPreset;


// if dead, set spectator and exit
if(!alive player) exitWith {[true] call acre_api_fnc_setSpectator;};

// ====================================================================================

// Set language of the units depending on side (BABEL API)
switch (side player) do {
	case blufor: {
		f_radios_settings_acre2_language_blufor call acre_api_fnc_babelSetSpokenLanguages;
		[f_radios_settings_acre2_language_blufor select 0] call acre_api_fnc_babelSetSpeakingLanguage;
	};
	case opfor: {
		f_radios_settings_acre2_language_opfor call acre_api_fnc_babelSetSpokenLanguages;
		[f_radios_settings_acre2_language_opfor select 0] call acre_api_fnc_babelSetSpeakingLanguage;
	};
	case independent: {
		f_radios_settings_acre2_language_indfor call acre_api_fnc_babelSetSpokenLanguages;
		[f_radios_settings_acre2_language_indfor select 0] call acre_api_fnc_babelSetSpeakingLanguage;
	};
	default {
		f_radios_settings_acre2_language_indfor call acre_api_fnc_babelSetSpokenLanguages;
		[f_radios_settings_acre2_language_indfor select 0] call acre_api_fnc_babelSetSpeakingLanguage;
	};
};

// ====================================================================================

// RADIO ASSIGNMENT

// Wait for gear assignation to take place
waitUntil{(missionNamespace getVariable ["phx_loadoutAssigned", false])};
if (f_var_debugMode == 1) then {
	hint format["DEBUG (f\radios\acre2\acre2_clientInit.sqf): phx_loadoutAssigned is set."];
};
private _char = toLower (typeOf player);

// REMOVE ALL RADIOS
// Wait for ACRE2 to initialise any radios the unit has in their inventory, and then
// remove them to ensure that duplicate radios aren't added by accident.
if (f_var_debugMode == 1) then {
	hint format["DEBUG (f\radios\acre2\acre2_clientInit.sqf): Checking No ItemRadio in inventory."];
};
waitUntil{uiSleep 0.3; !("ItemRadio" in (items player + assignedItems player))};
uiSleep 1;
if (f_var_debugMode == 1) then {
	hint format["DEBUG (f\radios\acre2\acre2_clientInit.sqf): No ItemRadio in inventory."];
};

waitUntil{[] call acre_api_fnc_isInitialized};
if (f_var_debugMode == 1) then {
	hint format["DEBUG (f\radios\acre2\acre2_clientInit.sqf): ACRE isInitialized passed."];
};
{player removeItem _x;} forEach ([] call acre_api_fnc_getCurrentRadioList);
// ====================================================================================

// ASSIGN RADIOS TO UNITS
// Depending on the loadout used in the assignGear component, each unit is assigned
// a set of radios.

if(_char != "NIL") then {

	// If radios are enabled in the settings
	if(!f_radios_settings_acre2_disableRadios) then {
		// Everyone gets a short-range radio by default
		if(isnil "f_radios_settings_acre2_shortRange") then {
			if (player canAdd f_radios_settings_acre2_standardSHRadio) then {
				player addItem f_radios_settings_acre2_standardSHRadio;
			} else {
				f_radios_settings_acre2_standardSHRadio call f_radios_acre2_giveRadioAction;
			};
		} else {
			if(_char in f_radios_settings_acre2_shortRange) then {
				if (player canAdd f_radios_settings_acre2_standardSHRadio) then {
					player addItem f_radios_settings_acre2_standardSHRadio;
				} else {
					f_radios_settings_acre2_standardSHRadio call f_radios_acre2_giveRadioAction;
				};
			};
		};

		// If unit is in the above list, add a 148
		if(_char in f_radios_settings_acre2_longRange) then {
			if (player canAdd f_radios_settings_acre2_standardLRRadio) then {
				player addItem f_radios_settings_acre2_standardLRRadio;
			} else {
				f_radios_settings_acre2_standardLRRadio call f_radios_acre2_giveRadioAction;
			};
		};
			// If unit is in the list of units that receive an extra long-range radio, add another 148
		if(_char in f_radios_settings_acre2_extraRadios) then {
			if (player canAdd f_radios_settings_acre2_extraRadio) then {
				player addItem f_radios_settings_acre2_extraRadio;
			} else {
				f_radios_settings_acre2_extraRadio call f_radios_acre2_giveRadioAction;
			};
		};
	};
};

// ====================================================================================

// ASSIGN DEFAULT CHANNELS TO RADIOS
// Depending on the squad joined, each radio is assigned a default starting channel

if(!f_radios_settings_acre2_disableRadios) then {

	private ["_presetArray","_presetLRArray","_radioSR","_radioLR","_radioExtra","_hasSR","_hasLR","_hasExtra","_groupID","_groupIDSplit","_groupChannelIndex","_groupLRChannelIndex","_groupName"];

	waitUntil {uiSleep 0.1; [] call acre_api_fnc_isInitialized};
	if (f_var_debugMode == 1) then {
		hint format["DEBUG (f\radios\acre2\acre2_clientInit.sqf): ACRE isInitialized passed."];
	};

	/*private _channelID = "TaskForceRadio";
	private _channelPassword = "123";
	[_channelID, _channelPassword] call acre_api_fnc_joinChannel;
	if (f_var_debugMode == 1) then {
		hint format["DEBUG (f\radios\acre2\acre2_clientInit.sqf): joinChannel passed."];
	};*/

	_presetArray = switch (side player) do {
		case blufor: {f_radios_settings_acre2_sr_groups_blufor};
  	case opfor: {f_radios_settings_acre2_sr_groups_opfor};
  	case independent: {f_radios_settings_acre2_sr_groups_indfor};
  	default {f_radios_settings_acre2_sr_groups_indfor};
	};

	_presetLRArray = switch (side player) do {
		case blufor: {f_radios_settings_acre2_lr_groups_blufor};
  	case opfor: {f_radios_settings_acre2_lr_groups_opfor};
  	case independent: {f_radios_settings_acre2_lr_groups_indfor};
		default {f_radios_settings_acre2_lr_groups_indfor};
	};

	_radioSR = [f_radios_settings_acre2_standardSHRadio] call acre_api_fnc_getRadioByType;
	_radioLR = [f_radios_settings_acre2_standardLRRadio] call acre_api_fnc_getRadioByType;
	_radioExtra = [f_radios_settings_acre2_extraRadio] call acre_api_fnc_getRadioByType;

	_hasSR = ((!isNil "_radioSR") && {_radioSR != ""});
	_hasLR = ((!isNil "_radioLR") && {_radioLR != ""});
	_hasExtra = ((!isNil "_radioExtra") && {_radioExtra != ""});

	_groupID = groupID (group player);
	//_groupIDSplit = [_groupID, " "] call bis_fnc_splitString;

	_groupChannelIndex = -1;
	_groupLRChannelIndex = -1;

	//if ((count _groupIDSplit) > 2) then {
	_groupName = _groupID;//toUpper (_groupIDSplit select (count _groupIDSplit - 2));

	if (_hasSR) then {
	  	{
	  		if (_groupName in (_x select 1)) exitWith { _groupChannelIndex = _forEachIndex; };
	  	} forEach _presetArray;
  	};

  	if (_hasLR || _hasExtra) then {
	  	{
	  		if (_groupName in (_x select 1)) exitWith { _groupLRChannelIndex = _forEachIndex; };
	  	} forEach _presetLRArray;
  	};
	//};

	if (_groupChannelIndex == -1 && {_hasSR}) then {
		hint format["[F3 ACRE2] Warning: Unknown group for short-range channel defaults (%1)", _groupID];
		_groupChannelIndex = 0;
	};

	if (_groupLRChannelIndex == -1 && {(_hasLR || _hasExtra)}) then {
		hint format["[F3 ACRE2] Warning: Unknown group for long-range channel defaults (%1)", _groupID];
  	_groupLRChannelIndex = 0;
	};

	if (_hasSR) then {
		if (f_var_debugMode == 1) then
		{
			hint format["DEBUG (f\radios\acre2\acre2_clientInit.sqf): Setting radio channel for '%1' to %2", _radioSR, _groupChannelIndex + 1];
		};
	    [_radioSR, (_groupChannelIndex + 1)] call acre_api_fnc_setRadioChannel;
	};

	if (_hasLR) then {
		if (f_var_debugMode == 1) then
		{
			hint format["DEBUG (f\radios\acre2\acre2_clientInit.sqf): Setting radio channel for '%1' to %2", _radioLR, _groupLRChannelIndex + 1];
		};
	    [_radioLR, (_groupLRChannelIndex + 1)] call acre_api_fnc_setRadioChannel;
	};

	if (_hasExtra) then {
		if (f_var_debugMode == 1) then
		{
			hint format["DEBUG (f\radios\acre2\acre2_clientInit.sqf): Setting radio channel for '%1' to %2", _radioExtra, _groupLRChannelIndex + 1];
		};
	    [_radioExtra, (_groupLRChannelIndex + 1)] call acre_api_fnc_setRadioChannel;
	};

};
