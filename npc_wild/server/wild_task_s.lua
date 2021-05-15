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
			NPC:setNPCTask(ped,{"hangOut",x,y,tx,ty})
		end,100,1,source)
		
	elseif task[1]== "hangOut" then
		--HANG OUT --> IDLE

		setTimer(function(ped)
			local category = Data:getData(source,"category");
			NPC:setNPCTask(ped, {"doAnim",getTickCount(),category,"idle",-1,false,false,true})
		end,100,1,source)

	elseif task[1]== "panic" then

		--恐慌结束->默认转为逃离状态

		setTimer(function(ped)
			NPC:setNPCTask(ped,{"awayFromElement",task[2],0.1,200})
		end,100,1,source)

	elseif task[1]== "guard" then

		--守卫任务结束

	else

		--其他任务结束变为闲逛

		setTimer(function(ped)
			local x,y = getElementPosition(ped);
			local xcoord,ycoord = math.randomCoord(5,10)
			local tx,ty = x+xcoord,y+ycoord
			NPC:setNPCTask(ped,{"hangOut",x,y,tx,ty})
		end,100,1,source)

	end

	--任务完成后qingli目标
	if Data:getData(source,"target") then
		--outputChatBox("taskDone AND TRY TO FORGET");
		Data:setData(source,"target",false);--清理长期目标
	end

	--addNPCTask(source,{"hangOut",x,y,tx,ty})

end