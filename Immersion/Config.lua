local _, L = ...

function L.GetListString(...)
	local ret = ''
	local strings = {...}
	local num = #strings
	for i, str in pairs(strings) do
		ret = ret .. '• ' .. str .. (i == num and '' or '\n')
	end
	return ret
end

function L.ValidateKey(key)
	return ( key and ( not key:lower():match('button') ) ) and key
end

function L.GetDefaultConfig()
	local t = {}
	for k, v in pairs(L.defaults) do
		t[k] = v
	end
	return t
end

function L.Get(key)
	if L.cfg and L.cfg[key] ~= nil then
		return L.cfg[key]
	else
		return L.defaults[key]
	end
end

function L.Set(key, val)
	L.cfg = L.cfg or {}
	L.cfg[key] = val
end

function L.GetFromSV(tbl)
	local id = tbl[#tbl]
	return ( L.cfg and L.cfg[id])
end

function L.GetFromDefaultOrSV(tbl)
	local id = tbl[#tbl]
	return ( L.cfg and L.cfg[id]) or L.defaults[id]
end


setmetatable(L, {
	__call = function(self, input, newValue)
		return L.Get(input) or self[input]
	end,
})


----------------------------------
-- Default config
----------------------------------

L.defaults = {
----------------------------------
	scale = 1,
	strata = 'MEDIUM',
	hideui = false,
--	theme = 'DEFAULT',

	titlescale = 1,
	titleoffset = 500,
	titleoffsetY = 0,

	elementscale = 1,

	boxscale = 1,
	boxoffsetX = 0,
	boxoffsetY = 150,
	boxlock = true,
	boxpoint = 'Bottom',
	
	camerarotationenabled = false,
	hdmodels = false,
	bookreading = true,
	
	gossipmode = false,
    debuginfo = false,

	disableprogression = false,
	flipshortcuts = false,
	delaydivisor = 15,
	anidivisor = 5,

	inspect = 'SHIFT',
	accept = 'SPACE',
	reset = 'BACKSPACE',
}---------------------------------

local stratas = {
	LOW 		= L['Low'],
	MEDIUM 		= L['Medium'],
	HIGH 		= L['High'],
	DIALOG		= L['Dialog'],
	FULLSCREEN 	= L['Fullscreen'],
	FULLSCREEN_DIALOG = L['Fullscreen dialog'],
	TOOLTIP 	= L['Tooltip'],
}

local modifiers = {
	SHIFT 	= SHIFT_KEY_TEXT,
	CTRL 	= CTRL_KEY_TEXT,
	ALT 	= ALT_KEY_TEXT,
	NOMOD 	= NONE,
}
--[[
local themes = {
	DEFAULT 	= DEFAULT;
	ALLIANCE 	= ALLIANCE_CHEER;
	HORDE 		= HORDE_CHEER;
	NEUTRAL		= BUG_CATEGORY8;
}]]

local titleanis = {
	[0]  = OFF,
	[1]  = SPELL_CAST_TIME_INSTANT,
	[5]  = FAST,
	[10] = SLOW,
}

L.options = {
	type = 'group',
	args = {		
		general = {
			type = 'group',
			name = GENERAL,
			order = 1,
			args = {
				framelock = {
					type = 'group',
					name = LOCK_FOCUS_FRAME,
					inline = true,
					order = 0,
					args = {
						boxlock = {
							type = 'toggle',
							name = MODEL .. ' / ',
							get = L.GetFromSV,
							set = function(_, val) L.cfg.boxlock = val end,
							order = 0,
						},
						titlelock = {
							type = 'toggle',
							name = QUESTS_LABEL .. ' / ' .. GOSSIP_OPTIONS,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.titlelock = val end,
							order = 1,
						},
					},
				},
				text = {
					type = 'group',
					name = L['Behavior'],
					inline = true,
					order = 1,
					args = {
						delaydivisor = {
						type = 'range',
						name = 'Text speed',
						desc = L['Change the speed of text delivery.'] .. '\n\n' ..
							MINIMUM .. '\n"' ..  L['How are you doing today?'] .. '"\n  -> ' .. 
							format(D_SECONDS, (strlen(L['How are you doing today?']) / 5) + 2)  .. '\n\n' .. 
							MAXIMUM .. '\n"' .. L['How are you doing today?'] .. '"\n  -> ' .. 
							format(D_SECONDS, (strlen(L['How are you doing today?']) / 40) + 2),
						min = 5,
						max = 40,
						step = 5,
						order = 1,
						get = L.GetFromDefaultOrSV,
						set = function(self, val) 
							L.cfg.delaydivisor = val
						end,
						},
						disableprogression = {
							type = 'toggle',
							name = L['Disable automatic text progress'],
							desc = L['Stop NPCs from automatically proceeding to the next line of dialogue.'],
							order = 2,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.disableprogression = val end,
						},
						showprogressbar = {
							type = 'toggle',
							name = L['Show text progress bar'],
							order = 4,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.showprogressbar = val end,
							disabled = function() return L('disableprogression') end,
						},
						mouseheader = {
							type = 'header',
							name = MOUSE_LABEL,
							order = 5,
						},
						flipshortcuts = {
							type = 'toggle',
							name = L['Flip mouse functions'],
							desc = L.GetListString(
								L['Left click is used to handle text.'], 
								L['Right click is used to accept/hand in quests.']),
							order = 6,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.flipshortcuts = val end,
							disabled = function() return ConsolePort end,
						},
						immersivemode = {
							type = 'toggle',
							name = L['Immersive mode'],
							desc = L['Use your primary mouse button to read through text, accept/turn in quests and select the best available gossip option.'],
							order = 7,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.immersivemode = val end,
							disabled = function() return ConsolePort end,
						},
					},
				},
				hide = {
					type = 'group',
					name = L['Hide interface'],
					inline = true,
					order = 2,
					args = {
						hideui = {
							type = 'toggle',
							name = L['Hide interface'],
							desc = L['Hide my user interface when interacting with an NPC.'],
							order = 0,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.hideui = val end,
						},
						hideminimap = {
							type = 'toggle',
							name = L['Hide minimap'],
							disabled = function() return not L('hideui') end,
							order = 1,
							get = L.GetFromSV,
							set = function(_, val) 
								L.cfg.hideminimap = val
								L.ToggleIgnoreFrame(Minimap, not val)
								L.ToggleIgnoreFrame(MinimapCluster, not val)
							end,
						},
						hidetracker = {
							type = 'toggle',
							name = L['Hide objective tracker'],
							disabled = function() return not L('hideui') end,
							order = 2,
							get = L.GetFromSV,
							set = function(_, val) 
								L.cfg.hidetracker = val 
								L.ToggleIgnoreFrame(WatchFrame, not val)
							end,
						},
						hidetooltip = {
							type = 'toggle',
							name = L['Hide tooltip'],
							disabled = function() return not L('hideui') end,
							order = 3,
							get = L.GetFromSV,
							set = function(_, val)
								L.cfg.hidetooltip = val
							end,
						},
						camerarotationenabled = {
							type = 'toggle',
							name = BINDING_NAME_SWINGCAMERA,
							disabled = function() return not L('hideui') end,
							order = 4,
							get = L.GetFromSV,
							set = function(_, val)
								L.cfg.camerarotationenabled = val
							end,
						},
					},
				},
				ontheflybox = {
					type = 'group',
					name = PLAYBACK,
					inline = true,
					order = 3,
					args = {
						onthefly = {
							type = 'toggle',
							name = QUICKBUTTON_NAME_EVERYTHING,
							order = 0,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.onthefly = val end,
						},
						ontheflydesc = {
							type = 'description',
							fontSize = 'medium',
							order = 1,
							name = L["The quest/gossip text doesn't vanish when you stop interacting with the NPC or when accepting a new quest. Instead, it vanishes at the end of the text sequence. This allows you to maintain your immersive experience when speed leveling."],
						},
						gossipmode = {
							type = 'toggle',
							name = L['Every interaction'],
							order = 2,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.gossipmode = val end,
						},
						gossipmodedesc = {
							type = 'description',
							fontSize = 'medium',
							order = 3,
							name = L['Show every time when you interacting with the NPC, if disabled and there is only non-gossip option then go to it directly.'],
						},
						-- supertracked = {
							-- type = 'toggle',
							-- name = OBJECTIVES_TRACKER_LABEL,
							-- order = 2,
							-- get = L.GetFromSV,
							-- set = function(_, val) L.cfg.supertracked = val end,
						-- },
						-- supertrackeddesc = {
							-- type = 'description',
							-- fontSize = 'medium',
							-- order = 3,
							-- name = L["When a quest is supertracked (clicked on in the objective tracker, or set automatically by proximity), the quest text will play if nothing else is obstructing it."],
						-- },
					},
				},
				onhdmodels = {
					type = 'group',
					name = L['HD Models'],
					inline = true,
					order = 4,
					args = {
						hdmodels = {
							type = 'toggle',
							name = L['HD Models'],
							order = 0,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.hdmodels = val end,
						},
						hdmodelsdesc = {
							type = 'description',
							fontSize = 'medium',
							name = L['Support for correct adjustment of portrait models and animations if player uses patches of HD models'],
						},
					},
				},
				debugmode = {
					type = 'group',
					name = 'Debug',
					inline = true,
					order = 5,
					args = {
						debuginfo = {
							type = 'toggle',
							name = 'Debug mode',
							order = 0,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.debuginfo = val end,
						},
					},
				},
				-- talkinghead = {
					-- type = 'group',
					-- name = L['Hook talking head'],
					-- inline = true,
					-- order = 5,
					-- args = {
						-- movetalkinghead = {
							-- type = 'toggle',
							-- name = VIDEO_OPTIONS_ENABLED,
							-- order = 0,
							-- get = L.GetFromSV,
							-- set = function(_, val) L.cfg.movetalkinghead = val end,
						-- },
						-- movetalkingheaddesc = {
							-- type = 'description',
							-- fontSize = 'medium',
							-- name = L["The regular talking head frame appears in the same place as Immersion when you're not interacting with anything and on top of Immersion if they are visible at the same time."],
						-- },
					-- },
				-- },
			},
		},
		keybindings = {
			type = 'group',
			name = KEY_BINDINGS,
			order = 2,
			disabled = function() return ConsolePort end,
			args = {
				header = {
					type = 'header',
					name = KEY_BINDINGS,
					order = 0,
				},
				accept = {
					type = 'keybinding',
					name = ACCEPT,
					desc = L.GetListString(ACCEPT, NEXT, CONTINUE, COMPLETE_QUEST, SPELL_CAST_TIME_INSTANT .. ': ' .. modifiers[L('inspect')]),
					get = L.GetFromSV,
					set = function(_, val) L.cfg.accept = L.ValidateKey(val) end,
					order = 1,
				},
				reset = {
					type = 'keybinding',
					name = RESET,
					get = L.GetFromSV,
					set = function(_, val) L.cfg.reset = L.ValidateKey(val) end,
					order = 4,
				},
				goodbye = {
					type = 'keybinding',
					name = GOODBYE .. '/' .. CLOSE .. ' (' .. KEY_ESCAPE .. ')',
					desc = L.GetListString(QUESTS_LABEL, GOSSIP_OPTIONS),
					get = L.GetFromSV,
					set = function(_, val) L.cfg.goodbye = L.ValidateKey(val) end,
					order = 2,
				},
				enablenumbers = {
					type = 'toggle',
					name = '[1-9] ' .. PET_BATTLE_SELECT_AN_ACTION, -- lol
					desc = L.GetListString(QUESTS_LABEL, GOSSIP_OPTIONS),
					get = L.GetFromSV,
					set = function(_, val) L.cfg.enablenumbers = val end,
					order = 5,
				},
			},
		},
		display = {
			type = 'group',
			name = DISPLAY,
			order = 3,
			args = {
				anidivisor = {
					type = 'select',
					name = L['Dynamic offset'],
					order = 0,
					values = titleanis,
					get = L.GetFromDefaultOrSV,
					set = function(_, val) L.cfg.anidivisor = val end,
					style = 'dropdown',
				},
				strata = {
					type = 'select',
					name = L['Frame strata'],
					order = 1,
					values = stratas,
					get = L.GetFromDefaultOrSV,
					set = function(_, val) local f = L.frame
						L.cfg.strata = val
						f:SetFrameStrata(val)
						f.TalkBox:SetFrameStrata(val)
					end,
					style = 'dropdown',
				},
				scale = {
					type = 'range',
					name = L['Global scale'],
					min = 0.5,
					max = 1.5,
					step = 0.1,
					order = 2,
					get = L.GetFromDefaultOrSV,
					set = function(self, val) 
						L.cfg.scale = val
						L.frame:SetScale(val)
					end,
				},
				header = {
					type = 'header',
					name = DISPLAY,
					order = 4,
				},
				description = {
					type = 'description',
					fontSize = 'medium',
					order = 5,
					name = L.GetListString(
								MODEL ..' / '..': '..L['Customize the talking head frame.'],
								QUESTS_LABEL..' / '..GOSSIP_OPTIONS..': '..L['Change the placement and scale of your dialogue options.']) .. '\n',
				},
				box = {
					type = 'group',
					name = MODEL .. ' / ',
					inline = true,
					order = 6,
					args = {
						solidbackground = {
							type = 'toggle',
							name = L['Solid background'],
							order = 0,
							get = L.GetFromSV,
							set = function(_, val) 
								L.cfg.solidbackground = val
								L.frame.TalkBox.BackgroundFrame.SolidBackground:SetShown(val)
								L.frame.TalkBox.Elements:SetBackdrop(val and L.Backdrops.TALKBOX_SOLID or L.Backdrops.TALKBOX)
							end,
						},
						disablebgtextures = {
							type = 'toggle',
							name = L['Disable overlay backgrounds'],
							order = 1,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.disablebgtextures = val end,
						},
						disableglowani = {
							type = 'toggle',
							name = L['Disable sheen animation'],
							order = 2,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.disableglowani = val end,
						},
						disableportrait = {
							type = 'toggle',
							name = L['Disable portrait border'],
							order = 3,
							get = L.GetFromSV,
							set = function(_, val) 
								L.cfg.disableportrait = val
								L.frame.TalkBox.PortraitFrame:SetShown(not val)
								L.frame.TalkBox.MainFrame.Model.PortraitBG:SetShown(not val)
							end,
						},
						disableanisequence = {
							type = 'toggle',
							name = L['Disable model animations'],
							order = 4,
							get = L.GetFromSV,
							set = function(_, val)
								L.cfg.disableanisequence = val
							end
						},
						disableboxhighlight = {
							type = 'toggle',
							name = L['Disable mouseover highlight'],
							order = 5,
							get = L.GetFromSV,
							set = function(_, val)
								L.cfg.disableboxhighlight = val
							end,
						},
						boxscale = {
							type = 'range',
							name = L['Scale'],
							order = 6,
							min = 0.5,
							max = 1.5,
							step = 0.1,
							get = L.GetFromDefaultOrSV,
							set = function(self, val) 
								L.cfg.boxscale = val
								L.frame.TalkBox:SetScale(val)
							end,
						},
						resetposition = {
							type = 'execute',
							name = RESET_POSITION,
							order = 7,
							func = function(self)
								L.Set('boxpoint', L.defaults.boxpoint)
								L.Set('boxoffsetX', L.defaults.boxoffsetX)
								L.Set('boxoffsetY', L.defaults.boxoffsetY)
								local t = L.frame.TalkBox
								t.extraY = 0
								t.offsetX = L('boxoffsetX')
								t.offsetY = L('boxoffsetY')
								t:ClearAllPoints()
								t:SetPoint(L('boxpoint'), UIParent, L('boxoffsetX'), L('boxoffsetY'))
							end,
						},
					},
				},
				titles = {
					type = 'group',
					name = QUESTS_LABEL .. ' / ' .. GOSSIP_OPTIONS,
					inline = true,
					order = 7,
					args = {
						gossipatcursor = {
							type = 'toggle',
							name = L['Show at mouse location'],
							get = L.GetFromSV,
							set = function(_, val) L.cfg.gossipatcursor = val end,
							order = 1,
						},
						titlescale = {
							type = 'range',
							name = 'Scale',
							min = 0.5,
							max = 1.5,
							step = 0.1,
							order = 0,
							get = L.GetFromDefaultOrSV,
							set = function(self, val) 
								L.cfg.titlescale = val
								L.frame.TitleButtons:SetScale(val)
							end,
						},
					},
				},
				elements = {
					type = 'group',
					name = QUEST_OBJECTIVES .. ' / ' .. QUEST_REWARDS,
					inline = true,
					order = 8,
					args = {
						elementscale = {
							type = 'range',
							name = 'Scale',
							min = 0.5,
							max = 1.5,
							step = 0.1,
							order = 0,
							get = L.GetFromDefaultOrSV,
							set = function(self, val) 
								L.cfg.elementscale = val
								L.frame.TalkBox.Elements:SetScale(val)
							end,
						},
						inspect = {
							type = 'select',
							name = INSPECT .. ' ('..ITEMS..')',
							order = 1,
							values = modifiers,
							get = L.GetFromDefaultOrSV,
							set = function(_, val)
								L.cfg.inspect = val
							end,
							style = 'dropdown',
						},
					},
				},
				itemtextread = {
					type = 'group',
					name = ITEMS .. ' / ' .. GUILD_BANK_TAB_INFO,
					inline = true,
					order = 9,
					args = {
						bookreading = {
							type = 'toggle',
							name = L['Books'],
							order = 0,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.bookreading = val end,
						},
						bookreadingdesc = {
							type = 'description',
							fontSize = 'medium',
							name = L['Reading books in Immersive style |cffffff7d0a[BETA]|r'],
						},
					},
				},
			},
		},	
--[[	experimental = {
			type = 'group',
			name = 'Experimental',
			order = 5,
			args = {
				nameplatemodebox = {
					type = 'group',
					name = 'Anchor to NPC nameplate',
					inline = true,
					order = 0,
					args = {
						nameplatemode = {
							type = 'toggle',
							name = VIDEO_OPTIONS_ENABLED,
							order = 0,
							get = L.GetFromSV,
							set = function(_, val) L.cfg.nameplatemode = val end,
						},						
						nameplatemodecvar = {
							type = 'execute',
							name = 'Toggle CVar',
							order = 1,
							func = function(self)
								local state = GetCVarBool('nameplateShowFriends')
								SetCVar('nameplateShowFriends', not state)
								local msg = state and NAMEPLATES_MESSAGE_FRIENDLY_OFF or NAMEPLATES_MESSAGE_FRIENDLY_ON
								UIErrorsFrame:AddMessage(msg, YELLOW_FONT_COLOR.r, YELLOW_FONT_COLOR.g, YELLOW_FONT_COLOR.b)
							end,
						},
						nameplatemodedesc = {
							type = 'description',
							fontSize = 'medium',
							order = 2,
							name = 'Show frame on NPC nameplate. This feature requires a CVar to be enabled (nameplateShowFriends).\nClick on the button above to toggle this CVar on/off.\n\nNote that you might have to press Cancel in the interface options for the CVar changes to take effect.',
						},
					},
				},
			},
		},]]
	},
}