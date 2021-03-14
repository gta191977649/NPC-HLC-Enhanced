--BASIC TYPE: CREATURES
--SECOND LEVEL TYPE : HUMAN/ZOMBIE/ANIMAL

local otherElements = getElementByID("otherElements") -- we would need that aswell for binding handlers.

creatures = {} -- HOLD ALL creature

creature = {}; --BASIC CLASS
creature.__index = creature;


--创建生物
function creature:create()

    
    outputDebugString("TRY CREATE creature ");

    local self = setmetatable({
        source = createPed(0,0,0,3);
    }, creature );

    table.insert(creatures,self)
    setElementParent(self.source,otherElements) -- bind to parent for data system
    setElementData(self.source,"creature",true) -- use for other resources to fliter

    return self.source;

end


--自我介绍
function creature:speak()
    outputDebugString("i am "..tostring(self.type).." at "..tostring(self.x)..","..tostring(self.y)..","..tostring(self.z));
end

function creature:getElement()
    return self.source;
end

function creature:debug()
    outputDebugString(tostring(inspect(self)));
end

