--c = creature:create(0,1,2,3)
--c:debug()

--a = animal:create(0,2,2,3)
--a:debug()

w = wolf:create(3,3,3)
--w:debug()
w:printFoot()
w:printAttack()
w:speak()

w2 = bear:create(4,3,3)
--w2:debug()
w2:printFoot()
w2:printAttack()
w2:speak()

z = Infected:create(5,3,3)
z2 = hunter:create(6,3,3)