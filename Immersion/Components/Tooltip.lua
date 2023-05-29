local _, L = ...
local Tooltip = {}
local isConsolePortLoaded = IsAddOnLoaded('ConsolePort')
L.TooltipMixin = Tooltip

function Tooltip:OnShow()
	L.UIFrameFadeIn(self, 0.2, 0, 1)
	self:SetAllPoints()
end

function Tooltip:OnHide()
	self:ClearAllPoints()
	self:OnLeave()
end

function Tooltip:OnEnter()
	local parent = self:GetParent()
	L.UIFrameFadeIn(parent.Hilite, 0.2, parent.Hilite:GetAlpha(), 1)
	if not isConsolePortLoaded then
		self:SetFocus()
	end
end

function Tooltip:OnLeave()
	local parent = self:GetParent()
	L.UIFrameFadeOut(parent.Hilite, 0.2, parent.Hilite:GetAlpha(), 0)
	if not isConsolePortLoaded then
		self:ClearFocus()
	end
end

function Tooltip:SetFocus()
	local parent = self:GetParent()
	GameTooltip_ShowCompareItem(parent)
	if self.pool then
		for tooltip in self.pool:EnumerateActive() do
			if tooltip ~= parent then
				L.UIFrameFadeOut(tooltip, 0.2, tooltip:GetAlpha(), 0.1)
			end
		end
	end
end

function Tooltip:ClearFocus()
	local parent = self:GetParent()
	if self.pool then
		for tooltip in self.pool:EnumerateActive() do
			if tooltip ~= parent then
				L.UIFrameFadeIn(tooltip, 0.2, tooltip:GetAlpha(), 1)
			end
		end
	end
	for _, sTooltip in pairs(parent.shoppingTooltips) do
		sTooltip:Hide()
	end
end

function Tooltip:SetReferences(item, inspector)
	self.item = item
	self.inspector = inspector
	self.pool = inspector and inspector.tooltipFramePool
end

function Tooltip:OnClick()
	local item = self.item
	local inspector = self.inspector
	if item then
		if (IsModifiedClick('EXPANDITEM') and item.objectType == 'item' ) then
			HandleModifiedItemClick(GetQuestItemLink(item.type, item:GetID()))
			inspector:Hide()
		elseif ( item.container and item.container.chooseItems and item.type == "choice" ) then
			item.container.itemChoice = item:GetID()
			item.highlight:SetPoint('TOPLEFT', item, 0, 0)
			item.highlight:Show()
			item.highlight.TextSheen.InAnim:Stop()
			item.highlight.TextSheen.InAnim:Play()
			item.highlight.Icon.InAnim:Stop()
			item.highlight.Icon.InAnim:Play()
			item.Icon.InAnim:Stop()
			item.Border.InAnim:Stop()
			item.Icon.InAnim:Play()
			item.Border.InAnim:Play()
			inspector:Hide()
		end
	end
end