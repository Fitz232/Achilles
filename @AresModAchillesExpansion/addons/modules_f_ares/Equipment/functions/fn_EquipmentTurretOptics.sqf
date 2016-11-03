////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	AUTHOR: Kex
//	DATE: 11/1/16
//	VERSION: 1.0
//	FILE: achilles\modules_f_ares\Equipment\functions\fn_EquipmentTurretOptics.sqf
//  DESCRIPTION: Module for toggling turret optics
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#include "\achilles\modules_f_ares\module_header.hpp"

private ["_vehicles","_NVG","_thermals"];
_unitUnderCursor = [_logic, false] call Ares_fnc_GetUnitUnderCursor;

if (isNull _unitUnderCursor) then
{
	// select players
	_dialogResult = [
		localize "STR_ADD_REMOVE_TURRET_OPTICS",
		[ 
			[localize "STR_MODE",[localize "STR_ALL",localize "STR_SELECTION",localize "STR_SIDE"]],
			[localize "STR_SIDE","SIDE"],
			[localize "STR_NVD",[localize "STR_UNCHANGED",localize "STR_AVAILABLE",localize "STR_UNAVAILABLE"]],
			[localize "STR_THERMALS",[localize "STR_UNCHANGED",localize "STR_AVAILABLE",localize "STR_UNAVAILABLE"]]
		],
		"Achilles_fnc_RscDisplayAttributes_selectAIUnits"
	] call Ares_fnc_ShowChooseDialog;
	
	if (count _dialogResult == 0) exitWith {};
	
	_vehicles = switch (_dialogResult select 0) do
	{
		case 0:
		{
			vehicles select {alive _x};
		};
		case 1: 
		{
			_selection = [toLower localize "STR_OBJECTS"] call Achilles_fnc_SelectUnits;
			if (isNil "_selection") exitWith {nil};
			_selection select {alive _x};
		};
		case 2: 
		{
			_side_index = _dialogResult select 1;
			_side = [east,west,independent,civilian] select (_side_index - 1);
			vehicles select {(alive _x) and (side _x == _side)};
		};
	};

	if (count _vehicles == 0) exitWith 
	{
		[localize "STR_NO_OBJECT_SELECTED"] call Ares_fnc_ShowZeusMessage; 
		playSound "FD_Start_F";
	};
	_NVG = [nil,false,true] select (_dialogResult select 2);
	_thermals = [nil,false,true] select (_dialogResult select 3);
}
else
{
	_dialogResult = 
	[
		localize "STR_ADD_REMOVE_TURRET_OPTICS",
		[
			[localize "STR_NVG",[localize "STR_UNCHANGED",localize "STR_AVAILABLE",localize "STR_UNAVAILABLE"]],
			[localize "STR_THERMALS",[localize "STR_UNCHANGED",localize "STR_AVAILABLE",localize "STR_UNAVAILABLE"]]
		]
	] call Ares_fnc_ShowChooseDialog;
	
	if (count _dialogResult == 0) exitWith {};
	_vehicles = [_unitUnderCursor];
	_NVG = [nil,false,true] select (_dialogResult select 0);
	_thermals = [nil,false,true] select (_dialogResult select 1);
};

if (isNil "_vehicles") exitWith {};
{
	if (not isNil "_NVG") then {_x disableNVGEquipment _NVG};
	if (not isNil "_thermals") then {_x disableTIEquipment _thermals};
} forEach _vehicles;

[localize "STR_APPLIED_MODULE_TO_X_OBJECTS", count _vehicles] call Ares_fnc_ShowZeusMessage;

#include "\achilles\modules_f_ares\module_footer.hpp"

