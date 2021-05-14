UPDATE_COUNT = 35
UPDATE_INTERVAL_MS = 200
local cycleNPCs
function initNPCControl()
	--addEventHandler("onClientPreRender",root,cycleNPCs)
	setTimer ( cycleNPCs, UPDATE_COUNT,1)
	--cycleNPCs()
end
--Async:setDebug(true)
Async:setPriority("low")
function cycleNPCs() 
	Async:setPriority("low")
	Async:forkey(streamed_npcs,function(npc,val) 
		if isElement(npc) and getElementHealth(getPedOccupiedVehicle(npc) or npc) >= 1 then
			local task = getNPCCurrentTask(npc)
			if task then
				if performTask[task[1]](npc,task) then
					setNPCTaskToNext(npc)
				end
			else
				stopAllNPCActions(npc)
			end
		end
	end,function() 
		initNPCControl()
	end)
end