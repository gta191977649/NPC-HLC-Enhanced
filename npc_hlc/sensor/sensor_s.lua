--PS:当目标死亡时，所有以其为目标的攻击者任务都将完成
function taskDone(task)
    outputDebugString(tostring(inspect(source)).." taskDone:"..tostring(inspect(task)))

	if Data:getData(source,"target") then
		--outputChatBox("taskDone AND TRY TO FORGET");
		Data:setData(source,"target",nil);--清理长期目标
	end
end
