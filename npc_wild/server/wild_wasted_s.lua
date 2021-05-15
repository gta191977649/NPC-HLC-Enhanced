function creatureDied(totalAmmo,killer,killerWeapon,bodypart,stealth)

    outputDebugString("Your Ped is SERVER-SIDE dead now!")

    local x,y,z = getElementPosition(source)

    local loots = {}

    --构建 武器战利品
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

    --构建 战利品（生肉）
    local itemdata = {}
    itemdata.char_type = "Loot";
    itemdata.itemid = 52;
    itemdata.amount = math.random(1,4);
    itemdata.equip = 0;
    table.insert(loots,itemdata)

    --刷出所有战利品
    for _,loot in ipairs(loots)do
        --CREATE LOOT
        -- outputDebugString("loot:"..tostring(inspect(loot)));
        Item:createLootObject(loot,x,y,z-0.875,1,loot.char_type);
    end 

    --倒计时后清理死亡的尸体(30分钟)
	--setTimer(destroyDeadCreature,1800000,1,source,pedCol,x,y,z) -- destroyElement(ped)

    if killer and isElement(killer) then
        if getElementType(killer) == "player" then

            local targetname = Loc:Localization("NAME:"..tostring(Data:getData(source,"name")),killer);
            local killerwep = getWeaponInHand(killer) or "hand"; -- NEED FIX WEAPON NAME

            Player:givePlayerData(killer,"Kill",1);
            local kills = Player:getPlayerData(killer,"Kill");
            outputDebugString("kills:"..tostring(kills));

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

    --TIME FOR DEAD

    --REMOVE ATTACHED WEAPON
    local gang = Data:getData(source,"gang");
    if gang > 0 then
        triggerEvent("relation > take",root,killer,gang,5);
    end

end
addEventHandler("onPedWasted",root, creatureDied) --Add the Event when ped1 dies