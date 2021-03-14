--SECOND LEVEL TYPE : zombie
zombie = {};
zombie.__index = zombie;
setmetatable( zombie, creature );

--[[
zombie = creature:create()
function zombie:create()
    outputDebugString("CREATE zombie TYPE");
    local table = {
        type = "zombie",
    }
    local self = setmetatable(table,{__index = self});
    return self;

end
]]

function zombie:printFoot()
    outputDebugString("i am 4 foot of:"..tostring(self.category));
end
