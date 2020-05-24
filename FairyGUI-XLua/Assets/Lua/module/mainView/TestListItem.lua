TestListItem = fgui.extension_class(GButton)
function TestListItem:ctor()
    print("TestListItem ctor",self,TestListItem.SetData)
end

function TestListItem:SetData(data,index,len)
    print("item setdata",index,len)
    self:GetChild("txtTitle").text = "item"..data
end