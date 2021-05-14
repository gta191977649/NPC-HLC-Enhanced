local animationManagerWindow = nil
local replaceAnimationLabel, playAnimationLabel = nil, nil
local restoreDefaultsButton, stopAnimationButton = nil, nil
local replaceAnimationGridList, playAnimationGridList = nil, nil

local isShowingAnimationBlocksInPlayGridList = true
local currentBlockNameSelected = nil

local isLocalPlayerAnimating = false

--GUI
local function PopulatePlayAnimationGridListWithBlocks ()
    isShowingAnimationBlocksInPlayGridList = true
    currentBlockNameSelected = nil

    guiGridListClear ( playAnimationGridList )

    -- Add IFP blocks to the play animation gridlist
    for customAnimationBlockIndex, customAnimationBlock in ipairs ( globalLoadedIfps ) do 
        local rowIndex = guiGridListAddRow ( playAnimationGridList, " + "..customAnimationBlock.friendlyName )
        guiGridListSetItemData ( playAnimationGridList, rowIndex, 1, customAnimationBlockIndex )
    end
end

--GUI
local function PopulatePlayAnimationGridListWithCustomBlockAnimations ( ifpIndex )
    isShowingAnimationBlocksInPlayGridList = false
    currentBlockNameSelected = globalLoadedIfps [ifpIndex].blockName

    guiGridListClear ( playAnimationGridList )
    guiGridListAddRow ( playAnimationGridList, ".." )

    -- Add IFP blocks to the play animation gridlist
    for _, customAnimationName in ipairs ( globalLoadedIfps [ifpIndex].animations ) do 
        local rowIndex = guiGridListAddRow ( playAnimationGridList, "  "..customAnimationName )
        guiGridListSetItemData ( playAnimationGridList, rowIndex, 1, customAnimationName )
    end
end

--事件：资源启动时
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        triggerServerEvent ( "onCustomAnimationSyncRequest", resourceRoot, localPlayer )

        outputChatBox ("Press 'F2' to toggle Animation Manager", 255, 255, 255)
        --showCursor ( true )

        animationManagerWindow = guiCreateWindow(118, 116, 558, 371, "Animation Manager", false)
        guiWindowSetSizable(animationManagerWindow, false)
        guiSetVisible ( animationManagerWindow, false ) --default close

        replaceAnimationLabel = guiCreateLabel(12, 26, 245, 19, "Replace Animations With", false, animationManagerWindow)
        guiSetFont(replaceAnimationLabel, "default-bold-small")
        guiLabelSetHorizontalAlign(replaceAnimationLabel, "center", false)

        replaceAnimationGridList = guiCreateGridList(12, 49, 245, 255, false, animationManagerWindow)
        guiGridListAddColumn(replaceAnimationGridList, "Animation Blocks", 0.9)
        
        restoreDefaultsButton = guiCreateButton(49, 314, 174, 41, "Restore Defaults", false, animationManagerWindow)
        playAnimationLabel = guiCreateLabel(294, 26, 245, 19, "Play Animation", false, animationManagerWindow)
        guiSetFont(playAnimationLabel, "default-bold-small")
        guiLabelSetHorizontalAlign(playAnimationLabel, "center", false)
        
        stopAnimationButton = guiCreateButton(329, 314, 174, 41, "Stop Animation", false, animationManagerWindow)
        playAnimationGridList = guiCreateGridList(294, 49, 245, 255, false, animationManagerWindow)
        guiGridListAddColumn(playAnimationGridList, "Animation Blocks", 0.9)

        -- load IFP files and add them to the play animation gridlist
        -- 读取IFP文件，增加到GRIDLIST
        for customAnimationBlockIndex, customAnimationBlock in ipairs ( globalLoadedIfps ) do 
            local ifp = engineLoadIFP ( customAnimationBlock.path, customAnimationBlock.blockName )
            if not ifp then
                outputChatBox ("Failed to load '"..customAnimationBlock.path.."'")
            end
        end

        -- now add replaceable ifps to the other grid list
        -- 部分动作文件增加到左侧列表
        for _, ifpIndex in ipairs ( globalReplaceableIfpsIndices ) do 
            local customAnimationBlock = globalLoadedIfps [ ifpIndex ]
            local rowIndex = guiGridListAddRow ( replaceAnimationGridList, customAnimationBlock.friendlyName )
            guiGridListSetItemData ( replaceAnimationGridList, rowIndex, 1, ifpIndex )
        end

        --GUI
        PopulatePlayAnimationGridListWithBlocks ()

        --默认动作
        ReplacePedBlockAnimations ( localPlayer, 10 )
    end
) 

