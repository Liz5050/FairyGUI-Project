require 'FairyGUI'
List = function(list,itemRender)
    local private = {}
    local public = {list = list}
    private.items = {}

    public.SetData = function(data)
        private.data = data
        private.isVirtual = false
        private.RemoveItemsToPool()
        private.AddItemsFromPool(data)
    end

    public.GetData = function()
        return private.data
    end

    public.SetVirtual = function(data,itemRender,getListItemResource,isLoop)
        private.data = data
        private.isVirtual = true
        if not itemRender then
            itemRender = private.DefaultItemRenderer
        end
        list.itemRenderer = itemRender
        if getListItemResource and not list.itemProvider then
            list.itemProvider = getListItemResource
        end
        if isLoop then
            list:SetVirtualAndLoop()
        else
            list:SetVirtual()
        end
        if data then
            list.numItems = #data
        else
            list.numItems = 0
        end
    end

    private.DefaultItemRenderer = function(index,itemGo)
        local item = itemRender()
        item.Init(itemGo)
        local luaIdx = index + 1
        item.SetData(private.data[luaIdx],luaIdx)
    end

    private.AddItemsFromPool = function(data)
        if data and #data > 0 then
            if data and #data > 0  then
                local len = #data
                for i = 1, len do
                    local itemGo = list:AddItemFromPool()
                    local item = itemRender()
                    item.Init(itemGo)
                    item.SetData(data[i],i,len)
                    table.insert(private.items,item)
                end
            end
        end
    end

    private.RemoveItemsToPool = function()
        if private.autoRecycle then
            for i = 1,#private.items do
                local itemGo = list:RemoveChildAt(i - 1)
                private.items[i].Reset()
                list:ReturnToPool(itemGo)
            end
        else
            list:RemoveChildrenToPool()
        end
    end

    return public
end