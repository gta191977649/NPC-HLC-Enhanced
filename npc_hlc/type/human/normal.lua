--通用皮肤

slaveSkin = {	
    63,--bfypro
    145,--wfycrk
    146,--hmycm
    213,--vwmotr2
    238,--sbfypro
    257,--swfystr
    310
}
--裸男
meatSkin = {	
    252,--wmyva2
    154,--wmybe
    97 --wmylg
}

-- NOT USED
cultSkin = {
    32,--dwmolc1
    33,--dwmolc2
    132,--dnmolc1
    157,--cwfyhb
    158,--cwmofr
    159,--cwmohb1
    160,--cwmohb2
    200 --cwmyhb2
}

--皮肤对照表

--武器对照表
CampGuardWeapons = {29,25} --camp guards weapons
raiderWeapons = {11,12,15,23,33,25,2,4,5,6,7,8,10,24}
randomMelee = { 2,4,5,6,7,8,10,11,12,15}
raiderBossWeapons = {25,27,30,33,34,31,24}

ESTgruntWeapons = {31,29} --military weapons
ESTgruntHeavyWeapons = {31,27}
ESTSpecWeapons = {3}
ESTCleanerWeapons = {29,27,37}
ESTSuitWeapons = {29}

banditWeapons = {25,27,29,30,33,34,31}

SyndicateTriadWeapons = {30,27,29}

NeutralFreelancerWeapons = {4,5,6,7,8,25,10,11,12,14,15,24} --vagrants and looters weapons

local normalType = {

    --食人族/猎头者
    --吃人？
    ['raider_guard']={skin={108,109,181,247,248,242,293},wep=CampGuardWeapons},
    ['raider_hunter']={skin={108,109,181,247,248,242,293},wep=raiderWeapons},
    ['raider_slave']={skin=slaveSkin},
    ['raider_meat']={skin=meatSkin},
    ['raider_vendor']={skin={108,109,181,247,248,242,293},wep=randomMelee},
    ['raider_quest']={skin={108,109,181,247,248,242,293},wep=raiderBossWeapons},

    ['cdf_guard']={skin={73,16,176,179,2,21,278},wep=CampGuardWeapons},-- CDFMilitiaskins
    ['cdf_staff']={skin={101,133,234,250,16,73,2}},-- CDFStaffSkins
    ['cdf_vendor']={skin={236,131,1,2,21},wep={24}},-- CDFVendorSkins
    ['cdf_quest']={skin={236,131,1,2,21},},-- CDFVendorSkins
    ['cdf_hunter']={skin={73,16,176,179,2,21,278},wep=CampGuardWeapons},-- CDFMilitiaskins

    --权势军队
    ['establishment_grunt']={skin={287},wep=ESTgruntWeapons},-- 
    ['establishment_heavy']={skin={277},wep=ESTgruntHeavyWeapons},-- 
    ['establishment_rescue01']={skin={265},wep=ESTgruntWeapons},-- 
    ['establishment_rescue01heavy']={skin={279},wep=ESTgruntHeavyWeapons},-- 
    ['establishment_spec']={skin={285},wep=ESTSpecWeapons},-- 
    ['establishment_peacekeeper']={skin={266,284,281,282},wep=CampGuardWeapons},--EstablishmentPeacekeeperSkins
    ['establishment_refugee']={skin={10,15,77,78,79,32,44,58,62,95,131,132,134,137,151,157,158,159,160},},--refugeeSkins -- 难民
    ['establishment_quest']={skin={286},},-- 
    ['establishment_cleaner']={skin={281},wep=ESTCleanerWeapons},-- 
    ['establishment_staff']={skin={171,172,194,189,253,274,211,217,50,27,11,153,260,268,309,305},},--EstabStaffSkins -- if botSkinID == 27 or botSkinID == 260 or botSkinID == 309 or botSkinID == 305 or botSkinID == 268 or botSkinID == 50 then name = "Worker" else name = "Servant" end
    ['establishment_armypatrol']={skin={287,277},wep=ESTgruntWeapons},--EstabTrooperSkins
    ['establishment_r01patrol']={skin={285,279},wep=ESTgruntHeavyWeapons},-- EstablishmentSpecSkins
    ['establishment_peacekepatrol']={skin={266,284,281,282},wep=ESTSpecWeapons},--EstablishmentPeacekeeperSkins
    ['establishment_suit']={skin={163,164,165,166},ESTSuitWeapons},-- EstabSuitSkins
    ['establishment_vip']={skin={147,169,216,219,228,235,249,227,231,223,224,187,185,186,148,150,141,113,98,94,88,85,76,59,57,55,54,53,46,43,40,38,37,36,12,9,14},},--EstabVIPSkins


    --强盗
    ['bandit_guard']={skin={28,30,47,104,144,301,241,177,184,102,18,223},wep=banditWeapons},
    ['bandit_hunter']={skin={28,30,47,104,144,301,241,177,184,102,18,223},wep=banditWeapons},
    ['bandit_quest']={skin={28,30,47,104,144,301,241,177,184,102,18,223},wep=banditWeapons},

    --拾荒者
    --养猪？
    ['scavenger_scavguard']={skin={143,160,180,183,24,220,272,25,135},wep=CampGuardWeapons},--ScavengerGuardSkins
    ['scavenger_wastefreelance']={skin={100,133,143,13,202,26,223},wep=banditWeapons},--WastelanderFreelancerSkins
    ['scavenger_nang']={skin={121,122,123},wep=CampGuardWeapons},--SyndicateDaNangSkin Syndicate!!!!!!!!!
    ['scavenger_triad']={skin={117,118},wep=SyndicateTriadWeapons},--SyndicateTriadSkin Syndicate!!!!!!!
    ['scavenger_freelance']={skin={183,29,202,24,25,112},wep=banditWeapons},--ScavengerFreelancerSkins
    ['scavenger_wasteguard']={skin={34,133,134,198,201,202,261,26},wep=CampGuardWeapons},--wastelandersSkin
    ['scavenger_scavvendor']={skin={132,95,44},wep={24},},--ScavengersVendorSkins
    ['scavenger_wastevendor']={skin={201,197,196,160,131,132,134,129,31,10},wep={24},},--wastelanderCivSkin
    ['scavenger_syndvendor']={skin={210,54,58,57,123,170,224,225,227,263},wep={24},},--SyndicateCivSkin
    ['scavenger_scavquest']={skin={183,29,202,24,25,112},},--ScavengerFreelancerSkins
    ['scavenger_wastequest']={skin={100,133,143,13,202,26,223},},--WastelanderFreelancerSkins
    ['scavenger_syndQuest']={skin={294,49},},--SyndQuestgiverSkins
    ['scavenger_civ']={skin={10,15,77,78,79},},-- dumpSkins
    ['scavenger_wasteciv']={skin={201,197,196,160,131,132,134,129,31,10},},--wastelanderCivSkin
    ['scavenger_syndciv']={skin={210,54,58,57,123,170,224,225,227,263},},--SyndicateCivSkin
    ['scavenger_pig']={skin={81},},--animalFarmSkins 应该被转移到动物!

    --自由人
    ['neutral_freelance']={skin={32,79,134,183,29,100,177,241,28,30,47,104,144,135,137,160,168,182,200,230,223},wep=NeutralFreelancerWeapons,},--NeutralFreelancerSkins

};

