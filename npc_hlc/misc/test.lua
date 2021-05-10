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

--注意：延迟刷出测试NPC，否则刷出过快的NPC无法正确绑定武器,ped类型转为userdata
function delayTest()
    --freelance = createCreature("normal",250,2500,16,0,"neutral","freelance")
    --ZB
    infected1 = createCreature("infected",210,2500,16)
    hunter1 = createCreature("hunter",220,2500,16)
    --ANIMAL
    bear1 = createCreature("bear",230,2500,16)
    puma1 = createCreature("puma",240,2500,16)
    --CIV
    --c1 = createCreature("normal",240.1689453125,2500.109375,16.484375,0,"scavenger","syndciv")
    --c1 = createCreature("normal",241.1689453125,2500.109375,16.484375,0,"cdf","staff")
end

function initTester()

    setTimer(delayTest,500,1)

    local k = 1
    
    --创建猎人
    --[[
    local ped = createPed(0, 0, 0, 3) --create the ped
    giveWeapon(ped,22,999,true)
    setElementDimension(ped,1);
    --enableHLCForNPC(ped) --make HLC functions work on the ped
    ]]



    --c2 = createCreature("normal",241.1689453125,2501.109375,16.484375,30,"cdf","guard")
    --c3 = createCreature("normal",243.1689453125,2502.109375,16.484375,60,"cdf","guard")
    --z = createCreature("infected",250.107421875,2505.68359375,16.484375)
    --h = createCreature("hunter",290.1044921875,2525.9169921875,16.792568206787)

    --c2 = createCreature("bandit",284.236328125,2534.7548828125,16.818849563599)

    --刷自由人
    --setTimer(createCreature,100,1,"normal",260,2500.109375,16.484375,0,"neutral","freelance")
    

    --z = createCreature("infected",250.107421875,2505.68359375,16.484375)
    --b = createCreature("bear",261.3671875,2487.5546875,16.484375)
    --[[
    

    
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
