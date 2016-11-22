///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	AUTHOR: Kex
//	DATE: 11/20/16
//	VERSION: 1.0
//	FILE: Achilles\functions_f_achilles\features\fn_ungroupObjects.sqf
//  DESCRIPTION: Ungroup a group of objects if center object is in input array
//
//	ARGUMENTS:
//	_this select 0:			ARRAY	- array of objects
//
//	RETURNS:
//	nothing (procedure)
//
//	Example:
//	[_center_object_1,_center_object_2,_center_object_3] call Achilles_fnc_ungroupObjects;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

_object_list = param [0,[],[[]]];

if (count _object_list == 0) exitWith {};

{
	_center_object = _x;
	_group_attributes = _center_object getVariable ["Achilles_var_groupAttributes",nil];
	if (not isNil "_group_attributes") then
	{
		[_group_attributes apply {_x select 0}, true] call Ares_fnc_AddUnitsToCurator;
		_center_object setVariable ["Achilles_var_groupAttributes",nil];
	};
} forEach _object_list;