--- WorkerBaseItem.lua
--- 雇员Item
--- Created by Toma.
--- DateTime: 2024/5/30 上午10:55

---@class WorkerBaseItem : IUIItem
WorkerBaseItem = Class("WorkerBaseItem", IUIItem)

---@return WorkerBaseItem
function WorkerBaseItem.Get(go, clickFunc)
    local item = WorkerBaseItem:New(go)
    item:Awake()
    item:Start()
    item:OnInitData(clickFunc)
    return item
end

function WorkerBaseItem:Awake()
    IUIItem.Awake(self)
    
    -- region Get Component
    ---@type UnityEngine.UI.Image
    self.icon = self:GetDefaultComponentIn("icon")
    ---@type UnityEngine.UI.Text
    self.lvTxt = self:GetDefaultComponentIn("lvTxt")
    ---@type UnityEngine.UI.Text
    self.pokerTxt = self:GetDefaultComponentIn("pokerTxt")
    ---@type UnityEngine.UI.Text
    self.workTimeText = self:GetDefaultComponentIn("workTimeText")
    ---@type UnityEngine.UI.Image
    self.qualityBg = self:GetDefaultComponentIn("qualityBg")
    ---@type UnityEngine.GameObject
    self.starList = self:GetChild("starList")
    -- endregion
end

function WorkerBaseItem:Start()
    -- 可以在这里初始化一些数据或逻辑
    UIHelper:AddClick(self.gameObject, function ()
        self:OnClick()
    end)
end

---初始化数据
---@param clickFunc function 点击回调函数
function WorkerBaseItem:OnInitData(clickFunc)
    self.clickFunc = clickFunc
end

---更新工人信息
---@param info table 工人信息
function WorkerBaseItem:UpdateInfo(info)
    
end

---通过worker信息更新
---@param worker table 工人数据对象
function WorkerBaseItem:UpdateInfoByInfo(worker)
   
end

---通过配置更新
---@param cfg WorkerCfg
function WorkerBaseItem:UpdateInfoByCfg(cfg)
    -- 实现基于配置更新逻辑

end

---点击事件处理
function WorkerBaseItem:OnClick()
    if self.clickFunc then
        self.clickFunc(self)
    end
end

return WorkerBaseItem