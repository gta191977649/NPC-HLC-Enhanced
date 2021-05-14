function initNPCHLC()
	initNPCControl() --初始化NPC控制TIMER
	streamed_npcs = {}
end
addEventHandler("onClientResourceStart",resourceRoot,initNPCHLC)

