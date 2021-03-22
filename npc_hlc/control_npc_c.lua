UPDATE_COUNT = 30
UPDATE_INTERVAL_MS = 200

function initNPCControl()
	--addEventHandler("onClientPreRender",root,cycleNPCs)
	setTimer ( cycleNPCs, UPDATE_COUNT, 0)
end
Async:setPriority("low")
function cycleNPCs()
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
	end)
end

function cycleNPCs_old()
	local streamed_npcs = {}
	for pednum,ped in ipairs(getElementsByType("ped",root,true)) do
		if getElementData(ped,"npc_hlc") then
			streamed_npcs[ped] = true
		end
	end
	for npc,streamedin in pairs(streamed_npcs) do
		if getElementHealth(getPedOccupiedVehicle(npc) or npc) >= 1 then
			while true do
				local thistask = getElementData(npc,"npc_hlc:thistask")
				if thistask then
					local task = getElementData(npc,"npc_hlc:task."..thistask)
					if task then
						if performTask[task[1]](npc,task) then
							setNPCTaskToNext(npc)
						else
							break
						end
					else
						stopAllNPCActions(npc)
						break
					end
				else
					stopAllNPCActions(npc)
					break
				end
			end
		else
			stopAllNPCActions(npc)
		end
	end
end


function setNPCTaskToNext(npc)
	setElementData(
		npc,"npc_hlc:thistask",
		getElementData(npc,"npc_hlc:thistask")+1,
		true
	)
end

