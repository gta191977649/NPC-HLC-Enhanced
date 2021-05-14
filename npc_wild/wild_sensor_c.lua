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
	--通过对应帮会判断

	local aGang
	if getElementType(a) =="ped" then
		aGang = Data:getData(a,"gang")
	elseif getElementType(a) =="player" then 
		aGang = Player:getPlayerData(a,"Gang");
	end

	local bGang
	if getElementType(b) =="ped" then
		bGang = Data:getData(b,"gang")
	elseif getElementType(b) =="player" then
		bGang = Player:getPlayerData(b,"Gang");
	end

	local rValue = 0
	if getElementType(a) =="player" then
		local r = Player:getPlayerData(a,"Relation");

		if bGang == 0 then
			rValue = -50 -- 自由人(帮会是0)始终是敌对状态
		else
			rValue = r[tostring(bGang)]
		end

	elseif getElementType(b) =="player" then
		local r = Player:getPlayerData(b,"Relation");

		if aGang == 0 then
			rValue = -50 -- 自由人(帮会是0)始终是敌对状态
		else
			rValue = r[tostring(aGang)]
		end
		
	else
		--rValue = basicRelation[aGang][bGang]
		--两者都是NPC，固定关系
		rel = "npc relationship"
	end

	if tonumber(rValue) >= 10 then
		rel = "friendly";
	elseif tonumber(rValue) <= -10 then 
		rel = "hostility";
	end

	-----------------------------------------------

	return rel
end


--玩家/NPC 通知其他人面向玩家
--DONE 有目标的NPC不受到干扰
--TODO 不同物种之间能否相互通知
function warnOther(npc,target,action)
	local x,y,z = getElementPosition(npc);
	local range = 30;
	local peds = getElementsWithinRange(x,y,z,range,"ped");

	for _,ped in pairs(peds) do
		if ped ~= npc then -- 过滤NPC我自己

			--NPC
			local pedTraits = Data:getData(ped,"traits")
			local pedCategory = pedTraits.category;

			--CALLER IS PLAYER OR NPC
			local npcTraits
			local npcCategory

			if getElementType(npc)=="player" then
				npcCategory = "human" -- 玩家属于human物种，所以没有种间隔离
			else
				npcTraits = Data:getData(npc,"traits")
				npcCategory = npcTraits.category;
			end

			--outputDebugString("pedTraits:"..tostring(inspect(pedTraits)));
			outputDebugString("pedCategory:"..tostring(pedCategory));
			outputDebugString("npcCategory:"..tostring(npcCategory));

			--相同物种之间才能沟通
			--DONE 射击能通知到其他物种
			if pedCategory == npcCategory or action == "shoot" then

				--[[
					if NPC:isNPCHaveTask(ped) then
						task = NPC:getNPCCurrentTask(ped)
						--QUEST:这里task理论上不为空，但是确实存在空
						if task and task[1] == "killPed" then
						else
						end
					else
						--没有任务的NPC（基本上不存在）
					end
				]]

				--有目标的NPC不理睬警告
				local pedTarget = Data:getData(ped,"target")

				if not pedTarget then
					--outputChatBox(inspect(ped).." MISS TARGET :"..tostring(pedTarget));

					--先做寻找动作
					IFP:syncAnimationLib ( ped, "human", "search", -1, false) --KEEP SEARCH
					--延迟2秒后转过来（2秒差不多正好转头动作做完）
					setTimer(setElementFaceTo,2000,1,ped,target)
					wildFind(ped,target,false,action)--发现但是不通知其他人
				else
					--outputChatBox(inspect(ped).." pedTarget :"..tostring(pedTarget));
				end
				
			end

		end
	end

end


