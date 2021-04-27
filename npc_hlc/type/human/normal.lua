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

    --questgiver/vendor 应该包括guard行为，或者同时具有civilian属性

    --【食人族/猎头者】 OK //////////////////////////////////////////////
    ['raider_guard']={name="Raider Barker",behaviour="guard",traits={"raider"},gang=5,skin={108,109,181,247,248,242,293},wep=CampGuardWeapons}, -- 食人族守卫 OK
    ['raider_hunter']={name="Raider Mongrel",behaviour="hunt",traits={"civilian,male","raider"},gang=5,skin={108,109,181,247,248,242,293},wep=raiderWeapons}, -- 食人族 OK
    ['raider_slave']={name="Slave",behaviour="default",traits={"civilian,male,raiderslave"},gang=5,skin=slaveSkin}, -- 食人族奴隶 OK
    ['raider_meat']={name="Meat",behaviour="default",traits={"raidermeat"},gang=5,skin=meatSkin},--拥有随机4种动作 OK
    --"BEACH","ParkSit_M_Loop",-1, true
    --"SWEET","Sweet_injuredloop",-1, true
    --"CRACK", "crckidle2", -1, false
    --"GRAVEYARD", "mrnF_loop", -1, true
    ['raider_vendor']={name="Trader",behaviour="guard",traits={"vendor","raider"},gang=5,skin={108,109,181,247,248,242,293},wep=randomMelee}, --商人 OK
    ['raider_quest']={name="Warchief",behaviour="guard",traits={"questgiver","raider"},gang=5,skin={108,109,181,247,248,242,293},wep=raiderBossWeapons}, -- 酋长 OK

    --【城市民兵武装】 OK ///////////////////////////////////////////////
    ['cdf_guard']={name="Militia",behaviour="guard",traits={"cdf"},gang=3,skin={73,16,176,179,2,21,278},wep=CampGuardWeapons},--民兵守卫 OK
    ['cdf_hunter']={name="Militia",behaviour="hunt",traits={"cdf,civilian,male"},gang=3,skin={73,16,176,179,2,21,278},wep=CampGuardWeapons},-- 民兵 OK
    ['cdf_vendor']={name="Quartermaster",behaviour="guard",traits={"cdf,vendor"},gang=3,skin={236,131,1,2,21},wep={24}},-- 军需官 OK
    ['cdf_staff']={name="Citizen",behaviour="default",traits={"cdf,civilian,male"},gang=3,skin={101,133,234,250,16,73,2}},--平民 OK
    ['cdf_quest']={name="Militia Leader",behaviour="guard",traits={"cdf,questgiver"},gang=3,skin={236,131,1,2,21},},-- 民兵领袖 可能存在特殊类型 CDF Recruiter 招募者  OK


    --【权势军队】 OK /////////////////////////
    ['establishment_refugee']={name="Refugee",behaviour="default",traits={"male","civilian","refugee"},gang=4,skin={10,15,77,78,79,32,44,58,62,95,131,132,134,137,151,157,158,159,160},},--难民 OK
    ['establishment_grunt']={name="Trooper",behaviour="guard",traits={"establishment"},gang=4,skin={287},wep=ESTgruntWeapons},-- 应该有 25护甲 OK
    ['establishment_heavy']={name="Heavy Trooper",behaviour="guard",traits={"heavy","laser","establishment"},gang=4,skin={277},wep=ESTgruntHeavyWeapons},-- 50重甲 OK
    ['establishment_rescue01']={name="R/01 Grunt",behaviour="guard",traits={"laser","establishment"},gang=4,skin={265},wep=ESTgruntWeapons},-- 50重甲 OK
    ['establishment_rescue01heavy']={name="R/01 Heavy",behaviour="guard",traits={"heavy","laser","establishment"},gang=4,skin={279},wep=ESTgruntHeavyWeapons},-- 75重甲，狙击武器 OK
    ['establishment_spec']={name="R/01 Spec",behaviour="hunt",gang=4,traits={"spec","establishment"},skin={285},wep=ESTSpecWeapons},-- 50重甲
    ['establishment_cleaner']={name="Cleaner",behaviour="hunt",gang=4,traits={"civilian,cleaner","establishment"},skin={281},wep=ESTCleanerWeapons},-- 清理者 25护甲 OK
    ['establishment_peacekeeper']={name="Peacekeeper",behaviour="guard",traits={"peacekeeper","establishment"},gang=4,skin={266,284,281,282},wep=CampGuardWeapons},--EstablishmentPeacekeeperSkins 维和部队 OK
    ['establishment_quest']={name="General",behaviour="default",gang=4,skin={286},},-- 领导
    ['establishment_armypatrol']={name="Trooper",behaviour="hunt",traits={"civilian","male","armypatrol","establishment"},gang=4,skin={287,277},wep=ESTgruntWeapons},--EstabTrooperSkins OK
    ['establishment_r01patrol']={name="R/01 Operator",behaviour="hunt",traits={"civilian","male","R01patrol,laser","establishment"},gang=4,skin={285,279},wep=ESTgruntHeavyWeapons},-- EstablishmentSpecSkins --25护甲 狙击武器 OK
    ['establishment_peacekepatrol']={name="Peacekeeper",behaviour="hunt",traits={"civilian","male","peacekeeper","establishment"},gang=4,skin={266,284,281,282},wep=ESTSpecWeapons},--EstablishmentPeacekeeperSkins OK
    ['establishment_suit']={name="R/01 Agent",behaviour="hunt",traits={"civilian","male","suit","establishment"},gang=4,skin={163,164,165,166},ESTSuitWeapons},-- EstabSuitSkins 特工 OK
    ['establishment_staff']={name={"Worker","Servant"},behaviour="default",traits={"civilian","male","establishment"},gang=4,skin={171,172,194,189,253,274,211,217,50,27,11,153,260,268,309,305},},--EstabStaffSkins -- if botSkinID == 27 or botSkinID == 260 or botSkinID == 309 or botSkinID == 305 or botSkinID == 268 or botSkinID == 50 then name = "Worker" else name = "Servant" end
    ['establishment_vip']={name="Resident",behaviour="default",traits={"civilian","male","establishment"},gang=4,skin={147,169,216,219,228,235,249,227,231,223,224,187,185,186,148,150,141,113,98,94,88,85,76,59,57,55,54,53,46,43,40,38,37,36,12,9,14},},--EstabVIPSkins

    --【拾荒者】 养猪？
    ['scavenger_civ']={name="Survivor",behaviour="default",traits={"male","civilian","scavenger"},gang=1,skin={10,15,77,78,79},},-- dumpSkins 拾荒阵营幸存者
    ['scavenger_scavguard']={name="Guard",behaviour="guard",traits={"scavenger"},gang=1,skin={143,160,180,183,24,220,272,25,135},wep=CampGuardWeapons},--ScavengerGuardSkins 守卫
    ['scavenger_freelance']={name="Scavenger",behaviour="hunt",traits={"male","civilian","freelancer"},gang=1,skin={183,29,202,24,25,112},wep=banditWeapons},--ScavengerFreelancerSkins 拾荒者
    ['scavenger_scavvendor']={name="Trader",behaviour="default",traits={"scavenger","vendor"},gang=1,skin={132,95,44},wep={24},},--ScavengersVendorSkins 
    ['scavenger_scavquest']={name="Scavenger Leader",behaviour="guard",traits={"scavenger","questgiver"},gang=1,skin={183,29,202,24,25,112},},--ScavengerFreelancerSkins
    --猪，转移到动物？猪也有派系...
    ['scavenger_pig']={name="Pig",gang=1,skin={81},},--animalFarmSkins 应该被转移到动物!

    --【拾荒者】 废土阵营
    ['scavenger_wasteguard']={name="Wastelander",behaviour="guard",traits={"wastelander"},gang=1,skin={34,133,134,198,201,202,261,26},wep=CampGuardWeapons},--wastelandersSkin 荒地者
    ['scavenger_wastefreelance']={name="Wastelander",behaviour="hunt",traits={"male","civilian","freelancer"},gang=1,skin={100,133,143,13,202,26,223},wep=banditWeapons},--WastelanderFreelancerSkins
    ['scavenger_wastevendor']={name="Trader",behaviour="default",traits={"wastelander","vendor"},gang=1,skin={201,197,196,160,131,132,134,129,31,10},wep={24},},--wastelanderCivSkin
    ['scavenger_wasteciv']={name="Wastelander",behaviour="civilian",traits={"male","civilian","wastelander"},gang=1,skin={201,197,196,160,131,132,134,129,31,10},},--wastelanderCivSkin 荒野求生者
    ['scavenger_wastequest']={name="Wastelander Leader",behaviour="guard",traits={"wastelander","questgiver"},gang=1,skin={100,133,143,13,202,26,223},},--WastelanderFreelancerSkins 领袖

    --【拾荒者】 黑社会 syndicate
    ['scavenger_nang']={name="Guard",behaviour="guard",traits={"syndicate"},gang=1,skin={121,122,123},wep=CampGuardWeapons},--黑社会Nang OK
    ['scavenger_triad']={name="Guard",behaviour="guard",traits={"syndicate"},gang=1,skin={117,118},wep=SyndicateTriadWeapons},--黑社会Traid OK
    ['scavenger_syndciv']={name="Survivor",behaviour="default",traits={"male","civilian","syndicate"},gang=1,skin={210,54,58,57,123,170,224,225,227,263},},--黑社会平民 OK
    ['scavenger_syndvendor']={name="Trader",behaviour="guard",traits={"syndicate","vendor"},gang=1,skin={210,54,58,57,123,170,224,225,227,263},wep={24},},--SyndicateCivSkin
    ['scavenger_syndQuest']={name="Syndicate Boss",behaviour="guard",traits={"syndicate","questgiver"},gang=1,skin={294,49},},--SyndQuestgiverSkins

    --【强盗】 OK ///////////////////////////
    ['bandit_guard']={name="Bandit",behaviour="guard",traits={"civilian","male","bandit"},gang=2,skin={28,30,47,104,144,301,241,177,184,102,18,223},wep=banditWeapons}, -- OK
    ['bandit_hunter']={name="Bandit",behaviour="hunt",traits={"civilian","male","bandit"},gang=2,skin={28,30,47,104,144,301,241,177,184,102,18,223},wep=banditWeapons},-- OK
    ['bandit_quest']={name="Gang Leader",behaviour="guard",traits={"questgiver","bandit"},gang=2,skin={28,30,47,104,144,301,241,177,184,102,18,223},wep=banditWeapons},-- OK

    --【自由人】 OK
    ['neutral_freelance']={name={"Looter","Robber","Vagrant","Drifter","Nomad","Thug"},behaviour="hunt",traits={"civilian","male","freelancer"},gang=0,skin={32,79,134,183,29,100,177,241,28,30,47,104,144,135,137,160,168,182,200,230,223},wep=NeutralFreelancerWeapons,},--NeutralFreelancerSkins
    
    --【测试】
    ['tester_archer']={name="GM",behaviour="guard",traits={},gang=0,skin={0},wep={23},},--NeutralFreelancerSkins

};


