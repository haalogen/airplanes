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

function _MError(msg_number, varargin)
// Helper function. Prints the standard error messages.
//
// Parameters
//  msg_number: Message number.
//
// Description
//  Prints error message number msg_number using error().
//
// See also
//  error

    messages = [ ...
        "Only grayscale images are implemented."; ...
        "At least %d arguments expected." ...
    ];

    select argn(2)
    case 0 then
        error();
    case 1 then
        error(messages(msg_number));
    else
        text = msprintf(messages(msg_number), varargin(:));
        error(text);
    end
endfunction
