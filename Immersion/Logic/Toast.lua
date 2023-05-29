local _, L = ...
local NPC, Text = ImmersionFrame, ImmersionFrame.TalkBox.TextFrame.Text
local API = ImmersionAPI;
----------------------------------
local playbackQueue, questCache = {}, {}
local QUEST_TOAST_CACHE_LIMIT = 30
----------------------------------

local function IsTextCached(text, tbl)
	for i, toast in ipairs(tbl) do
		if toast.text == text then
			return i
		end
	end
end

local function IsFrameReady()
	local event = NPC.lastEvent or ''
	local notInGossip = event:match('GOSSIP') and not UnitExists('npc')
	local notInQuest = NPC:IsObstructingQuestEvent(event) and NPC:IsNotQuestDisplayed(event)
	local notInObjectOrItem = NPC:IsNPCObjectOrItem(notInGossip, notInQuest)
	return notInGossip or notInQuest or notInObjectOrItem
end

local function CanToastPlay()
	return IsFrameReady() and #playbackQueue > 0
end

local function PopToast(i)
	local toast = tremove(playbackQueue, i)
	if ( toast and toast.questID ~= 0 and not IsTextCached(toast.text, questCache) ) then
		tinsert(questCache, 1, toast)
		questCache[QUEST_TOAST_CACHE_LIMIT] = nil
	end
end

local function RemoveToastByKey(key, value)
	local i = 1
	while playbackQueue[i] do
		if playbackQueue[i][key] == value then
			PopToast(i)
		else
			i = i + 1
		end
	end
end

local function PlayToast(toast)
	NPC:PlayIntro('IMMERSION_TOAST', true)
	NPC:UpdateTalkingHead(toast.title, toast.text, toast.purpose, toast.display, true)
end

local function QueueToast(tbl, title, text, purpose, unit)
	if not IsTextCached(text, tbl) then
		tinsert(tbl, {
			title 	= title;
			text 	= text;
			purpose = purpose;
			questID = API:GetQuestID();
			youSaid = L.ClickedTitleCache or {};
			display = API:GetCreatureID(unit);
		})
	end
end

----------------------------------

function NPC:PlaySuperTrackedQuestToast(questID)
	for i, toast in ipairs(questCache) do
		if ( toast.questID == questID ) and
			---------------------------------- 
			IsFrameReady() and
			not IsOptionFrameOpen() and
			not self:IsToastObstructed() then
			----------------------------------
			PlayToast(tremove(questCache, i))
			break
		end
	end
end

function NPC:PlayToasts(obstructingFrameOpen)
	if CanToastPlay() and not obstructingFrameOpen and not self:IsToastObstructed() then
		local toast = playbackQueue[1]
		if toast then
			PlayToast(toast)
		end
	end
end

function NPC:QueueToast(...)
	QueueToast(playbackQueue, ...)
end

function NPC:QueueQuestToast(...)
	QueueToast(questCache, ...)
end

function NPC:RemoveToastByText(text)
	RemoveToastByKey('text', text)
	if CanToastPlay() then
		self:PlayToasts()
	elseif IsFrameReady() then
		self:PlayOutro()
	end
end

function NPC:ClearToasts()
	for i=1, #playbackQueue do
		PopToast(1)
	end
end

----------------------------------

do	-- OBSTRUCTION:
	-- The toast should not play text while *obstructing* frames are showing.
	-- The user should be limited to one focal point at a time, so the case where
	-- multiple frames are playing text at the same time must be handled.
	local obstructorsShowing = 0
	local function ObstructorOnShow()
		obstructorsShowing = obstructorsShowing + 1
		if ( obstructorsShowing > 0 ) and ( NPC.playbackEvent == 'IMMERSION_TOAST' ) then
			NPC:PlayOutro(true)
			Text:PauseTimer()
		end
	end

	local function ObstructorOnHide()
		obstructorsShowing = obstructorsShowing - 1
		if ( obstructorsShowing < 1 ) and ( NPC.playbackEvent == 'IMMERSION_TOAST' ) then
			NPC:PlayToasts()
		end
	end

	local function AddToastObstructor(frame)
		-- assert(C_Widget.IsFrameWidget(frame), 'ImmersionToast:AddObstructor(frame): invalid frame widget')
		frame:HookScript('OnShow', ObstructorOnShow)
		frame:HookScript('OnHide', ObstructorOnHide)

		obstructorsShowing = obstructorsShowing + (frame:IsVisible() and 1 or 0)
	end

	function NPC:IsToastObstructed()
		return obstructorsShowing > 0
	end

	-- Force base frames and TalkingHeadFrame.
	if LevelUpDisplay then AddToastObstructor(LevelUpDisplay) end
	if AlertFrame then AddToastObstructor(AlertFrame) end
end

function NPC:IsToastDone()
	return #playbackQueue
end


