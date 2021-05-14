<<<<<<< HEAD:npc_hlc/control/control_npc_s.lua
UPDATE_INTERVAL_MS = 1000
=======
--服务器：基础任务管理

UPDATE_INTERVAL_MS = 2000
>>>>>>> evenmov:npc_hlc/task/control_npc_s.lua
UPDATE_INTERVAL_MS_INV = 1/UPDATE_INTERVAL_MS
UPDATE_INTERVAL_S = UPDATE_INTERVAL_MS*0.001
UPDATE_INTERVAL_S_INV = 1/UPDATE_INTERVAL_S

function initNPCControl()
	addEvent("npc_hlc:onNPCTaskDone",false)
	setTimer(cycleNPCs,UPDATE_INTERVAL_MS,0)
end

--服务器：循环NPC
function cycleNPCs()
	check_cols = nil
	if check_cols then
		server_coldata = getResourceFromName("server_coldata")
		if server_coldata and getResourceState(server_coldata) == "running" then
			call(server_coldata,"generateColData")
		else
			check_cols = nil
		end
	end

	--决定syncer？
	for npc,exists in pairs(all_npcs) do
		-- find and filtering the un-synced npcs
		if isHLCEnabled(npc) then
			local syncer = getElementSyncer(getPedOccupiedVehicle(npc) or npc)
			if syncer then
				if unsynced_npcs[npc] then
					removeNPCFromUnsyncedList(npc)
				end
			else
				if not unsynced_npcs[npc] then
					addNPCToUnsyncedList(npc)
				end
			end
		else
			if unsynced_npcs[npc] then
				removeNPCFromUnsyncedList(npc)
			end
		end
	end
	-- serverside envaluation for unsynced npcs
	
	local this_time = getTickCount()
	local gamespeed = getGameSpeed()
	--未同步的NPC交给服务器来同步？
	for npc,unsynced in pairs(unsynced_npcs) do
		if getElementHealth(getPedOccupiedVehicle(npc) or npc) >= 1 then
			local time_diff = (this_time-getNPCLastUpdateTime(npc))*gamespeed
<<<<<<< HEAD:npc_hlc/control/control_npc_s.lua
			if time_diff > 1 then
				local task = getNpcCurrentTask(npc)
				if not task then
					removeElementData(npc,"npc_hlc:thistask")
					removeElementData(npc,"npc_hlc:lasttask")
					break
				else
					local prev_time_diff,prev_task = time_diff,task
					time_diff = time_diff-performTask[task[1]](npc,task,time_diff)
					if time_diff ~= time_diff then
=======
			while time_diff > 1 do
				local thistask = getElementData(npc,"npc_hlc:thistask")
				if thistask then
					--outputDebugString("server cycleNPCs:"..tostring(inspect(getElementData(npc,"npc_hlc:task.1"))))
					local task = getElementData(npc,"npc_hlc:task."..thistask)
					if not task then
						--outputDebugString("remove...");
						removeElementData(npc,"npc_hlc:thistask")
						removeElementData(npc,"npc_hlc:lasttask")
>>>>>>> evenmov:npc_hlc/task/control_npc_s.lua
						break
					end
					if time_diff > 1 then
						setNPCTaskToNext(npc)
					end
				end
				
			end
			updateNPCLastUpdateTime(npc,this_time)
		end
	end

end

--服务器：NPC执行下一个任务
function setNPCTaskToNext(npc)
	outputDebugString("server setNPCTaskToNext..");
	local thistask = getElementData(npc,"npc_hlc:thistask")
	setElementData(npc,"npc_hlc:thistask",thistask+1)
end

--服务器：任务完成
--似乎是通过判断thistask增加来触发任务完成
function cleanUpDoneTasks(dataname,oldval,newVal)
	if notrigger then return end
	--if dataname == "npc_hlc:task.1" then
		--outputDebugString(dataname.." old:"..tostring(inspect(oldval)).." to new:"..tostring(inspect(newVal)))
		--outputDebugString("source:"..tostring(inspect(source)));
		--outputDebugString("client:"..tostring(inspect(client)));
		--outputDebugString("sourceResource:"..tostring(inspect(sourceResource)));
	--end
	if not oldval or dataname ~= "npc_hlc:thistask" then return end

	--outputDebugString("cleanUpDoneTasks:"..dataname.." old:"..tostring(inspect(oldval)).." to new:"..tostring(inspect(newVal)))
	-- thistask发生了变化后执行后续代码

	local newval = getElementData(source,dataname)
	if not newval then 
		--outputDebugString("thistask become nil , ignore next part");
		return
	end

	-- thistask比之前减小，设置为之前的值
	if newval < oldval then
		notrigger = true
		--outputDebugString("cleanUpDoneTasks notrigger");
		setElementData(source,dataname,oldval)
		notrigger = nil
	end

	--thistask 的 newval 比之前大，清理已经完成的task部分

	--清理已完成任务信息
	--outputDebugString("from:"..tostring(oldval).." to "..tostring(newval-1))
	for tasknum = oldval,newval-1 do
		local taskstr = "npc_hlc:task."..tasknum
		local task = getElementData(source,taskstr)
		if task then
			triggerEvent("npc_hlc:onNPCTaskDone",source,task)
			--outputDebugString("onNPCTaskDone remove:"..taskstr);
			removeElementData(source,taskstr)
		end
	end
end

