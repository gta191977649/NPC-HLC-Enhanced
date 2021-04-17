--THIRD LEVEL TYPE : WOLF
goat = {
    name = "white goat", --名
    type = "goat", --原型
    skin = 13,
    attack = 10,
    fovDistance = 30, --视野距离
    fovAngle = 90, --视野角度
    speed = "sprint",
};
goat.__index = goat;
setmetatable( goat, animal );

function goat:create(x,y,z,r)

    --outputDebugString("CREATE goat");
    --outputDebugString("CREATE goat AT "..x..","..y..","..z);
    local o = animal:create(goat.skin,x,y,z,r)
    setmetatable(o,self);
    self.__index = self;

    for k,v in pairs(goat) do 
        Data:setData(self.source,k,v)
    end
    return o;

end
