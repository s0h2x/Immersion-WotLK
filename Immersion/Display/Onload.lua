local _, L = ...
local frame = _G[ _ .. 'Frame' ]
local talkbox = frame.TalkBox
local titles = frame.TitleButtons
local inspector = frame.Inspector
local elements = talkbox.Elements
L.frame = frame

----------------------------------
-- Prepare propagation, so that we
-- can catch certain key strokes
-- but propagate the event otherwise.
----------------------------------
-- frame:SetPropagateKeyboardInput(true)

----------------------------------
-- In the case of hide UI option,
-- frames needs to ignore the
-- alpha change of UIParent.
----------------------------------
frame:SetIgnoreParentAlpha(true)
inspector:SetIgnoreParentAlpha(true)

----------------------------------
-- Register events for main frame
----------------------------------
for _, event in pairs({
	'ADDON_LOADED',
--	'ITEM_TEXT_BEGIN', 	-- Starting to read a book
--	'ITEM_TEXT_READY', 	-- New book text is ready
--	'ITEM_TEXT_CLOSED', -- Stop reading a book
	'GOSSIP_CLOSED',	-- Close gossip frame
	'GOSSIP_SHOW',		-- Show gossip options, can be a mix of gossip/quests
	'QUEST_ACCEPTED', 	-- Use this event for on-the-fly quest text tracking.
	'QUEST_COMPLETE',	-- Quest completed
	'QUEST_DETAIL',		-- Quest details/objectives/accept frame
	'QUEST_FINISHED',	-- Fires when quest frame is closed
	'QUEST_GREETING',	-- Multiple quests to choose from, but no gossip options
--	'QUEST_IGNORED',	-- Ignore the currently shown quest
	'QUEST_PROGRESS',	-- Fires when you click on a quest you're currently on
	'QUEST_ITEM_UPDATE', -- Item update while in convo, refresh frames.
--	'MERCHANT_SHOW', 	-- Force close gossip on merchant interaction.
--	'NAME_PLATE_UNIT_ADDED', 	-- For nameplate mode
--	'NAME_PLATE_UNIT_REMOVED', 	-- For nameplate mode
--	ImmersionAPI.IsRetail and 'SUPER_TRACKING_CHANGED',
--	ImmersionAPI.IsWoW10 and 'PLAYER_INTERACTION_MANAGER_FRAME_SHOW',
}) do if event then
		frame:RegisterEvent(event)
	end
end


frame.IgnoreResetEvent = {
	QUEST_ACCEPTED = true,
--	NAME_PLATE_UNIT_ADDED = true,
--	NAME_PLATE_UNIT_REMOVED = true,
--	SUPER_TRACKING_CHANGED = true,
}

frame.IgnoreGossipEvent = {
	GOSSIP_SHOW = true,
	GOSSIP_CLOSED = true,
	QUEST_ACCEPTED = true,
--	NAME_PLATE_UNIT_ADDED = true,
--	NAME_PLATE_UNIT_REMOVED = true,
--	SUPER_TRACKING_CHANGED = true,
}

----------------------------------
-- Register events for titlebuttons
----------------------------------
for _, event in pairs({
	'GOSSIP_CLOSED',	-- Hide buttons
	'GOSSIP_SHOW',		-- Show gossip options, can be a mix of gossip/quests
	'QUEST_COMPLETE',	-- Hide when going from gossip -> complete
	'QUEST_DETAIL',		-- Hide when going from gossip -> detail
	'QUEST_FINISHED',	-- Hide when going from gossip -> finished 
	'QUEST_GREETING',	-- Show quest options, why is this a thing again?
--	'QUEST_IGNORED',	-- Hide when using ignore binding?
	'QUEST_PROGRESS',	-- Hide when going from gossip -> active quest
--	'QUEST_LOG_UPDATE',	-- If quest changes while interacting
	'UNIT_QUEST_LOG_CHANGED',
}) do titles:RegisterEvent(event) end

