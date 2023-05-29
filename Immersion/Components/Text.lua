local _, L = ...
local Timer, GetTime = CreateFrame('Frame'), GetTime

-- Borrowed fixes from Storyline :)
local LINE_FEED_REPLACE, LINE_BREAK_REPLACE
do  local LINE_FEED, CARRIAGE_RETURN = string.char(10), string.char(13)
	LINE_FEED_REPLACE = LINE_FEED .. '+'
	LINE_BREAK_REPLACE = LINE_FEED .. CARRIAGE_RETURN .. LINE_FEED
end

local TEXT_TIME_DIVISOR -- set later as baseline divisor for (text length / time).
local TEXT_TIME_PADDING = 2 -- static padding, feels more natural with a pause to breathe.
local MAX_UNTIL_SPLIT = 200 -- start recursive string splitting if the text is too long.

Timer.Texts = {}
L.TextMixin = {}

local Text = L.TextMixin

----------------------------------
-- Text: manage text input
----------------------------------
function Text:SetText(text)
	TEXT_TIME_DIVISOR = L('delaydivisor')
	self.lengthText = 2400
	self:PreparePlayback()
	self.storedText = text
	if text then
		local timeToFinish, strings, timers = self:CreateLineData(text)
		self.numTexts = #strings
		self.timeToFinish = timeToFinish
		self.timeStarted = GetTime()
		self:QueueTexts(strings, timers)
	end
end

function Text:ReplaceLinefeed(text)
	return text:gsub(LINE_FEED_REPLACE, '\n'):gsub(LINE_BREAK_REPLACE, '\n')
end

function Text:ReplaceNatural(str)
	local new = str -- substitute natural breaks with newline.
	:gsub('%.%s%.%s%.', '...') 		-- ponder special case
	:gsub('%.%s+', '.\n') 			-- sentence
	:gsub('%.%.%.\n', '...\n...') 	-- ponder
	:gsub('%!%s+', '!\n')			-- exclamation
	:gsub('%?%s+', '?\n') 			-- question
	return new, (new == str) -- return new string, and whether something changed
end

function Text:CreateLineData(text)
	text = self:ReplaceLinefeed(text)
	local timeToFinish, strings, timers = 0, {}, {}
	for _, paragraph in ipairs({strsplit('\n', text)}) do
		timeToFinish = timeToFinish + self:AddString(paragraph, strings, timers)
	end
	return timeToFinish, strings, timers
end

function Text:CalculateLineTime(length)
	return (length / (TEXT_TIME_DIVISOR or 15) ) + TEXT_TIME_PADDING
end

