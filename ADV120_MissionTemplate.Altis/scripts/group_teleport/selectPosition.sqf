/*
Handles the action for selecting the group's teleport position
*/

GTP_positionCheck = 
{
	_return = false;
	{
		if (_this inArea _x) exitWith {_return = true};
	} forEach GTP_markerList;
	_return
}

GTP_clickEventHandler = 
{
	_pos = _this select 1;
	if (_pos call GTP_positionCheck) then
	{
		GTP_selectedPosition = _pos;
		hint "Position selected.";
		openMap false;
		["GTP_clickEvent", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	} else
	{
		hint "You're not allowed to start there.";
	}
}

["GTP_clickEvent", "onMapSingleClick", GTP_clickEventHandler, nil] call BIS_fnc_addStackedEventHandler;

openMap true;

hint "Click on your desired start location.";

