--重要：客户端 基本ACTIONS
--这里是NPC的最基础行为

DGS = exports.dgs
AI = {}
AI.config = {
	sensorOffset = 2,
	sensorOffsetZ = 0,
	sensorOffsetY = 1,
	sensorDetectLength = 7,
	backwardsTimer = 1500,
	decision_timeout = 500,
	decision_walk_timeout = 1000
}
--AI决定
AI.decisions = {
	"IDLE",--1
	"FORWARD_AVOID_OBSTCLE",--2
	"BACKWARD_AVOID_OBSTCLE",
	"WAIT_OBSTCLE",
	"WALK_OBSTCLE_RIGHT", --5
	"WALK_OBSTCLE_LEFT",
	"WALK_OBSTCLE_BACK",
}
--调试模式
debug = false
local mathCos = math.cos
local mathSin = math.sin
local mathAtan = math.atan
local mathAtan2 = math.atan2
local mathPi = math.pi
local radToDeg = 180/math.pi
local degToRad = math.pi/180
local mathRandom = math.random

function mathAbs(x)
	return x < 0 and -x or x
end

local _isLineOfSightClear = isLineOfSightClear
local _processLineOfSight = processLineOfSight
function processLineOfSight(startX,startY,startZ,endX,endY,endZ,checkBuildings,checkVehicles,checkPlayers,checkObjects,checkDummies,seeThroughStuff,ignoreSomeObjectsForCamera,shootThroughStuff,ignoredElement,includeWorldModelInformation)
	local isClear = isLineOfSightClear(startX,startY,startZ,endX,endY,endZ,checkBuildings,checkVehicles,checkPlayers,checkObjects,checkDummies,seeThroughStuff,ignoreSomeObjectsForCamera,ignoredElement)
	if not isClear then
		return _processLineOfSight(startX,startY,startZ,endX,endY,endZ,checkBuildings,checkVehicles,checkPlayers,checkObjects,checkDummies,seeThroughStuff,ignoreSomeObjectsForCamera,shootThroughStuff,ignoredElement,includeWorldModelInformation )
	end
	return false
end


function stopAllNPCActions(npc)
	stopNPCWalkingActions(npc)
	stopNPCWeaponActions(npc)
	stopNPCDrivingActions(npc)

	setPedControlState(npc,"vehicle_fire",false)
	setPedControlState(npc,"vehicle_secondary_fire",false)
	setPedControlState(npc,"steer_forward",false)
	setPedControlState(npc,"steer_back",false)
	setPedControlState(npc,"horn",false)
	setPedControlState(npc,"handbrake",false)
end

function stopNPCWalkingActions(npc)
	setPedControlState(npc,"forwards",false)
	setPedControlState(npc,"backwards",false)
	setPedControlState(npc,"sprint",false)
	setPedControlState(npc,"walk",false)
	setPedControlState(npc,"right",false)
	setPedControlState(npc,"left",false)
end

function stopNPCWeaponActions(npc)
	setPedControlState(npc,"aim_weapon",false)
	setPedControlState(npc,"fire",false)
end

function stopNPCDrivingActions(npc)
	local car = getPedOccupiedVehicle(npc)
	if not car then return end
	local m = getElementMatrix(car)
	local vx,vy,vz = getElementVelocity(car)
	vy = vx*m[2][1]+vy*m[2][2]+vz*m[2][3]
	setPedControlState(npc,"accelerate",vy < -0.01)
	setPedControlState(npc,"brake_reverse",vy > 0.01)
	setPedControlState(npc,"vehicle_left",false)
	setPedControlState(npc,"vehicle_right",false)
end