----------------------------------
-- Load SavedVaribles, config and compat
----------------------------------
function frame:ADDON_LOADED(name)
	if name == _ then
		local svref = _ .. 'Setup'
		L.cfg = _G[svref] or L.GetDefaultConfig()
		_G[svref] = L.cfg

		-- Set module scales
		talkbox:SetScale(L('boxscale'))
		titles:SetScale(L('titlescale'))
		elements:SetScale(L('elementscale'))
		self:SetScale(L('scale'))

		-- Set the module points
		talkbox:SetPoint(L('boxpoint'), UIParent, L('boxoffsetX'), L('boxoffsetY'))
		titles:SetPoint('CENTER', UIParent, 'CENTER', L('titleoffset'), L('titleoffsetY'))

		self:SetFrameStrata(L('strata'))
		talkbox:SetFrameStrata(L('strata'))

		-- If previous version and flyins were disabled, set anidivisor to instant
		if L.cfg.disableflyin then
			L.cfg.disableflyin = nil
			L.cfg.anidivisor = 1
		end

		-- Hide portrait 
		talkbox.PortraitFrame:SetShown(not L('disableportrait'))
		talkbox.MainFrame.Model.PortraitBG:SetShown(not L('disableportrait'))

		-- Show solid background
		talkbox.BackgroundFrame.SolidBackground:SetShown(L('solidbackground'))
		L.SetBackdrop(elements, L('solidbackground') and L.Backdrops.TALKBOX_SOLID or L.Backdrops.TALKBOX)

		-- Set frame ignore for hideUI features on load.
		L.ToggleIgnoreFrame(Minimap, not L('hideminimap'))
		L.ToggleIgnoreFrame(MinimapCluster, not L('hideminimap'))
		L.ToggleIgnoreFrame(WatchFrame, not L('hidetracker'))
        
        -- Check confing for frame item text
        self:UpdateItemTextFrame()

		-- Register options table
		LibStub('AceConfigRegistry-3.0'):RegisterOptionsTable(_, L.options)
		L.config = LibStub('AceConfigDialog-3.0'):AddToBlizOptions(_)

		-- Slash handler
		_G['SLASH_' .. _:upper() .. '1'] = '/' .. _:lower()
		SlashCmdList[_:upper()] = function() LibStub('AceConfigDialog-3.0'):Open(_) end

		-- Add some sexiness to the config frame.
		local logo = CreateFrame('Frame', nil, L.config)
		logo:SetFrameLevel(4)
		logo:SetSize(64, 64)
		logo:SetPoint('TOPRIGHT', 8, 24)
		L.SetBackdrop(logo, {bgFile = ('Interface\\AddOns\\%s\\Textures\\Logo'):format(_)})
		L.config.logo = logo
	end
	
	-- Immersion is loaded, no more addons to track. Garbage collect this function.
	if IsAddOnLoaded(_) then
		self:UnregisterEvent('ADDON_LOADED')
		self.ADDON_LOADED = nil
	end
end

-- Update parent for ignoring frames
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
function frame:PLAYER_ENTERING_WORLD()
	self.ignoreParent:SetPoint('CENTER', UIParent, 'CENTER')
	self.ignoreParent:SetFrameLevel(UIParent:GetFrameLevel())
	self.ignoreParent:SetScale(UIParent:GetEffectiveScale())
end

-- Set backdrops on elements
L.SetBackdrop(talkbox.Hilite, L.Backdrops.TALKBOX_HILITE)

-- Initiate titlebuttons
L.Mixin(titles, L.TitlesMixin)

-- Initiate elements
L.Mixin(elements, L.ElementsMixin)

----------------------------------
-- Set up dynamically sized frames
----------------------------------
do
	local AdjustToChildren = L.AdjustToChildren
	L.Mixin(elements, AdjustToChildren)
	L.Mixin(elements.Content, AdjustToChildren)
	L.Mixin(elements.Progress, AdjustToChildren)
	L.Mixin(elements.Content.RewardsFrame, AdjustToChildren)
	L.Mixin(inspector, AdjustToChildren)
	L.Mixin(inspector.Extras, AdjustToChildren)
	L.Mixin(inspector.Choices, AdjustToChildren)
