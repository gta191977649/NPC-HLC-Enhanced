function initNPCHLC()
	initNPCControl()
	streamed_npcs = {}
end
addEventHandler("onClientResourceStart",resourceRoot,initNPCHLC)