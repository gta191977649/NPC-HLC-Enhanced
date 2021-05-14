-- old cycle npc implmentation replace by async methods

cycleNPCs = function()
	for pednum,npc in ipairs(getElementsByType("ped",root,true)) do
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
end
-- async version

cycleNPCs = function()
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
<<<<<<< HEAD:npc_hlc/control/cycle.npc_bk
=======

--客户端：NPC执行下一个任务
--似乎thistask>lastask才能触发taskDone
function setNPCTaskToNext(npc)
	--outputDebugString("client setNPCTaskToNext");
	--[[
	local lasttask = getElementData(npc,"npc_hlc:thistask");
	local thistask = getElementData(npc,"npc_hlc:thistask")+1
	if thistask > lasttask then thistask = lasttask end
	setElementData(npc,"npc_hlc:thistask",thistask)
	]]
	local thistask = getElementData(npc,"npc_hlc:thistask")
	setElementData(npc,"npc_hlc:thistask",thistask+1)
end
>>>>>>> evenmov:npc_hlc/task/control_npc_c.lua
