--注意，客户端设置的数据不会被同步到服务器
function setData(element,key,value)
    --pElement: element or string, which you wish to set data
    --pKey: string, which defines a key used by element
    --pValue: string, boolean, number, userdata or table which will be set as key value
    --pType: string, which defines type of data, can be "local", "synced" or "private"
    --pEvent: string or false/nil, defining which server event caused data to change
    local pSyncer = nil --pSyncer: element or false/nil, responsible for data syncing
    setCustomData(element,key,value,"synced",nil,pSyncer)
end

function getData(element,key)
    return getCustomData(element,key,"synced")
end

function onDataHandler(pElement, pKey, pType, pOldValue, pNewValue, pEvent, pSyncer)
	outputChatBox("onDataHandler got triggered at key: "..pKey.." ("..pType.." data) - syncer element: "..inspect(pSyncer))
end
addDataHandler("player", {}, {}, onDataHandler, "onDataChanged")