--BASIC TYPE: CREATURES
--SECOND LEVEL TYPE : HUMAN/ZOMBIE/ANIMAL

local otherElements = getElementByID("otherElements") -- we would need that aswell for binding handlers.

--HOLDER
--KEY:element VALUE:creature
creatures = {} -- HOLD ALL creature

--BASIC CLASS
creature = {
    core = "creature",
}; 

creature.__index = creature;

--创建
function creature:create(skin,x,y,z)

    --outputDebugString("TRY CREATE creature ");

    local o = {}
    setmetatable(o,self);
    self.__index = self;


    self.source = createPed(skin,x,y,z);
    setElementDimension(self.source,1)

    creatures[self.source] = self;
    
    setElementParent(self.source,otherElements) -- bind to parent for data system
    setElementData(self.source,"creature",true) -- use for other resources to fliter

    return o;

end

--死亡
function creature:kill()
    killPed(self.source)
end

--摧毁
function creature:destroy()

    creatures[self.source] = nil;
    destroyElement(self.source);

	setmetatable( self, nil );
	self = nil;

end

--SET IF NEED (SERVERSIDE)
function creature:set(key,value)
    self[key] = value
    Data:setData(self.source,key,value)
end

--GET IF NEED (SERVERSIDE)
function creature:get(key,value)
    return self[key]
end

--自我介绍
function creature:speak()
    outputDebugString("i am "..tostring(self.type).." at "..tostring(self.x)..","..tostring(self.y)..","..tostring(self.z));
end

--返回生物对应的element
function creature:getElement()
    return self.source;
end

function creature:debug()
    outputDebugString(tostring(inspect(self)));
end

