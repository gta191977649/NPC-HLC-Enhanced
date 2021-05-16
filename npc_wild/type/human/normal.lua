--THIRD LEVEL TYPE : normal
normal = {
    name = "Normal Ped",--名
    type = "normal",--原型
    attack = 10,
    fovDistance = 30,--视野距离
    fovAngle = 120,--视野角度

    speed = "sprint",--默认速度是奔跑

    --人类会使用工具，这里应该由武器决定
    --TODO 武器最大射程 = shootdist
    shootdist = 3, -- shootdist < followdist 导致在特定距离时NPC会发呆，既不会攻击，也不会靠近
    followdist = 1,
    accuracy = 0.975,--0.95,

    gang = 0;
    sensor = false;--默认感知能力关闭
    behaviour = "default", -- 默认
    traits = {category="human"}, -- 特性

    trade = {}, -- 交易信息
};

normal.__index = normal;
setmetatable( normal,human );

outputDebugString("normal.lua");

--人类
function normal:create(x,y,z,r,faction,btype)

    --outputDebugString("CREATE normal of "..faction..","..btype..","..z);
    --outputDebugString("normalType loaded normal.lua:"..tostring(table.nums(normalType)))

    local skins = normalType[faction.."_"..btype].skin or 0 
    local weps = normalType[faction.."_"..btype].wep or nil
    local gang = normalType[faction.."_"..btype].gang or normal.gang
    local behaviour = normalType[faction.."_"..btype].behaviour or normal.behaviour
    local trade = normalType[faction.."_"..btype].trade or normal.trade -- 获取贸易信息

    --name
    local name = faction.." "..btype
    if type(normalType[faction.."_"..btype].name)=="table" then
        name = table.random(normalType[faction.."_"..btype].name)
    else
        name = normalType[faction.."_"..btype].name or faction.." "..btype
    end
    --traits
    local traits = normalType[faction.."_"..btype].traits
    local weapon = nil;

    --随机武器，已挪到人类
    if weps then
        if type(weps) == "table" then 
            weapon = weps[math.random(1,#weps)] 
        else
            weapon = weps
        end
    end

    --outputDebugString("CREATE normal human :"..tostring(faction).." "..tostring(btype).." wep:"..tostring(weapon).." from "..tostring(inspect(weps)));

    local o = human:create(skins,x,y,z,r,weapon)
    setmetatable(o,self);
    self.__index = self;

    -- 这里的参数需要在table中 
    o.name = name
    o.gang = gang
    o.sensor = false; -- 感知能力默认开启
    o.behaviour = behaviour; -- 默认行为
    o.traits = table.merge(traits,normal.traits);--注意是合并normal的属性
    --outputDebugString("normal.traits:"..tostring(inspect(normal.traits)));
    --outputDebugString("o.traits:"..tostring(inspect(o.traits)));
    o.type = faction.."_"..btype; --SAVE TYPE (方便直接抓取信息)

    local tradelist = {}
    --构建商人库存
    if table.avalible(trade) then
        local tradepool = table.merge(trade,commonTrade);
        --outputDebugString("tradepool:"..tostring(inspect(tradepool)))
        
        for _,v in pairs(tradepool) do 
            local id = itemNameToID[v[1]]
            local rate = v[2]*100
            if math.random(100) <= rate then
                if not table.haveValue(tradelist,id) then
                    table.insert(tradelist,id)
                end
            end
        end
        --outputDebugString("tradelist:"..tostring(inspect(tradelist)))
    end

    -- 贸易
    o.trade = {
        list = tradelist,
        pricelevel = 1,
    }


    if weapon then
        
        --处理字符串为数字
        if type(weapon) == "string" then
            weapon = weapons[weapon].gtaid;
        end

        o.shootdist = gta_weapons[weapon].range;
        if o.shootdist > 10 then
            o.followdist = o.shootdist;
        end
    end

    --normal表为索引，实际值为o，若无v补位
    --outputDebugString("sync normal");
    for k,v in pairs(normal) do
        Data:setData(self.source,k,o[k] or v)
    end

    return o;

end