function Text:AddString(str, strings, timers)
	local length, timer, new, forceShow = str:len(), 0
	if length > MAX_UNTIL_SPLIT then
		new, forceShow = self:ReplaceNatural(str)
		--[[ If the string is unchanged, this will recurse infinitely, therefore
			force the long string to be shown. This safeguard is probably meaningless,
			as it requires 200+ chars without any punctuation. ]]
		if not forceShow then -- recursively split the altered string
			for _, sentence in ipairs({strsplit('\n', new)}) do
				timer = timer + self:AddString(sentence, strings, timers)
			end
			return timer
		end
	end
	if ( length ~= 0 or forceShow ) then
		timer = self:CalculateLineTime(length)
		timers[ #strings + 1] = timer
		strings[ #strings + 1 ] = str
	end
	return timer
end


----------------------------------
-- Text: playback
----------------------------------
function Text:QueueTexts(strings, timers)
	assert(strings, 'No strings added to object '.. ( self:GetName() or '<unnamed fontString>' ) )
	assert(timers, 'No timers added to object '.. ( self:GetName() or '<unnamed fontString>' ) )
	self.strings = strings
	self.timers = timers
	Timer:AddText(self)
end

function Text:ForceNext()
	if self:HasLineData() then
		local _, remainingLineTime = self:RemoveLine()
		self.timeToFinish = self.timeToFinish - remainingLineTime
		if self:HasLine() then
			self:SetToCurrentLine()
		else
			self:PauseTimer()
			self:RepeatTexts()
			self:FlagForceFinished(true)
		end
		if not self:HasFollowup() then
			self:OnFinished()
			self:FlagForceFinished(true)
		end
	end
end

function Text:SetToCurrentLine()
	self:DisplayLine(self:GetLine())
end

function Text:SetCurrentLineTime(time)
	self.currentLineTime = time or 0
end

function Text:UpdateCurrentLineTime(delta)
	self.timers[1] = self.timers[1] + delta
end

function Text:RepeatTexts()
	if self.storedText then
		self:SetText(self.storedText)
	end
end

function Text:OnFinished()
	self.strings = nil
	self.timers = nil
end

function Text:FlagForceFinished(state)
	self.forceFinished = state
end

function Text:IsForceFinishedFlagged()
	return self.forceFinished
end

function Text:PreparePlayback()
	self.numTexts = nil
	self:FlagForceFinished(false)
	self:PauseTimer()
	self:OnFinished()
	self:DisplayLine()
end

function Text:ResumeTimer()
	if self:HasLineData() then
		Timer:AddText(self)
		return true
	end
end

function Text:PauseTimer()
	Timer:RemoveText(self)
end

----------------------------------
-- Text: display
----------------------------------
function Text:DisplayLine(text, time)
	if not self:GetFont() then
		self:CheckApplicableFonts()
		self:SetFontObject(self.fontObjectsToTry[1])
	end

	getmetatable(self).__index.SetText(self, text)
	self:SetCurrentLineTime(time)
	self:ApplyFontObjects()

	if self.OnDisplayLineCallback then
		self:OnDisplayLineCallback(text, time)
	end
end

function Text:SetFontObjectsToTry(...)
	self.fontObjectsToTry = { ... }
	if self:GetText() then
		self:ApplyFontObjects()
	end
end

function Text:ApplyFontObjects()
	self:CheckApplicableFonts()

	for i, fontObject in ipairs(self.fontObjectsToTry) do
		self:SetFontObject(fontObject)
		if not self:IsTruncated() then
			break
		end
	end
end

function Text:CheckApplicableFonts()
	if not self.fontObjectsToTry or not self.fontObjectsToTry[1] then
		error('No fonts applied to TextMixin, call SetFontObjectsToTry first')
	end
end

----------------------------------
-- Text: state getters
----------------------------------
function Text:GetTimeRemaining()
	if self.timeStarted and self.timeToFinish then
		local difference = ( self.timeStarted + self.timeToFinish ) - GetTime()
		return difference < 0 and 0 or difference
	end
	return 0
end

function Text:GetProgress()
	local full = self:GetNumTexts()
	local remaining = self:GetNumRemaining()
	return ('%d/%d'):format(full - remaining + 1, full)
end

function Text:GetProgressPercent()
	if self.timeStarted and self.timeToFinish then
		local progress = ( GetTime() - self.timeStarted ) / self.timeToFinish
		return ( progress > 1 ) and 1 or progress
	end
	return 1
end

function Text:GetCurrentProgress()
	local modifiedTime = self:GetModifiedTime()
	local fullTime = self:GetOriginalTime()
	if modifiedTime and fullTime and fullTime > 0 then
		return (1 - modifiedTime / fullTime)
	end
end

function Text:IsFinished() 		return not self.strings end
function Text:IsSequence() 		return self.numTexts and self.numTexts > 1 end
function Text:IsLineFinished() 	return self.timers[1] <= 0 end
function Text:GetNumTexts() 	return self.numTexts or 0 end
function Text:GetNumRemaining() return self.strings and #self.strings or 0 end

function Text:HasLineData() 	return self.strings and self.timers end
function Text:HasLine() 		return self.strings and self.strings[1] and true end
function Text:HasFollowup() 	return self.strings and self.strings[2] and true end

function Text:GetModifiedTime() return self.timers and self.timers[1] end
function Text:GetOriginalTime()	return self.currentLineTime or 0 end
function Text:GetLineProgress() return (self.timers and self.currentLineTime) and (self.timers[1]/self.currentLineTime) or 1 end

function Text:GetLine() 		return self.strings[1], self.timers[1] end
function Text:RemoveLine() 		return tremove(self.strings, 1), tremove(self.timers, 1) end

----------------------------------
-- Timer handle
----------------------------------
function Timer:AddText(fontString)
	if fontString then
		self.Texts[fontString] = true
		self:SetScript('OnUpdate', self.OnUpdate)
	end
end

function Timer:GetTexts() return pairs(self.Texts) end

function Timer:RemoveText(fontString)
	if fontString then
		self.Texts[fontString] = nil
	end
end

function Timer:OnTextFinished(fontString)
	if fontString then
		self:RemoveText(fontString)
		if fontString.OnFinishedCallback then
			fontString:OnFinishedCallback()
		end
	end
end

function Timer:OnUpdate(elapsed)
	for text in self:GetTexts() do
		if text:HasLine() then
			-- if there's no text displayed, display the current line.
			if not text:GetText() then
				text:SetToCurrentLine()
			end
			-- deduct elapsed time since update from current timer
			text:UpdateCurrentLineTime(-elapsed)
			-- timer is below/equal to zero, move on to next line
			if text:IsLineFinished() then
				text:RemoveLine()
				-- check if there's another line waiting
				if text:HasLine() then
					text:SetToCurrentLine()
				else
					text:OnFinished()
				end
			end
		else
			self:OnTextFinished(text)
		end
	end
	if not next(self.Texts) then
		self:SetScript('OnUpdate', nil)
	end
end