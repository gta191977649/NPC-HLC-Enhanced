--注意，目前的target只可能是玩家
function wildFind(npc,target)
	outputChatBox(tostring(inspect(npc)).." find new target "..tostring(inspect(target)));
	--根据两者关系决定动物的行为
	local npc_name = Data:getData(npc,"name")
	if npc_name == "Wolf Crew" or npc_name == "Bear" then
		triggerServerEvent("npc > addTask",npcRoot,npc,{"killPed",target,3,1})
	else
		triggerServerEvent("npc > addTask",npcRoot,npc,{"awayFromElement",target,0.1,200})
	end
end
addEvent("npc > findTarget",true)
addEventHandler("npc > findTarget",root,wildFind,false)


--注意，目前的target只可能是玩家
function wildLost(npc,target)
	outputChatBox(tostring(inspect(npc)).." lost target "..tostring(inspect(target)));
	--triggerServerEvent("npc > clearTask",getResourceRootElement(getResourceFromName("npc_hlc")),npc)

	if NPC:isNPCHaveTask(npc) then
		task = NPC:getNPCCurrentTask(npc)
		if task[1] == "killPed" and task[2]==target then
			--
			outputChatBox("npc:"..tostring(inspect(npc)).."Lost me and go to check last point");
			local x,y,z = getElementPosition(target);
			triggerServerEvent("npc > setTask",npcRoot,npc,{"walkToPos",x,y,z,2})

		end
	end
end
addEvent("npc > lostTarget",true)
addEventHandler("npc > lostTarget",root,wildLost,false)
