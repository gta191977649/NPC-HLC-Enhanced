
w = wolf:create(3,3,3)
--w:debug()
--w:printFoot()
--w:printAttack()
--w:speak()

w2 = bear:create(4,3,3)
--w2:debug()
--w2:printFoot()
--w2:printAttack()
--w2:speak()

z = Infected:create(5,3,3)
z2 = hunter:create(6,3,3)

local tester = w:getElement()
outputDebugString("type of w:"..tostring(getElementType(tester)));

function initTester()

    for _,c in pairs(creatures) do
        
        --DEBUG
        enableHLCForNPC(c,"walk",0.99,40/180) --make HLC functions work on the ped
        addNPCTask(c, {"walkAlongLine", 0, 0, 3, 0, 20, 3, 2, 4}) --walk 20 units to the north
        addNPCTask(c, {"walkAlongLine", 0, 20, 3, 20, 20, 3, 2, 4}) --walk 20 units to the east
    end


end
addEventHandler("onResourceStart",resourceRoot,initTester)
