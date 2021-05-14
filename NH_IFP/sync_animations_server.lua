-- since we're only interested in ped block, we don't need support for other blocks
-- you might want to rename playerAnimations.replacedPedBlock to playerAnimations.replacedBlocks 
-- to add support for replacing more blocks and keeping them sync 

local playerAnimations = {  } -- current = {}, replacedPedBlock = {}
local synchronizationPlayers = {}

local SetAnimation -- function

--事件：当玩家加入时
addEventHandler ( "onPlayerJoin", root,
    function ( )
        --清空进入玩家当前动作
        playerAnimations [ source ] = {}
    end
)

--事件：当玩家退出时
addEventHandler ( "onPlayerQuit", root,
    function ( )
        for i, player in pairs ( synchronizationPlayers ) do
            if source == player then 
                table.remove ( synchronizationPlayers, i ) --从同步管理器中移除玩家
                break
            end 
        end 
        playerAnimations [ source ] = nil
    end
)

--开局：清空所有玩家动作
for _, player in pairs ( getElementsByType ("player") ) do 
    playerAnimations [ player ] = {}
end
--开局：清空所有NPC动作
for _, ped in pairs ( getElementsByType ("ped") ) do 
    playerAnimations [ ped ] = {}
end
--TODO，NPC丢失时清空NPC TABLE


--已征用！！！！！！
--事件：自定义动作停止
--解析：客户端动作停止后，修改服务器的信息为无动作
addEvent ("onCustomAnimationStop", true )
addEventHandler ("onCustomAnimationStop", root,
    function ( player )
        outputChatBox("onCustomAnimationStop");
        SetAnimation ( player, false )--关闭当前动作
    end 
)

--服务器export函数
function syncAnimation(player,blockName,animationName,time,loop,updatePosition,interruptable,freezeLastFrame,blendTime,retainPedState)
    --outputChatBox("server syncAnimation:"..tostring(blockName));
    --outputChatBox("onCustomAnimationSet,loop="..tostring(loop));
    --outputChatBox("onCustomAnimationSet,time="..tostring(time));

    --默认参数
    if time == nil then time = -1 end
    if loop == nil then loop = true end
    if updatePosition == nil then updatePosition = true end
    if interruptable == nil then updatePosition = true end
    if freezeLastFrame == nil then freezeLastFrame = true end
    if blendTime == nil then blendTime = 250 end
    if retainPedState == nil then retainPedState = false end
    if updatePosition == nil then updatePosition = true end

    --outputChatBox("player:"..tostring(getPlayerName(player).." Play "..tostring(blockName).."'s "..tostring(animationName)));
    SetAnimation ( player, blockName, animationName ) --自定义函数-将动作信息存储到表格
    --outputChatBox("Server syncAnimation synchronizationPlayers count:"..tostring(#synchronizationPlayers).." target "..tostring(inspect(player)))
    triggerClientEvent ( synchronizationPlayers, "onClientCustomAnimationSet", player, blockName, animationName,time,loop,updatePosition,interruptable,freezeLastFrame,blendTime,retainPedState ) 
end
--已征用！！！！！！！！！！！
--事件：设置自定义动作时
--解析：来自某个玩家发送了请求，然后将他的动作同步给其他玩家
addEvent ("onCustomAnimationSet", true )
addEventHandler ("onCustomAnimationSet", root, syncAnimation, false )

--客户端函数：库版
function syncAnimationLib(ped,lib,code,time,loop,updatePosition,interruptable,freezeLastFrame,blendTime,retainPedState)
    outputChatBox("syncAnimationLib:"..tostring(lib)..","..tostring(code))
    if lib and code then
        local random = math.random ( 1, table.getn ( IFPLib[lib][code] ) )
        syncAnimation(ped,IFPLib[lib][code][random].block,IFPLib[lib][code][random].anim,time,loop,updatePosition,interruptable,freezeLastFrame,blendTime,retainPedState);
    else
        syncAnimation(ped,false,false);
    end 
end

--事件：客户端申请同步自定义动作
--触发条件：玩家客户端启动时
addEvent ("onCustomAnimationSyncRequest", true )
addEventHandler ("onCustomAnimationSyncRequest", root,
    function ( player )
        table.insert ( synchronizationPlayers, player ) --增加玩家到同步管理器
        triggerLatentClientEvent ( player, "onClientCustomAnimationSyncRequest", 50000, false, player, playerAnimations ) --将信息同步给玩家
    end 
)


--事件：替换自定义动作时
addEvent ("onCustomAnimationReplace", true )
addEventHandler ("onCustomAnimationReplace", root,
    function ( player, ifpIndex )
        playerAnimations[ player ].replacedPedBlock = ifpIndex
        triggerClientEvent ( synchronizationPlayers, "onClientCustomAnimationReplace", player, ifpIndex )
    end 
)

--事件：恢复自定义动作时
addEvent ("onCustomAnimationRestore", true )
addEventHandler ("onCustomAnimationRestore", root,
    function ( player, blockName )
        playerAnimations[ player ].replacedPedBlock = nil
        triggerClientEvent ( synchronizationPlayers, "onClientCustomAnimationRestore", player, blockName )
    end 
)

--自定函数：设置动作
--主要是修改了一个信息表
function SetAnimation ( player, blockName, animationName )
    if not playerAnimations[ player ] then playerAnimations[ player ] = {} end 
    if blockName == false then
        playerAnimations[ player ].current = nil
    else
        --修改服务器表格，该玩家目前的动作为Block的animation
        playerAnimations[ player ].current = { blockName, animationName }
    end 
end 

