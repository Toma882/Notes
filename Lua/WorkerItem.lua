---
--- 雇员Item
--- Created by Toma.
--- DateTime: 2024/5/30 上午10:55
---

----@class WorkerItem : IUIItem
WorkerItem = Class("WorkerItem", IUIItem)

---@return WorkerItem
function WorkerItem.Get(go)
    local item = WorkerItem:New(go)
    item:Awake()
    return item
end

function WorkerItem:Awake()
    IUIItem.Awake(self)
    ---@type UnityEngine.GameObject
    self.NoneGo = self:GetChild("NoneGo")
    ---@type UnityEngine.GameObject
    self.LockGo = self:GetChild("LockGo")
    ---@type UnityEngine.UI.Text
    self.LockText = self:GetDefaultComponentIn("LockText")
    ---@type UnityEngine.GameObject
    self.EmptyGo = self:GetChild("EmptyGo")
    ---@type UnityEngine.GameObject
    self.UnlockGo = self:GetChild("UnlockGo")
    ---@type UnityEngine.GameObject
    self.BgGo = self:GetChild("BgGo")
    ---@type UnityEngine.UI.Image
    self.Icon = self:GetDefaultComponentIn("Icon")
    ---@type UnityEngine.UI.Text
    self.ScoreText = self:GetDefaultComponentIn("ScoreText")
    ---@type UnityEngine.GameObject
    self.ScoreGo = self:GetChild("ScoreGo")
    ---@type UnityEngine.GameObject
    self.PokerGo = self:GetChild("PokerGo")
    ---@type UnityEngine.GameObject
    self.TimeGo = self:GetChild("TimeGo")

    ---@type UnityEngine.GameObject
    self.containerGo = self:FindComponent("container")
    UIHelper:AddClick(self.containerGo, function()
        self:OnClick()
    end)
end

function WorkerItem:OnInitData(clickFunc)
    self.clickFunc = clickFunc
end

---@param info WorkerSlotData
function WorkerItem:UpdateInfo(info)
    self.slotInfo = info
    local dbid = info.workerDbid
    self.LockText.text = info:GetLockDesc()
    self:UpdateInfoByDbId(dbid)
    self.containerGo.name = "Guide_WorkerItem_Btn" .. self.index
end


---@param dbid number
function WorkerItem:UpdateInfoByDbId(dbid)
    self.dbid = dbid

    if dbid > 0 then
        self.NoneGo:SetActive(false)
        self.UnlockGo:SetActive(true)
    else
        self.NoneGo:SetActive(true)
        self.LockGo:SetActive(dbid < 0)
        self.EmptyGo:SetActive(dbid == 0)
        self.UnlockGo:SetActive(false)
        if self.button then
            self.button.gameObject.name = "Guide_WorkerItem_Btn" .. self.index
        end
    end

    self.info = WorkerDataMgr:GetWorkerInfo(self.dbid)
    if self.info then
        self.ScoreText.text = "Lv." .. self.info.lv
        self:UpdateInfoByCfg(self.info:GetCfg())
    end
end

function WorkerItem:UpdateInfoByCfg(cfg)
    local count = self.BgGo.transform.childCount
    local pokerType = cfg.pokerType
    for i = 1, count do
        self.BgGo:GetChild(i - 1):SetActive(i == pokerType)
    end

    count = self.PokerGo.transform.childCount
    for i = 1, count do
        self.PokerGo:GetChild(i - 1):SetActive(i == pokerType)
    end

    count = self.ScoreGo.transform.childCount
    local skillType = cfg.skillType
    for i = 1, count do
        self.ScoreGo:GetChild(i - 1):SetActive(i == skillType)
    end

    count = self.TimeGo.transform.childCount
    local workTimeType = cfg.workTimeType
    for i = 1, count do
        self.TimeGo:GetChild(i - 1):SetActive(i == workTimeType)
    end

    self.Icon.sprite = self:LoadSprite(cfg.headImage)
end

function WorkerItem:OnClick()
    if self.clickFunc then
        self.clickFunc(self)
    else
        if  self.dbid and self.dbid >= 0 then
            ---@type GridContainer
            local gridContainer = MallDataMgr:GetOperationGrid()
            if gridContainer then
                local gridData = gridContainer:GetLinkGridData()
                if gridData.gridType == GridType.ResPoint then
                    OpenUI(PanelID.ResPointDelopyPanel, gridData)
                else
                    OpenUI(PanelID.StoreDepolyPanel, gridData)
                end
            end
        else
            MsgBox.Tips("需要升级才能解锁")
        end
    end
end

return WorkerItem