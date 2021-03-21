--SECOND LEVEL TYPE : ANIMAL
puma = {
    name = "Puma", --名
    type = "puma", --原型
    skin = 7,
    attack = 2,
    fovDistance = 30, --视野距离（熊瞎子）
    fovAngle = 120, --视野角度
    speed = "sprintfast",
};
puma.__index = puma;
setmetatable( puma, animal );

function puma:create(x,y,z)

    local o = animal:create(puma.skin,x,y,z)
    setmetatable(o,self);
    self.__index = self;

    for k,v in pairs(puma) do 
        Data:setData(self.source,k,v)
    end
    return o;

end
