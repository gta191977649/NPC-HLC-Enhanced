
IFPLib = {
    ['human']={
        ['idle']={
            --[1]={block="Attractors",anim="Stepsit_loop"}, --bear sit
            --[1]={block="bar",anim="barcustom_loop"}, --摇晃头部(会导致位移)
            [1]={block="bd_fire",anim="wash_up"}, --搓手
            [2]={block="ped",anim="phone_talk"},--打电话
            [3]={block="ped",anim="fucku"},--FKU
            [4]={block="ped",anim="gum_eat"},--eat
            [5]={block="ped",anim="IDLE_chat"},--eat
            [6]={block="ped",anim="IDLE_HBHB"},--eat
            [7]={block="ped",anim="IDLE_tired"},--eat
            [8]={block="ped",anim="roadcross"},--左右看
            [9]={block="ped",anim="roadcross_gang"},--左右看
            [10]={block="ped",anim="XPRESSscratch"},--左右看
            --[3]={block="BEACH",anim="ParkSit_M_loop"}, --坐下
        },
        ['walk']={
            [1]={block="ped",anim="WALK_civi"},
        },
        ['drink']={
            [1]={block="bar",anim="dnk_stndM_loop"},--男喝
        },
        ['panic']={--恐慌
            --{block="ped",anim="run_civi"},--
            {block="ped",anim="cower"},--抱头
        },
        ['handsup']={--举手求饶
            --{block="ped",anim="run_civi"},--
            {block="SHOP",anim="SHP_Rob_HandsUp"},--抱头
        },
        ['warn']={--发现目标/示警
            {block="ON_LOOKERS",anim="point_loop"},--
            {block="ON_LOOKERS",anim="shout_in"},--
        },
        ['search']={--
            {block="ped",anim="flee_lkaround_01"},--左顾右盼
        },
        ['talk']={--交谈
            {block="ped",anim="IDLE_chat"},--
            {block="ped",anim="endchat_01"},--
            {block="ped",anim="XPRESSscratch"},--
            {block="ped",anim="roadcross"},--
        },
    },
    ['animal']={
        ['idle']={
            --[1]={block="Attractors",anim="Stepsit_loop"}, --bear sit
            [1]={block="bd_fire",anim="wash_up"}, --摇晃身体
            [2]={block="benchpress",anim="gym_bp_celebrate"}, --剧烈摇晃身体
        },
    },
    ['zombie']={
        ['walk']={
            [1]={block="nh_zombie",anim="zb_walk"},
            [2]={block="nh_zombie",anim="zb_walk2"},
            [3]={block="nh_zombie",anim="zb_walk3"},
            [4]={block="nh_zombie",anim="zb_walk4"},
            [5]={block="nh_zombie",anim="zb_walk5"},
            [6]={block="nh_zombie",anim="zb_walk_old"},
            [7]={block="nh_zombie",anim="zb_walk_old2"},
            [8]={block="nh_zombie",anim="zb_walk_old3"},
        },
        ['run']={
            [1]={block="nh_zombie",anim="zb_run"},
            [2]={block="nh_zombie",anim="zb_run2"},
            [3]={block="nh_zombie",anim="zb_run3"},
            [4]={block="nh_zombie",anim="zb_run4"},
        },
        ['attack']={
            [1]={block="nh_zombie",anim="zb_attack_right"},
            [2]={block="nh_zombie",anim="zb_attack_right2"},
            [3]={block="nh_zombie",anim="zb_attack_left"},
            [4]={block="nh_zombie",anim="zb_attack_left2"},
        },
        ['sprint']={
            [1]={block="nh_zombie",anim="zb_sprint"},
            [2]={block="nh_zombie",anim="zb_sprint2"},
            [3]={block="nh_zombie",anim="zb_sprint3"},
            [4]={block="nh_zombie",anim="zb_sprint4"},
        },
        ['idle']={
            [1]={block="nh_zombie",anim="zb_idle"},
            [2]={block="nh_zombie",anim="zb_idle2"},
            [3]={block="nh_zombie",anim="zb_idle3"},
            [4]={block="nh_zombie",anim="zb_idle4"},
            [5]={block="nh_zombie",anim="zb_idle5"},
            [6]={block="nh_zombie",anim="zb_idle6"},
            [7]={block="nh_zombie",anim="zb_idle7"},
        },
        ['eat']={
            [1]={block="nh_zombie",anim="zb_eat"},
        },
        ['search']={
            [1]={block="nh_zombie",anim="zb_search"},
        },
    },
}

--TODO:增加一个反向查询功能
animToIFPLib ={}