--注意，目前的target只可能是玩家
-----------------------------------------------
-- NPC 发现目标
-- 参数 NPC,目标，是否通知其他人，发现在干什么
-----------------------------------------------
function wildFind(npc,target,warn,action)

	if warn == nil then warn = true end -- 默认通知其他人

	--outputDebugString(tostring(Data:getData(npc,"name")).." warn other "..tostring(warn));

	local traits = Data:getData(npc,"traits");
	--detail 
	local isAnimal = table.haveValue(traits,"animal"); -- 是动物
	local isZombie = table.haveValue(traits,"zombie"); -- 是僵尸
	--关系
	local relationType = getRelationship(npc,target);
	outputDebugString(inspect(npc).." relationType:"..tostring(relationType));

	if relationType == "hostility" then

		--敌对关系
		triggerEvent("sync.message", npc, npc, 240, 125, 0, "ALERT") -- 警戒标识

		if isAnimal or isZombie then
			--triggerEvent("onChatbubblesMessageIncome",npc,"*Ao*Wu",0);
		else
			IFP:syncAnimationLib ( npc, "human", "warn",-1,false); -- 通知其他NPC的动作
		end
		
		setElementFaceTo(npc,target)
		if warn then
			outputChatBox(tostring(Data:getData(npc,"name")).." find and warn other");
			warnOther(npc,target);
		end

		local shootdist = Data:getData(npc,"shootdist");
		local followdist = Data:getData(npc,"followdist");
		local behaviour = Data:getData(npc,"behaviour");

		outputChatBox("behaviour:"..tostring(behaviour))

		--------------------------------
		--PLANA 根据behaviour决定
		if behaviour == "guard" then
			--DO NOTHING CAUSE TASK HANDLE IT
			triggerEvent("onChatbubblesMessageIncome",npc,Loc:Localization(table.random(regularAlertLines)),0);
			Data:setData(npc,"target",target);--设置目标(仅在必要时)
		elseif behaviour == "hunt" then
			--if not isNPCHaveTask
			triggerEvent("onChatbubblesMessageIncome",npc,Loc:Localization(table.random(regularAlertLines)),0);
			triggerServerEvent("npc > setTask",npcRoot,npc,{"killPed",target,shootdist,followdist})
			Data:setData(npc,"target",target);--设置目标(仅在必要时)
		else
			--敌人的默认行为NPC(无特殊action，发现敌人玩家)
			--PANIC任务 使用NPC恐惧 target
			--triggerServerEvent("npc > setTask",npcRoot,npc,{"panic",target})
		end

		-----------------------------
		--PLANB 根据性格决定
		if table.haveValue(traits,"tough") then
			triggerServerEvent("npc > setTask",npcRoot,npc,{"killPed",target,shootdist,followdist})
			Data:setData(npc,"target",target);--设置目标(仅在必要时)
		elseif table.haveValue(traits,"weak") then
			--注意目前weak属性属于动物，动物直接逃离玩家
			triggerServerEvent("npc > setTask",npcRoot,npc,{"awayFromElement",target,0.1,200})
			Data:setData(npc,"target",target);--设置目标(仅在必要时)
			--triggerServerEvent("npc > setTask",npcRoot,npc,{"panic",target})
		else
			--NORMAL
			--中立性格，不软不硬
		end

		

	elseif relationType == "friendly" then
		--triggerEvent("onChatbubblesMessageIncome",npc,"Hello "..tostring(getPlayerName(target)..", We are "..tostring(relationType)),0);
		--友好NPC
	else
		--triggerEvent("onChatbubblesMessageIncome",npc,"This is "..tostring(getPlayerName(target)..", We are "..tostring(relationType)),0);
		--和平NPC
	end

	----------------
	--对特殊行为的反应
	if action == "shoot" then
		--当目标在射击时
		if table.haveValue(traits,"civilian") then
			--所有的市民都会恐惧开枪
			triggerServerEvent("npc > setTask",npcRoot,npc,{"panic",target})
		end
	end


	
end
addEvent("npc > findTarget",true)
addEventHandler("npc > findTarget",root,wildFind,false)


-----------------------------------------------
-- NPC 丢失目标
-----------------------------------------------
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
			Data:setData(npc,"target",false);--清理长期目标
		else
			--其他情况
			Data:setData(npc,"target",false);--清理长期目标
		end

	else
		--没有任务了，忘记他吧
		--TODO 这里未执行到过....可能目前丢失玩家的时候基本上都是有任务的状态
		--outputChatBox("wildLost AND TRY TO FORGET");
		Data:setData(npc,"target",false);--清理长期目标
	end 
end
addEvent("npc > lostTarget",true)
addEventHandler("npc > lostTarget",root,wildLost,false)

-----------------------------------------------
-- NPC 受伤
-----------------------------------------------
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

		--获取受害者和攻击者之间的关系
		local relationType = getRelationship(source,attacker);
		
		local name = Data:getData(source,"name");

		outputChatBox(tostring(name).." find new attacker "..tostring(inspect(attacker)));

		--误伤是否反击？
		--目前只反击玩家或者非友好帮会的攻击
		if getElementType(attacker) == "player" or relationType ~= "friendly" then
			-----------------
			---player killer
			------------------
			--如果已有attacker作为目标，就不要再执行了
			if NPC:isNPCHaveTask(source) then
				task = NPC:getNPCCurrentTask(source)
				--QUEST:这里task理论上不为空，但是确实存在空
				if task and task[1] == "killPed" and task[2]==attacker then
					outputChatBox("IGNORE SAME ATTACKER TO FIGHT BACK");
				else
					local traits = Data:getData(source,"traits");
					if table.haveValue(traits,"civilian") then
						--重要：强制停止之前的动作（比如PANIC时的举手）
						IFP:syncAnimationLib(source) -- 停止动作
						triggerServerEvent("npc > setTask",npcRoot,source,{"awayFromElement",attacker,0.1,200})
						--setNPCTask(ped,{"awayFromElement",task[2],0.1,200})
					else
						--立刻 反击
						local shootdist = Data:getData(source,"shootdist");
						local followdist = Data:getData(source,"followdist");
						triggerServerEvent("npc > setTask",npcRoot,source,{"killPed",attacker,shootdist,followdist})
						Data:setData(source,"target",attacker);--设置长期目标
					end

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
addEventHandler ( "onClientPedDamage", root, wildDamageSensor )


-----------------------------------------------
-- 玩家开枪
--
-----------------------------------------------
function shootingNoise(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	warnOther(source,source,"shoot")--source 开枪者
	--setPedAnimation ( source, "ped", "flee_lkaround_01", -1, true, true, true )
end
addEventHandler ( "onClientPlayerWeaponFire", localPlayer, shootingNoise )