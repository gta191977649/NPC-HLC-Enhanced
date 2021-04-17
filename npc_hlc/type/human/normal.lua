--通用皮肤

slaveSkin = {	
    63, --bfypro
    145, --wfycrk
    146, --hmycm
    213, --vwmotr2
    238, --sbfypro
    257, --swfystr
    310
}
meatSkin = {	
    252, --wmyva2
    154, --wmybe
    97 --wmylg
}

-- NOT USED
cultSkin = {
    32, --dwmolc1
    33, --dwmolc2
    132, --dnmolc1
    157, --cwfyhb
    158, --cwmofr
    159, --cwmohb1
    160, --cwmohb2
    200 --cwmyhb2
}

--皮肤对照表


local skin = {

    ['raider_guard'] = {108,109,181,247,248,242,293},
    ['raider_hunter'] = {108,109,181,247,248,242,293},
    ['raider_slave'] = slaveSkin,
    ['raider_meat'] = meatSkin,
    ['raider_vendor'] = {108,109,181,247,248,242,293},
    ['raider_quest'] = {108,109,181,247,248,242,293},

    ['cdf_guard'] = {73,16,176,179,2,21,278}, -- CDFMilitiaskins
    ['cdf_staff'] = { 101,133,234,250,16,73,2}, -- CDFStaffSkins
    ['cdf_vendor'] = {236,131,1,2,21}, -- CDFVendorSkins
    ['cdf_quest'] = {236,131,1,2,21}, -- CDFVendorSkins
    ['cdf_hunter'] = {73,16,176,179,2,21,278}, -- CDFMilitiaskins

    ['establishment_grunt'] = 287, -- 
    ['establishment_heavy'] = 277, -- 
    ['establishment_rescue01'] = 265, -- 
    ['establishment_rescue01heavy'] = 279, -- 
    ['establishment_spec'] = 285, -- 
    ['establishment_peacekeeper'] = {266,284,281,282},--EstablishmentPeacekeeperSkins
    ['establishment_refugee'] = { 10,15,77,78,79, 32, 44, 58, 62, 95, 131, 132, 134, 137, 151, 157, 158, 159, 160 },--refugeeSkins
    ['establishment_quest'] = 286, -- 
    ['establishment_cleaner'] = 281, -- 
    ['establishment_staff'] = {171,172,194,189,253,274,211,217,50,27,11,153,260,268,309,305}, --EstabStaffSkins -- if botSkinID == 27 or botSkinID == 260 or botSkinID == 309 or botSkinID == 305 or botSkinID == 268 or botSkinID == 50 then name = "Worker" else name = "Servant" end
    ['establishment_armypatrol'] = {287,277},--EstabTrooperSkins
    ['establishment_r01patrol'] = {285,279}, -- EstablishmentSpecSkins
    ['establishment_peacekepatrol'] = {266,284,281,282}, --EstablishmentPeacekeeperSkins
    ['establishment_suit'] = {163,164,165,166}, -- EstabSuitSkins
    ['establishment_vip'] = {147,169,216,219,228,235,249,227,231,223,224,187,185,186,148,150,141,113,98,94,88,85,76,59,57,55,54,53,46,43,40,38,37,36,12,9,14},--EstabVIPSkins

    ['bandit_guard']={28,30,47,104,144,301,241,177,184,102,18,223},
    ['bandit_hunter']={28,30,47,104,144,301,241,177,184,102,18,223},
    ['bandit_quest']={28,30,47,104,144,301,241,177,184,102,18,223},

    --拾荒者
    ['scavenger_scavguard'] = {143,160, 180, 183, 24, 220,272, 25,135},--ScavengerGuardSkins
    ['scavenger_wastefreelance'] = {100,133,143,13,202,26,223},--WastelanderFreelancerSkins
    ['scavenger_nang'] = { 121, 122, 123 }, --SyndicateDaNangSkin
    ['scavenger_triad'] = {117,118}, --SyndicateTriadSkin
    ['scavenger_freelance'] = {183,29,202,24,25,112},--ScavengerFreelancerSkins
    ['scavenger_wasteguard'] = {34,133,134,198,201,202,261,26},--wastelandersSkin
    ['scavenger_scavvendor'] = {132,95,44},--ScavengersVendorSkins
    ['scavenger_wastevendor'] = {201, 197, 196, 160, 131, 132, 134, 129, 31, 10},--wastelanderCivSkin
    ['scavenger_syndvendor'] = { 210, 54, 58, 57, 123, 170, 224, 225, 227, 263 },--SyndicateCivSkin
    ['scavenger_scavquest']= {183,29,202,24,25,112},--ScavengerFreelancerSkins
    ['scavenger_wastequest']= {100,133,143,13,202,26,223},--WastelanderFreelancerSkins
    ['scavenger_SyndQuest'] = {294,49}, --SyndQuestgiverSkins
    ['scavenger_civ'] = { 10,15,77,78,79 }, -- dumpSkins
    ['scavenger_wasteciv'] = {201, 197, 196, 160, 131, 132, 134, 129, 31, 10},--wastelanderCivSkin
    ['scavenger_syndciv']= { 210, 54, 58, 57, 123, 170, 224, 225, 227, 263 },--SyndicateCivSkin
    ['scavenger_pig']= { 81 }, --animalFarmSkins 应该被转移到动物!

}

--THIRD LEVEL TYPE : WOLF
normal = {
    name = "Normal Ped", --名
    type = "normal", --原型
    attack = 10,
    fovDistance = 30, --视野距离
    fovAngle = 120, --视野角度
    speed = "sprint",
    --人类会使用工具，这里应该由武器决定
    -- shootdist < followdist 导致在特定距离时NPC会发呆，既不会攻击，也不会靠近
    shootdist = 30,
    followdist = 20,
    accuracy = 0.975,--0.95,

    --武器未区分
    weapon = {25,27,29,30,33,34,31},
};
normal.__index = normal;
setmetatable( normal, human );

--人类的subtype是阵营
function normal:create(x,y,z,r,faction,btype)

    outputDebugString("CREATE normal human :"..tostring(faction).." "..tostring(btype));
    --outputDebugString("CREATE normal AT "..x..","..y..","..z);

    local skins = skin[faction.."_"..btype] or 0 

    local o = human:create(skins,x,y,z,r,normal.weapon)
    setmetatable(o,self);
    self.__index = self;

    -- name 
    normal.name = faction.." "..btype

    for k,v in pairs(normal) do 
        Data:setData(self.source,k,v)
    end

    return o;

end