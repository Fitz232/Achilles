////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	AUTHOR: Kex
//	DATE: 20/11/16
//	VERSION: 1.0
//	FILE: Achilles\ui_f\functions\keyEvents\fn_HandleCuratorObjectEdited.sqf
//  DESCRIPTION: Executes when curator editable object is moved or rotated
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define UNITARY_BASIS_CORRECTION_TRANSPOSED [[-1,0,0],[0,0,-1],[0,1,0]]

_handled_object = param [1,objNull,[objNull]];

if (isNull _handled_object) exitWith {};

// if object is a center object of a group => correct position and orientation for other objects of the group
_group_attributes = _handled_object getVariable ["Achilles_var_groupAttributes",nil];
if (not isNil "_group_attributes") then
{
	_center_pos = getPosWorld _handled_object;
	
	// define internal basis
	_vector_dir = vectorDir _handled_object;
	_vector_up =  vectorUp _handled_object;
	_vector_perpendicular = _vector_dir vectorCrossProduct _vector_up;

	// define transformation matrix
	_internal_to_standard = [_vector_dir, _vector_up, _vector_perpendicular];
	
	{
		_object = _x select 0;
		
		// reposition
		private _tmp = [_internal_to_standard, _x select 1] call Achilles_fnc_vectorMap;
		_vector_center_object = [UNITARY_BASIS_CORRECTION_TRANSPOSED, _tmp] call Achilles_fnc_vectorMap;
		_object setPosWorld (_vector_center_object vectorAdd _center_pos);
		
		// reorientation
		_vectors_dir_up = (_x select [2,2]) apply 
		{
			private _tmp = [_internal_to_standard, _x] call Achilles_fnc_vectorMap;
			_return = [UNITARY_BASIS_CORRECTION_TRANSPOSED, _tmp] call Achilles_fnc_vectorMap;
			_return;
		};
		if (local _object) then
		{
			_object setVectorDirAndUp _vectors_dir_up;
		} else
		{
			[_object ,_vectors_dir_up] remoteExec ["setVectorDirAndUp",_object];
		};	
	} forEach _group_attributes;
};