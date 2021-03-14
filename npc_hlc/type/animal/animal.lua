--SECOND LEVEL TYPE : ANIMAL
animal = {};
animal.__index = animal;
setmetatable( animal, creature );

--[[
animal = creature:create()
function animal:create()
    outputDebugString("CREATE ANIMAL TYPE");
    local table = {
        type = "animal",
    }
    local self = setmetatable(table,{__index = self});
    return self;

end
]]

function animal:printFoot()
    outputDebugString("i am 4 foot of:"..tostring(self.category));
end
