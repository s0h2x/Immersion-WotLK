local API, _, L = ImmersionAPI, ...
local Inspector, CreateFramePool = ImmersionFrame.Inspector, API.CreateFramePool

-- Synthetic OnLoad
do local self = Inspector
	-- add tables for column frames, used when drawing qItems as tooltips
	self.Choices.Columns = {}
	self.Extras.Columns = {}
	self.Active = {}

	self.parent = self:GetParent()
	self.ignoreRegions = true
	self:EnableMouse(true)

	-- set parent/strata on load main frame keeps table key, strata correctly draws over everything else.
	if L('hideui') then
		self:SetParent(UIParent)
	end
	self:SetFrameStrata('FULLSCREEN_DIALOG')

	self.Items = {}
	self:SetScale(1.1)

	local r, g, b = L.GetClassColor(select(2, UnitClass('player')))
	--self.Background:SetColorTexture(1, 1, 1)
	self.Background:SetGradientAlpha('VERTICAL', 0, 0, 0, 0.75, r / 5, g / 5, b / 5, 0.75)

	self.tooltipFramePool = CreateFramePool('GameTooltip', self, 'ImmersionItemTooltipTemplate', function(self, obj) obj:Hide() end)
	self.tooltipFramePool.creationFunc = function(framePool)
		local index = #framePool.inactiveObjects + framePool.numActiveObjects + 1
		local tooltip = L.Create({
			type    = framePool.frameType,
			name    = 'GameTooltip',
			index   = index,
			parent  = framePool.parent,
			inherit = framePool.frameTemplate
		})
		L.SetBackdrop(tooltip.Hilite, L.Backdrops.GOSSIP_HILITE)
		return tooltip
	end
end

function Inspector:OnShow()
	self.parent.TalkBox:Dim();
	self.tooltipFramePool:ReleaseAll();
end

function Inspector:OnHide()
	self.parent.TalkBox:Undim();
	self.tooltipFramePool:ReleaseAll();
	wipe(self.Active);

	-- Reset columns
	for _, column in ipairs(self.Choices.Columns) do
		column.lastItem = nil
		column:SetSize(1, 1)
		column:Hide()
	end
	for _, column in ipairs(self.Extras.Columns) do
		column.lastItem = nil
		column:SetSize(1, 1)
		column:Hide()
	end
end

Inspector:SetScript('OnShow', Inspector.OnShow)
Inspector:SetScript('OnHide', Inspector.OnHide)