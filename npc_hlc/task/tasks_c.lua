performTask = {}

function performTask.walkToPos(npc,task)
	if isPedInVehicle(npc) then return true end
	local destx,desty,destz,dest_dist = task[2],task[3],task[4],task[5]
	local x,y = getElementPosition(npc)
	local distx,disty = destx-x,desty-y
	local dist = distx*distx+disty*disty
	local dest_dist = task[5]
	if dist < dest_dist*dest_dist then 
		stopAllNPCActions(npc)
		return true 
	end
	makeNPCWalkToPos(npc,destx,desty)
end
function performTask.enterToVehicle(npc,task)
	print("[C] performTask.enterToVehicle")
	if isPedInVehicle(npc) then 
		return true 
	end
	makeNPCEnterToVehicle(npc,task[2],task[3])
end
function performTask.exitFromVehicle(npc,task)
	print("[C] performTask.enterToVehicle")
	if not isPedInVehicle(npc) then
		return true 
	end
	makeNPCExitFromVehicle(npc)
end

function performTask.walkAlongLine(npc,task)
	if isPedInVehicle(npc) then return true end
	local x1,y1,z1,x2,y2,z2 = task[2],task[3],task[4],task[5],task[6],task[7]
	local off,enddist = task[8],task[9]
	local x,y,z = getElementPosition(npc)
	local pos = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	if pos >= 1-enddist/len then return true end
	--随机偏移node位置，防止NPC撞一起
	--local offset = math.random(0,1) 
	makeNPCWalkAlongLine(npc,x1,y1,z1,x2,y2,z2,off)
end

function performTask.walkAroundBend(npc,task)
	if isPedInVehicle(npc) then return true end
	local x0,y0 = task[2],task[3]
	local x1,y1,z1 = task[4],task[5],task[6]
	local x2,y2,z2 = task[7],task[8],task[9]
	local off,enddist = task[10],task[11]
	local x,y,z = getElementPosition(npc)
	local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*math.pi*0.5
	local angle = getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)+enddist/len
	if angle >= math.pi*0.5 then 
		stopAllNPCActions(npc)
		return true 
	end

	
	makeNPCWalkAroundBend(npc,x0,y0,x1,y1,x2,y2,off)
end

function performTask.walkFollowElement(npc,task)
	if isPedInVehicle(npc) then return true end
	local followed,mindist = task[2],task[3]
	if not isElement(followed) then return true end
	local x,y = getElementPosition(npc)
	local fx,fy = getElementPosition(followed)
	local dx,dy = fx-x,fy-y
	if dx*dx+dy*dy > mindist*mindist then
		makeNPCWalkToPos(npc,fx,fy)
	else
		stopAllNPCActions(npc)
	end
end

function performTask.shootPoint(npc,task)
	local x,y,z = task[2],task[3],task[4]
	makeNPCShootAtPos(npc,x,y,z)
end

function performTask.shootElement(npc,task)
	local target = task[2]
	if not isElement(target) then return true end
	makeNPCShootAtElement(npc,target)
end

function performTask.killPed(npc,task)
	if isPedInVehicle(npc) then return true end
	local target,shootdist,followdist = task[2],task[3],task[4]
	if not isElement(target) or getElementHealth(target) < 1 then return true end
	local x,y,z = getElementPosition(npc)
	local tx,ty,tz = getElementPosition(target)
	local dx,dy = tx-x,ty-y
	local distsq = dx*dx+dy*dy
	if distsq < shootdist*shootdist then
		makeNPCShootAtElement(npc,target)
		setPedRotation(npc,-math.deg(math.atan2(dx,dy)))
	else
		stopNPCWeaponActions(npc)
	end
	if distsq > followdist*followdist then
		makeNPCWalkToPos(npc,tx,ty)
	else
		stopNPCWalkingActions(npc)
	end
	return false
end

function performTask.runAvoidTarget(npc,task)
	if isPedInVehicle(npc) then 
		stopAllNPCActions(npc)
		makeNPCExitFromVehicle(npc)
	end

	local element,safedist = task[2],task[3]
	if not isElement(element) then return true end
	local x,y = getElementPosition(npc) -- 获取NPC坐标
	local fx,fy = getElementPosition(element) --获取远离目标坐标
	local ax,ay = 0,0; -- 生成一个离玩家比较远的点
	local dx,dy = fx-x,fy-y -- 获取平面距离

	offset = Vector3(-dx,-dy,0):getNormalized()*safedist; -- 获取远离玩家方向的模向量*安全距离
	ax = x + offset:getX();
	ay = y + offset:getY();
	--outputChatBox("ax:"..tostring(ax).." ay:"..tostring(ay))


		-- 如果太靠近

	if dx*dx+dy*dy > safedist*safedist then -- 足够安全了
		--outputChatBox("I AM SAFE");
		stopAllNPCActions(npc) -- 我要休息
		return true -- 任务完成！
	else
		makeNPCWalkToPos(npc,ax,ay) -- 继续跑
	end

