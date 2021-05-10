--PS:当目标死亡时，所有以其为目标的攻击者任务都将完成
--重要：因为onNPCTaskDone有延迟，新的任务需要使用timer延迟一下执行！不然会导致任务被错误删除无法触发

function taskDone(task)

	--outputDebugString("TRY taskDone "..tostring(inspect(source)).." taskDone:"..tostring(inspect(task)))

	if task[1]== "doAnim" and task[4]=="idle" then
		--IDLE - > HANG OUT
		--outputDebugString("IDLE - > HANG OUT")

		setTimer(function(ped)
			local x,y = getElementPosition(ped);
			local xcoord,ycoord = math.randomCoord(5,10)
			local tx,ty = x+xcoord,y+ycoord
			setNPCTask(ped,{"hangOut",x,y,tx,ty})
		end,100,1,source)
		
	elseif task[1]== "hangOut" then
		--HANG OUT --> IDLE

		setTimer(function(ped)
			local category = Data:getData(source,"category");
			setNPCTask(ped, {"doAnim",getTickCount(),category,"idle",-1,false,false,true})
		end,100,1,source)

	elseif task[1]== "panic" then

		--恐慌结束->默认转为逃离状态

		setTimer(function(ped)
			setNPCTask(ped,{"awayFromElement",task[2],0.1,200})
		end,100,1,source)

	else

		setTimer(function(ped)
			local x,y = getElementPosition(ped);
			local xcoord,ycoord = math.randomCoord(5,10)
			local tx,ty = x+xcoord,y+ycoord
			setNPCTask(ped,{"hangOut",x,y,tx,ty})
		end,100,1,source)

	end

	--任务完成后qingli目标
	if Data:getData(source,"target") then
		--outputChatBox("taskDone AND TRY TO FORGET");
		Data:setData(source,"target",false);--清理长期目标
	end

	--addNPCTask(source,{"hangOut",x,y,tx,ty})

end


--------------------------------
--AIM NPC
--------------------------------

--瞄准NPC
--注意 未右键瞄准时也可以除法
--TODO 屏蔽僵尸/动物
function aimAtNPC(ped)

	if not ped then return end
	if getElementType(ped)~= "ped" then return end -- 目前只检测PED

	local aiming = getControlState(source,"aim_weapon") -- 区分冷兵器还是热武器用？
	local validPed = false -- ped 
	local armed -- 是否使用武器瞄准

	--特定武器才触发
	local slot = getSlotFromWeapon(getPedWeapon(source))
	if slot > 1 and slot ~= 10 then 
		armed = true 
	else 
		armed = false 
	end

	--outputChatBox(inspect(ped).." aimAtNPC aiming:"..tostring(aiming).." armed:"..tostring(armed));

	--过滤未被威胁过的NPC
	--确保距离够近
	if ped and getElementType(ped) == "ped" and armed then
		local distance = getDistance(ped,source);
		if distance < 5 then
			validPed = true
			theThreatenedPed = ped -- 确保同时只能威胁一名NPC掏出物品
		end
		--outputChatBox(inspect(ped).." targeted")
	end

	--执行
	if validPed then

		local traits = Data:getData(ped,"traits")
		--outputDebugString("traits:"..tostring(traits))
		local civ = table.haveValue(traits,"civilian");
		--outputDebugString("civ:"..tostring(civ));

		local relation = getRelationship(source,ped);

		setElementData(ped,"threatened",true) -- 设置威胁状态（防止频繁检测威胁）
		setTimer(setElementData,10000,1,ped,"threatened",false) -- 清除威胁状态（10秒）

		if not getElementData(ped,"threatened") then

			--友好关系，条件成立
			if relation == "friendly" then

				if aiming then
					--武器瞄准时的信息
					triggerClientEvent("onChatbubblesMessageIncome",ped,Loc:Localization(table.random(threatenFriendlyMessages),source),0);
					triggerClientEvent(root, "sync.message", ped, ped, 255, 255, 255, "ANGRY")
				else
					--玩家未瞄准时的信息
					triggerClientEvent("onChatbubblesMessageIncome",ped,Loc:Localization(table.random(unholsteredFriendlyMessages),source),0);
					triggerClientEvent(root, "sync.message", ped, ped, 255, 255, 255, "ALERT")
				end

			end

			--敌对关系，条件成立
			if relation == "hostility" then

				--if aiming and (getSlotFromWeapon(getPedWeapon(ped)) < 2 or getSlotFromWeapon(getPedWeapon(ped)) == 10) then
					setElementFaceTo(ped,source)
					setPedAnimation(ped,"ped","handscower",4000,false,true,false,false) -- 被瞄准惊吓
					triggerClientEvent("onChatbubblesMessageIncome",ped,Loc:Localization(table.random(meleeThreatenedMessages),source),0);
					triggerClientEvent(root, "sync.message", root, ped, 255, 255, 255, "INTIMIDATED")
				--end
			end

		end

		--瞄准市民 触发panic 
		--只有市民会投降
		if aiming and civ then
			
			--outputDebugString("make ped panic!"..tostring(inspect(getNPCCurrentTask(ped))));
			
			--如果目前task不是panic，设置任务为panic
			local task = getNPCCurrentTask(ped)
			if task[1] ~= "panic" then
				triggerClientEvent("onChatbubblesMessageIncome",ped,Loc:Localization(table.random(threatenRobbingMessages),source),0);
				triggerClientEvent(root, "sync.message", ped, ped, 255, 255, 255, "SCARED")
				setNPCTask(ped,{"panic",source}) -- 使用NPC恐惧source
			end

		end

		--TODO 抢劫
		--[[
		setTimer(function()

			if isElement(ped) and theTargetedElement == ped then -- 确保威胁的是同一个人
				if not getElementData(ped,"wasrobbed") then
					-- -1 善恶
					triggerClientEvent("onChatbubblesMessageIncome",ped,table.random(pedWasRobbedMessages),0);
					triggerClientEvent(root, "sync.message", ped, ped, 255, 255, 255, "ROBBED")
				else
					triggerClientEvent("onChatbubblesMessageIncome",ped,table.random(pedWasAlreadyRobbedMessages),0);
				end

			end

		end	, 5000, 1) -- PED 'PANIC' STATE DURATION after threatened
		]]

	end


	
end
addEventHandler("onPlayerTarget",root,aimAtNPC)