end

-- Set point since the relative region didn't exist on load.
local name = talkbox.NameFrame.Name
name:SetPoint('TOPLEFT', talkbox.PortraitFrame.Portrait, 'TOPRIGHT', 2, -19)

----------------------------------
-- Model script, light
----------------------------------
local model = talkbox.MainFrame.Model
--L.SetLight(model, true, L.ModelMixin.LightValues)
L.Mixin(model, L.ModelMixin)
L.MixinNormal(model, UtilMixin)

----------------------------------
-- Main text things
----------------------------------
local text = talkbox.TextFrame.Text
L.MixinNormal(text, L.TextMixin) -- see Mixins\Text.lua
-- Set array of fonts so the fontstring can be as big as possible without truncating the text
text:SetFontObjectsToTry(SystemFont_Shadow_Large, SystemFont_Shadow_Med2, SystemFont_Shadow_Med1)

-- Run a 'talk' animation on the portrait model whenever a new text is set
function text:OnDisplayLineCallback(text)
	local counter = talkbox.TextFrame.SpeechProgress
	talkbox.TextFrame.Text.FadeIn:Stop()
	talkbox.TextFrame.Text.FadeIn:Play()
	counter.FadeIn:Stop()
	counter.FadeIn:Play()
	if text then
		local isEmote = text:match('%b<>')
		self:SetVertexColor(1, isEmote and 0.5 or 1, isEmote and 0 or 1)
		model:PrepareAnimation(text, isEmote)
		model:RunSequence(self:GetModifiedTime(), self:IsSequence())
	end
	
	counter:Hide()
	if self:IsSequence() then
		if not self:IsFinished() then
			counter:Show()
			counter:SetText(self:GetProgress())
		end
	end

	if self:IsVisible() then
		if L('disableprogression') then
			self:PauseTimer()
		end
	end
end

function text:OnFinishedCallback()
	-- remove the last playback line, because the text played until completion.
	if L('onthefly') and not self:IsForceFinishedFlagged() then
		frame:RemoveToastByText(self.storedText)
	end
end

----------------------------------
-- Misc fixes
----------------------------------
talkbox:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
talkbox:RegisterForDrag('LeftButton')
talkbox.TextFrame.SpeechProgress:SetFont('Fonts\\MORPHEUS.ttf', 16, '')
talkbox.TextFrame.SpeechProgress:SetShadowColor(0, 0, 0, 1)
talkbox.TextFrame.SpeechProgress:SetShadowOffset(0, -1)

----------------------------------
-- Set movable frames
----------------------------------
talkbox:SetMovable(true)
talkbox:SetUserPlaced(false)
talkbox:SetClampedToScreen(true)

titles:SetMovable(true)
titles:SetUserPlaced(false)

--------------------------------
-- Hooks and hacks
--------------------------------

-- Hide regular frames
L.HideFrame(GossipFrame)
L.HideFrame(QuestFrame)

local function SetFrameToEvent(frame1, frame2)
	for _, event in pairs({
		'ITEM_TEXT_BEGIN', 	-- Starting to read a book
		'ITEM_TEXT_READY', 	-- New book text is ready
		'ITEM_TEXT_CLOSED', -- Stop reading a book
	}) do if event then
			frame1:RegisterEvent(event)
			if frame2 then
				frame2:UnregisterEvent(event)
			end
		end
	end
end

function frame:UpdateItemTextFrame()
	if L('bookreading') then
		L.HideFrame(ItemTextFrame)
		SetFrameToEvent(frame)
	else
		SetFrameToEvent(ItemTextFrame, frame)
		ItemTextFrame:SetParent(UIParent)
	end
end

-- Handle custom gossip events (new in Shadowlands)
frame.gossipHandlers = CustomGossipFrameManager and CustomGossipFrameManager.handlers or {};