--客户端 创建NPC射线
function createPedRaycast(element,type) 
	local px,py,pz = getElementPosition(element)
	local x0, y0, z0, x1, y1, z1 = getElementBoundingBox( element )
	local vWidth = mathAbs(y0 - y1)
	local vHeight = mathAbs(x0 -x1)
	if type == "raycast_eye_l" then
		local lx,ly,lz = getPositionFromElementOffset(element,-1,vWidth,0)
		--local ray,_,_,_,hitElement,_,_,_,_,_,_,hitModel = processLineOfSight(px,py,pz,lx,ly,lz,true,true,true,true,false,true,true,false,element,true)
		local ray = isLineOfSightClear(px,py,pz,lx,ly,lz,true,true,true,true,true,false,false,element)
		if debug then dxDrawLine3D( px,py,pz, lx,ly,lz,ray == false and tocolor ( 255, 0, 0, 255 )  or tocolor ( 0, 255, 0, 255 ) ,1 ) end
		return not ray
	end
	if type == "raycast_eye_m" then
		local lx,ly,lz = getPositionFromElementOffset(element,0,vWidth+0.5,0)
		--local ray,_,_,_,hitElement,_,_,_,_,_,_,hitModel = processLineOfSight(px,py,pz,lx,ly,lz,true,true,true,true,false,true,true,false,element,true)
		local ray = isLineOfSightClear(px,py,pz,lx,ly,lz,true,true,true,true,true,false,false,element)
		if debug then dxDrawLine3D( px,py,pz, lx,ly,lz,ray == false and tocolor ( 255, 0, 0, 255 )  or tocolor ( 0, 255, 0, 255 ) ,1 ) end
		return not ray
	end
	if type == "raycast_eye_r" then
		local lx,ly,lz = getPositionFromElementOffset(element,1,vWidth,0)
		--local ray,_,_,_,hitElement,_,_,_,_,_,_,hitModel = processLineOfSight(px,py,pz,lx,ly,lz,true,true,true,true,false,true,true,false,element,true)
		local ray = isLineOfSightClear(px,py,pz,lx,ly,lz,true,true,true,true,true,false,false,element)
		if debug then dxDrawLine3D( px,py,pz, lx,ly,lz,ray == false and tocolor ( 255, 0, 0, 255 )  or tocolor ( 0, 255, 0, 255 ) ,1 ) end
		return not ray
	end
end

--客户端：让NPC移动到坐标（X,Y）通过操纵按键的方式而不是设置动作
function makeNPCWalkToPos(npc,x,y)
	local speed = getNPCWalkSpeed(npc)
	
	-- injected ai logic 初始化AI参数
	initalAIParameter(npc)
	AI[npc].task = getNPCCurrentTask(npc)[1] -- 获取NPC的首个任务
	local px,py,pz = getElementPosition(npc)
	local cameraAngle = math.deg(mathAtan2(x-px,y-py))
	setPedCameraRotation(npc,cameraAngle) -- 设置NPC转向？

	--检测三个方向的射线碰撞情况
	local ray_eye_l = createPedRaycast(npc,"raycast_eye_l")
	local ray_eye_m = createPedRaycast(npc,"raycast_eye_m")
	local ray_eye_r = createPedRaycast(npc,"raycast_eye_r")

	local currentTick = getTickCount()

	if AI[npc].decision == AI.decisions[1] then -- 从IDLE状态开始

		if ray_eye_l and ray_eye_r and ray_eye_m or ray_eye_l and ray_eye_r then 
			AI[npc].decision = AI.decisions[7]
			AI[npc].lastDecisionTick = currentTick
		end
		
		if ray_eye_l or ray_eye_l and ray_eye_m then --碰撞到左边或者碰撞到左+前
			--controlPedRight(npc)
			AI[npc].decision = AI.decisions[5] --向右
			AI[npc].lastDecisionTick = currentTick
		end
		if ray_eye_r or ray_eye_r and ray_eye_m then --碰撞到右边或者碰撞到右+前
			--controlPedLeft(npc)
			AI[npc].decision = AI.decisions[6] -- 向左
			AI[npc].lastDecisionTick = currentTick
		end
		if ray_eye_m then -- 碰撞到前面，随机左转或者右转
			local dir = math.random(1,2)
			if dir == 1 then
				AI[npc].decision = AI.decisions[5]
				AI[npc].lastDecisionTick = currentTick
			end
			if dir == 2 then
				AI[npc].decision = AI.decisions[6]
				AI[npc].lastDecisionTick = currentTick
			end
		end

		if isElementInWater(npc) then -- NPC落水后
			local angle = 360-math.deg(math.atan2(x-px,y-py))
			setPedRotation(npc,angle)
		end

	end

	-- ai decision 根据AI决策执行行为
	if AI[npc].decision == AI.decisions[5] then -- 向右
		controlPedRight(npc)
		--setPedCameraRotation(npc,cameraAngle + 90)
		if not ray_eye_l or AI[npc].lastDecisionTick ~= nil and currentTick - AI[npc].lastDecisionTick >= AI.config.decision_walk_timeout then
			AI[npc].decision = AI.decisions[1]
		end
		
	end
	if AI[npc].decision == AI.decisions[6] then --向左
		controlPedLeft(npc)
		--setPedCameraRotation(npc,cameraAngle - 90)
		if not ray_eye_r or currentTick - AI[npc].lastDecisionTick >= AI.config.decision_walk_timeout then
			AI[npc].decision = AI.decisions[1]
		end
		
	end
	if AI[npc].decision == AI.decisions[7] then --后退
		controlPedBack(npc)
		--setPedCameraRotation(npc,cameraAngle + 180)
		if currentTick - AI[npc].lastDecisionTick >= AI.config.decision_walk_timeout then
			AI[npc].decision = AI.decisions[1]
		end
		
	end



	-- render debug text
	if debug then
		DGS:dgsSetProperty(AI[npc].text,"text",string.format("%s\nDECISION:%s\nLIGHT:%s",AI[npc].task,AI[npc].decision,light ~= nil and light or "N/A"))
	end

	setPedControlState(npc,"forwards",true)
	setPedControlState(npc,"walk",speed == "walk")
	setPedControlState(npc,"sprint",
		speed == "sprint" or
				speed == "sprintfast" and not getPedControlState(npc,"sprint")
	)