--[[ Keep in case of reimplementing this functionality

function Toast:DisplayClickableQuest(questID)
	local hasQuestID 	= ( questID and questID ~= 0)
	local logIndex 		= ( hasQuestID and GetQuestLogIndexByID(questID) )
	local isQuestActive = ( logIndex and logIndex ~= 0 )
	local isQuestTurnIn = ( hasQuestID and IsQuestComplete(questID) )
	local isQuestCompleted = ( hasQuestID and IsQuestFlaggedCompleted(questID) )

	if hasQuestID then
		self.Subtitle:SetVertexColor(1, .82, 0)
		self.ToastType:SetTexture(nil)
	else
		self.Subtitle:SetVertexColor(.75, .75, .75)
	end

	self.logIndex = nil
	self.questID = nil
	self.QuestButton:Hide()

	if isQuestTurnIn or isQuestActive then
		self.logIndex = logIndex
		self.questID = questID
		self.CacheType:SetTexture(nil)
		self.QuestButton:Show()
	elseif isQuestCompleted then
		self.CacheType:SetTexture('Interface\\GossipFrame\\BankerGossipIcon')
	elseif hasQuestID then
		self.CacheType:SetTexture('Interface\\GossipFrame\\AvailableQuestIcon')
	end
end

-- Show quest details if available.
function Toast:OnQuestButtonClicked()
	if self.logIndex and self.questID then
		SetSuperTrackedQuestID(self.questID)
	end
end

local QUEST_ICONS
do 	local QUEST_ICONS_FILE = 'Interface\\QuestFrame\\QuestTypeIcons'
	local QUEST_ICONS_FILE_WIDTH = 128
	local QUEST_ICONS_FILE_HEIGHT = 64
	local QUEST_ICON_SIZE = 18

	local function CreateQuestIconTextureMarkup(left, right, top, bottom)
		return CreateTextureMarkup(
			QUEST_ICONS_FILE, 
			QUEST_ICONS_FILE_WIDTH, 
			QUEST_ICONS_FILE_HEIGHT, 
			QUEST_ICON_SIZE, QUEST_ICON_SIZE, 
			left / QUEST_ICONS_FILE_WIDTH,
			right / QUEST_ICONS_FILE_WIDTH,
			top / QUEST_ICONS_FILE_HEIGHT,
			bottom / QUEST_ICONS_FILE_HEIGHT) .. ' '
	end

	QUEST_ICONS = {
		item 	= CreateQuestIconTextureMarkup(18, 36, 36, 54);
		object 	= CreateQuestIconTextureMarkup(72, 90,  0, 18);
		event 	= CreateQuestIconTextureMarkup(36, 54, 18, 36);
		monster = CreateQuestIconTextureMarkup(0,  18, 36, 54);
	--	reputation = CreateQuestIconTextureMarkup();
	--	log = CreateQuestIconTextureMarkup();
	-- 	player = CreateQuestIconTextureMarkup();
	}
end

function Toast:OnQuestButtonMouseover()
	if self.questID then
		local logIndex = GetQuestLogIndexByID(self.questID)
		if logIndex then
			local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID = GetQuestLogTitle(logIndex)

			GameTooltip:SetOwner(self.QuestButton, 'ANCHOR_TOPLEFT')
			GameTooltip:AddLine(title)

			if isComplete and isComplete > 0 then
				local completionText = GetQuestLogCompletionText(logIndex) or QUEST_WATCH_QUEST_READY
				GameTooltip:AddLine(completionText, 1, 1, 1, true)
			else
				local _, objectiveText = GetQuestLogQuestText(logIndex)
				GameTooltip:AddLine(objectiveText, 1, 1, 1, true)

				local requiredMoney = GetQuestLogRequiredMoney(logIndex)
				local numObjectives = GetNumQuestLeaderBoards(logIndex)

				if numObjectives > 0 then
					GameTooltip:AddLine(' ')
				end

				for i = 1, numObjectives do
					local text, objectiveType, finished = GetQuestLogLeaderBoard(i, logIndex)
					if text then
						local color = HIGHLIGHT_FONT_COLOR
						local marker = QUEST_ICONS[objectiveType] or QUEST_DASH
						if finished then
							color = GRAY_FONT_COLOR
						end
						GameTooltip:AddLine(marker..text, color.r, color.g, color.b, true)
					end
				end
				if 	requiredMoney > 0 then
					local playerMoney = GetMoney()
					local color = HIGHLIGHT_FONT_COLOR
					if 	requiredMoney <= playerMoney then
						playerMoney = requiredMoney
						color = GRAY_FONT_COLOR
					end
					GameTooltip:AddLine(QUEST_DASH..GetMoneyString(playerMoney)..' / '..GetMoneyString(requiredMoney), color.r, color.g, color.b)
				end
				GameTooltip:Show()
			end
		end
	end
end
]]--
