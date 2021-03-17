--客户端：基础任务管理

UPDATE_COUNT = 30 --循环间隔
UPDATE_INTERVAL_MS = 200

function initNPCControl()
	--addEventHandler("onClientPreRender",root,cycleNPCs)
	setTimer ( cycleNPCs, UPDATE_COUNT, 0)
end

--客户端：循环NPC任务
function cycleNPCs()
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

--客户端：NPC执行下一个任务
function setNPCTaskToNext(npc)
	setElementData(
		npc,"npc_hlc:thistask",
		getElementData(npc,"npc_hlc:thistask")+1,
		true
	)
end
