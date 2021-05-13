
function isHLCEnabled(npc)
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
	local thistask = getElementData(npc,"npc_hlc:thistask")
	return getElementData(npc,"npc_hlc:task."..thistask)
end

function setNPCTaskToNext(npc)
	local thistask = getElementData(npc,"npc_hlc:thistask")
	setElementData(
		npc,"npc_hlc:thistask",
		thistask+1,
		true
	)
end