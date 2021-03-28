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

	else

		setTimer(function(ped)
			local x,y = getElementPosition(ped);
			local xcoord,ycoord = math.randomCoord(5,10)
			local tx,ty = x+xcoord,y+ycoord
			setNPCTask(ped,{"hangOut",x,y,tx,ty})
		end,100,1,source)

	end


	if Data:getData(source,"target") then
		--outputChatBox("taskDone AND TRY TO FORGET");
		Data:setData(source,"target",nil);--清理长期目标
	end

	--addNPCTask(source,{"hangOut",x,y,tx,ty})

end
