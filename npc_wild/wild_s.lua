wilds = {} --记录所有野生动物

function InitWildCreature()
    setTimer ( SpawnWildCreature, 5000, 0 ) --直接开启在玩家周围随机产生僵尸
    setTimer ( clearFarCreature, 5000, 0) --KEEPS ALL THE CRETURES CLOSE TO PLAYERS
end
addEventHandler("onResourceStart", getRootElement(), InitWildCreature)

--服务器端:获取区域内的动物数量
--TODO:每次都要搜索一次所有的PED嘛？
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

--服务器：产生一个生物
function spawnCreature(x,y,z)
    --outputChatBox("spawnCreature");
    --create
    local c = NPC:createCreature("wolf",x,y,z)
    table.insert(wilds,c)

    --减少区域库存
    local zone = getZoneName(x, y, z)
    local zoneElement = getElementByID(zone);
    if zoneElement then
        local left = Data:getData(zoneElement,"leftZombie"); --获取区域剩余
        left = left - 1 
        if left < 0 then left = 0 end
        Data:setData(zoneElement, "leftZombie", tonumber(left))
        --outputChatBox("CREATURE ZONE TO DECRESE "..tostring(zone).." to "..tostring(left));
    else 
        --outputChatBox("CREATURE ERROR ZONE TO DECRESE "..tostring(zone));
    end

end
addEvent("wild > serverSpawn",true);
addEventHandler( "wild > serverSpawn", getRootElement(), spawnCreature )

--旧的写法（为每一位玩家刷新僵尸）
--TODO:每一位玩家都会成为刷新对象，也许可以挑选一下？
--TODO:假如100人在线，会刷新100只生物出来导致卡顿
function SpawnWildCreature()
    --outputChatBox("TRY SpawnWildCreature");

    --获取所有存活的玩家
    local liveplayers = getAlivePlayers()
    if (table.getn( liveplayers ) > 0 ) then

        --循环所有战局玩家
        --目前的写法是每个玩家都会作为刷新检测，玩家越多，刷新越多
        --TODO 是否需要改为按照区域刷新
        for PKey,thePlayer in ipairs(liveplayers) do

            --限制非大厅玩家
            if isElement(thePlayer) and getElementData(thePlayer,"room")=="playing" then

                spawn = true

                --计算当前区域是否已经最大值

				--玩家当前区域最大值检测
				x, y, z = getElementPosition(thePlayer)
				zone = getZoneName(x, y, z)

				local zoneElement = getElementByID(zone);
				if zoneElement then 

                    local count = getCreatureInZone(zone);
					local leftCreature = Data:getCustomData(zoneElement,"leftZombie","synced"); --获取区域剩余

					if leftCreature > 0 then -- 存在库存
						--检测是否达到上限
						local maxCreature = Data:getCustomData(zoneElement,"maxZombie","synced"); --获取区域上限
						--outputChatBox(tostring(count).."+"..tostring(count).." vs maxZombie:"..tostring(maxCreature));
						if count >= maxCreature then 
							spawn = false
							outputChatBox("MAX CREATURE , WE ARE SAFE NOW")
						end
					else 
						--库存耗尽，不再产生僵尸
                        outputChatBox("NO LEFT , WE ARE SAFE NOW")
						spawn = false
					end

				else
                    outputChatBox("NO ZONE , WE ARE SAFE NOW")
                    --丢失zone信息
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

--新的写法(按照区域刷新僵尸)


    --放弃原因：就算确定了需要刷新的区域，还要计算区域内的玩家，并且为每一位玩家循环进行刷新，似乎效率没有改善
    --[[

    --服务器:更新区域中的玩家数量
    function countPlayersInZone(zone)
    end

    function SpawnWildCreature()
        --outputChatBox("TRY SpawnWildCreature");
        zones = getElementsByType("zone");
        if table.getn(zones) > 0 then
            outputChatBox("TRY SpawnWildCreature in Zone:"..tostring(table.getn(zones)));
            for key,zone in ipairs(zones) do 
                local playerOfZone = 0
                if playerOfZone > 0 then
                end
            end
        end
    end
    ]]

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

				--返还被清空的库存
				local zx,zy,zz = getElementPosition(theCreature);
				zcode = getZoneName(zx,zy,zz);
				Zone:addZoneData(zcode,"leftZombie",1)

				--Zomb_delete (theCreature)
                destroyElement(theCreature)
                table.remove(wilds,key)
			end
		end
	end

    outputChatBox("clearFarCreature left:"..tostring(#wilds));


end