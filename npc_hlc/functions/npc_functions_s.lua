--NPC初始化
function enableHLCForNPC(npc,walkspeed,accuracy,drivespeed)
	if not isElement(npc) or getElementType(npc) ~= "ped" then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	if all_npcs[npc] then
		outputDebugString("HLC already enabled",2)
		return false
	end

	if walkspeed and not NPC_SPEED_ONFOOT[walkspeed] then
		outputDebugString("Invalid walkspeed argument",2)
		return false
	end
	if accuracy then
		accuracy = tonumber(accuracy)
		if not accuracy or accuracy < 0 or accuracy > 1 then
			outputDebugString("Invalid accuracy argument",2)
			return false
		end
	end
	if drivespeed then
		drivespeed = tonumber(drivespeed)
		if not drivespeed or drivespeed < 0 then
			outputDebugString("Invalid drivespeed argument",2)
			return false
		end
	end

	addEventHandler("onElementDataChange",npc,cleanUpDoneTasks) --绑定data变化函数到npc
	addEventHandler("onElementDestroy",npc,destroyNPCInformationOnDestroy)--绑定清理函数到NPC
	all_npcs[npc] = true
	setElementData(npc,"npc_hlc",true)
	addNPCToUnsyncedList(npc)
	
	setNPCWalkSpeed(npc,walkspeed or "run")
	setNPCWeaponAccuracy(npc,accuracy or 1)
	setNPCDriveSpeed(npc,drivespeed or 40/180)

	return true
end

--NPC反初始化
function disableHLCForNPC(npc)
	if not isElement(npc) or getElementType(npc) ~= "ped" then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	if not all_npcs[npc] then
		outputDebugString("HLC not enabled",2)
		return false
	end

	clearNPCTasks(npc)

	removeEventHandler("onElementDataChange",npc,cleanUpDoneTasks)
	removeEventHandler("onElementDestroy",npc,destroyNPCInformationOnDestroy)
	destroyNPCInformation(npc)
	removeElementData(npc,"npc_hlc")
	
	removeElementData(npc,"npc_hlc:walk_speed")
	removeElementData(npc,"npc_hlc:accuracy")
	removeElementData(npc,"npc_hlc:drive_speed")

	return true
end

function setNPCWalkSpeed(npc,speed)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	if speed ~= "walk" and speed ~= "run" and speed ~= "sprint" and speed ~= "sprintfast" then
		outputDebugString("Invalid speed argument",2)
		return false
	end
	setElementData(npc,"npc_hlc:walk_speed",speed)
	return true
end

function setNPCWeaponAccuracy(npc,accuracy)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	accuracy = tonumber(accuracy)
	if not accuracy or accuracy < 0 or accuracy > 1 then
		outputDebugString("Invalid accuracy argument",2)
		return false
	end
	setElementData(npc,"npc_hlc:accuracy",accuracy)
	return true
end

function setNPCDriveSpeed(npc,speed)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	speed = tonumber(speed)
	if not speed or speed < 0 then
		outputDebugString("Invalid speed argument",2)
		return false
	end
	setElementData(npc,"npc_hlc:drive_speed",speed)
	return true
end

------------------------------------------------
function addNPCTask(npc,task)
	outputChatBox("addNPCTask:"..tostring(task[1]));
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	if not isTaskValid(task) then
		outputDebugString("Invalid task argument",2)
		return false
	end
	local lasttask = getElementData(npc,"npc_hlc:lasttask")
	if not lasttask then
		lasttask = 1
		setElementData(npc,"npc_hlc:thistask",1)
	else
		lasttask = lasttask+1
	end
	setElementData(npc,"npc_hlc:task."..lasttask,task)
	setElementData(npc,"npc_hlc:lasttask",lasttask)
	return true
end
addEvent("npc > addTask",true)
addEventHandler("npc > addTask",resourceRoot,addNPCTask,false)

--服务器函数：清理NPC任务
function clearNPCTasks(npc)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	local thistask = getElementData(npc,"npc_hlc:thistask")
	if not thistask then return end
	local lasttask = getElementData(npc,"npc_hlc:lasttask")
	for task = thistask,lasttask do
		removeElementData(npc,"npc_hlc:task."..task)
	end
	removeElementData(npc,"npc_hlc:thistask")
	removeElementData(npc,"npc_hlc:lasttask")
	return true
end
addEvent("npc > clearTask",true)
addEventHandler("npc > clearTask",resourceRoot,clearNPCTasks,false)

--服务器：设置NPC任务
function setNPCTask(npc,task)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	if not isTaskValid(task) then
		outputDebugString("Invalid task argument",2)
		return false
	end
	clearNPCTasks(npc)
	setElementData(npc,"npc_hlc:task.1",task)
	setElementData(npc,"npc_hlc:thistask",1)
	setElementData(npc,"npc_hlc:lasttask",1)
	return true
end

--服务器：检测任务是否可用
function isTaskValid(task)
	local taskFunc = taskValid[task[1]]
	--outputChatBox(tostring(taskFunc))
	return taskFunc and taskFunc(task) or false
end

--2021

--服务器：检测NPC是否存在任务
function isNPCHaveTask(npc)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	--thistask 是数字
	local thistask = getElementData(npc,"npc_hlc:thistask")
	if not thistask then
		return false
	else
		return true
	end 
end


--创建生物
function createCreature(type,x,y,z,dim)

	outputDebugString("TRY CALL createCreature:"..tostring(type));
	local c = cType[type]:create(x,y,z) -- 不要使用预留名creature..不然BUG

	local cElement = c:getElement();

	--反绑定
	setElementData(cElement,"creature",c);
	creatures[cElement] = self;

	speed = Data:getData(cElement,"speed")
	enableHLCForNPC(cElement,speed,0.99,1)
	return cElement;
	
end