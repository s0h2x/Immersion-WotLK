local _, L = ...
local ScalerMixin = {}; L.ScalerMixin = ScalerMixin;
----------------------------------
-- ScalerMixin
----------------------------------
function ScalerMixin:ScaleUpdate()
	local scale = self.targetScale
	local current = self:GetScale()
	local delta = scale > current and 0.025 or -0.025
	if abs(current - scale) < 0.05 then
		self:SetScale(scale)
		self:SetScript('OnUpdate', self.oldScript)
		if self.OnScaleFinished then
			self:OnScaleFinished()
		end
	else
		self:SetScale( current + delta )
	end
end
function ScalerMixin:ScaleTo(scale)
	local oldScript = self:GetScript('OnUpdate')
	self.targetScale = scale
	if oldScript and oldScript ~= self.ScaleUpdate then
		self.oldScript = oldScript
		self:HookScript('OnUpdate', self.ScaleUpdate)
	else
		self.oldScript = nil
		self:SetScript('OnUpdate', self.ScaleUpdate)
	end
end

function ScalerMixin:OnEnter()
	self:ScaleTo(self.enterScale or 1.1)
	if self.Hilite then
		L.UIFrameFadeIn(self.Hilite, 0.2, self.Hilite:GetAlpha(), 1)
	end
end

function ScalerMixin:OnLeave()
	self:ScaleTo(self.normalScale or 1)
	if self.Hilite then
		L.UIFrameFadeOut(self.Hilite, 0.2, self.Hilite:GetAlpha(), 0)
	end
end

function ScalerMixin:OnHide()
	self:SetScript('OnUpdate', nil)
	self:SetScale(self.normalScale or 1)
	if self.Hilite then
		self.Hilite:SetAlpha(0)
	end
end
----------------------------------
-- AdjustMixin
----------------------------------
local AdjustMixin = {}; L.AdjustToChildren = AdjustMixin;
	
function AdjustMixin:IterateChildren()
	local regions = {self:GetChildren()}
	if not self.ignoreRegions then
		for _, v in pairs({self:GetRegions()}) do
			regions[#regions + 1] = v
		end
	end
	return pairs(regions)
end

function AdjustMixin:GetAdjustableChildren()
	local adjustable = {}
	for _, child in self:IterateChildren() do
		if child.AdjustToChildren then
			adjustable[#adjustable + 1] = child
		end
	end
	return pairs(adjustable)
end

function AdjustMixin:AdjustToChildren(xPad, yPad)
	self:SetSize(1, 1)
	for _, child in self:GetAdjustableChildren() do
		child:AdjustToChildren()
	end
	local top, bottom, left, right
	for _, child in self:IterateChildren() do
		if child:IsShown() then
			local childTop, childBottom = child:GetTop(), child:GetBottom()
			local childLeft, childRight = child:GetLeft(), child:GetRight()
			if (childTop) and (not top or childTop > top) then
				top = childTop
			end
			if (childBottom) and (not bottom or childBottom < bottom) then
				bottom = childBottom
			end
			if (childLeft) and (not left or childLeft < left) then
				left = childLeft
			end
			if (childRight) and (not right or childRight > right) then
				right = childRight
			end
		end
	end
	if top and bottom then
		self:SetHeight(abs( top - bottom ) + (yPad or 0))
	end
	if left and right then
		self:SetWidth(abs( right - left ) + (xPad or 0))
	end
	return self:GetSize()
end