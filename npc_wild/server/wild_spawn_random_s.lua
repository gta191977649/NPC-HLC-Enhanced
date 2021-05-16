wilds = {} --记录所有野生动物

function InitWildCreature()
    setTimer ( SpawnWildCreature, NPC_WILD_SPAWN_TIME, 0 ) --直接开启在玩家周围随机产生动物
    setTimer ( clearFarCreature, 5000, 0) --KEEPS ALL THE CRETURES CLOSE TO PLAYERS
end
addEventHandler("onResourceStart", getRootElement(), InitWildCreature)


--服务器端:获取区域内的动物数量
--TODO:每次都要搜索一次所有的PED嘛？
--[[
function getCreatureInZone(zone)
    count = 0
    if #wilds > 0 then
        for key,creature in pairs(wilds) do 
            if isElement(creature) and getElementData(creature,"creature") then 
                local cx,cy,cz = getElementPosition(creature)
                local czone = getZoneName(cx, cy, cz)
                --outputDebugString("czone:"..tostring(czone).." vs zone:"..tostring(zone));
                if czone == zone then 
                    count = count + 1
                end
            end
        end
    end 
	--outputChatBox("getCreatureInZone:"..tostring(count));
	return count
end
]]

--服务器：产生一个生物
function spawnCreature(x,y,z)
    --create

    hour = getTime();

    if table.haveValue({21,22,23,0,1,2,3,4,5},hour) then
        --night
        local random = math.random(1,5)
        if random > 4 then 
            spawn_type = "hunter"
        else
            spawn_type = "infected"
        end
    else

        local city = getZoneName(x, y, z,true)
        if city == "Los Santos" or city == "Las Venturas" or city == "San Fierro" then
            spawn_type = "normal"
            subtype = "neutral"
            btype = "freelance"
        else
            --animal
            local random = math.random(1,5)
            if random == 1 then 
                spawn_type = "wolf"
            elseif random == 2 then
                spawn_type = "goat"
            elseif random == 3 then
                spawn_type = "bear"
            elseif random == 4 then
                spawn_type = "puma"
            else
                spawn_type = "goat"
            end
        end

    end

    outputChatBox("spawnCreature "..tostring(spawn_type).." "..tostring(subtype).." "..tostring(btype));

    local c = createCreature(spawn_type,x,y,z,math.random(1,360),subtype,btype)
    table.insert(wilds,c)

end
addEvent("wild > serverSpawn",true);
addEventHandler( "wild > serverSpawn", getRootElement(), spawnCreature )

--服务器：为每一位玩家刷新
function SpawnWildCreature()
    --outputChatBox("TRY SpawnWildCreature");

    --获取所有存活的玩家
    local liveplayers = getAlivePlayers()
    if (table.getn( liveplayers ) > 0 ) then

        --循环所有战局玩家
        --目前的写法是每个玩家都会作为刷新检测，玩家越多，刷新越多
        for PKey,thePlayer in ipairs(liveplayers) do

            --限制非大厅玩家
            if isElement(thePlayer) and getElementData(thePlayer,"room")=="playing" then

                spawn = true

                x, y, z = getElementPosition(thePlayer) -- 获取玩家坐标
                local npcs = getElementsWithinRange(x,y,z,100,"ped"); -- 获取玩家范围内的NPC列表
                --outputDebugString("npcs checked:"..tostring(#npcs));

                -- 限制每个玩家附近最多10个NPC
				if #npcs > NPC_WILD_SPAWN_MAX then 
                    spawn = false
                end

            end

            --outputDebugString("spawn:"..tostring(spawn))

            if spawn and isElement(thePlayer) then

                --TODO 用复用函数替换
                --产生随机位置
                local xcoord = 0
                local ycoord = 0
                local xdirection = math.random(1,2)
                if xdirection == 1 then
                    xcoord = math.random(20,40)
                else
                    xcoord = math.random(-40,-20)
                end
                local ydirection = math.random(1,2)
                if ydirection == 1 then
                    ycoord = math.random(20,40)
                else
                    ycoord = math.random(-40,-20)
                end

                --这里需要去客户端，因为使用了getGroundPosition函数
                triggerClientEvent ( "wild > clientSpawn", thePlayer, ycoord, xcoord ) -- 可以去服务器计算一次玩家周围僵尸是不是太多了
            end

        end



    end

end

--服务器：清理周围无玩家的生物
function clearFarCreature()
    local farCreatures = { }
    local allplayers = getElementsByType ( "player" )

    for key,theCreature in ipairs(wilds) do
        if isElement(theCreature) then
            if (getElementData (theCreature, "creature") == true) then
                far = 1
                local Zx, Zy, Zz = getElementPosition( theCreature )
                for theKey,thePlayer in ipairs(allplayers) do
                    local Px, Py, Pz = getElementPosition( thePlayer )
                    local distance = (getDistanceBetweenPoints3D( Px, Py, Pz, Zx, Zy, Zz ))
                    if (distance < 75) then
                        far = 0
                    end
                end
                if far == 1 then
                    table.insert( farCreatures, theCreature )
                end
            end
        else
            table.remove( wilds, key )
        end
    end
	
    --清理远处的生物
	if ( #farCreatures >1 ) then
		for key,theCreature in ipairs(farCreatures) do
			if getElementData (theCreature, "creature") == true then

                destroyCreature(theCreature);

                table.remove(wilds,key)

                outputChatBox("clearFarCreature left:"..tostring(#wilds));
			end
		end
	end

end