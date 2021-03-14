--SECOND LEVEL TYPE : ANIMAL

bear = {};
bear.__index = bear;

setmetatable( bear, animal );

--bear = animal:create()

function bear:create(x,y,z)
    outputDebugString("CREATE BEAR "..x..y..z);
    
    local table = {
        skin = 12,
        category = "animal",
        type = "bear",
        x = x,
        y = y,
        z = z,
        attack = 20,
        source = creature:create();
    }
    local self = setmetatable(table,bear);

    setElementModel(self.source,self.skin)
    setElementPosition(self.source,self.x,self.y,self.z)
    setElementDimension(self.source,1)

    --SET DATA
    for k,v in pairs(table) do
        Data:setData(self.source,k,v)
    end

    return self;

end

function bear:printAttack()
    outputDebugString(tostring(self.type).." attack:"..tostring(self.attack));
end




--c:debug();
--a:debug();
--w:debug();

--c:speak();
--a:speak();
--w:speak();
--w:printAttack();