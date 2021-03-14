--SECOND LEVEL TYPE : ANIMAL

wolf = {};
wolf.__index = wolf;

setmetatable( wolf, animal );

--wolf = animal:create()

function wolf:create(x,y,z)
    outputDebugString("CREATE WOLF "..x..y..z);
    local table = {
        skin = 14,
        category = "animal", -- which data will not change
        type = "wolf", -- which data will not change
        x = x,
        y = y,
        z = z,
        attack = 10, -- which data will not change
        source = creature:create();
    }
    local self = setmetatable(table,wolf);

    setElementModel(self.source,self.skin)
    setElementPosition(self.source,self.x,self.y,self.z)
    setElementDimension(self.source,1)

    --SET DATA
    for k,v in pairs(table) do
        Data:setData(self.source,k,v)
    end

    return self;

end

function wolf:printAttack()
    outputDebugString(tostring(self.type).." attack:"..tostring(self.attack));
end




--c:debug();
--a:debug();
--w:debug();

--c:speak();
--a:speak();
--w:speak();
--w:printAttack();