end

--客户端：NPC步行到车边后上车
function makeNPCEnterToVehicle(npc,vehicle,seat)
	print("[C] Set setPedEnterVehicle")
	local x,y,z = getElementPosition(npc)
	local vx,vy,vz = getElementPosition(vehicle)

	local dis = getDistanceBetweenPoints3D(x,y,z,vx,vy,vz)
	if dis <= 3 then
		setPedEnterVehicle (npc,vehicle,seat)
	else
		makeNPCWalkToPos(npc,vx,vy)
	end
end

--客户端：NPC离开车
function makeNPCExitFromVehicle(npc)
	if not getPedOccupiedVehicle(npc) then return false end
	setPedExitVehicle (npc)
end

function makeNPCWalkAlongLine(npc,x1,y1,z1,x2,y2,z2,off)
	local x,y,z = getElementPosition(npc)
	local p2 = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	p2 = p2+off/len
	local p1 = 1-p2
	local destx,desty = p1*x1+p2*x2,p1*y1+p2*y2
	makeNPCWalkToPos(npc,destx,desty)
end

function makeNPCWalkAroundBend(npc,x0,y0,x1,y1,x2,y2,off)
	local x,y,z = getElementPosition(npc)
	local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*mathPi*0.5
	local p2 = getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)/mathPi*2+off/len
	local destx,desty = getPosFromBend(p2*mathPi*0.5,x0,y0,x1,y1,x2,y2)
	makeNPCWalkToPos(npc,destx,desty)
end

--客户端：NPC射击坐标
function makeNPCShootAtPos(npc,x,y,z)
	local sx,sy,sz = getElementPosition(npc)
	x,y,z = x-sx,y-sy,z-sz
	local yx,yy,yz = 0,0,1
	local xx,xy,xz = yy*z-yz*y,yz*x-yx*z,yx*y-yy*x
	yx,yy,yz = y*xz-z*xy,z*xx-x*xz,x*xy-y*xx
	local inacc = 1-getNPCWeaponAccuracy(npc)
	local ticks = getTickCount()
	local xmult = inacc*mathSin(ticks*0.01 )*1000/math.sqrt(xx*xx+xy*xy+xz*xz)
	local ymult = inacc*mathCos(ticks*0.011)*1000/math.sqrt(yx*yx+yy*yy+yz*yz)
	local mult = 1000/math.sqrt(x*x+y*y+z*z)
	xx,xy,xz = xx*xmult,xy*xmult,xz*xmult
	yx,yy,yz = yx*ymult,yy*ymult,yz*ymult
	x,y,z = x*mult,y*mult,z*mult

	setPedAimTarget(npc,sx+xx+yx+x,sy+xy+yy+y,sz+xz+yz+z) -- 射击坐标
	if isPedInVehicle(npc) then
		setPedControlState(npc,"vehicle_fire",not getPedControlState(npc,"vehicle_fire"))
	else
		setPedControlState(npc,"aim_weapon",true)
		setPedControlState(npc,"fire",not getPedControlState(npc,"fire"))
	end
end

