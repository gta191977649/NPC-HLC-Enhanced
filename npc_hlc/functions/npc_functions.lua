-------------------------------------------------------
-- shared file
-------------------------------------------------------

function isHLCEnabled(npc)
	return isElement(npc) and getElementData(npc,"npc_hlc") or false
end

--客户端：检测NPC是否存在任务
--TODO：参考getNPCCurrentTask
function isNPCHaveTask(npc)
	if not isElement(npc) then
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

function getNPCWalkSpeed(npc)
	if not isHLCEnabled(npc) then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	return getElementData(npc,"npc_hlc:walk_speed")
end

function getNPCWeaponAccuracy(npc)
	if not isHLCEnabled(npc) then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	return getElementData(npc,"npc_hlc:accuracy")
end

function getNPCDriveSpeed(npc)
	if not isHLCEnabled(npc) then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	return getElementData(npc,"npc_hlc:drive_speed")
end

--双
function getNPCCurrentTask(npc)
	if not isHLCEnabled(npc) then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	local thistask = getElementData(npc,"npc_hlc:thistask")
	return getElementData(npc,"npc_hlc:task."..thistask) 
end

--2021
--服务器/客户端 复原应有的速度
--PS:该文件同时被客户端和用户端使用，我很纳闷
function resetNPCWalkSpeed(npc)
	local speed = Data:getData(npc,"speed");
	if localPlayer then
		triggerServerEvent("npc > setWalkSpeed",resourceRoot,npc,speed) -- 设置闲逛速度
	else
		setNPCWalkSpeed(npc,speed)
	end
end