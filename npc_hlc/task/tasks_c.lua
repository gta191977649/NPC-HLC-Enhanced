--客户端：任务执行函数

performTask = {}

--改进2021.5.4
--支持僵尸等使用动作移动
function performTask.walkToPos(npc,task)
	if isPedInVehicle(npc) then return true end
	local destx,desty,destz,dest_dist = task[2],task[3],task[4],task[5]
	local x,y = getElementPosition(npc)
	local distx,disty = destx-x,desty-y
	local dist = distx*distx+disty*disty
	local dest_dist = task[5]
	if dist < dest_dist*dest_dist then return true end

	--获取我的属性
	local walkingstyle = Data:getData(npc,"walkingstyle");

	--outputDebugString(inspect(npc).." walkToPos C"..tostring(Data:getData(npc,"name")));

	if walkingstyle and type(walkingstyle)=="string" then
		makeNPCAnimToPos(npc,destx,desty) -- 动作移动
	else
		makeNPCWalkToPos(npc,destx,desty) -- 按键移动
	end

end

--改进 2021.5.4
--闲逛任务
function performTask.hangOut(npc,task)

	if isPedInVehicle(npc) then return true end

	local action = getElementData(npc,"hangOut:action");
	--初始化行走动作
	if not action then
		setElementData(npc,"hangOut:action","walk",false);
		--setPedAnimation(npc,"ped","WALK_civi");
		setElementData(npc,"hangOut:tick",getTickCount())
	end

	local x,y = task[2],task[3];
	local nX,nY = getElementPosition(npc);
	local dist = getDistanceBetweenPoints2D(nX,nY,x,y);

	--获取npc的属性
	local walkingstyle = Data:getData(npc,"walkingstyle");
	--outputChatBox(inspect(npc).." walkingstyle:"..tostring(walkingstyle));

	if action == "walk" then

		--移动遇到障碍物就休息
		local ray_eye_m = createPedRaycast(npc,"raycast_eye_m")

		--DONE 增加交谈时停止移动
		if getTickCount() - getElementData(npc,"hangOut:tick") > 3000 or ray_eye_m or getElementData(npc,"talking") then

			--outputChatBox(Data:getData(npc,"name").."REST NOW!");
			
			--特殊类型的idle动作
			if walkingstyle and type(walkingstyle)=="string" then
				--停止动作移动
				IFP:syncAnimationLib ( npc, walkingstyle, "idle", -1, true, true, true) --KEEP WALKING
			else
				--outputChatBox("TRY stopNPCWalkingActions");
				--停止按键模式
				stopNPCWalkingActions(npc)
			end

			--如果在说话转向玩家
			if getElementData(npc,"talking") then
				setElementFaceTo(npc,localPlayer)
			end

			setElementData(npc,"hangOut:action","rest",false);
			setElementData(npc,"hangOut:tick",getTickCount(),false) -- 更新tick
		end

	elseif action == "rest" then

		if getTickCount() - getElementData(npc,"hangOut:tick") > 5000 then

			--休息够了继续走

			if walkingstyle and type(walkingstyle)=="string" then
				IFP:syncAnimationLib ( npc, walkingstyle, "walk", -1, true, true, true) --KEEP WALKING
			else
				--按键移动模式
				setPedControlState(npc,"forwards",true)
				setPedControlState(npc,"walk",true)
			end
			
			setElementData(npc,"hangOut:action","walk",false);
			setElementData(npc,"hangOut:tick",getTickCount(),false) -- 更新tick

			--随机方向或者返回原点
			if dist > 5 then
				--outputChatBox(Data:getData(npc,"name").."Walk TO POS!");
				setElementFaceToPos(npc,x,y)
			else
				--outputChatBox(Data:getData(npc,"name").."RANDOM Walk NOW!");
				setPedRotation(npc,math.random(360))
			end
		end

	end


end

--NEW 2021
--守卫坐标
--TODO 守卫需要返回默认的方向，不然会丧失对外的警戒
function performTask.guardPos(npc,task)

	local x,y,z,r = task[2],task[3],task[4],task[5];
	local nX,nY,nZ = getElementPosition(npc);
	local Guarddist = getDistanceBetweenPoints3D(nX,nY,nZ,x,y,z); -- 距离任务点的位置，无用

	local shootdist = Data:getData(npc,"shootdist");
	local target = Data:getData(npc,"target");

	if target and isElement(target) and getElementHealth(target) > 0 then

		local tX,tY,tZ = getElementPosition(target)
		local targetDist = getDistanceBetweenPoints3D(nX,nY,nZ,tX,tY,tZ)

		--outputDebugString("npc guard find target:"..tostring(target).." distance to task:"..tostring(targetDist));

		-- 防止拳头无脑进攻
		if targetDist <= shootdist then
			makeNPCShootAtElement(npc,target);
		end
		setElementFaceTo(npc,target)

	else

		--守卫不存在目标

		stopNPCWeaponActions(npc)--STOP SHOT

		if Guarddist > 1 then
			--BACK TO GUARD POS? - 目前出拳攻击可能导致NPC位移
			makeNPCWalkToPos(npc,x,y)
		end


		--TODO 2.没有任务的时候沿着目的地旋转角度..扇形检测
		-- 代码未完成
		local rx,ry,rz = getElementRotation(npc)
		--outputChatBox("rz:"..tostring(rz).." vs task r:"..tostring(r));
		--[[
		if rz > r then 
			--rz = rz - 1
			--setElementRotation(npc,rx,ry,r)
		elseif rz < r then
			--rz = rz + 1
			--setElementRotation(npc,rx,ry,r)
		end
		]]

		--DONE 延迟6秒返回默认的方向
		local resetRotation = getElementData(npc,"resetRotation")
		if rz ~= r and resetRotation == false then

			-- 交谈的时候不要转回去
			if getElementData(npc,"talking") then return false end

			--DONE 6秒后NPC可能不在了
			setElementData(npc,"resetRotation",true,false);
			setTimer(function(npc,rx,ry,r)
				if isElement(npc) then
					setElementData(npc,"resetRotation",false,false)
					setElementRotation(npc,rx,ry,r)
				end
			end,6000,1,npc,rx,ry,r)

		else
			--setElementData(npc,"resetRotation",false,false);
		end
		
	end
	--不能返回true，不然任务就结束了

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

