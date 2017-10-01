/*
Group Teleport Action Script

Allows group leaders to select a location on the map during safestart. 
Once safestart is over, they and their group are teleported to this location. 

by Professor Cupcake
*/

if (isDedicated) exitWith {};

GTP_markerList = [];

{
	if (_x select [0, 3] == "gtp_") then
	{
		GTP_markerList pushBack _x;
	}
} forEach allMapMarkers;

waitUntil {player == player};

GTP_action = player addAction ["<t color='#ffff00>'Select Start Position</t>", "scripts\group_teleport\selectPosition.sqf", nil, 1.5, false, true, "", "((leader player == player) && (f_var_mission_timer > 0))"]