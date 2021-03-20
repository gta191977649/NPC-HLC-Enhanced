--THIRD LEVEL TYPE : WOLF

wolf = {
    name = "Wolf Crew", --名
    type = "wolf", --原型
    skin = 14,
    attack = 10,
};
wolf.__index = wolf;
setmetatable( wolf, animal );

function wolf:create(x,y,z)

    --outputDebugString("CREATE WOLF");
    --outputDebugString("CREATE WOLF AT "..x..","..y..","..z);
    local o = animal:create(14,x,y,z)
    setmetatable(o,self);
    self.__index = self;

    self.level = 1
    
    --[[
    setElementModel(self.source,14)
    setElementPosition(self.source,x,y,z)
    setElementDimension(self.source,1)

    --SET DATA
    for k,v in pairs(table) do 
        Data:setData(self.source,k,v)
    end
    ]]

    Data:setData(self.source,"name",self.name);
    Data:setData(self.source,"level",self.level);
    Data:setData(self.source,"category",self.category);
    Data:setData(self.source,"type",self.type);

    return o;

end

function wolf:show()
    outputChatBox(tostring(self.name).." level:"..tostring(self.level))
end

wolfKing = {}
wolfKing.__index = wolfKing;
setmetatable( wolfKing , wolf );

function wolfKing:create(x,y,z)
    outputDebugString("CREATE WOLF KING");
    o = wolf:create(x,y,z)

    setmetatable(o, self)
    self.__index = self
    self.name = "King of Wolf"
    self.level = 3

    Data:setData(self.source,"name",self.name);
    Data:setData(self.source,"level",self.level);

    setElementModel(self.source,11);

    return o
end
function wolfKing:show()
    outputChatBox(tostring(self.name).." level:"..tostring(self.level)..tostring(self.source))
end