--NEW 2021 
-- 被威胁/恐惧
-- 参数：威胁者
function performTask.panic(npc,task)

	local element = task[2];
	if not isElement(element) then return true end -- 无效威胁，任务完成

	Data:setData(npc,"target",element);

	local distance = getDistance(npc,element);
	local hisTarget = getPedTarget(element); -- 他的标准目标
	local heIsAiming = getPedControlState(element,"aim_weapon") -- 他是否瞄准

	--检测威胁对象是否正在关注我
	local targetMe = false 
	if hisTarget == npc and heIsAiming then
		targetMe = true
	end

	if distance > 10 then
		--距离过远，恐慌结束
		IFP:syncAnimationLib(npc) -- 停止动作
		Data:setData(npc,"target",false);
		return true
	else

		local ifp = getElementData(npc,"ifp");
		--lastBlock,lastAnimation = getPedAnimation(npc)
		--outputDebugString(tostring(lastBlock)..","..tostring(lastAnimation));

		if targetMe then
			if ifp == "handsup" then
			--if lastBlock == "shop" and lastAnimation == "SHP_Rob_HandsUp" then
				return false
			else
				--triggerEvent("onChatbubblesMessageIncome",npc,Loc:Localization(table.random(threatenRobbingMessages)),0);
				setElementFaceTo(npc,element);--面向威胁者
				IFP:syncAnimationLib(npc,"human","handsup",-1,true,false)
			end
		else
			if ifp == "panic" then
			--if lastBlock == "ped" and lastAnimation == "cower" then
				return false
			else
				IFP:syncAnimationLib(npc,"human","panic",-1,true,false);
			end
			
			-- outputChatBox(inspect(element).." hisTarget "..tostring(hisTarget));
		end
	end
	return false

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
		-- DO NOTHING..

	elseif dx*dx+dy*dy > safedist*safedist then -- 足够安全了
		--outputChatBox("I AM SAFE");
		stopAllNPCActions(npc) -- 我要休息
		return true -- 任务完成！
	else
		makeNPCWalkToPos(npc,ax,ay) -- 继续跑
	end

end

--NEW 2021
--同步动作
--目前会循环执行一套动作，不会触发任务完成
--注意：这个task目前未使用
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

--改进 2021.5.4 支持动作移动
--TODO：当攻击用KEY，移动用ANIM时，攻击动作无法执行完成（比如没有玩家跑得快的僵尸）
--TODO：原因是停止ANIM将玩家的攻击动作也强行停止了...
--TODO：当距离大于followdist且小于shootdist时，会同时执行两部分，导致僵尸肉搏攻击BUG
function performTask.killPed(npc,task)
	if isPedInVehicle(npc) then return true end
	local target,shootdist,followdist = task[2],task[3],task[4]
	if not isElement(target) or getElementHealth(target) == 0 then return true end -- 注意这里有个生命值检测
	local x,y,z = getElementPosition(npc)
	local tx,ty,tz = getElementPosition(target)

	--outputDebugString(inspect(npc).." performTask.killPed "..tostring(Data:getData(npc,"name")));

	--local dx,dy = tx-x,ty-y
	--local distsq = dx*dx+dy*dy

	local distsq = getDistance(npc,target)

	--outputDebugString("distsq:"..tostring(distsq));
	--outputDebugString("shootdist:"..tostring(shootdist));
	--outputDebugString("followdist:"..tostring(followdist));

	--获取我的属性
	local walkingstyle = Data:getData(npc,"walkingstyle");
	--outputDebugString("isZombie:"..tostring(inspect(isZombie)));


	--距离小于射击距离3
	--TODO:这里在重复执行
	if distsq < shootdist then
		--outputDebugString("Shoot!!!"..tostring(distsq).." < "..tostring(shootdist));
		makeNPCShootAtElement(npc,target)
		setElementFaceTo(npc,target);
		--setPedRotation(npc,-math.deg(math.atan2(dx,dy)))
	else
		--outputChatBox("stopNPCWalkingActions");
		stopNPCWeaponActions(npc)
	end
	
	--距离大于追踪距离1
	if distsq > followdist then
		--outputDebugString("move!!!:"..tostring(distsq).." > "..tostring(followdist));
		if walkingstyle and type(walkingstyle)=="string" then
			--ZOMBIE MOVE
			makeNPCAnimToPos(npc,tx,ty)
			--outputDebugString("ZOMBIE MOVE...");
		else
			makeNPCWalkToPos(npc,tx,ty)
		end
	else
		if walkingstyle and type(walkingstyle)=="string" then
			--STOP ZOMBIE MOVE
			--[[
			local b,a = getPedAnimation(npc)
			outputDebugString("b:"..tostring(b)..",a="..tostring(a));
			--过滤出拳状态 失败
			if b == "nb_zombie" then
				stopNPCWalkingAnim(npc)
			end
			]]
			stopNPCWalkingAnim(npc)
		else
			stopNPCWalkingActions(npc)
		end
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

