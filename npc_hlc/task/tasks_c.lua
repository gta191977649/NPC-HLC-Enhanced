--客户端：任务执行函数

performTask = {}

function performTask.walkToPos(npc,task)
	if isPedInVehicle(npc) then return true end
	local destx,desty,destz,dest_dist = task[2],task[3],task[4],task[5]
	local x,y = getElementPosition(npc)
	local distx,disty = destx-x,desty-y
	local dist = distx*distx+disty*disty
	local dest_dist = task[5]
	if dist < dest_dist*dest_dist then return true end
	makeNPCWalkToPos(npc,destx,desty)
end

--NEW 2021
--闲逛任务
--TODO 可以做成和IDLE之间互相转换，但是不好，因为部分NPC可能不转换
function performTask.hangOut(npc,task)
	--outputChatBox("[C] performTask.hangOut"); 
	if isPedInVehicle(npc) then return true end

	if getNPCWalkSpeed(npc) ~="walk" then
		--outputChatBox("set walk for hangOut");
		IFP:syncAnimation(npc);--强制清理一次动作
		triggerServerEvent("npc > setWalkSpeed",resourceRoot,npc,"walk") -- 设置闲逛速度
	end

	local x,y = task[2],task[3]
	local destx,desty = task[4],task[5]

	local nX,nY = getElementPosition(npc);
	local dist = getDistanceBetweenPoints2D(nX,nY,destx,desty);

	local dest_dist = 1 -- 最小距离

	--靠近目的地
	if dist < dest_dist*dest_dist then 
		--PLAN A  --可以任务完成
		--return true
		--outputDebugString("dist:"..tostring(dist).." vs "..tostring(dest_dist*dest_dist))
		--PLAN B 产生新的目标 OR 自动切换进入IDLE模式
		
		--PLAN B2 再次进入IDLE动作
		--local category = Data:getData(npc,"category");
		--triggerServerEvent("npc > setTask",resourceRoot,npc,{"doAnim", category,"idle",-1,false,false,true})
		return true
		--return true

	else
		makeNPCWalkToPos(npc,destx,desty)
	end

end

function performTask.enterToVehicle(npc,task)
	print("[C] performTask.enterToVehicle")
	if isPedInVehicle(npc) then return true end
	makeNPCEnterToVehicle(npc,task[2],task[3])
end
function performTask.exitFromVehicle(npc,task)
	print("[C] performTask.enterToVehicle")
	if not isPedInVehicle(npc) then return true end
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
	if angle >= math.pi*0.5 then return true end

	makeNPCWalkAroundBend(npc,x0,y0,x1,y1,x2,y2,off)
end

function performTask.walkFollowElement(npc,task)
	if isPedInVehicle(npc) then return true end
	local followed,mindist = task[2],task[3] -- 获取远离目标，最小距离
	if not isElement(followed) then return true end
	local x,y = getElementPosition(npc)
	local fx,fy = getElementPosition(followed)
	local dx,dy = fx-x,fy-y
	if dx*dx+dy*dy > mindist*mindist then -- 如果平面距离
		makeNPCWalkToPos(npc,fx,fy)
	else
		stopAllNPCActions(npc)
		return true
	end
end

-- NEW 2021
-- 执行频率挺高
-- TODO 没有躲避其他玩家
function performTask.awayFromElement(npc,task)
	--outputChatBox("[C] performTask.awayFromElement"); 
	if isPedInVehicle(npc) then return true end
	
	local element,mindist,safedist = task[2],task[3],task[4]
	if not isElement(element) then return true end
	local x,y = getElementPosition(npc) -- 获取NPC坐标
	local fx,fy = getElementPosition(element) --获取远离目标坐标
	local ax,ay = 0,0; -- 生成一个离玩家比较远的点
	local dx,dy = fx-x,fy-y -- 获取平面距离

	offset = Vector3(-dx,-dy,0):getNormalized()*safedist; -- 获取远离玩家方向的模向量*安全距离
	ax = x + offset:getX();
	ay = y + offset:getY();
	--outputChatBox("ax:"..tostring(ax).." ay:"..tostring(ay))

	if dx*dx+dy*dy < mindist*mindist then -- 太近了

		-- 如果太靠近

	elseif dx*dx+dy*dy > safedist*safedist then -- 足够安全了
		--outputChatBox("I AM SAFE");
		stopAllNPCActions(npc) -- 我要休息
		return true -- 任务完成！
	else
		makeNPCWalkToPos(npc,ax,ay) -- 继续跑
	end

