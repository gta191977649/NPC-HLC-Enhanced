--createCreature("wolf",3,3,3)

--w:debug()
--w:show()

--wK = wolfKing:create(4,3,3)
--k:debug()
--k:show()
--w:speak()

--w2 = bear:create(4,3,3)
--w2:debug()
--w2:printFoot()
--w2:printAttack()
--w2:speak()

--z = Infected:create(5,3,3)
--z2 = hunter:create(6,3,3)


function initTester()

    local k = 1
    
    --创建猎人
    --[[
    local ped = createPed(0, 0, 0, 3) --create the ped
    giveWeapon(ped,22,999,true)
    setElementDimension(ped,1);
    --enableHLCForNPC(ped) --make HLC functions work on the ped
    ]]

    c1 = createCreature("wolf",240.1689453125,2500.109375,16.484375)
    c2 = createCreature("bandit",284.236328125,2534.7548828125,16.818849563599)
    --[[
    
    c2 = createCreature("bear",261.3671875,2487.5546875,16.484375)
    c3 = createCreature("puma",284.236328125,2534.7548828125,16.818849563599)
    ]]


    --[[
    for c,creature in pairs(creatures) do
        setTimer(function()


            if c~= wK:getElement() then
                addNPCTask(c,{"walkFollowElement",wK:getElement(), 1})
            else
                --walkAlongLine
                addNPCTask(c, {"walkAlongLine", 0, 0, 3, 0, 20, 3, 2, 4}) --walk 20 units to the north
                addNPCTask(c, {"walkAlongLine", 0, 20, 3, 20, 20, 3, 2, 4}) --walk 20 units to the east
                addNPCTask(c, {"walkAlongLine", 20, 20, 3, 0, 0, 3, 2, 4}) --walk 20 units to the east

                addNPCTask(ped, {"killPed",c,100,5}) -- ATTACK LEADER
            end

            


        end,3000*k,1)
        k = k + 1;
    end
    --]]

end
addEventHandler("onResourceStart",resourceRoot,initTester)
