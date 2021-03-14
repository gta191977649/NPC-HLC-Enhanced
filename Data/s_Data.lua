--懒人简化版数据同步
function setData(element,key,value)
	--pElement: element or string, which you wish to set data
	--pKey: string, which defines a key used by element
	--pValue: string, boolean, number, userdata or table which will be set as key value
	--pType: string, which defines type of data, can be "local", "synced" or "private"
	--pReceivers: player or table with players or nil/false, specifies which players will receive data, ignored if pType isn't equal to "private"
	
	local pSyncer = nil --pSyncer: element or false/nil, responsible for data syncing
	--outputChatBox("pSyncer:"..tostring(getElementType(pSyncer)));
	
	local pEvent = "onDataChanged" --pEvent: string or false/nil, defining which server event caused data to change
	--pBuffer: string or false/nil, if string passed it will enable batch or buffer functionality (see below for explanation)
	--pTimeout: integer or false/nil, if it's == -1 then server will use batch, if it's >= 0 server will use buffer, ignored if pBuffer isn't enabled

	setCustomData(element,key,value,"synced",nil,pSyncer,pEvent,nil,nil)
end

function getData(element,key)
	--pElement: element or a string which holds data pack
	--pKey: string which holds data under certain name or nil
	--pType: string which defines data type, can be "local", "synced" or "private"
	--pRequester: player or nil/false, which requests data - ignored when pType isn't equal to "private"
    return getCustomData(element,key,"synced",nil)
end