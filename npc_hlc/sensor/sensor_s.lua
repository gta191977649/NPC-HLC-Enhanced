function taskDone(task)
    outputDebugString(tostring(inspect(source)).." taskDone:"..tostring(inspect(task)))
	outputChatBox("taskDone AND TRY TO FORGET");
	Data:setData(source,"target",nil);--清理长期目标

end
