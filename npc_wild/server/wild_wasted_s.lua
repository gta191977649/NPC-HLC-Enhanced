function creatureDied(totalAmmo,killer,killerWeapon,bodypart,stealth)
    outputDebugString("Your Ped is dead now!")

    local x,y,z = getElementPosition(source)

    local loots = {}

    local npcWep = Data:getData(source,"weapon")
    if npcWep then

        local itemdata = {}
        itemdata.char_type = "Loot";
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

    for _,loot in ipairs(loots)do
        --CREATE LOOT
        Item:createLootObject(loot,x,y,z-0.875,1,loot.char_type);
    end 

    --倒计时后清理死亡的尸体(30分钟)
	--setTimer(destroyDeadCreature,1800000,1,source,pedCol,x,y,z) -- destroyElement(ped)

    if killer and isElement(killer) then
        if getElementType(killer) == "player" then

            local targetname = Loc:Localization(Data:getData(source,"name"),killer);
            local killerwep = getWeaponInHand(killer); -- NEED FIX WEAPON NAME

            local kills = Player:givePlayerData(killer,"Kill",1);

            local killtype = "kill2";
            if (bodypart == 9) then 
                --HEAD SHOT
                killtype = "kill1"; 
                Player:givePlayerData(killer,"HeadShot",1);
            end 
            triggerClientEvent(killer,"showkill",killer,killtype,"you",Loc:Localization(killerwep,killer),targetname,kills);
        end
    end

    --TIME FOR DEAD

end
addEventHandler("onPedWasted",root, creatureDied) --Add the Event when ped1 dies