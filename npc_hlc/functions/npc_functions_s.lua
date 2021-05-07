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
addEvent("npc > setWalkSpeed",true)
addEventHandler("npc > setWalkSpeed",resourceRoot,setNPCWalkSpeed,false)

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
	--outputDebugString("addNPCTask:"..tostring(task[1]));
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
	--outputDebugString("addNPCTask:"..tostring(task))
	setElementData(npc,"npc_hlc:task."..lasttask,task)
	setElementData(npc,"npc_hlc:lasttask",lasttask)
	return true
end
addEvent("npc > addTask",true)
addEventHandler("npc > addTask",resourceRoot,addNPCTask,false)

--2021 resetNPCWalkSpeed
function resetNPCWalkSpeed(npc)
	local speed = Data:getData(npc,"speed");
	setNPCWalkSpeed(npc,speed)
end

--服务器函数：清理NPC任务
function clearNPCTasks(npc)
	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	local thistask = getElementData(npc,"npc_hlc:thistask")
	if not thistask then return end

	IFP:syncAnimation(npc,false,false);--强制刷新一次动作，不然新的control无法生效
	resetNPCWalkSpeed(npc)--恢复原有速度

	--outputDebugString("clearNPCTasks:"..tostring(thistask))

	local checktask = getElementData(npc,"npc_hlc:task."..thistask)
	if checktask then
		--outputChatBox(inspect(checktask))
		--清理武器动作
		if checktask[1]=="killPed" then
			--outputChatBox("trigger try");
			triggerClientEvent("npc > stopWeaponActions",resourceRoot,npc);
			--stopNPCWeaponActions(npc)--这是服务端的，需要用trigger
		end
	end

	local lasttask = getElementData(npc,"npc_hlc:lasttask")

	--outputDebugString("clearNPCTasks thistask:"..tostring(thistask));--获取的是ID
	--outputDebugString("clearNPCTasks lasttask:"..tostring(lasttask));--获取的是ID

	-- if thistask > lasttask then thistask = lasttask end -- TRY UGLY FIX

	--循环清空所有任务
	for task = thistask,lasttask do
		--outputDebugString("clearNPCTasks remove task:"..tostring(task))
		removeElementData(npc,"npc_hlc:task."..task)
	end
	--outputDebugString("TRY REMOVE TASK")
	removeElementData(npc,"npc_hlc:thistask")
	removeElementData(npc,"npc_hlc:lasttask")
	return true
end
addEvent("npc > clearTask",true)
addEventHandler("npc > clearTask",resourceRoot,clearNPCTasks,false)

--服务器：设置NPC任务
function setNPCTask(npc,task)

	--outputDebugString("setNPCTask to:"..inspect(task))

	local thistask = getElementData(npc,"npc_hlc:thistask")
	--outputDebugString(inspect(npc).." setNPCTask thistask:"..tostring(thistask));--获取的是ID

	if not npc or not all_npcs[npc] then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	if not isTaskValid(task) then
		outputDebugString("Invalid task argument",2)
		return false
	end

	clearNPCTasks(npc)

	--outputDebugString("setNPCTask:"..tostring(inspect(task)));
	setElementData(npc,"npc_hlc:task.1",task)
	setElementData(npc,"npc_hlc:thistask",1)
	setElementData(npc,"npc_hlc:lasttask",1)

	
	--outputDebugString("getNPCTask:"..tostring(inspect(getNPCCurrentTask(npc))));
	return true
end
addEvent("npc > setTask",true)
addEventHandler("npc > setTask",resourceRoot,setNPCTask,false)

--服务器：检测任务是否可用
function isTaskValid(task)
	local taskFunc = taskValid[task[1]]
	--outputChatBox(tostring(taskFunc))
	return taskFunc and taskFunc(task) or false
end

--2021
-----------------------------------------------------------------------------------------------------


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

--2021
--创建生物
--如果是人类，需要阵营，名字
--参数：CLASS类型，坐标XYZ,角度R，姓名name，子分类subtype（人类是阵营，其他动物是种类）
function createCreature(type,x,y,z,r,subtype,btype)

	--DEBUG 不存在的类型创建为僵尸
	--outputDebugString("table have key "..tostring(cType[type]))
	--outputDebugString("not table have key "..tostring(not cType[type]))
	--outputDebugString("TRY CALL createCreature:"..tostring(type));

	local c = nil;

	if type == "normal" then
		c = cType[type]:create(x,y,z,r,subtype,btype) -- 不要使用预留名creature..不然BUG
	else
		c = cType[type]:create(x,y,z,r) -- 不要使用预留名creature..不然BUG
	end
	local cElement = c:getElement();

	--反绑定
	setElementData(cElement,"creature",type);
	creatures[cElement] = c;

	--绑定到任务结束函数
	addEventHandler("npc_hlc:onNPCTaskDone",cElement,taskDone)

	local accuracy = Data:getData(cElement,"accuracy");
	local speed = Data:getData(cElement,"speed");
	--local category = Data:getData(cElement,"category");

	local behaviour = Data:getData(cElement,"behaviour");
	enableHLCForNPC(cElement,speed,accuracy,1)

	--默认任务
	if behaviour == "guard" then
		Data:setData(cElement,"sensor",true); -- 开启感知
		accuracy = 1 -- 守卫设计准确度很高
		setNPCTask(cElement, {"guardPos",x,y,z})--loop false to sequence random animation
	elseif behaviour == "hunt" then
		--追杀
		Data:setData(cElement,"sensor",true); -- 开启感知
	elseif behaviour == "default" then
		--闲逛市民
		setNPCTask(cElement,{"hangOut",x,y,x,y})
	else
		--trade
		--僵尸
		setNPCTask(cElement,{"hangOut",x,y,x,y})
	end
	
	--outputDebugString("createCreature to:"..tostring(table.nums(creatures)));

	return cElement;

end

--NEW
--摧毁生物
function destroyCreature(element)
	local creature = creatures[element];
	--outputDebugString(tostring(inspect(element)).."creature:"..tostring(inspect(creature)))
	if creature then
		--outputDebugString("TRY destroyCreature "..tostring(inspect(element)))
		creature:destroy(element)
	else
		outputDebugString("no creature in lib to destroy..left:"..tostring(table.nums(creatures)))
	end
end