--客户端：NPC设计element
--TODO:当前设计的是NPC或者PED的头部，不适合动物
function makeNPCShootAtElement(npc,target)
	local x,y,z = getElementPosition(target)
	local vx,vy,vz = getElementVelocity(target)
	local tgtype = getElementType(target)
	if tgtype == "ped" or tgtype == "player" then
		x,y,z = getPedBonePosition(target,3)
		local vehicle = getPedOccupiedVehicle(target)
		if vehicle then
			vx,vy,vz = getElementVelocity(vehicle)
		end
	end
	vx,vy,vz = vx*6,vy*6,vz*6
	makeNPCShootAtPos(npc,x+vx,y+vy,z+vz)
end

--客户端：设置AI参数
function initalAIParameter(npc)
	if AI[npc] == nil then
		AI[npc] = {}
		AI[npc].decision = AI.decisions[1]
		if debug then
			AI[npc].text = DGS:dgsCreate3DText(0,0,4,"D:IDLE",white)
			DGS:dgsSetProperty(AI[npc].text,"fadeDistance",20)
			DGS:dgsSetProperty(AI[npc].text,"textSize",{0.6,0.6})
			DGS:dgsSetProperty(AI[npc].text,"shadow",{0.2,0.2,tocolor(0,0,0,255),true})
			DGS:dgs3DTextAttachToElement(AI[npc].text,npc,0,0)
			--DGS:dgsAttachToAutoDestroy(npc,AI[npc].text)
		end
		addEventHandler("onClientElementDestroy", npc, function ()
			if isTimer(AI[source].timer) then killTimer(AI[source].timer) end
			if debug then
				destroyElement(AI[source].text)
			end
			AI[source] = nil
		end)
	end
end

--判断路
function isModelObstcle(model_id)
	local dff = engineGetModelNameFromID(model_id) -- check if not road
	
	if dff ~= false and tostring(dff) then 
		local isRoad = string.match(dff, 'road')
		if isRoad ~= nil then
			--print(string.format( "%d : %s NO",model_id,dff))
			return false
		end
	end
	return true
end

function obstacleCheck(hitModel)
	if hitModel~= nil and tonumber(hitModel) then 
		return isModelObstcle(hitModel)
	end
	return true
end

--更多用于车的射线检测
function createRaycast(element,type)
	local px,py,pz = getElementPosition(element)
	local x0, y0, z0, x1, y1, z1 = getElementBoundingBox( element )
	local vWidth = mathAbs(y0 - y1)
	local vHeight = mathAbs(x0 -x1)
	local lx,ly,lz = 0
	if type == "raycast_l" then
		lx,ly,lz = getPositionFromElementOffset(element,-AI.config.sensorOffset,vWidth+1,AI.config.sensorOffsetZ)
	end
	if type == "raycast_m" then
		lx,ly,lz = getPositionFromElementOffset(element,0,vWidth+1.5,AI.config.sensorOffsetZ)
	end
	if type == "raycast_r" then
		lx,ly,lz = getPositionFromElementOffset(element,AI.config.sensorOffset,vWidth+1,AI.config.sensorOffsetZ)
	end
	if type == "raycast_b" then
		lx,ly,lz = getPositionFromElementOffset(element, 0,-(vWidth/2+1),AI.config.sensorOffsetZ)
	end
	if type == "raycast_sr" then
		lx,ly,lz = getPositionFromElementOffset(element,vHeight/2 + 1,0,AI.config.sensorOffsetZ)
	end
	if type == "raycast_sl" then
		lx,ly,lz = getPositionFromElementOffset(element,-(vHeight/2 + 1),0,AI.config.sensorOffsetZ)
	end
	if type == "raycast_bl" then
		lx,ly,lz = getPositionFromElementOffset(element, AI.config.sensorOffset+0.5,-(vWidth/2+1),AI.config.sensorOffsetZ)
	end
	if type == "raycast_br" then
		lx,ly,lz = getPositionFromElementOffset(element, -AI.config.sensorOffset-0.5,-(vWidth/2+1),AI.config.sensorOffsetZ)
	end

	local ray,_,_,_,hitElement,_,_,_,_,_,_,hitModel = processLineOfSight(px,py,pz+AI.config.sensorOffsetZ,lx,ly,lz,true,true,true,true,false,true,true,false,element,true)
	if ray then
		ray = obstacleCheck(hitModel)
	end
	if debug then dxDrawLine3D( px,py,pz, lx,ly,lz,ray == true and tocolor ( 255, 0, 0, 255 )  or tocolor ( 0, 255, 0, 255 ) ,1 ) end

	return ray,hitElement,hitModel
