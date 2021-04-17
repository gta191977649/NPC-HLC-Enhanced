--THIRD LEVEL TYPE : 猎杀者僵尸
hunter = {
    name = "hunter", --名
    type = "hunter", --原型
    skin = 54,
    attack = 10,
    fovDistance = 30, --视野距离
    fovAngle = 120, --视野角度
    speed = "sprint",
};
hunter.__index = hunter;
setmetatable( hunter, zombie );

function hunter:create(x,y,z,r)

    --outputDebugString("CREATE hunter");
    --outputDebugString("CREATE hunter AT "..x..","..y..","..z);
    local o = zombie:create(hunter.skin,x,y,z,r)
    setmetatable(o,self);
    self.__index = self;

    for k,v in pairs(hunter) do 
        Data:setData(self.source,k,v)
    end

    --zombie HAVE WEAPONS
    local ped = o:getElement()
    giveWeapon(ped,4,1,true)--KNIFE

    return o;

end