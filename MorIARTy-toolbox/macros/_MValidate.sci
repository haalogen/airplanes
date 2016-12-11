//////////////////////////////////////////////////
// MorIARTy - Morphological Image Analysis and Recognition Toolbox
// Copyright (C) 2016  MorIARTy Team
//
// Authors:
//  Andrey Zubyuk
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//////////////////////////////////////////////////

function ok = _MValidate(data, datatype, arg3, fieldtype, arg5)
// Helper function. Validates the arguments.
//
// Parameters
//  data: Data to validate.
//  datatype: Expected data type.
//  arg3: A field name for structures or a list of possible values for the others (optional).
//  fieldtype: Expected field type (optional).
//  arg5: A list of possible field values (optional).
//  ok: Validation result — %t (true) if validation is successful.
//
// Description
//  TODO

    if argn(2) < 2 then
        error("At least 2 arguments expected.");
    end
    if exists("arg3") then
        if type(arg3) == 10 then
            field = arg3;
        elseif type(arg3) == 15 then
            values = arg3;
        else
            error("Incorrect 3-rd argument.");
        end
    end
    if datatype == "struct" & exists("arg5") then
        values = arg5;
    end

    t = type(data);
    ok = %f;

    if datatype == "double" then
        _MDebug("double");
        ok = t == 1 | t == 17;
    elseif datatype == "double scalar" then
        _MDebug("double scalar");
        ok = t == 1 & isscalar(data);
    elseif datatype == "double vector" then
        _MDebug("double vector");
        ok = t == 1 & (isvector(data) | isscalar(data));
    elseif datatype == "int" then
        _MDebug("int");
        ok = t == 8;
        if ~ok & (t == 1 | t == 17) then
            ok = isequal(round(data), data);
        end
    elseif datatype == "int scalar" then
        _MDebug("int scalar");
        ok = t == 8 & isscalar(data);
        if ~ok & (t == 1 | t == 17) then
            ok = isequal(round(data), data) & isscalar(data);
        end
    elseif datatype == "int vector" then
        _MDebug("int vector");
        ok = t == 8 & (isvector(data) | isscalar(data));
        if ~ok & (t == 1 | t == 17) then
            ok = isequal(round(data), data) & (isvector(data) | isscalar(data));
        end
    elseif datatype == "bool" then
        _MDebug("bool");
        ok = t == 4;
    elseif datatype == "bool scalar" then
        _MDebug("bool scalar");
        ok = t == 4 & isscalar(data);
    elseif datatype == "bool vector" then
        _MDebug("bool vector");
        ok = t == 4 & (isvector(data) | isscalar(data));
    elseif datatype == "string" then
        _MDebug("string");
        ok = t == 10;
    elseif datatype == "list" then
        _MDebug("list");
        ok = t == 15;
    elseif datatype == "function" then
        _MDebug("function");
        ok = t == 11 | t == 13;
    elseif datatype == "struct" then
        _MDebug("struct");
        if ~isstruct(data) then
            ok = %f;
            return;
        end
        if exists("field") then
            fields = fieldnames(data);
            if sum(fields == field) == 0 then
                _MDebug("field does not exist");
                ok = %f;
                return;
            end
            _MDebug("field exists");
            if exists("fieldtype") then
                if exists("values") then
                    _MDebug("validate field type and value");
                    ok = eval(msprintf("_MValidate(data.%s, fieldtype, values)", field));
                else
                    _MDebug("validate field type");
                    ok = eval(msprintf("_MValidate(data.%s, fieldtype)", field));
                end
            else
                ok = %t;
            end
        else
            ok = %t;
        end
    else
        error("Unknown type specified.");
    end

    if ok & datatype ~= "struct" & exists("values") then
        _MDebug("validate data value");
        ok = %f;
        for i = 1 : length(values)
            ok = ok | isequal(data, values(i));
            _MDebug(msprintf("values(%d): ok == %d", i, uint8(ok)));
        end
    end
endfunction
