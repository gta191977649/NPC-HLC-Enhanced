
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

function getNPCCurrentTask(npc)
	if not isHLCEnabled(npc) then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	local thistask = getElementData(npc,"npc_hlc:thistask")
	return getElementData(npc,"npc_hlc:task."..thistask)
	 
end