end

function isVehicleWaitingTrafficLight(veh)
	if isElement(veh) and getElementType(veh) == "vehicle" then
		local npc = getVehicleOccupant (veh,0)
		if AI[npc] ~= nil then 
			if AI[npc].task == "waitForGreenLight" then return true end
		end
	end
	return false
end
function isGreenLight(direction)
	local state = getTrafficLightState()
	if direction == "NS" then 
		return state == 0 or state == 5 or state == 8
	end
	if direction == "WE" then 
		return state == 3 or state == 5 or state == 7
	end
end
function makeNPCDriveToPos(npc,x,y,z,light)
	local car = getPedOccupiedVehicle(npc)
	local crx,cry,crz = getElementRotation(car)
	if crx > 180 and crx < 270 then return setElementHealth(car,0) end -- fliped boom
	if getElementHealth( car ) <= 0 then 
		return
	end
	local px,py,pz = getElementPosition(car)
	local m = getElementMatrix(car)
	local _rx,_ry,_rz = crx*degToRad,cry*degToRad,crz*degToRad
	local rxCos,ryCos,rzCos,rxSin,rySin,rzSin = mathCos(_rx),mathCos(_ry),mathCos(_rz),mathSin(_rx),mathSin(_ry),mathSin(_rz)
	local m11,m12,m13,m21,m22,m23,m31,m32,m33 = rzCos*ryCos-rzSin*rxSin*rySin,ryCos*rzSin+rzCos*rxSin*rySin,-rxCos*rySin,-rxCos*rzSin,rzCos*rxCos,rxSin,rzCos*rySin+ryCos*rzSin*rxSin,rzSin*rySin-rzCos*ryCos*rxSin,rxCos*ryCos
	x,y,z = x-px,y-py,z-pz
	local rx,ry,rz = x*m11+y*m12+z*m13,x*m21+y*m22+z*m23,x*m31+y*m32+z*m33
	if ry <= 0 then
		setPedControlState(npc,"vehicle_left",rx < 0)
		setPedControlState(npc,"vehicle_right",rx >= 0)
	else
		local secondpart = getTickCount()%100
		setPedControlState(npc,"vehicle_left",rx*500/ry < -secondpart)
		setPedControlState(npc,"vehicle_right",rx*500/ry > secondpart)
	end
	local vx,vy,vz = getElementVelocity(car)
	local vrx,vry,vrz = vx*m11+vy*m12+vz*m13,vx*m21+vy*m22+vz*m23,vx*m31+vy*m32+vz*m33
	local speed

	local currentTick = getTickCount()

	-- inject AI Sensor logic
	initalAIParameter(npc)
	if isElementStreamedIn(car) then -- do it only when the car is streamed in
		-- setup tasks
		AI[npc].task = getNPCCurrentTask(npc)[1]
		-- setup sensors
		--[[
		-- left
		AI[npc].ray_l,AI[npc].ray_l_hit,AI[npc].ray_l_model = createRaycast(car,"raycast_l")
		-- mid
		AI[npc].ray_m,AI[npc].ray_m_hit,AI[npc].ray_m_model = createRaycast(car,"raycast_m")
		-- right
		AI[npc].ray_r,AI[npc].ray_r_hit,AI[npc].ray_r_model = createRaycast(car,"raycast_r")
		-- back
		AI[npc].ray_b,AI[npc].ray_b_hit,AI[npc].ray_b_model = createRaycast(car,"raycast_b")
		-- side right
		AI[npc].ray_sr,AI[npc].ray_sr_hit,AI[npc].ray_sr_model = createRaycast(car,"raycast_sr")
		-- side left
		AI[npc].ray_sl,AI[npc].ray_sl_hit,AI[npc].ray_sl_model = createRaycast(car,"raycast_sl")
		-- back left
		AI[npc].ray_bl,AI[npc].ray_bl_hit,AI[npc].ray_bl_model = createRaycast(car,"raycast_bl")
		-- back right
		AI[npc].ray_br,AI[npc].ray_br_hit,AI[npc].ray_br_model = createRaycast(car,"raycast_br")
		--]]

		-- left
		local ray_l = createRaycast(car,"raycast_l")
		-- mid
		local ray_m,hitElement = createRaycast(car,"raycast_m")
		-- right
		local ray_r = createRaycast(car,"raycast_r")
		-- back
		local ray_b = createRaycast(car,"raycast_b")
		-- side right
		local ray_sr = createRaycast(car,"raycast_sr")
		-- side left
		local ray_sl = createRaycast(car,"raycast_sl")
		-- back left
		local ray_bl = createRaycast(car,"raycast_bl")
		-- back right
		local ray_br = createRaycast(car,"raycast_br")
		
		-- logic
		if AI[npc].task == "driveAroundBend" then
			speed = getNPCDriveSpeed(npc)*mathSin(mathPi*0.5-mathAtan(mathAbs(rx/ry))*0.75) * 0.7
		else 
			speed = getNPCDriveSpeed(npc)*mathSin(mathPi*0.5-mathAtan(mathAbs(rx/ry))*0.75) * 0.9
		end
		-- logic for idle
		-- render debug text
		if debug then
			DGS:dgsSetProperty(AI[npc].text,"text",string.format("%s\nDECISION:%s\nLIGHT:%s",AI[npc].task,AI[npc].decision,light ~= nil and light or "N/A"))
		end

		-- check if is train then stop do nothing


		if AI[npc].decision == AI.decisions[1] then
			--[[
			if not ray_m and not ray_l and not ray_r then
				speed = speed
			end
			--]]

			if ray_m then
				-- check if is vehile & wait for green light
				local _,hit = createRaycast(car,"raycast_m")
				if hit ~=nil and isElement(hit) and getElementType(hit) == "vehicle" and light ~= nil and isGreenLight(light) == false and AI[npc].task == "driveAlongLine" then 
					speed = 0
					setPedControlState (npc,"handbrake",true)
				else
					AI[npc].decision = AI.decisions[2]
					AI[npc].lastDecisionTick = currentTick
				end
				
			end
			if ray_l then
				-- check if is vehile & wait for green light
				local _,hit = createRaycast(car,"raycast_l")
				if hit ~=nil and isElement(hit) and getElementType(hit) == "vehicle" and light ~= nil and isGreenLight(light) == false and AI[npc].task == "driveAlongLine" then 
					speed = 0
					setPedControlState (npc,"handbrake",true)
				else
					AI[npc].decision = AI.decisions[2]
					AI[npc].lastDecisionTick = currentTick
				end
				
			end
			if ray_r then
				-- check if is vehile & wait for green light
				local _,hit = createRaycast(car,"raycast_r")
				if hit ~=nil and isElement(hit) and getElementType(hit) == "vehicle" and light ~= nil and isGreenLight(light) == false and AI[npc].task == "driveAlongLine" then 
					speed = 0	
					setPedControlState (npc,"handbrake",true)
				else
					AI[npc].decision = AI.decisions[2]
					AI[npc].lastDecisionTick = currentTick
				end
				
			end
			if ray_sl or ray_sr then
				AI[npc].decision = AI.decisions[2]
				AI[npc].lastDecisionTick = currentTick
			end
			
			setPedControlState (npc,"handbrake",false)
			setPedControlState(npc,"accelerate",vry < speed)
			setPedControlState(npc,"brake_reverse",vry > speed*1.2)
		end
		-- logic for forward aovding obstcle
		if AI[npc].decision == AI.decisions[2] then
		
			if ray_m then
				speed = speed * 0.5
			end

			if ray_r or ray_r and ray_m then
				speed = speed * 0.5
				controlVehicleLeft(npc)
			end
			if ray_l or ray_l and ray_m then
				speed = speed * 0.5
				controlVehicleRight(npc)
			end
			if ray_sl then
				controlVehicleRight(npc)
			end
			if ray_sr then
				controlVehicleLeft(npc)
			end

			if ray_m and  ray_r and ray_l and task == "driveAlongLine" or ray_r and ray_l and AI[npc].task == "driveAlongLine" then
				AI[npc].decision = AI.decisions[3]
				AI[npc].lastDecisionTick = currentTick
				return
			end
			if not ray_m or not ray_l or not ray_r  then
				AI[npc].decision = AI.decisions[1]
				return

			elseif currentTick - AI[npc].lastDecisionTick >= AI.config.decision_timeout then
				AI[npc].decision = AI.decisions[1]
				return
			end
			setPedControlState(npc,"accelerate",vry < speed)
			setPedControlState(npc,"brake_reverse",vry > speed*1.1)
		end
		-- logic for backwords avoding obstcles
		if AI[npc].decision == AI.decisions[3] then
			speed = speed * 0.5
			if ray_b then
				AI[npc].decision = AI.decisions[1]
			end
			if not ray_l or not ray_r then
				if not ray_l then
					controlVehicleRight(npc)
				end
				if not ray_r then
					controlVehicleLeft(npc)
				end
				if currentTick - AI[npc].lastDecisionTick >= AI.config.backwardsTimer then
					AI[npc].decision = AI.decisions[1]
				end
			end

			if ray_bl then
				controlVehicleRight(npc)
			end

			if ray_br then
				controlVehicleLeft(npc)
			end

			controlVehicleBackward(npc)
			setPedControlState(npc,"brake_reverse",vry < speed)
			setPedControlState(npc,"accelerate",vry > speed*1.1)

		end
		-- logic for wait obstcle
		if AI[npc].decision == AI.decisions[4] then
			speed = 0
		end

	else
		speed = getNPCDriveSpeed(npc)*mathSin(mathPi*0.5-mathAtan(mathAbs(rx/ry))*0.75) 
		setPedControlState(npc,"accelerate",vry < speed)
		setPedControlState(npc,"brake_reverse",vry > speed*1.1)
	end



