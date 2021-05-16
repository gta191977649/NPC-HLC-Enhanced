function creatureDied(totalAmmo,killer,killerWeapon,bodypart,stealth)

   --outputDebugString("Your Ped is SERVER-SIDE dead now!")

    local x,y,z = getElementPosition(source)

    --获取基本属性
    local traits = Data:getData(source,"traits")
    --outputDebugString("traits:"..tostring(inspect(traits)));
	local isZombie = table.haveValue(traits,"zombie"); -- 是僵尸
	local isHuman = table.haveValue(traits,"human"); -- 是human
    --outputDebugString("isHuman:"..tostring(isHuman));


    local loots = {}

    if isZombie then

        local haveLoot = math.random(1,4);
        if haveLoot <=1 then
            if zombieloot then
                --构建 战利品
                local itemdata = {}
                itemdata.char_type = "Loot";
                local randomItem = table.random(zombieloot)
                outputDebugString("randomItem:"..tostring(randomItem))
                itemdata.itemid = getItemID(randomItem);
                itemdata.amount = math.random(1);
                itemdata.equip = 0;
                table.insert(loots,itemdata)
            end
        end

    elseif isHuman then

        --构建 武器战利品 必然掉落
        local npcWep = Data:getData(source,"weapon")
        if npcWep then

            local itemdata = {}
            itemdata.char_type = "Loot";
            outputDebugString("npcWep:"..tostring(npcWep))
            itemdata.itemid = getItemID(npcWep);
            itemdata.amount = 1;
            itemdata.equip = 0;
            itemdata.ap = {}
            itemdata.ap.Ammo = 0;
            itemdata.ap.Dur = math.random(1,10);
            itemdata.ap.Qua = math.random(1,100)*0.01;
            table.insert(loots,itemdata)

            --随机增加子弹
            npcAmmo = weapons[npcWep].ammo;
            if npcAmmo then
                local itemdata = {}
                itemdata.char_type = "Loot";
                outputDebugString("npcAmmo:"..tostring(npcAmmo))
                itemdata.itemid = getItemID(npcAmmo);
                itemdata.amount = math.random(1,4);
                itemdata.equip = 0;
                table.insert(loots,itemdata)
            end

        end

        --有概率(2/3)
        local haveLoot = math.random(1,4);
        if haveLoot <=2 then

            --NPC 随机 LOOT
            local npcType = Data:getData(source,"type")
            outputDebugString("npcType:"..tostring(npcType));
            if npcType then
                local npcLoot = normalType[npcType].loot
                outputDebugString("npcLoot:"..tostring(inspect(npcType)));
                if npcLoot then
                    --构建 战利品
                    local itemdata = {}
                    itemdata.char_type = "Loot";
                    local randomItem = table.random(npcLoot)
                    outputDebugString("randomItem:"..tostring(randomItem))
                    itemdata.itemid = getItemID(randomItem);
                    itemdata.amount = math.random(1);
                    itemdata.equip = 0;
                    table.insert(loots,itemdata)
                end
            end

        end
        

    else

        --构建 战利品（生肉）
        local itemdata = {}
        itemdata.char_type = "Loot";
        itemdata.itemid = 52;
        itemdata.amount = math.random(1,4);
        itemdata.equip = 0;
        table.insert(loots,itemdata)

    end

    --刷出所有战利品
    for _,loot in ipairs(loots)do
        --CREATE LOOT
        -- outputDebugString("loot:"..tostring(inspect(loot)));
        Item:createLootObject(loot,x,y,z-0.875,1,loot.char_type,ITEM_DROPED_REMOVE);
    end


    if killer and isElement(killer) then
        if getElementType(killer) == "player" then

            local targetname = Loc:Localization("NAME:"..tostring(Data:getData(source,"name")),killer);
            local killerwep = getWeaponInHand(killer) or "hand"; -- NEED FIX WEAPON NAME

            Player:givePlayerData(killer,"Kill",1);
            local kills = Player:getPlayerData(killer,"Kill");
            --outputDebugString("kills:"..tostring(kills));

            local killtype = "kill2";
            if (bodypart == 9) then 
                --HEAD SHOT
                killtype = "kill1"; 
                Player:givePlayerData(killer,"HeadShot",1);
            end 
            triggerClientEvent(killer,"showkill",killer,killtype,"you",Loc:Localization(killerwep,killer),targetname,kills);
        else
            outputChatBox("killer:"..tostring(inspect(killer)));
        end
    end

    --REMOVE ATTACHED WEAPON
    local gang = Data:getData(source,"gang");
    if gang > 0 then
        triggerEvent("relation > take",root,killer,gang,5);
    end

    --倒计时后清理死亡的尸体(30分钟=1800000)
    --注意：距离过远也会删除掉/远离COL也会？可能不
	setTimer(destroyCreature,NPC_DEAD_REMOVE,1,source)

end
addEventHandler("onPedWasted",root, creatureDied) --Add the Event when ped1 dies