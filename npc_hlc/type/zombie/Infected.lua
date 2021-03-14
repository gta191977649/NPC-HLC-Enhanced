--SECOND LEVEL TYPE : zombie

Infected = {};
Infected.__index = Infected;

setmetatable( Infected, zombie );

--Infected = zombie:create()

function Infected:create(x,y,z)
    outputDebugString("CREATE Infected "..x..y..z);
    local table = {
        skin = 15,
        category = "zombie",
        type = "Infected",
        x = x,
        y = y,
        z = z,
        attack = 20,
        source = creature:create();
    }
    local self = setmetatable(table,Infected);

    setElementModel(self.source,self.skin)
    setElementPosition(self.source,self.x,self.y,self.z)
    setElementDimension(self.source,1)

    --SET DATA
    for k,v in pairs(table) do
        Data:setData(self.source,k,v)
    end

    return self;

end

function Infected:printAttack()
    outputDebugString(tostring(self.type).." attack:"..tostring(self.attack));
end




--c:debug();
--a:debug();
--w:debug();

--c:speak();
--a:speak();
--w:speak();
--w:printAttack();