--THIRD LEVEL TYPE : WOLF
normal = {
    name = "Normal Ped",--名
    type = "normal",--原型
    attack = 10,
    fovDistance = 30,--视野距离
    fovAngle = 120,--视野角度
    speed = "walk",

    --人类会使用工具，这里应该由武器决定
    --TODO 武器最大射程 = shootdist
    shootdist = 30, -- shootdist < followdist 导致在特定距离时NPC会发呆，既不会攻击，也不会靠近
    followdist = 20,
    accuracy = 0.975,--0.95,

    gang = 0;
    sensor = false;--默认感知能力关闭
    behaviour = "default", -- 默认
    traits = {},
};

normal.__index = normal;
setmetatable( normal,human );

--人类的subtype是阵营
function normal:create(x,y,z,r,faction,btype)

    --outputDebugString("CREATE normal AT "..x..","..y..","..z);

    local skins = normalType[faction.."_"..btype].skin or 0 
    local weps = normalType[faction.."_"..btype].wep or nil
    local gang = normalType[faction.."_"..btype].gang or normal.gang
    local behaviour = normalType[faction.."_"..btype].behaviour or normal.behaviour
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
    o.traits = traits;

    if not weapon or weapon <= 9 then
        o.shootdist = 3
        o.followdist = 1
    end

    --normal表为索引，实际值为o，若无v补位
    --outputDebugString("sync normal");
    for k,v in pairs(normal) do 
        Data:setData(self.source,k,o[k] or v)
    end

    return o;

end