--函数：替换动作
function ReplacePedBlockAnimations ( player, ifpIndex )
    local customIfpBlockName = globalLoadedIfps [ ifpIndex ].blockName
    outputChatBox("ReplacePedBlockAnimations:"..tostring(customIfpBlockName));
    for _, animationName in pairs ( globalPedAnimationBlock.animations ) do 
        -- make sure that we don't replace a partial animation
        --outputChatBox("replace:"..tostring(animationName));
        if not globalPedAnimationBlock.partialAnimations [ animationName ] then 
            engineReplaceAnimation ( player, "ped", animationName, customIfpBlockName, animationName )
        end
    end
end 

--双击
local function HandleReplacedAnimationGridListDoubleClick ()
    outputChatBox("HandleReplacedAnimationGridListDoubleClick");
    local replacedAnimGridSelectedRow, replacedAnimGridSelectedCol = guiGridListGetSelectedItem ( replaceAnimationGridList ); 
    if replacedAnimGridSelectedRow and replacedAnimGridSelectedRow ~= -1 then 
        local ifpFriendlyName = guiGridListGetItemText( replaceAnimationGridList, replacedAnimGridSelectedRow, replacedAnimGridSelectedCol ) 
        local ifpIndex = guiGridListGetItemData(replaceAnimationGridList, replacedAnimGridSelectedRow, replacedAnimGridSelectedCol )
        ReplacePedBlockAnimations ( localPlayer, ifpIndex )
        triggerServerEvent ( "onCustomAnimationReplace", resourceRoot, localPlayer, ifpIndex )
        outputChatBox ("Replaced 'ped' block animations with '"..ifpFriendlyName.."'", 255, 255, 255)
    end
end 

--双击右边某个动作
--修改后用于播放单个动作
local function HandlePlayAnimationGridListDoubleClick ()
    outputChatBox("Play One Animation");
    local playAnimGridSelectedRow, playAnimGridSelectedCol = guiGridListGetSelectedItem ( playAnimationGridList ); 
    if playAnimGridSelectedRow and playAnimGridSelectedRow ~= -1 then 
        local itemText = guiGridListGetItemText( playAnimationGridList, playAnimGridSelectedRow, playAnimGridSelectedCol )
        if isShowingAnimationBlocksInPlayGridList then  
            local ifpIndex = guiGridListGetItemData(playAnimationGridList, playAnimGridSelectedRow, playAnimGridSelectedCol )
            PopulatePlayAnimationGridListWithCustomBlockAnimations ( ifpIndex )
        else
            if itemText == ".." then -- 返回上一级菜单
                PopulatePlayAnimationGridListWithBlocks ( )
            else
                local animationName = guiGridListGetItemData(playAnimationGridList, playAnimGridSelectedRow, playAnimGridSelectedCol )

                --------------
                --设置本地玩家动作
                setPedAnimation ( localPlayer, currentBlockNameSelected, animationName )
                --通知服务器端同步动作
                triggerServerEvent ( "onCustomAnimationSet", resourceRoot, localPlayer, currentBlockNameSelected, animationName )
                isLocalPlayerAnimating = true --设置本地玩家动作状态
            end
       end
    end 
end 

--双击鼠标
addEventHandler( "onClientGUIDoubleClick", resourceRoot,
    function ( button, state, absoluteX, absoluteY )
        if button == "left" and state == "up" then 
            if source == replaceAnimationGridList then 
                HandleReplacedAnimationGridListDoubleClick ( )
            elseif source == playAnimationGridList then 
                HandlePlayAnimationGridListDoubleClick ( )
            end 
        end
    end 
)

