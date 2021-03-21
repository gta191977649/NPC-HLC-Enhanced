--服务器端：执行任务
--如果NPC存在同步者，则跳过服务器执行部分，因为于客户端执行

performTask = {}

function performTask.enterToVehicle(npc,task,maxtime)
	if getElementSyncer(npc) then return maxtime end
	return makeNPCEnterToVehicle(npc,task[2],task[3],maxtime)
end
function performTask.exitFromVehicle(npc,task,maxtime)
	if getElementSyncer(npc) then return maxtime end
	return makeNPCExitFromVehicle(npc,maxtime)
end
function performTask.walkToPos(npc,task,maxtime)
	if getElementSyncer(npc) then return maxtime end
	return makeNPCWalkToPos(npc,task[2],task[3],task[4],maxtime)
end

function performTask.walkAlongLine(npc,task,maxtime)
	if getElementSyncer(npc) then return maxtime end
	return makeNPCWalkAlongLine(npc,task[2],task[3],task[4],task[5],task[6],task[7],task[8],maxtime)
end

function performTask.walkAroundBend(npc,task,maxtime)
	if getElementSyncer(npc) then return maxtime end
	return makeNPCWalkAroundBend(npc,task[2],task[3],task[4],task[5],task[6],task[7],task[8],task[9],task[10],maxtime)
end

function performTask.walkFollowElement(npc,task,maxtime)
	setElementPosition(npc,getElementPosition(npc))
	return maxtime
end

--2021 NEW
--TODO 不是很明白含义
function performTask.awayFromElement(npc,task,maxtime)
	setElementPosition(npc,getElementPosition(npc))
	return maxtime
end

function performTask.shootPoint(npc,task,maxtime)
	setElementPosition(npc,getElementPosition(npc))
	return maxtime
end

function performTask.shootElement(npc,task,maxtime)
	setElementPosition(npc,getElementPosition(npc))
	return maxtime
end

function performTask.killPed(npc,task,maxtime)
	setElementPosition(npc,getElementPosition(npc))
	return maxtime
end

function performTask.driveToPos(npc,task,maxtime)
	local vehicle = getPedOccupiedVehicle(npc)
	if not vehicle then return 0 end
	if getElementSyncer(vehicle) then return maxtime end
	return makeNPCDriveToPos(npc,task[2],task[3],task[4],maxtime)
end

function performTask.driveAlongLine(npc,task,maxtime)
	local vehicle = getPedOccupiedVehicle(npc)
	if not vehicle then return 0 end
	if getElementSyncer(vehicle) then return maxtime end
	return makeNPCDriveAlongLine(npc,task[2],task[3],task[4],task[5],task[6],task[7],task[8],maxtime)
end

function performTask.driveAroundBend(npc,task,maxtime)
	local vehicle = getPedOccupiedVehicle(npc)
	if not vehicle then return 0 end
	if getElementSyncer(vehicle) then return maxtime end
	return makeNPCDriveAroundBend(npc,task[2],task[3],task[4],task[5],task[6],task[7],task[8],task[9],task[10],maxtime)
end

function performTask.waitForGreenLight(npc,task,maxtime)
	local ctrlelm = getPedOccupiedVehicle(npc) or npc
	if getElementSyncer(ctrlelm) then return maxtime end
	local state = getTrafficLightState()
	if
		state == 6 or state == 9 or
		task[2] == "NS" and (state == 0 or state == 5 or state == 8) or
		task[2] == "WE" and (state == 3 or state == 5 or state == 7) or
		task[2] == "ped" and state == 2
	then
		maxtime = 0
	end
	setElementPosition(ctrlelm,getElementPosition(ctrlelm))
	return maxtime
end

