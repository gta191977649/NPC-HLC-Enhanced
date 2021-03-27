--THIRD LEVEL TYPE : WOLF
bandit = {
    name = "Bandit", --名
    type = "bandit", --原型
    skin = 288,
    attack = 10,
    fovDistance = 30, --视野距离
    fovAngle = 120, --视野角度
    speed = "sprint",
    --人类会使用工具，这里应该由武器决定
    -- shootdist < followdist 导致在特定距离时NPC会发呆，既不会攻击，也不会靠近
    shootdist = 30,
    followdist = 20,
    accuracy = 0.8,--0.95,
};
bandit.__index = bandit;
setmetatable( bandit, human );

function bandit:create(x,y,z)

    --outputDebugString("CREATE bandit");
    --outputDebugString("CREATE bandit AT "..x..","..y..","..z);
    local o = human:create(bandit.skin,x,y,z)
    setmetatable(o,self);
    self.__index = self;

    for k,v in pairs(bandit) do 
        Data:setData(self.source,k,v)
    end

    --HUMAN HAVE WEAPONS
    local ped = o:getElement()
    giveWeapon(ped,30,9999,true)--无限子弹

    return o;

end