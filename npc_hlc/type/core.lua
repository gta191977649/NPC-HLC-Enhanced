--BASIC TYPE: CREATURES
--SECOND LEVEL TYPE : HUMAN/ZOMBIE/ANIMAL
creature = {}; --BASIC CLASS
creature.__index = creature;


--创建生物
function creature:create()

    outputDebugString("TRY CREATE creature ");

    local self = setmetatable({
        source = createPed(0,0,0,3);
    }, creature );

    return self.source;

end


--自我介绍
function creature:speak()
    outputDebugString("i am "..tostring(self.type).." at "..tostring(self.x)..","..tostring(self.y)..","..tostring(self.z));
end

function creature:debug()
    outputDebugString(tostring(inspect(self)));
end