--THIRD LEVEL TYPE : WOLF
normal = {
    name = "Normal Ped",--名
    type = "normal",--原型
    attack = 10,
    fovDistance = 30,--视野距离
    fovAngle = 120,--视野角度
    speed = "sprint",

    --人类会使用工具，这里应该由武器决定
    shootdist = 30, -- shootdist < followdist 导致在特定距离时NPC会发呆，既不会攻击，也不会靠近
    followdist = 20,
    accuracy = 0.975,--0.95,

    gang = 0;
};

normal.__index = normal;
setmetatable( normal,human );

--人类的subtype是阵营
function normal:create(x,y,z,r,faction,btype)

    
    --outputDebugString("CREATE normal AT "..x..","..y..","..z);

    local skins = normalType[faction.."_"..btype].skin or 0 
    local weps = normalType[faction.."_"..btype].wep or nil

    local weapon = nil;

    --随机武器，已挪到人类
    if weps then
        if type(weps) == "table" then 
            weapon = weps[math.random(1,#weps)] 
        else
            weapon = weps
        end
    end

    outputDebugString("CREATE normal human :"..tostring(faction).." "..tostring(btype).." wep:"..tostring(weapon).." from "..tostring(inspect(weps)));

    local o = human:create(skins,x,y,z,r,weapon)
    setmetatable(o,self);
    self.__index = self;

    -- name 
    o.name = faction.." "..btype
    if not weapon or weapon <= 9 then
        o.shootdist = 3
        o.followdist = 1
    end

    --normal表为索引，实际值为o，若无v补位
    --牛逼!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    for k,v in pairs(normal) do 
        Data:setData(self.source,k,o[k] or v)
    end

    return o;

end