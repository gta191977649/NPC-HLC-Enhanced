--重要函数，获取二者之间的关系
--参数：英文
function getRelationship(a,b)

	local rel = "ignore" -- 默认关系，无视

	local traitsA = Data:getData(a,"traits");
	local traitsB = Data:getData(b,"traits");

	--------------------------------------------------
	--任意一方为僵尸，且二者不都为僵尸
	local aZb = table.haveValue(traitsA,"zombie");
	local bZb = table.haveValue(traitsB,"zombie");
	if aZb ~= bZb and (aZb or bZb) then
		rel = "hostility"
		return rel;
	end

	---------------------------------------------------
	--

	return rel
end

--注意，目前的target只可能是玩家
function wildFind(npc,target)

	local name = Data:getData(npc,"name");

	--TODO 更好的方式?
	--只需要判定NPC对玩家是哪种行为，最后执行即可

	--根据两者关系决定动物的行为
	local gang = Data:getData(npc,"gang");

	local gang_target
	if getElementType(target) =="ped" then
		gang_target = Data:getData(target,"gang")
	elseif getElementType(target) =="player" then 
		gang_target = Player:getPlayerData(target,"Gang");
	end
	outputChatBox(tostring(name).." find new target "..tostring(inspect(target)).."gang:"..tostring(gang_target));

	triggerEvent("sync.message", npc, npc, 240, 125, 0, "ALERT")

	if gang ~= gang_target then

		--debug 
		--if Data:getData(npc,"type") == "goat" then
		--	triggerServerEvent("npc > setTask",npcRoot,npc,{"awayFromElement",target,0.1,200})
		--	return 
		--end

		--二者位于不同帮会
		local shootdist = Data:getData(npc,"shootdist");
		local followdist = Data:getData(npc,"followdist");
		local behaviour = Data:getData(npc,"behaviour");

		outputChatBox("behaviour:"..tostring(behaviour))

		--NPC无组织
		if gang == 0 then
			--TODO 僵尸也没有组织
			if Data:getData(npc,"category") == "zombie" then
				triggerServerEvent("npc > setTask",npcRoot,npc,{"killPed",target,shootdist,followdist})
			else
				triggerEvent("onChatbubblesMessageIncome",npc,"Hello "..tostring(getPlayerName(target).."!"),0);
			end
			
		elseif gang_target == 0 then
			--玩家无组织
			triggerEvent("onChatbubblesMessageIncome",npc,"Hello "..tostring(getPlayerName(target).."!"),0);
			--TODO 注意，这里因为设置了target，守卫任务的NPC还是会攻击，应该修复
		else

			--根据behaviour判定
			if behaviour == "guard" then
				--DO NOTHING CAUSE TASK HANDLE IT
			elseif behaviour == "hunt" then
				--if nott isNPCHaveTask
				triggerEvent("onChatbubblesMessageIncome",npc,"Kill "..tostring(getPlayerName(target).."!"),0);
				triggerServerEvent("npc > setTask",npcRoot,npc,{"killPed",target,shootdist,followdist})
			else
				triggerServerEvent("npc > setTask",npcRoot,npc,{"awayFromElement",target,0.1,200})
			end
			
		end
		
	else
		--二者帮会相同
		--triggerServerEvent("npc > setTask",npcRoot,npc,{"awayFromElement",target,0.1,200})
		triggerEvent("onChatbubblesMessageIncome",npc,"Hello "..tostring(getPlayerName(target).."!"),0);
	end

	Data:setData(npc,"target",target);--设置长期目标
end
addEvent("npc > findTarget",true)
addEventHandler("npc > findTarget",root,wildFind,false)


--注意，目前的target只可能是玩家
function wildLost(npc,target)

	local name = Data:getData(npc,"name");
	
	outputChatBox(tostring(name).." lost target "..tostring(inspect(target)));
	--triggerServerEvent("npc > clearTask",getResourceRootElement(getResourceFromName("npc_hlc")),npc)

	if NPC:isNPCHaveTask(npc) then
		task = NPC:getNPCCurrentTask(npc)
		--QUEST:这里task理论上不为空，但是确实存在空
		--杀人任务目标丢失，放弃击杀
		if task and task[1] == "killPed" and task[2]==target then
			--
			outputChatBox("npc:"..tostring(inspect(npc)).."Lost me and go to check last point");
			local x,y,z = getElementPosition(target);
			triggerServerEvent("npc > setTask",npcRoot,npc,{"walkToPos",x,y,z,2})

		elseif task and task[1] == "guardPos" then
			--守卫任务目标丢失，清空目标
			--outputChatBox("GUARD wildLost AND TRY TO FORGET");
			Data:setData(npc,"target",nil);--清理长期目标
		end

	else
		--没有任务了，忘记他吧
		--TODO 这里未执行到过....可能目前丢失玩家的时候基本上都是有任务的状态
		--outputChatBox("wildLost AND TRY TO FORGET");
		Data:setData(npc,"target",nil);--清理长期目标
	end 
end

addEvent("npc > lostTarget",true)
addEventHandler("npc > lostTarget",root,wildLost,false)

--客户端受伤后决策判定
function wildDamageSensor(attacker,weapon,bodypart,loss)

	if not getElementData(source,"creature") then
		cancelEvent()
		--outputChatBox("return need after cancel");
		return;
	end
	--source:ped that got damaged
	--outputChatBox(inspect(attacker).." attack "..inspect(source));

	--有攻击者
	if attacker then

		--根据两者关系决定动物的行为
		local gang = Data:getData(source,"gang");--被攻击者帮会
		local gang_attacker = Data:getData(attacker,"gang");--攻击者帮会

		--误伤是否反击
		--目前只反击玩家或者非同帮会成员
		if getElementType(attacker) == "player" or ( gang ~= gang_attacker ) then
			-----------------
			---player killer
			------------------
			--如果已有attacker作为目标，就不要再执行了
			if NPC:isNPCHaveTask(source) then
				task = NPC:getNPCCurrentTask(source)
				--QUEST:这里task理论上不为空，但是确实存在空
				if task and task[1] == "killPed" and task[2]==target then
					outputChatBox("IGNORE SAME ATTACKER TO FIGHT BACK");
				else
					--立刻 反击
					local shootdist = Data:getData(source,"shootdist");
					local followdist = Data:getData(source,"followdist");
					triggerServerEvent("npc > setTask",npcRoot,source,{"killPed",attacker,shootdist,followdist})
					Data:setData(source,"target",target);--设置长期目标
				end
			end

		elseif getElementType(attacker) == "vehicle" then
			-----------------
			---veh killer
			-----------------

		end


	else
	end

	--TODO 如果NPC被2个以上玩家顺序攻击，会频繁的改变目标，需要增加一个仇恨值判断，例如新目标是否比旧目标仇恨值更高

end
--注意这里getRootElement()需要是NPC的上级
addEventHandler ( "onClientPedDamage", getRootElement(), wildDamageSensor )