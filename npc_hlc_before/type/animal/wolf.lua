--THIRD LEVEL TYPE : WOLF
wolf = {
    name = "Wolf Crew", --名
    type = "wolf", --原型
    skin = 14,
    attack = 10,
    fovDistance = 30, --视野距离
    fovAngle = 90, --视野角度
    speed = "run",
    traits = {category="animal","tough"}, -- 特性
};
wolf.__index = wolf;
setmetatable( wolf, animal );

function wolf:create(x,y,z,r)

    --outputDebugString("CREATE WOLF");
    --outputDebugString("CREATE WOLF AT "..x..","..y..","..z);
    local o = animal:create(wolf.skin,x,y,z,r)
    setmetatable(o,self);
    self.__index = self;

    for k,v in pairs(wolf) do 
        Data:setData(self.source,k,v)
    end
    return o;

end

wolfKing = {
    name = "King of Wolf",
}
wolfKing.__index = wolfKing;
setmetatable( wolfKing , wolf );

function wolfKing:create(x,y,z)
    outputDebugString("CREATE WOLF KING");
    o = wolf:create(x,y,z)

    setmetatable(o, self)
    self.__index = self

    for k,v in pairs(wolfKing) do 
        Data:setData(self.source,k,v)
    end

    setElementModel(self.source,11);

    return o
end