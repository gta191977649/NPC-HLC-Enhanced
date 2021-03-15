w = wolf:create(3,3,3)
--w:debug()
--w:show()

k = wolfKing:create(4,3,3)
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
    for c,creature in pairs(creatures) do
        setTimer(function()
            --DEBUG
            local type = "walk"
            if Data:getData(c,"name")~= "Wolf Crew" then
                type = "run"
            end
            enableHLCForNPC(c,type,0.99,1) --make HLC functions work on the ped
            addNPCTask(c, {"walkAlongLine", 0, 0, 3, 0, 20, 3, 2, 4}) --walk 20 units to the north
            addNPCTask(c, {"walkAlongLine", 0, 20, 3, 20, 20, 3, 2, 4}) --walk 20 units to the east
            addNPCTask(c, {"walkAlongLine", 20, 20, 3, 0, 0, 3, 2, 4}) --walk 20 units to the east

        end,3000*k,1)
        k = k + 1;
    end


end
addEventHandler("onResourceStart",resourceRoot,initTester)
