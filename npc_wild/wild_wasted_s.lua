function creatureDied(totalAmmo,killer,killerWeapon,bodypart,stealth)
    outputDebugString("Your Ped is dead now!")

    local x,y,z = getElementPosition(source)

    --构建 战利品（生肉）
    local itemdata = {}
    itemdata.char_type = "Loot";
    itemdata.itemid = 52;
    itemdata.amount = math.random(1,4);
    itemdata.equip = 0;
    --CREATE LOOT
    Item:createLootObject(itemdata,x,y,z-0.875,1,"Nature");

    --倒计时后清理死亡的尸体(30分钟)
	--setTimer(destroyDeadCreature,1800000,1,source,pedCol,x,y,z) -- destroyElement(ped)

    if killer and isElement(killer) then
        if getElementType(killer) == "player" then

            local targetname = Data:getData(source,"name");
            local killerwep = getWeaponInHand(killer) or "MISS WEAPON NAME"; -- NEED FIX WEAPON NAME

            Player:givePlayerData(killer,"Kill",1);

            local killtype = "kill2";
            if (bodypart == 9) then 
                --HEAD SHOT
                killtype = "kill1"; 
                Player:givePlayerData(killer,"HeadShot",1);
            end 
            triggerClientEvent(killer,"showkill",killer,killtype,"you",Loc:Localization(killerwep,killer),targetname,0);


            --杀死后调整关系
            --relation change
            if getElementType(killer) == "player" then
                local gang = Data:getData(source,"gang");
                outputDebugString("set player gang relation:"..tostring(gang));
                if gang > 0 then
                    triggerEvent("relation > take",root,killer,gang,5);
                end
            end

        end
    end

    --TIME FOR DEAD

end
addEventHandler("onPedWasted",root, creatureDied) --Add the Event when ped1 dies