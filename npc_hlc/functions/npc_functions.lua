function isHLCEnabled(npc)
	if streamed_npcs[npc] ~= nil then 
		return true 
	end
	return isElement(npc) and getElementData(npc,"npc_hlc") or false
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
		outputDebugString("Invalid ped argument")
		return false
	end

	--requestNPCServerSync(npc) 
	--[[
	local thistask = streamed_npcs[npc].thistask
	if streamed_npcs[npc].tasks[thistask] ~= nil then 
		--print("fetch from cache...")
		return streamed_npcs[npc].tasks[thistask]
	end
	]]
	-- else use element data
	thistask = getElementData(npc,"npc_hlc:thistask")
	if thistask then
		local task = getElementData(npc,"npc_hlc:task."..thistask)
		--update cache buffer
		--streamed_npcs[npc].tasks[thistask] = task
		--print("fetch from element data...")
		return task
	end
	return false
end

function setNPCTaskToNext(npc)
	local thistask = getElementData(npc,"npc_hlc:thistask")
	setElementData(
		npc,"npc_hlc:thistask",
		thistask+1,
		true
	)
	-- sync buffer (decrease set/get element data access)
	--streamed_npcs[npc].thistask = thistask+1
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

--客户端：获取当前任务名
function getNPCTaskName(npc)
	if not isHLCEnabled(npc) then
		outputDebugString("Invalid ped argument",2)
		return false
	end
	local thistask = getElementData(npc,"npc_hlc:thistask")
	local task = getElementData(npc,"npc_hlc:task."..thistask);
	return task[1]
end