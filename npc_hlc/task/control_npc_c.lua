UPDATE_COUNT = 35
UPDATE_INTERVAL_MS = 2000

Async:setDebug(false)

--[[
function delayIn(source)
	if getElementType( source ) == "ped" then
		if isHLCEnabled(source) then
			streamed_npcs[source] = {
				thistask = nil,
				lasttask = nil,
				tasks = {},
			}
		else
			outputDebugString("failed onClientElementStreamIn:"..tostring(inspect(source)))
		end
	end
end

--Async:setPriority(500, 33); 
addEventHandler( "onClientElementStreamIn", root,
    function ( )
		setTimer(delayIn,1000,1,source)
    end
);
addEventHandler( "onClientElementStreamOut", root,
    function ( )
        if getElementType( source ) == "ped" then
            if isHLCEnabled(source) then
				streamed_npcs[source] = nil
			end
        end
    end
);
]]
cycleNPCs = function()
	Async:setPriority("low")
	local data = getElementsByType("ped",root,true)
	Async:foreach(data, function(npc,pednum) 
		if npc ~= nil and isElement(npc) then
			if getElementData(npc,"npc_hlc") then
				if getElementHealth(getPedOccupiedVehicle(npc) or npc) >= 1 then
					local thistask = getElementData(npc,"npc_hlc:thistask")
					if thistask then
						local task = getElementData(npc,"npc_hlc:task."..thistask)
						if task then
							if performTask[task[1]](npc,task) then
								setNPCTaskToNext(npc)
							end
						else
							stopAllNPCActions(npc)
						end
					else
						stopAllNPCActions(npc)
					end
				end
			end
		end
	end,initNPCControl)
end

function initNPCControl()
	--addEventHandler("onClientHUDRender",root,cycleNPCs,true,"low")
	setTimer ( cycleNPCs, UPDATE_COUNT,1)

end