
--------------------------------
--AIM NPC
--------------------------------

--瞄准NPC
--注意 未右键瞄准时也可以除法
--TODO 屏蔽僵尸/动物
function aimAtNPC(ped)

	if not ped then return end
	if getElementType(ped)~= "ped" then return end -- 目前只检测PED

	-- Detail
	local traits = Data:getData(ped,"traits") 
	local isAnimal = table.haveValue(traits,"animal"); -- 是动物
	local isZombie = table.haveValue(traits,"zombie"); -- 是僵尸
	--

	if isAnimal or isZombie then return end -- 动物和僵尸不会对玩家关注做出回应

	local aiming = getControlState(source,"aim_weapon") -- 区分冷兵器还是热武器用？
	local validPed = false -- ped 
	local armed -- 是否使用武器瞄准

	--特定武器才触发(似乎只有热武器)
	local slot = getSlotFromWeapon(getPedWeapon(source))
	if slot > 1 and slot ~= 10 then 
		armed = true 
	else 
		armed = false 
	end

	--outputChatBox(inspect(ped).." aimAtNPC aiming:"..tostring(aiming).." armed:"..tostring(armed));

	--过滤未被威胁过的NPC
	--确保距离够近
	if ped and armed then
		local distance = getDistance(ped,source);
		if distance < 5 then
			validPed = true
			theThreatenedPed = ped -- 确保同时只能威胁一名NPC掏出物品
		end
		--outputChatBox(inspect(ped).." targeted")
	end

	--执行
	if validPed then
		
		--outputDebugString("traits:"..tostring(traits))
		local civ = table.haveValue(traits,"civilian");
		--outputDebugString("civ:"..tostring(civ));

		local taskName = exports.npc_hlc:getNPCTaskName(ped);
		if taskName == "panic" then
			--已经是panic状态了
			if getElementData(ped,"talking") or isPedDead(ped) then return end; -- 过滤正在说话状态
			
			setElementData(ped, "talking", true)
			setTimer(function()
				setElementData(ped, "talking", false)
			end,5000,1)	

			triggerClientEvent("onChatbubblesMessageIncome",ped,Loc:Localization(table.random(panicChat),source),0);
			triggerClientEvent(root, "sync.message", ped, ped, 255, 255, 255, "PANIC")

		else

			--瞄准市民 触发panic 
			--只有市民会投降
			--这里是突发事件，不要被谈话过滤掉
			--注意 这里检测慢一些，所以总是会先触发后续代码
			if aiming and civ then
				
				outputDebugString("make ped panic!");
				
				exports.npc_hlc:setNPCTask(ped,{"panic",source}) -- 使用NPC恐惧source
				triggerClientEvent("onChatbubblesMessageIncome",ped,Loc:Localization(table.random(threatenRobbingMessages),source),0);
				triggerClientEvent(root, "sync.message", ped, ped, 255, 255, 255, "SCARED")

			end

			-- 过滤正在说话状态
			if getElementData(ped,"talking") or isPedDead(ped) then return end;

			setElementData(ped, "talking", true)
			setTimer(function() 
				setElementData(ped, "talking", false)
			end,5000,1)	

			-----------------------------

			local relation = getRelationship(source,ped);
			outputChatBox("relation:"..tostring(relation));
	
			--友好关系，条件成立
			if relation == "friendly" or relation == "ignore" then

				if aiming then
					--武器瞄准时的信息
					triggerClientEvent("onChatbubblesMessageIncome",ped,Loc:Localization(table.random(threatenFriendlyMessages),source),0);
					triggerClientEvent(root, "sync.message", ped, ped, 255, 255, 255, "ANGRY")
				else
					--玩家未瞄准时的信息
					triggerClientEvent("onChatbubblesMessageIncome",ped,Loc:Localization(table.random(unholsteredFriendlyMessages),source),0);
					triggerClientEvent(root, "sync.message", ped, ped, 255, 255, 255, "ALERT")
				end

			elseif relation == "hostility" then

				--敌对关系，条件成立

				--当玩家举起格斗武器时 惧怕玩家的动作
				--outputChatBox("aiming:"..tostring(aiming));
				--outputChatBox("getSlotFromWeapon(getPedWeapon(ped):"..tostring(getSlotFromWeapon(getPedWeapon(ped))));

				-- 没瞄准CIV的时候惊吓他们
				-- 非CIV的其他敌人已经攻击玩家了，不在这里处理
				if civ and not aiming then -- and (getSlotFromWeapon(getPedWeapon(ped)) < 2 or getSlotFromWeapon(getPedWeapon(ped)) == 10) then
					setElementFaceTo(ped,source)
					setPedAnimation(ped,"ped","handscower",4000,false,true,false,false) -- 被瞄准惊吓
					triggerClientEvent("onChatbubblesMessageIncome",ped,Loc:Localization(table.random(meleeThreatenedMessages),source),0);
					triggerClientEvent(root, "sync.message", root, ped, 255, 255, 255, "INTIMIDATED")
				end

				--否则，不想搭理玩家...
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