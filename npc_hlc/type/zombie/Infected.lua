--THIRD LEVEL TYPE : 普通感染者
infected = {
    name = "infected", --名
    type = "infected", --原型
    skin = 77,
    attack = 10,
    fovDistance = 30, --视野距离
    fovAngle = 120, --视野角度
    speed = "run",
};
infected.__index = infected;
setmetatable( infected, zombie );

function infected:create(x,y,z)

    --outputDebugString("CREATE infected");
    --outputDebugString("CREATE infected AT "..x..","..y..","..z);
    local o = zombie:create(infected.skin,x,y,z)
    setmetatable(o,self);
    self.__index = self;

    for k,v in pairs(infected) do 
        Data:setData(self.source,k,v)
    end

    --zombie HAVE KNIFE
    local ped = o:getElement()
    giveWeapon(ped,4,1,true)--KNIFE

    return o;

end