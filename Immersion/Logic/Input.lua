local API, NPC, _, L = ImmersionAPI, ImmersionFrame, ...;

L.Inputs = {
	accept = function(self)
		local text = self.TalkBox.TextFrame.Text
		local numActive = self.TitleButtons:GetNumActive()
		if ( not self:IsModifierDown() and text:GetNumRemaining() > 1 and text:IsSequence() ) then
			text:ForceNext()
		elseif ( self.lastEvent == 'GOSSIP_SHOW' and numActive < 1 ) then
			API:CloseGossip()
		elseif ( self.lastEvent == 'GOSSIP_SHOW' and numActive == 1 ) then
			API:SelectGossipOption(1)
		elseif ( numActive > 1 ) then
			self:SelectBestOption()
		else
			self.TalkBox:OnLeftClick()
		end
	end,
	reset = function(self)
		self.TalkBox.TextFrame.Text:RepeatTexts()
	end,
	goodbye = function(self)
		API:CloseGossip()
		API:CloseQuest()
	end,
	number = function(self, id)
		if self.hasItems then
			local choiceIterator = 0
			for _, item in ipairs(self.TalkBox.Elements.Content.RewardsFrame.Buttons) do
				if item:IsVisible() and item.type == 'choice' then
					choiceIterator = choiceIterator + 1
					if choiceIterator == id then
						item:Click()
						return
					end
				end
			end
		else
			local button = self.TitleButtons.Buttons[id]
			if button then
				button.Hilite:SetAlpha(1)
				button:Click()
				button:OnLeave()
				PlaySound(EnumConst.SOUNDKIT.IG_QUEST_LIST_SELECT)
			end
		end
	end,
}

L.ModifierStates = {
	SHIFT 	= IsShiftKeyDown;
	CTRL 	= IsControlKeyDown;
	ALT 	= IsAltKeyDown;
	NOMOD 	= function() return false end;
}

L.States = {
	'',
	'CTRL-',
	'SHIFT-',
	'ALT-',
	'CTRL-SHIFT-',
	'ALT-SHIFT-',
	'ALT-CTRL-',
	'CTRL-ALT-SHIFT-'
}

L.Numbers = {
	['1'] = L.States,
	['2'] = L.States,
	['3'] = L.States,
	['4'] = L.States,
	['5'] = L.States,
	['6'] = L.States,
	['7'] = L.States,
	['8'] = L.States,
	['9'] = L.States,
}