end


addEventHandler("onClientVehicleCollision", root,
	function(collider, damageImpulseMag, bodyPart, x, y, z, nx, ny, nz,hitElementforce,model)
		if collider ~= nil then return end
		local npc = getVehicleOccupant (source,0)

		if isModelObstcle(model) then
			if AI[npc] ~= nil and AI[npc].decision == AI.decisions[2] and bodyPart == 4 or AI[npc] ~= nil and collider == nil then
				AI[npc].decision = AI.decisions[3]
				AI[npc].lastDecisionTick = getTickCount()
			end
		end		
	end
)

function makeNPCDriveAlongLine(npc,x1,y1,z1,x2,y2,z2,off,light)
	local car = getPedOccupiedVehicle(npc)
	local x,y,z = getElementPosition(car)
	local p2 = getPercentageInLine(x,y,x1,y1,x2,y2)
	local len = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	p2 = p2+off/len
	local p1 = 1-p2
	local destx,desty,destz = p1*x1+p2*x2,p1*y1+p2*y2,p1*z1+p2*z2
	makeNPCDriveToPos(npc,destx,desty,destz,light)
end

function makeNPCDriveAroundBend(npc,x0,y0,x1,y1,z1,x2,y2,z2,off)
	local car = getPedOccupiedVehicle(npc)
	local x,y,z = getElementPosition(car)
	local len = getDistanceBetweenPoints2D(x1,y1,x2,y2)*mathPi*0.5
	local p2 = getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)/mathPi*2
	p2 = math.max(0,math.min(1,p2))
	p2 = p2+off/len
	local destx,desty = getPosFromBend(p2*mathPi*0.5,x0,y0,x1,y1,x2,y2)
	local destz = (1-p2)*z1+p2*z2
	makeNPCDriveToPos(npc,destx,desty,destz)
end

function makeNPCwaitForGreenLight(npc)
	stopAllNPCActions(npc)
	if AI[npc] ~= nil then
		AI[npc].task = getNPCCurrentTask(npc)[1]
	end
	if debug and AI[npc] ~= nil then
		
		DGS:dgsSetProperty(AI[npc].text,"text",string.format("%s\nDECISION:%s",AI[npc].task,AI[npc].decision))
	end
end

--[[
addEventHandler("onClientPreRender",root,function() 
	local car = getPedOccupiedVehicle(getLocalPlayer())
	if car then 
		local ray_l = createRaycast(car,"raycast_l")
		-- mid
		local ray_m,hitElement = createRaycast(car,"raycast_m")
		-- right
		local ray_r = createRaycast(car,"raycast_r")
		-- back
		local ray_b = createRaycast(car,"raycast_b")
		-- side right
		local ray_sr = createRaycast(car,"raycast_sr")
		-- side left
		local ray_sl = createRaycast(car,"raycast_sl")
		-- back left
		local ray_bl = createRaycast(car,"raycast_bl")
		-- back right
		local ray_br = createRaycast(car,"raycast_br")
	end
end)
--]]