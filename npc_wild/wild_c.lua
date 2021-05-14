--接受服务器产生Creature的要求
--修复坐标/检测条件
function clientSpawnCheck(xcoord, ycoord)
	--outputChatBox("clientSpawnCheck");
	local x,y,z = getElementPosition( localPlayer )
	local posx = x+xcoord
	local posy = y+ycoord
	local gz = getGroundPosition ( posx, posy, z+500 )
	triggerServerEvent ("wild > serverSpawn", localPlayer, posx, posy, gz+1 ) -- 产生

end
addEvent( "wild > clientSpawn", true )
addEventHandler("wild > clientSpawn", getRootElement(), clientSpawnCheck)
