--客户端 视觉与听觉检测

SENSOR_COUNT = 1000 --循环间隔

function initNPCSensor()
	setTimer ( sensorChecks, SENSOR_COUNT, 0)
end
addEventHandler("onClientResourceStart",resourceRoot,initNPCSensor)


--[[
We check the chance for a npc to detect a player based on his
visibility and sound. The closer the player is to a npc, the 
bigger the chance to be detected.
]]
--参数：距离，噪音或者视野
function checkLOSChance(distance,value)
	local var = math.max((value-distance),0)
	distance = math.max(0.1,distance)
	local maxExp = math.exp(2)*distance
	local myExp = (math.exp(2)*var)/maxExp
	myExp = math.min(myExp*5,100)
	return myExp
end

--核心：检测能否找到(看或者听到)本地玩家
--参数：目标NPC
function checkFind(npc)

	canFind = false
	targetBySound = false 
	targetByVisibility = false

	----获取二者坐标
	local Nx,Ny,Nz = getElementPosition( npc )
	local Px,Py,Pz = getElementPosition( localPlayer )

	local isclear = isLineOfSightClear (Nx, Ny, Nz+1, Nx, Ny, Nz +1, true, true, false, true, false, false, false) -- 二者之间没有遮挡
	local sound,visibility = Player:getSoundAndVisibilityLevel(); -- 获取玩家的噪音和可见度（可能需要整合）
	local distance = getDistanceBetweenPoints3D(Px, Py, Pz, Nx, Ny, Nz);

	-------------------------看见/听见玩家检测2.0
	-- Noise Detection
	if distance <= sound/4 then
		if sound >= 80 then
			targetBySound = true		
		else
			local LOSChance = checkLOSChance(distance,sound)
				if math.random(0,100) < LOSChance then
					targetBySound = true
				end
		end
	else
			targetBySound = false
	end

	-- Visibility Detection
	-- 僵尸最大视野45
	local col = getElementData(npc,"viewcol");
	--outputChatBox(tostring(checkFind));
	if isclear and col and isElementWithinColShape(localPlayer,col) then
		--local LOSChance = checkLOSChance(distance,visibility)
		--if math.random(0,100) < LOSChance then
		--		targetByVisibility = true
		--end
		targetByVisibility = true
	else
		--TODO:如果已经锁定了玩家，近距离不会丢失
		if distance < 10 and getElementData ( npc, "target" ) == localPlayer then 
			targetByVisibility = true
		else
			targetByVisibility = false
		end
	end

	if targetBySound or targetByVisibility then
		canFind = true 
	end
	--outputChatBox("targetBySound:"..tostring(targetBySound)..",targetByVisibility:"..tostring(targetByVisibility));
	--canFind = false --debug
	return canFind,targetBySound,targetByVisibility

end

--核心：感应检测
function sensorChecks()
	--outputChatBox("sensorChecks start");
	for pednum,npc in ipairs(getElementsByType("ped",root,true)) do
		if getElementData(npc,"npc_hlc") then
			--outputChatBox("sensorChecks npc_hlc");
			if getElementHealth(getPedOccupiedVehicle(npc) or npc) >= 1 then
				--outputChatBox("sensorChecks Health");
				-- TODO 如果NPC存在SENSOR能力（才进入循环）

				-- if (getDistanceBetweenPoints3D(Px, Py, Pz, Zx, Zy, Zz) < 45 ) then 最大听觉/视觉范围以外不检测

						--判定能否 找到/听/看到 玩家
						local canFind,hear,visible = checkFind(npc);
						--outputChatBox("canFind:"..tostring(canFind).." hear:"..tostring(hear)..",visible:"..tostring(visible));
						
						if canFind then
							--outputChatBox("localPlayer:"..tostring(inspect(getPlayerName(localPlayer))).." been Find");
							--addNPCTask(npc,{"walkFollowElement",localPlayer,1})
							--call(npc_hlc,"addNPCTask",npc,{"walkFollowElement",localPlayer,1})
							--triggerServerEvent("npc > addTask",resourceRoot,npc,{"walkFollowElement",localPlayer,2})
							triggerServerEvent("npc > addTask",resourceRoot,npc,{"killPed",localPlayer,100,1})
						end

				-- end
			end
		end
	end
end 