end

--NEW 2021
-- 同步动作
--目前会循环执行一套动作，不会触发任务完成
function performTask.doAnim(npc,task)

	--注意：第一次执行的时候是获取不到的
	--string anim, string block, int time, bool loop, bool updatePosition, bool interruptable, bool freezeLastFrame, int blendTime, bool restoreTaskOnAnimEnd
	lastBlock,lastAnimation,time,loop = getPedAnimation(npc)
	--outputChatBox("[C] performTask.doAnim:"..tostring(lastBlock).." "..tostring(lastAnimation).." time:"..tostring(time).." loop:"..tostring(loop));

	--outputChatBox(inspect(task))
	local block,anim,time,loop,updatePosition,interruptable,freezeLastFrame = task[3],task[4],task[5],task[6],task[7]
	--outputDebugString(lastBlock);
	--outputDebugString(block);
	--outputDebugString(lastAnimation);
	--outputDebugString(anim);

	--TODO 这里无法判定成功因为库，名是我原创的
	if lastBlock and lastAnimation then
		--outputChatBox("give cause already have set animation:"..tostring(lastAnimation));
		return false
	else

		--[[
		if anim == "idle" then
			--IDLE 动作部分情况下会闲逛...
			chance = math.random(1,2)
			if chance < 2 then
				outputChatBox("try to hangOut");
				local x,y = getElementPosition(npc);
				local xcoord,ycoord = math.randomCoord(5,10)
				local tx,ty = x+xcoord,y+ycoord
				triggerServerEvent("npc > setTask",resourceRoot,npc,{"hangOut",x,y,tx,ty})
				return false  -- 不继续执行
			end

		end
			outputChatBox("try to:"..tostring(anim));
		]]

		if time == nil then time = -1 end
		if loop == nil then loop = true end
		if updatePosition == nil then updatePosition = true end
		if interruptable == nil then interruptable = true end
		if freezeLastFrame == nil then freezeLastFrame = false end --默认不冻住玩家
	
		IFP:syncAnimationLib(npc,block,anim,time,loop,updatePosition,interruptable,freezeLastFrame);
		
	end

	--时间检测
	--IDLE 执行10秒后结束
	past = getTickCount()-task[2]
	if anim =="idle" and  past > 5*1000 then
		--outputChatBox("time past:"..tostring(past));
		return true
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
	if not isElement(target) or getElementHealth(target) < 1 then return true end -- 注意这里有个生命值检测
	local x,y,z = getElementPosition(npc)
	local tx,ty,tz = getElementPosition(target)
	local dx,dy = tx-x,ty-y
	local distsq = dx*dx+dy*dy

	--outputChatBox("distsq:"..tostring(distsq));
	--outputChatBox("shootdist:"..tostring(shootdist*shootdist));

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

function performTask.driveToPos(npc,task)
	if isElementStreamedIn (npc)  == false then return end
	if getPedOccupiedVehicle(npc) == false then return false end
	local destx,desty,destz,dest_dist = task[2],task[3],task[4],task[5]
	local x,y,z = getElementPosition(getPedOccupiedVehicle(npc))
	local distx,disty,distz = destx-x,desty-y,destz-z
	local dist = distx*distx+disty*disty+distz*distz
	if dist < dest_dist*dest_dist then return true end
	makeNPCDriveToPos(npc,destx,desty,destz)
end

function performTask.driveAlongLine(npc,task)
	if getPedOccupiedVehicle(npc) == false then return false end
	local x1,y1,z1,x2,y2,z2 = task[2],task[3],task[4],task[5],task[6],task[7]
	local off,enddist,light = task[8],task[9],task[10]
	local x,y,z = getElementPosition(getPedOccupiedVehicle(npc))
	local pos = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	if pos >= 1-enddist/len then return true end
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
	if angle >= math.pi*0.5 then return true end
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

