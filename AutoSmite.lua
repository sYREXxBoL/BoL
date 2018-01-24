local version = "1.00"

function PrintMsg(msg)
	PrintChat("<font color=\"#afaa3b\"><b>[AutoSmite]</b></font> <font color=\"#ffffff\">"..msg.."</font>")
end

local Smite = nil
if myHero:GetSpellData(SUMMONER_1).name:find("smite") then
	Smite = SUMMONER_1 
elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("smite") then
	Smite = SUMMONER_2
end

if Smite == nil then
	PrintMsg("Smite not Found")
	PrintMsg("Script Not Laoded")
	return 
end

local S = {range = 500} 

local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_PHYSICAL)

local jungleMinions = minionManager(MINION_JUNGLE, 600, myHero, MINION_SORT_MAXHEALTH_DEC)

local jungleitem = 
{
	SR 	= { id = 3715, slot = nil }, -- Red Smite
	SRW = { id = 3714, slot = nil }, -- Red Warrior
	SRC = { id = 3717, slot = nil }, -- Red Cinderhulk
	SRR = { id = 3716, slot = nil }, -- Red Runeglaive
	SRD = { id = 3718, slot = nil }, -- Red Devourer
	SB 	= { id = 3706, slot = nil }, -- Blue Smite
	SBW = { id = 3707, slot = nil }, -- Blue Warrior
	SBC = { id = 3709, slot = nil }, -- Blue Cinderhulk
	SRR = { id = 3708, slot = nil }, -- Blue Runeglaive
	SBD = { id = 3710, slot = nil }, -- Blue Devourer
}

function GetSmiteDamage()
	if myHero.level <= 4 then
		SmiteDamage = 370 + (myHero.level * 20)
	end
	if myHero.level > 4 and myHero.level <= 9 then
		SmiteDamage = 330 + (myHero.level * 30)
	end
	if myHero.level > 9 and myHero.level <= 14 then
		SmiteDamage = 240 + (myHero.level * 40)
	end
	if myHero.level > 14 then
		SmiteDamage = 100 + (myHero.level * 50)
	end
	return SmiteDamage
end

function Menu()

	Menu = scriptConfig("AutoSmite", "AutoSmite")

		Menu:addSubMenu("> Key Settings", "Settings")
			Menu.Settings:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Settings:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Settings:addParam("AutoS", "Toggle On/Off AutoSmite", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("T"))
			Menu.Settings:addParam("AutoS2", "Hold AutoSmite", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("V"))

		Menu:addSubMenu("> Mob Settings", "MobSettings")
			Menu.MobSettings:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.MobSettings:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.MobSettings:addParam("onEpicMonster", "Smite Epic Monster", SCRIPT_PARAM_ONOFF, true)
			Menu.MobSettings:addParam("divider", "(Baron, Herald & Drake)", SCRIPT_PARAM_INFO, "")
			Menu.MobSettings:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.MobSettings:addParam("onBuffs", "Smite Buffs", SCRIPT_PARAM_ONOFF, true)
			Menu.MobSettings:addParam("divider", "(Red & Blue Buff)", SCRIPT_PARAM_INFO, "")

		Menu:addSubMenu("> Drawings", "Draw")
			Menu.Draw:addParam("General", "> Draw Settings:", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("drawSStatus", "Draw Smite Status", SCRIPT_PARAM_ONOFF, true)
			Menu.Draw:addParam("drawStatusScale","Front Scale", SCRIPT_PARAM_SLICE, 15, 15, 50, 0)
			Menu.Draw:addParam("divider", "", SCRIPT_PARAM_INFO, "")		

		Menu:addParam("space", "", 5, "")
		Menu:addParam("signature0", "            [AutoSmite] v"..version, 5, "")
		Menu:addParam("space1", "", 5, "")
		Menu:addParam("signature1", "              by sYREXx    ", 5, "")
end

function OnLoad()
	DelayAction(function()PrintMsg("Welcome <font color=\"#3393FF\"><b>"..GetUser().."</b></font>, Have Fun and Good Luck !") end, 0.5)
	DelayAction(function()PrintMsg("Successfully Loaded!") end, 0.5)

	Menu()
end

function OnTick()
	if (Menu.Settings.AutoS or Menu.Settings.AutoS2) then
		CheckJungle()
	end

	GetSmiteDamage()
end

function OnDraw()
	if myHero.dead then return end

	local mouse = GetCursorPos()

	local Scale = Menu.Draw.drawStatusScale

  	if (Menu.Settings.AutoS or Menu.Settings.AutoS2) and Menu.Draw.drawStatusScale then
	  	if isReady(Smite) then
	  		DrawTextA("Smite: "..GetSmiteDamage().."", Scale, mouse.x + 35, mouse.y - 10, ARGB(255, 15, 145, 0))
	  	else
	  		DrawTextA("Smite Not Ready", Scale, mouse.x + 35, mouse.y - 10, ARGB(255, 220, 10, 0))
	  	end
	end
end

function isReady(slot)
	return myHero:CanUseSpell(slot) == READY
end

function CheckJungle()
	if Smite then
		if isReady(Smite) then
			jungleMinions:update()
			for _, monster in pairs(jungleMinions.objects) do
				if Menu.Settings.onEpicMonster then
					if monster.charName == "SRU_Baron" or monster.charName == "SRU_Dragon_Water" or monster.charName == "SRU_Dragon_Fire" or monster.charName == "SRU_Dragon_Earth" or monster.charName == "SRU_Dragon_Air" or monster.charName == "SRU_Dragon_Elder" or monster.charName == "SRU_RiftHerald" then
						if monster ~= nil and GetDistanceSqr(monster) <= S.range * S.range and monster.health <= GetSmiteDamage() then
							CastSpell(Smite, monster)
						end
					end
				end
				if Menu.Settings.onBuffs then
					if monster.charName == "SRU_Blue" or monster.charName == "SRU_Red" then
						if monster ~= nil and GetDistanceSqr(monster) <= S.range * S.range and monster.health <= GetSmiteDamage() then
							CastSpell(Smite, monster)
						end
					end
				end
			end
		end
	end	 
end
