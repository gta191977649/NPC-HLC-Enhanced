--SECOND LEVEL TYPE : ANIMAL
bear = {
    name = "Bear", --名
    type = "bear", --原型
    skin = 12,
    attack = 25,
    fovDistance = 15, --视野距离（熊瞎子）
    fovAngle = 120, --视野角度
    speed = "run",
    traits = {category="animal","normal"}, -- 特性
};
bear.__index = bear;
setmetatable( bear, animal );

function bear:create(x,y,z,r)
    
    local o = animal:create(bear.skin,x,y,z,r)
    setmetatable(o,self);
    self.__index = self;

    for k,v in pairs(bear) do 
        Data:setData(self.source,k,v)
    end
    return o;


end
