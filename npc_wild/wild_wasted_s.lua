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

            local targetname = Loc:Localization("zombie",killer);
            local killerwep = "WEAPON NAME"; -- NEED FIX WEAPON NAME

            Player:givePlayerData(killer,"ZombieKill",1);

            local killtype = "kill2";
            if (bodypart == 9) then 
                --HEAD SHOT
                killtype = "kill1"; 
                Player:givePlayerData(killer,"HeadShot",1);
            end 
            triggerClientEvent(killer,"showkill",killer,killtype,"you",targetname,Loc:Localization(killerwep,killer),0);
        end
    end

    --TIME FOR DEAD

end
addEventHandler("onPedWasted",root, creatureDied) --Add the Event when ped1 dies