--客户端函数：为当前玩家设置一个动作并同步给所有人
function syncAnimation(ped,blockName,animationName,time,loop,updatePosition,interruptable,freezeLastFrame,blendTime,retainPedState)

    --outputChatBox("client syncAnimation:"..tostring(blockName).." "..tostring(animationName).." target "..tostring(inspect(ped)))
    --outputChatBox("syncAnimation,loop="..tostring(loop));
    --outputChatBox("syncAnimation,time="..tostring(time));

    --默认参数
    if time == nil then time = -1 end
    if loop == nil then loop = true end
    if updatePosition == nil then updatePosition = true end
    if interruptable == nil then interruptable = true end
    if freezeLastFrame == nil then freezeLastFrame = false end --默认不冻住玩家
    if blendTime == nil then blendTime = 250 end
    if retainPedState == nil then retainPedState = false end
    --------------
    --设置本地玩家动作
    if blockName and animationName then
        setPedAnimation ( ped, blockName, animationName,time,loop,updatePosition,interruptable,freezeLastFrame,blendTime,retainPedState )
    else
        setPedAnimation(ped)
    end

    --通知服务器端同步动作
    triggerServerEvent ( "onCustomAnimationSet", root, ped, blockName, animationName,time,loop,updatePosition,interruptable,freezeLastFrame,blendTime,retainPedState )

end

--客户端函数：库版
function syncAnimationLib(ped,lib,code,time,loop,updatePosition,interruptable,freezeLastFrame,blendTime,retainPedState)
    --outputChatBox("syncAnimationLib:"..tostring(lib).." "..tostring(code))
    if lib then
        local random = math.random ( 1, table.getn ( IFPLib[lib][code] ) )

        --设置数据
        setElementData(ped,"ifp",code)
        syncAnimation(ped,IFPLib[lib][code][random].block,IFPLib[lib][code][random].anim,time,loop,updatePosition,interruptable,freezeLastFrame,blendTime,retainPedState);
    else

        --设置数据
        setElementData(ped,"ifp",false)
        syncAnimation(ped);
    end
end