-- BSD 2-Clause License
--
-- Copyright (c) 2021, Eisa AlAwadhi
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- 1. Redistributions of source code must retain the above copyright notice, this
--    list of conditions and the following disclaimer.
--
-- 2. Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
-- CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
-- OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
-- OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-- Copyright (c) 2021, Eisa AlAwadhi
-- License: BSD 2-Clause License

-- Creator: Eisa AlAwadhi
-- Project: SimpleUndo
-- Version: 3.1

local utils = require 'mp.utils'
local seconds = 0
local countTimer = -1
local previousUndoTime = 0
local undoTime = 0

local pause = false

local function getUndo()
	previousUndoTime = undoTime
	undoTime = math.floor(mp.get_property_number('time-pos'))

	if (pause == true) then
		seconds = seconds
	else
		seconds = seconds - 0.5
	end

	previousUndoTime = previousUndoTime + seconds
	seconds = 0
end

mp.register_event('file-loaded', function()
	filePath = mp.get_property('path')

	timer = mp.add_periodic_timer(0.1, function()
		seconds = seconds + 0.1
	end)

	if (pause == true) then
		timer:stop()
	else
		timer:resume()
	end

	timer2 = mp.add_periodic_timer(0.1, function()

		countTimer = countTimer + 0.1
		if (countTimer == 0.6) then
			timer:resume()
			getUndo()
		end

	end)
	timer2:stop()
end)

mp.register_event('seek', function()
	countTimer = 0
	timer2:resume()
	timer:stop()
end)

mp.observe_property('pause', 'bool', function(name, value)
	if value then
		if timer ~= nil then
			timer:stop()
		end
		pause = true
	else
		if timer ~= nil then 
			timer:resume()
		end
		pause = false
	end
end)

mp.register_event('end-file', function()
	if timer ~= nil then
		timer:kill()
	end
	if timer2 ~= nil then
		timer2:kill()
	end
	previousUndoTime = 0
	undoTime = 0
	seconds = 0
	countTimer = -1
end)

local function undo()
	if (filePath ~= nil) and (countTimer >= 0) and (countTimer < 0.6) then
		timer2:stop()

		getUndo()

		if (previousUndoTime < 0) then
			previousUndoTime = 0
		end

		mp.commandv('seek', previousUndoTime, 'absolute', 'exact')
		mp.osd_message('Undo')
	elseif (filePath ~= nil) and (countTimer > 0.5) then

		if (previousUndoTime < 0) then
			previousUndoTime = 0
		end

		mp.commandv('seek', previousUndoTime, 'absolute', 'exact')
		mp.osd_message('Undo')
	elseif (filePath ~= nil) and (countTimer == -1) then
		mp.osd_message('No Undo Found')
	end
end

mp.add_key_binding("ctrl+z", "undo", undo)
mp.add_key_binding("ctrl+Z", "undoCaps", undo)