--玩家点击鼠标时，恢复动作/停止动作
addEventHandler( "onClientGUIClick", resourceRoot,
    function ( button, state )
        if button == "left" and state == "up" then 
            if source == restoreDefaultsButton then 
                -- restore all replaced animations of "ped" block
                engineRestoreAnimation ( localPlayer, "ped" )
                triggerServerEvent ( "onCustomAnimationRestore", resourceRoot,  localPlayer, "ped" )
                outputChatBox ("Restored ped block animations", 255, 255, 255)
            elseif source == stopAnimationButton then 
                setPedAnimation ( localPlayer, false )
                triggerServerEvent ( "onCustomAnimationSet", resourceRoot, localPlayer, false, false )
            end 
        end
    end 
)

--打开菜单
bindKey ( "F4", "down", 
    function ( key, keyState )
        if ( keyState == "down" ) then
            local isAnimationMangerWindowVisible = guiGetVisible ( animationManagerWindow )
            guiSetVisible ( animationManagerWindow, not isAnimationMangerWindowVisible )
            showCursor ( not isAnimationMangerWindowVisible )
        end
    end
)

addEvent ("onClientCustomAnimationSyncRequest", true )
addEventHandler ("onClientCustomAnimationSyncRequest", root,
    function ( playerAnimations )
        for player, anims in pairs ( playerAnimations ) do 
            if isElement ( player ) then 
                if anims.current then 
                    setPedAnimation ( player, anims.current[1], anims.current[2] ) 
                end
                if anims.replacedPedBlock then 
                    ReplacePedBlockAnimations ( player, anims.replacedPedBlock )
                end
            end
        end 
    end 
)

--事件：收到服务器同步动作的命令
--解析：这里设置的是某个玩家，主要是将他的动作在其他玩家客户端设置一次
addEvent ("onClientCustomAnimationSet", true )
addEventHandler ("onClientCustomAnimationSet", root,
    function ( blockName, animationName,time,loop,updatePosition,interruptable,freezeLastFrame,blendTime,retainPedState )

        --outputChatBox("onClientCustomAnimationSet,source="..tostring(inspect(source)));
        --注意：如果这里关闭了无法接受来自自己的动作消息
        if source == localPlayer then
            --outputChatBox("source == localPlayer");
            return
        end

        if blockName == false then 
            setPedAnimation ( source, false )
            return
        end 

        --outputChatBox("onClientCustomAnimationSet,loop="..tostring(loop));
        --outputChatBox("onClientCustomAnimationSet,time="..tostring(time));

        --默认参数
        if time == nil then time = -1 end
        if loop == nil then loop = true end
        if updatePosition == nil then updatePosition = true end
        if interruptable == nil then updatePosition = true end
        if freezeLastFrame == nil then freezeLastFrame = true end
        if blendTime == nil then blendTime = 250 end
        if retainPedState == nil then retainPedState = false end
        if updatePosition == nil then updatePosition = true end

        --outputChatBox("onClientCustomAnimationSet,loop="..tostring(loop));
        --outputChatBox("onClientCustomAnimationSet,time="..tostring(time));

        setPedAnimation ( source, blockName, animationName,time,loop,updatePosition,interruptable,freezeLastFrame,blendTime,retainPedState )
    end 
)

addEvent ("onClientCustomAnimationReplace", true )
addEventHandler ("onClientCustomAnimationReplace", root,
    function ( ifpIndex )
        if source == localPlayer then return end
        ReplacePedBlockAnimations ( source, ifpIndex )
    end 
)

addEvent ("onClientCustomAnimationRestore", true )
addEventHandler ("onClientCustomAnimationRestore", root,
    function ( blockName )
        if source == localPlayer then return end
        engineRestoreAnimation ( source, blockName )
    end 
)


--有用
--客户端检测玩家动作是否停止并通知服务器
--注意，只能检测到被同步的动作，本地的无法检测到
setTimer ( 
    function ()
        if isLocalPlayerAnimating then 
            if not getPedAnimation (localPlayer) then
                isLocalPlayerAnimating = false
                triggerServerEvent ( "onCustomAnimationStop", resourceRoot, localPlayer )
            end
        end
    end, 100, 0
)