end
-- attack target using any way
function performTask.attackElement(npc,task)
	if isPedInVehicle(npc) then 
		stopAllNPCActions(npc)
		makeNPCExitFromVehicle(npc)
	end
	local target= task[2]

	local veh = getPedOccupiedVehicle(target)
	if veh then 
		--stopAllNPCActions(npc)
		makeNPCEnterToVehicle(npc,veh)
	end
	if not isElement(target) or getElementHealth(target) < 1 then 
		stopAllNPCActions(npc)
		return true 
	end
	if getElementHealth(npc) < 1 then 
		stopAllNPCActions(npc)
		return false 
	end

	local x,y,z = getElementPosition(npc)
	local tx,ty,tz = getElementPosition(target)
	local dx,dy = tx-x,ty-y
	local distsq = dx*dx+dy*dy


	local dist = distsq

	followdist = 10
	shootdist = 10
	-- perform using weapon, if have one 
	local hasWeapon = getPedAvaiableWeaponSlot(npc)
	if hasWeapon ~= 0 then

		if distsq < shootdist*shootdist then
			setPedWeaponSlot (npc,hasWeapon)
			makeNPCShootAtElement(npc,target)
			setPedRotation(npc,-math.deg(math.atan2(dx,dy)))
		else
			stopNPCWeaponActions(npc)
		end
		if distsq > followdist*followdist then
			makeNPCWalkToPos(npc,tx,ty)
		else
			stopNPCWalkingActions(npc)

		end

	end
	-- beat player if no weapon
	if hasWeapon == 0 then
		setPedWeaponSlot (npc,0)
		-- perform beating 
		if dist > 1 then 
			makeNPCWalkToPos(npc,tx,ty,false)
		else 
			--stopNPCWalkingActions(npc)
			setPedAimTarget(npc,tx,ty,tz)
			stopAllNPCActions(npc)
			makeNPCShootAtElement(npc,target)
		end
	end
end

function performTask.driveToPos(npc,task)
	if isElementStreamedIn (npc)  == false then return end
	if getPedOccupiedVehicle(npc) == false then return false end
	local destx,desty,destz,dest_dist = task[2],task[3],task[4],task[5]
	local x,y,z = getElementPosition(getPedOccupiedVehicle(npc))
	local distx,disty,distz = destx-x,desty-y,destz-z
	local dist = distx*distx+disty*disty+distz*distz
	if dist < dest_dist*dest_dist then 
		stopAllNPCActions(npc)
		return true 
	end
	makeNPCDriveToPos(npc,destx,desty,destz)
end

function performTask.driveAlongLine(npc,task)
	if getPedOccupiedVehicle(npc) == false then return false end
	local x1,y1,z1,x2,y2,z2 = task[2],task[3],task[4],task[5],task[6],task[7]
	local off,enddist,light = task[8],task[9],task[10]
	local x,y,z = getElementPosition(getPedOccupiedVehicle(npc))
	local pos = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	if pos >= 1-enddist/len then 
		stopAllNPCActions(npc)
		return true 
	end
	makeNPCDriveAlongLine(npc,x1,y1,z1,x2,y2,z2,off,light)
end

function performTask.driveAroundBend(npc,task)
	if getPedOccupiedVehicle(npc) == false then return false end
	local x0,y0 = task[2],task[3]
	local x1,y1,z1 = task[4],task[5],task[6]
	local x2,y2,z2 = task[7],task[8],task[9]
	local off,enddist = task[10],task[11]
	local x,y,z = getElementPosition(getPedOccupiedVehicle(npc))
	local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*math.pi*0.5
	local angle = getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)+enddist/len
	if angle >= math.pi*0.5 then 
		stopAllNPCActions(npc)
		return true 
	end
	makeNPCDriveAroundBend(npc,x0,y0,x1,y1,z1,x2,y2,z2,off)
end

function performTask.waitForGreenLight(npc,task)
	makeNPCwaitForGreenLight(npc)
	local state = getTrafficLightState()
	if state == 6 or state == 9 then return true end
	if task[2] == "NS" then
		return state == 0 or state == 5 or state == 8
	elseif task[2] == "WE" then
		return state == 3 or state == 5 or state == 7
	elseif task[2] == "ped" then
		return state == 2
	end
	return true
end

