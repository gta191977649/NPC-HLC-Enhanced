--SECOND LEVEL TYPE : zombie

hunter = {};
hunter.__index = hunter;

setmetatable( hunter, zombie );

--hunter = zombie:create()

function hunter:create(x,y,z)
    outputDebugString("CREATE hunter "..x..y..z);
    local table = {
        skin = 54,
        category = "zombie",
        type = "hunter",
        x = x,
        y = y,
        z = z,
        attack = 20,
        source = creature:create();
    }
    local self = setmetatable(table,hunter);

    setElementModel(self.source,self.skin)
    setElementPosition(self.source,self.x,self.y,self.z)
    setElementDimension(self.source,1)

    return self;

end

function hunter:printAttack()
    outputDebugString(tostring(self.type).." attack:"..tostring(self.attack));
end




--c:debug();
--a:debug();
--w:debug();

--c:speak();
--a:speak();
--w:speak();
--w:printAttack();