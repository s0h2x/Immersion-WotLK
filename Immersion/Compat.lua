local _, L = ...
----------------------------------
-- Compatibility list
----------------------------------
L.compat = {
----------------------------------
	['ConsolePort'] = function(self)
		if ConsolePortCursor then L.ToggleIgnoreFrame(ConsolePortCursor, true) end
		if ConsolePortMouseHandle then L.ToggleIgnoreFrame(ConsolePortMouseHandle, true) end
		if ConsolePortUIHandle then L.ToggleIgnoreFrame(ConsolePortUIHandle.HintBar, true) end

		local config = ConsolePortOldConfig
		if config then
			local WindowMixin = {}
			function WindowMixin:OnShow()
				L.config:SetParent(self)
				L.config:ClearAllPoints()
				L.config:SetPoint('TOPLEFT', 16, -16)
				L.config:SetPoint('BOTTOMRIGHT', -16, 16)
				L.config.logo:Hide()
				L.config:Show()
			end

			function WindowMixin:OnHide()
				L.config.logo:Show()
			end
			
			config:AddPanel({
				name = _, 
				header = _, 
				mixin = WindowMixin,
			})
		end
	end;
----------------------------------
	['Blitz'] = function(self)
		local button, text = Blitz, BlitzText
		if button and text then
			button:SetParent(ImmersionContentFrame)
			button:ClearAllPoints()
			button:SetHitRectInsets(-100, 0, 0, 0)
			button:SetPoint('TOPRIGHT')

			text:ClearAllPoints()
			text:SetPoint('RIGHT', button, 'LEFT', 0, 1)
			text:SetJustifyH('RIGHT')
		end
	end;
----------------------------------
	['NomiCakes'] = function(self)
		NomiCakesGossipButtonName = _ .. 'TitleButton'
	end;
----------------------------------
	['!KalielsTracker'] = function(self)
		local KTF = _G['!KalielsTrackerFrame']
		L.ToggleIgnoreFrame(KTF, not L('hidetracker'))
		L.options.args.general.args.hide.args.hidetracker.set = function(_, val)
			L.cfg.hidetracker = val 
			L.ToggleIgnoreFrame(ObjectiveTrackerFrame, not val)
			L.ToggleIgnoreFrame(KTF, not val)
		end

		-- this override keeps the tracker from popping back up due to events when faded
		function KTF:SetAlpha(...)
			local newAlpha = ...
			if newAlpha and self.fadeInfo and abs(self:GetAlpha() - newAlpha) > 0.5 then
				return
			end
			getmetatable(self).__index.SetAlpha(self, ...)
		end
	end;
----------------------------------
	['ls_Toasts'] = function(self)
		ls_Toasts[1].RegisterCallback({}, 'ToastCreated', function(_, toast)
			L.ToggleIgnoreFrame(toast, true)
		end)
	end;
----------------------------------
	['DialogKey'] = function(self) -- because dummies can't figure out this is already baked in
		L.Set('enablenumbers', true)
	end;
}