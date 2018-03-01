if myHero.charName ~= "Katarina" then return end

local version = 1.08

function PrintMsg(msg)
	PrintChat("<font color=\"#ff0000\"><b>[Katarina]</b></font> <font color=\"#ffffff\">"..msg.."</font>")
end

if FileExist(LIB_PATH..'TRPrediction.lua') then
  	require('TRPrediction')
else
  	print("Downloading TRPrediction, please don't press F9")
    DelayAction(function() DownloadFile("https://raw.githubusercontent.com/Project4706/BoL/master/TRPrediction.lua".."?rand="..math.random(1,10000), LIB_PATH.."TRPrediction.lua", function () print("Successfully downloaded TRPrediction. Press F9 twice.") end) end, 3) 
    return
end

local Q = {range = 625}
local W = {range = 340}
local E = {range = 725, speed = 5000, delay = 0, radius = 145}
local R = {range = 550, active = false}

local I = {range = 600}

local items = 
{
	[3137] = {Name = "Dervish Blade", nickName = "Dervish Qss", requiresTarget = false, requiresXZ = false, spellRange = nil},
	[3140] = {Name = "Quicksilver Sash", nickName = "Qss", requiresTarget = false, requiresXZ = false, spellRange = nil},
	[3139] = {Name = "Mercurial Scimitar", nickName = "Merc Qss", requiresTarget = false, requiresXZ = false, spellRange = nil},
	[3157] = {Name = "Zhonya's Hourglass", nickName = "Zhonya's", requiresTarget = false, requiresXZ = false, spellRange = nil},
	[3144] = {Name = "Bilgewater Cutlass", nickName = "Cutlass", requiresTarget = true, requiresXZ = false, spellRange = 550},
	[3146] = {Name = "Hextech Gunblade", nickName = "Gunblade", requiresTarget = true, requiresXZ = false, spellRange = 700}
}

local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_PHYSICAL)

local minions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_MAXHEALTH_ASC)
local allyMinions = minionManager(MINION_ALLY, 1000, myHero, MINION_SORT_HEALTH_DES)
local jungleMinions = minionManager(MINION_JUNGLE, 600, myHero, MINION_SORT_MAXHEALTH_DEC)

local _Ignite = nil

if myHero:GetSpellData(SUMMONER_1).name:lower():find("summonerdot") then
	_Ignite = SUMMONER_1
elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerdot") then
	_Ignite = SUMMONER_2
end

local enemyHeros = GetEnemyHeroes()

local TRe, TP

local Dagger = {}

local dgr = 0

local skins = 
{
	["Katarina"] = {"Default", "Mercenary Katarina", "Red Card Katarina", "High Command Katarina", "Kitty Cat Katarina", "Bilgewater Katarina", "Sandstorm Katarina", "Slay Belle Katarina", "Warring Kingdoms Katarina", "PROJECT: Katarina", "Death Sworn Katarina"}
}

local buffs = 
{
	[5]=nil, [7]=nil, [8]=nil, [10]=nil, [11]=nil, [21]=nil, [24]=nil, [25]=nil, [29]=nil
}

function Menu()
	Menu = scriptConfig("Katarina", "Katarina")

		--[[Combo]]--
		Menu:addSubMenu("> Combo", "Combo")
			Menu.Combo:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("useItems", "Use Items", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("useIgnite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("E", "(E) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("R", "(R) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("divider", "", SCRIPT_PARAM_INFO, "")		
			Menu.Combo:addParam("EonlyD", "(E) - Only on Dagger ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("RSettings", "> R Settings:", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("RAmount", "min. Enemy Hit", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
			Menu.Combo:addParam("Rkill", "If Killable", SCRIPT_PARAM_ONOFF, true)

		--[[Harass]]--
		Menu:addSubMenu("> Harass", "Harass")
			Menu.Harass:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Harass:addParam("useItems", "Use Items", SCRIPT_PARAM_ONOFF, true)
			Menu.Harass:addParam("HarassToggle", "Toggle Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("K"))
			Menu.Harass:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Harass:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Harass:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Harass:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, true)

		--[[Killsteal]]--
		Menu:addSubMenu("> Killsteal", "Killsteal")
			Menu.Killsteal:addParam("generalInfo", "> General settings:", SCRIPT_PARAM_INFO, "")
		    Menu.Killsteal:addParam("Killsteal", "Use Killsteal", SCRIPT_PARAM_ONOFF, true)
		    Menu.Killsteal:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Killsteal:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Killsteal:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, false)
			Menu.Killsteal:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, false)
			Menu.Killsteal:addParam("E", "(E) - Use ", SCRIPT_PARAM_ONOFF, false)
			Menu.Killsteal:addParam("R", "(R) - Use ", SCRIPT_PARAM_ONOFF, false)
			Menu.Killsteal:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Killsteal:addParam("I", "(Ignite) - Use ", SCRIPT_PARAM_ONOFF, false)
			Menu.Killsteal:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Killsteal:addParam("Item", "(Items) - Use ", SCRIPT_PARAM_ONOFF, false)

		--[[Laneclear]]--
		Menu:addSubMenu("> Laneclear", "Laneclear")
			Menu.Laneclear:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Laneclear:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Laneclear:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Laneclear:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Laneclear:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Laneclear:addParam("E", "(E) - Use ", SCRIPT_PARAM_ONOFF, true)
			
		--[[Jungleclear]]--
		Menu:addSubMenu("> Jungleclear", "Jungleclear")
			Menu.Jungleclear:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Jungleclear:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Jungleclear:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Jungleclear:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Jungleclear:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Jungleclear:addParam("E", "(E) - Use ", SCRIPT_PARAM_ONOFF, true)

		--[[Lasthit]]--
		Menu:addSubMenu("> LastHit", "Lasthit")
			Menu.Lasthit:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Lasthit:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Lasthit:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Lasthit:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Lasthit:addParam("E", "(E) - Use ", SCRIPT_PARAM_ONOFF, true)


		--[[Escape]]--
		Menu:addSubMenu("> Escape","Escape")
			Menu.Escape:addParam("flee", "Flee Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("G"))
			Menu.Escape:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Escape:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Escape:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Escape:addParam("E", "(E) - Use ", SCRIPT_PARAM_ONOFF, true)

		--[[Drawings]]--
		Menu:addSubMenu("> Drawings", "Draw")
			Menu.Draw:addParam("lfps", "Low Fps Circles", SCRIPT_PARAM_ONOFF, true)
			Menu.Draw:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("Spell", "> Draw range of spell:", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("drawQrange", "(Q) - Draw ", SCRIPT_PARAM_ONOFF, true)
			Menu.Draw:addParam("Qcolor", "(Q) Color", SCRIPT_PARAM_COLOR, {255, 186, 85, 211})
			Menu.Draw:addParam("drawErange", "(E) - Draw ", SCRIPT_PARAM_ONOFF, true)
			Menu.Draw:addParam("Ecolor", "(E) Color", SCRIPT_PARAM_COLOR, {255, 186, 85, 211})
			Menu.Draw:addParam("drawRrange", "(R) - Draw ", SCRIPT_PARAM_ONOFF, true)
			Menu.Draw:addParam("Rcolor", "(R) Color", SCRIPT_PARAM_COLOR, {255, 186, 85, 211})
			Menu.Draw:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("drawD", "(Dagger) - Draw ", SCRIPT_PARAM_ONOFF, false)
			Menu.Draw:addParam("drawDCircle", "(Dagger) - Circle ", SCRIPT_PARAM_ONOFF, false)
			Menu.Draw:addParam("drawDLine", "(Dagger) - Line ", SCRIPT_PARAM_ONOFF, false)
			Menu.Draw:addParam("Dcolor", "(Dagger) Color", SCRIPT_PARAM_COLOR, {255, 186, 85, 211})
			Menu.Draw:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("General", "> Damage Draw:", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("Damage", "(Damage) - Draw ", SCRIPT_PARAM_ONOFF, true)


	--[[Def Item Settings]]
		Menu:addSubMenu("> Items Settings", "ItemsSettings")
			Menu.ItemsSettings:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.ItemsSettings:addParam("ItemsSettings", "Use Def Item", SCRIPT_PARAM_ONOFF, true)
			Menu.ItemsSettings:addParam("Humanizer", "Delay for QSS", SCRIPT_PARAM_SLICE, 250, 0, 500, 0)
			Menu.ItemsSettings:addSubMenu("QSS","QSS")
				Menu.ItemsSettings.QSS:addParam("Stun", "Remove Stun", SCRIPT_PARAM_ONOFF, true) --5
				Menu.ItemsSettings.QSS:addParam("Silence", "Remove Silence", SCRIPT_PARAM_ONOFF, true)--7
				Menu.ItemsSettings.QSS:addParam("Taunt", "Remove Taunt", SCRIPT_PARAM_ONOFF, true)--8
				Menu.ItemsSettings.QSS:addParam("Root", "Remove Root", SCRIPT_PARAM_ONOFF, true)--11
				Menu.ItemsSettings.QSS:addParam("Fear", "Remove Fear", SCRIPT_PARAM_ONOFF, true)--10
				Menu.ItemsSettings.QSS:addParam("Charm", "Remove Charm", SCRIPT_PARAM_ONOFF, true)--21
				Menu.ItemsSettings.QSS:addParam("Suppression", "Remove Suppression", SCRIPT_PARAM_ONOFF, true)--24
				Menu.ItemsSettings.QSS:addParam("Blind", "Remove Blind", SCRIPT_PARAM_ONOFF, true)--25
				Menu.ItemsSettings.QSS:addParam("KnockUp", "Remove Knock up", SCRIPT_PARAM_ONOFF, true)--29
			Menu.ItemsSettings:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.ItemsSettings:addParam("zhonya", "Use Zhonya", SCRIPT_PARAM_ONOFF, true)
			Menu.ItemsSettings:addParam("zhonyaHealth", "Use Zhonya at HP %", SCRIPT_PARAM_SLICE, 35, 1, 100, 0)
			Menu.ItemsSettings:addParam("zhonyaAmount", "Use Zhonya at min Enemy", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)

	--[[Misc]]--
		Menu:addSubMenu("> Skin SkinChanger", "Misc")
			Menu.Misc:addParam("SkinChanger", "> SkinChanger:", SCRIPT_PARAM_INFO, "")
			Menu.Misc:addParam("UseSkin", "Use Skin", SCRIPT_PARAM_ONOFF, false) 
			Menu.Misc:setCallback("UseSkin", StartSkin)
			Menu.Misc:addParam("SetSkin", myHero.charName.. " Skins", SCRIPT_PARAM_LIST, 1, skins[myHero.charName])
			Menu.Misc:setCallback("SetSkin", StartSkin)

	Menu:addParam("space", "", 5, "")
	Menu:addParam("signature0", "            [Katarina] v"..version, 5, "")
	Menu:addParam("space1", "", 5, "")
	Menu:addParam("signature1", "              by sYREXx    ", 5, "")
end

---------------------------------------------------------------------------------
--[[Spell Check's]]--
---------------------------------------------------------------------------------

function isReady(slot)
	return myHero:CanUseSpell(slot) == READY
end

function isLevel(slot)
	if myHero:GetSpellData(slot).level > 0 then
    	return true
  	else
    	return false
  	end
end

function Level(slot)
	if isLevel(slot) then
		return myHero:GetSpellData(slot).level
	end
end

function GetDamage(spell, unit)
	local truedamage = 0
	local basedamage = 0
	local AD = myHero.totalDamage
	local AP = myHero.ap
	local bAD = myHero.addDamage

	if spell == _Q then
		if isReady(_Q) then
			truedamage = myHero:CalcMagicDamage(unit, ((Level(_Q) * 30 + 45) + (AP * 0.6)))
		end
	elseif spell == _Dagger and dgr > 0 then
		if myHero.level == 1 then
			basedamage = 68
		elseif myHero.level == 2 then
			basedamage = 72
		elseif myHero.level == 3 then
			basedamage = 77
		elseif myHero.level == 4 then
			basedamage = 82
		elseif myHero.level == 5 then
			basedamage = 89
		elseif myHero.level == 6 then
			basedamage = 96	
		elseif myHero.level == 7 then
			basedamage = 103	
		elseif myHero.level == 8 then
			basedamage = 112	
		elseif myHero.level == 9 then
			basedamage = 121	
		elseif myHero.level == 10 then
			basedamage = 131	
		elseif myHero.level == 11 then
			basedamage = 142	
		elseif myHero.level == 12 then
			basedamage = 154	
		elseif myHero.level == 13 then
			basedamage = 166	
		elseif myHero.level == 14 then
			basedamage = 180	
		elseif myHero.level == 15 then
			basedamage = 194	
		elseif myHero.level == 16 then
			basedamage = 208
		elseif myHero.level == 17 then
			basedamage = 224	
		elseif myHero.level == 18 then
			basedamage = 240
		end

		if dgr > 1 then
			if myHero.level < 6 then
				truedamage = myHero:CalcMagicDamage(unit, 2 * (basedamage + bAD + (0.55 * AP)))
			elseif myHero.level < 11 and myHero.level > 5 then
				truedamage = myHero:CalcMagicDamage(unit, 2 * (basedamage + bAD + (0.7 * AP)))
			elseif myHero.level < 16 and myHero.level > 10 then
				truedamage = myHero:CalcMagicDamage(unit, 2 * (basedamage + bAD + (0.85 * AP))) 
			elseif myHero.level > 15 then
				truedamage = myHero:CalcMagicDamage(unit, 2 * (basedamage + bAD + AP))
			end
		else
			if myHero.level < 6 then
				truedamage = myHero:CalcMagicDamage(unit, (basedamage + bAD + (0.55 * AP)))
			elseif myHero.level < 11 and myHero.level > 5 then
				truedamage = myHero:CalcMagicDamage(unit, (basedamage + bAD + (0.7 * AP)))
			elseif myHero.level < 16 and myHero.level > 10 then
				truedamage = myHero:CalcMagicDamage(unit, (basedamage + bAD + (0.85 * AP))) 
			elseif myHero.level > 15 then
				truedamage = myHero:CalcMagicDamage(unit, (basedamage + bAD + AP))
			end
		end

	elseif spell == _E then
		if isReady(_E) then
			truedamage = myHero:CalcMagicDamage(unit, ((Level(_E) * 15) + (AD * 0.6) + (AP * 0.25)))
		end
	elseif spell == _R then
		if isReady(_R) then
			truedamage = myHero:CalcMagicDamage(unit, (((Level(_R) * 25) - ((Level(_R) - 1) * 12.5)) + (bAD * 0.22) + (AP * 0.19))) -- every 0.166 sec#
		end
	elseif spell == _Ignite and not _Ignite == nil then
		if isReady(_Ignite) then
			truedamage = (50 + (myHero.level * 20))
		end
	elseif HasItem(3146) then --GunBlade
		if spell == _GunBlade and ItemReady(3146) then
			if myHero.level == 1 then
				basedamage = 175
			elseif myHero.level == 2 then
				basedamage = 180
			elseif myHero.level == 3 then
				basedamage = 184
			elseif myHero.level == 4 then
				basedamage = 189
			elseif myHero.level == 5 then
				basedamage = 193
			elseif myHero.level == 6 then
				basedamage = 198	
			elseif myHero.level == 7 then
				basedamage = 203	
			elseif myHero.level == 8 then
				basedamage = 207	
			elseif myHero.level == 9 then
				basedamage = 212	
			elseif myHero.level == 10 then
				basedamage = 216	
			elseif myHero.level == 11 then
				basedamage = 221	
			elseif myHero.level == 12 then
				basedamage = 225	
			elseif myHero.level == 13 then
				basedamage = 230	
			elseif myHero.level == 14 then
				basedamage = 235	
			elseif myHero.level == 15 then
				basedamage = 239	
			elseif myHero.level == 16 then
				basedamage = 244
			elseif myHero.level == 17 then
				basedamage = 248	
			elseif myHero.level == 18 then
				basedamage = 253
			end
		end
		truedamage = myHero:CalcMagicDamage(unit, basedamage + (0.3 * AP))
	elseif HasItem(3144) then --Cutlass
		if spell == _Cutlass and ItemReady(3144) then
			truedamage = myHero:CalcMagicDamage(unit, 100)
		end
	end
	return truedamage
end

---------------------------------------------------------------------------------
--[[Callback's]]--
---------------------------------------------------------------------------------

function OnCreateObj(obj)
	if obj and obj.valid and obj.networkID and obj.networkID ~= 0 then
        if (obj.name:lower():find("katarina_base_w_indicator_ally") or obj.name:lower():find("katarina_skin01_w_indicator_ally") or obj.name:lower():find("katarina_skin02_w_indicator_ally") or obj.name:lower():find("katarina_akin03_w_indicator_ally") or obj.name:lower():find("katarina_skin04_w_indicator_ally") or obj.name:lower():find("katarina_skin05_w_indicator_ally") or obj.name:lower():find("katarina_skin06_w_indicator_ally") or obj.name:lower():find("katarina_skin07_w_indicator_ally") or obj.name:lower():find("katarina_skin08_w_indicator_ally") or obj.name:lower():find("katarina_skin09_w_indicator_ally") or obj.name:lower():find("katarina_skin10_w_indicator_ally")) then
            Dagger[obj.networkID] = {obj = Vector(obj)}
            dgr = dgr + 1
        end
    end
end

function OnDeleteObj(obj)
	if obj and obj.valid and obj.networkID and obj.networkID ~= 0 then
        if (obj.name:lower():find("katarina_base_w_indicator_ally") or obj.name:lower():find("katarina_skin01_w_indicator_ally") or obj.name:lower():find("katarina_skin02_w_indicator_ally") or obj.name:lower():find("katarina_akin03_w_indicator_ally") or obj.name:lower():find("katarina_skin04_w_indicator_ally") or obj.name:lower():find("katarina_skin05_w_indicator_ally") or obj.name:lower():find("katarina_skin06_w_indicator_ally") or obj.name:lower():find("katarina_skin07_w_indicator_ally") or obj.name:lower():find("katarina_skin08_w_indicator_ally") or obj.name:lower():find("katarina_skin09_w_indicator_ally") or obj.name:lower():find("katarina_skin10_w_indicator_ally")) then
            Dagger[obj.networkID] = nil
            dgr = dgr - 1 
        end
    end
end

function OnUpdateBuff(unit, buff)
   	if unit and unit.isMe and buff and buff.valid then
   		if Menu.ItemsSettings.ItemsSettings and buffs[buff.type] == true then
	   		DelayAction(function()
	   			CastItem(3137)
				CastItem(3140)
				CastItem(3139)
	   		end, Menu.ItemsSettings.Humanizer/1000)
		end
	end
end

function OnProcessSpell(unit, spell)
	if unit and unit.isMe and spell.name:lower():find("katarinar") then
		R.active = true
	end
end

function OnRemoveBuff(unit, buff)
	if unit and unit.isMe and buff.name:lower():find("katarinarsound") then
		R.active = false
	end
end

---------------------------------------------------------------------------------
--[[Spell's Settings]]--
---------------------------------------------------------------------------------

function Int()
	if TRPrediction then
      	TP = TRPrediction()
	    TRe = TR_BindSS({type = 'IsRadial', delay = E.delay, range = E.range, radius = E.radius, speed = E.speed, allowedCollisionCount = math.huge})
	end
end

function CastQ(unit)
	if ValidTarget(unit) and isReady(_Q) and GetDistanceSqr(unit) < Q.range * Q.range then
		CastSpell(_Q, unit)
	end
end

function CastW(unit)
	if isReady(_W) and GetDistanceSqr(unit) < W.range/2 * W.range/2 then
		CastSpell(_W)
	end
end

function CastETarget(unit)
	if ValidTarget(unit) and isReady(_E) and GetDistanceSqr(unit) < E.range * E.range then
		if TRPrediction then
			local CastPosition, timeToHit = TP:GetAOEPrediction(TRe, unit, myHero)
		    if CastPosition and timeToHit then
		      	CastSpell(_E, CastPosition.x, CastPosition.z)
		    end
		end
	end
end

function CastEDagger(unit)
	if ValidTarget(unit) then
		for _, D in pairs(Dagger) do
			local spot = D.obj + (Vector(unit) - D.obj): normalized() * 145
			if isReady(_E) and GetDistanceSqr(unit, spot) < W.range * W.range then
				CastSpell(_E, spot.x, spot.z)
			end
		end
	end
end

function GetECast(unit)
	if Menu.Combo.EonlyD then
		CastEDagger(unit)
	else
		if dgr > 0 then
			CastEDagger(unit)
		else
			CastETarget(unit)
		end
	end
end

function CastR(unit)
	if isReady(_R) and GetDistanceSqr(unit) < R.range * R.range then
		CastSpell(_R)
	end
end

function ChancelR()
	if R.active then
		AllowAttacks(false)
		AllowMovement(false)
	else
		AllowAttacks(true)
		AllowMovement(true)	
	end

	if R.active and CountEnemyHeroInRange(R.range, myHero) < 1 then
		myHero:MoveTo(mousePos.x, mousePos.z)
	end
end

function CastI(unit)
	if ValidTarget(unit) and _Ignite and isReady(_Ignite) and GetDistanceSqr(unit) < I.range * I.range then
		CastSpell(_Ignite, unit)
	end
end

---------------------------------------------------------------------------------
--[[Mode's]]--
---------------------------------------------------------------------------------

function GetCustomTarget()
	ts:update()	
	if ValidTarget(ts.target) and ts.target.type == myHero.type then
		return ts.target
	else
		return nil
	end
end

function Combo()
	local target = ts.target
	if ValidTarget(target) then
		local Distance = GetDistanceSqr(target)
		if (Menu.Combo.Q and Menu.Combo.W and Menu.Combo.E) and Distance <= W.range * W.range and not R.active then
			if Menu.Combo.useItems then
				CastItem(3146, target)
				CastItem(3144, target)
			end
			CastW(target)
			CastQ(target)
			GetECast(target)
		end

		if (Menu.Combo.Q and Menu.Combo.W and Menu.Combo.E) and Distance <= Q.range * Q.range and not R.active then
			CastQ(target)
			GetECast(target)
			if Menu.Combo.useItems then
				CastItem(3146, target)
				CastItem(3144, target)
			end
			CastW(target)
		end

		if (Menu.Combo.Q and Menu.Combo.W and Menu.Combo.E) and Distance <= E.range * E.range and not R.active then
			GetECast(target)
			if Menu.Combo.useItems then
				CastItem(3146, target)
				CastItem(3144, target)
			end
			CastW(target)
			CastQ(target)
		end

		if isLevel(_R) then
			if GetDistanceSqr(myHero, target) < R.range * R.range then
				if (Menu.Combo.R and CountEnemyHeroInRange(W.range, myHero) >= Menu.Combo.RAmount) or Menu.Combo.Rkill and (target.health <= (GetDamage(_R, target) * (RTime(target) / 0.125))) then
					CastR(target)
				end
			end
		end

		if Menu.Combo.useIgnite then
			if GetDistanceSqr(myHero, target) < 450 * 450 then
				if 25 >= (100 * target.health / target.maxHealth) then
					CastI(target)
				end
			end
		end
	end
end

function Harass()
	local target = ts.target
	if ValidTarget(target) then
		if Menu.Harass.Q then
			CastQ(target)
		end

		if Menu.Harass.W then
			CastW(target)
		end
	end
end

function Laneclear()
	minions:update()
	for _, minions in pairs(minions.objects) do
		if minions and ValidTarget(minions) then
			if Menu.Laneclear.E then
				for _, D in pairs(Dagger) do
					if dgr > 0 then
						if not UnderTurret(D.obj, enemyTurret) then
							GetECast(minions)
						end
					end
				end
			end

			if Menu.Laneclear.Q then 
				CastQ(minions) 
			end

			if Menu.Laneclear.W then
				CastW(minions) 
			end
		end
	end
end

function LastHit()
	minions:update()
	for _, minions in pairs(minions.objects) do
		if minions and ValidTarget(minions) then
			if Menu.Lasthit.Q then
				if minions.health <= GetDamage(_Q, minions) then
					CastQ(minions)
				end
			end

			if Menu.Lasthit.E then
				if minions.health <= GetDamage(_E, minions) then
					CastETarget(minions)
				end
			end
		end
	end
end

function Jungleclear()
	jungleMinions:update()
	for _, minions in pairs(jungleMinions.objects) do
		if minions and ValidTarget(minions) then
			if minions.name:lower():find("plant") then return end
			if minions and ValidTarget(minions) then
				if Menu.Jungleclear.Q then 
					CastQ(minions) 
				end

				if Menu.Jungleclear.E then
					if dgr > 0 then
						GetECast(minions)
					end
				end

				if Menu.Jungleclear.W then
					CastW(minions) 
				end
			end
		end
	end
end

function Killsteal()
	for _, enemy in pairs(enemyHeros) do
		if GetDistanceSqr(myHero, enemy) < 1000 * 1000 and not enemy.dead then
			if Menu.Killsteal.I then
				if enemy ~= nil and enemy.valid and enemy.health <= GetDamage(_Ignite, enemy) then
					CastI(enemy)
				end
			end
			--Q
			if Menu.Killsteal.Q and isReady(_Q) then
				if enemy ~= nil and enemy.valid and enemy.health <= GetDamage(_Q, enemy) then
					CastQ(enemy)
				end
			end
			-- W
			if Menu.Killsteal.W and isReady(_W) then
				if enemy ~= nil and enemy.valid and enemy.health <= GetDamage(_Dagger, enemy) then
					CastW(enemy)
				end
			end
			--E
			if Menu.Killsteal.E and isReady(_E) then
				if enemy ~= nil and enemy.valid and enemy.health <= GetDamage(_E, enemy) then
					CastETarget(enemy)
				end
			end

			-- E on Dagger
			if Menu.Killsteal.E and isReady(_E) then
				if dgr > 0 then
					for _, D in pairs(Dagger) do
						if enemy ~= nil and enemy.valid and enemy.health <= GetDamage(_E, enemy) + GetDamage(_Dagger, enemy) then
							if GetDistanceSqr(enemy, D.obj) < 250 * 250 then
								CastEDagger(enemy)
							end
						end
					end
				end
			end

			--Items
			if Menu.Killsteal.Item and HasItem(3146) and ItemReady(3146) then 
				if enemy ~= nil and enemy.valid and enemy.health <= GetDamage(_GunBlade, enemy) then
					CastItem(3146, enemy)
				end
			end

			if Menu.Killsteal.Item and HasItem(3144) and ItemReady(3144) then 
				if enemy ~= nil and enemy.valid and enemy.health <= GetDamage(_Cutlass, enemy) then
					CastItem(3144, enemy)
				end
			end
		end
	end
end

function Flee()
	myHero:MoveTo(mousePos.x, mousePos.z)
	if Menu.Escape.W then
		CastSpell(_W)
	end
	if Menu.Escape.E then
		allyMinions:update()
		minions:update()
		jungleMinions:update()
		
		if GetDistance(mousePos) > E.range then
            unit = myHero + (Vector(mousePos) - myHero):normalized() * E.range
        else
            unit = myHero + (Vector(mousePos) - myHero)
        end

        if isReady(_E) then
        	UnitValid = false
           	UnitDistance = 9999
			for _, m in pairs(allyMinions.objects) do
				if GetDistance(m, unit) < 350 and not m.dead and UnitDistance > GetDistance(mousePos, m) then
                    UnitDistance = GetDistance(mousePos, m)
                    UnitValid = m
                end
			end
			for _, m in pairs(minions.objects) do
				if GetDistance(m, unit) < 350 and not m.dead and UnitDistance > GetDistance(mousePos, m) then
                    UnitDistance = GetDistance(mousePos, m)
                    UnitValid = m
                end
			end
			for _, m in pairs(jungleMinions.objects) do
				if GetDistance(m, unit) < 350 and not m.dead and UnitDistance > GetDistance(mousePos, m) then
                    UnitDistance = GetDistance(mousePos, m)
                    UnitValid = m
                end
			end
			for _, D in pairs(Dagger) do
				if GetDistance(D.obj, unit) < 350 and UnitDistance > GetDistance(mousePos, D.obj) then
                    UnitDistance = GetDistance(mousePos, D.obj)
                    UnitValid = D.obj
                end
			end
		end

		if UnitValid then
            unit = UnitValid
        end

        if GetDistance(mousePos) > E.range then
            if UnitValid then
                CastSpell(_E, UnitValid.x, UnitValid.z)
            end
        elseif GetDistance(mousePos) < E.range then
            if UnitValid then
                CastSpell(_E, UnitValid.x, UnitValid.z)
            end
        end
	end
end

function Zhonya()
	if (Menu.ItemsSettings.zhonyaHealth >= (100 * myHero.health / myHero.maxHealth)) and Menu.ItemsSettings.zhonyaAmount <= CountEnemyHeroInRange(W.range, myHero) then
		CastItem(3157)
	end
end

---------------------------------------------------------------------------------
--[[Item's]]--
---------------------------------------------------------------------------------

function HasItem(id)  
  	local itemSlot = GetInventorySlotItem(id)
  	if itemSlot ~= nil then
    	return true
  	else
    	return false
  	end
end

function ItemReady(id)
  	if HasItem(id) then
    	local itemSlot = GetInventorySlotItem(id)
    	if myHero:CanUseSpell(itemSlot) == READY then
      		return true
    	else
      		return false
    	end
  	else
    	return false
  	end
end

function CastItem(theItem, p2, p3)
  	local itemSlot = GetInventorySlotItem(theItem)
  	if HasItem(theItem) then
    	if ItemReady(theItem) then
	      	if items[theItem].requiresTarget then
	        	CastSpell(itemSlot, p2)
	      	elseif items[theItem].requiresXZ then
	        	CastSpell(itemSlot, p2, p3)
	      	else
	        	CastSpell(itemSlot)
	      	end
  		end
	end
end

function CountEnemyHeroInRange(range, object)
    object = object or myHero
    range = range and range * range or myHero.range * myHero.range
    local enemyInRange = 0
    for i = 1, heroManager.iCount, 1 do
        local hero = heroManager:getHero(i)
        if ValidTarget(hero) and GetDistanceSqr(object, hero) <= range then
            enemyInRange = enemyInRange + 1
        end
    end
    return enemyInRange
end

function RTime(unit)
	if ValidTarget(unit) then
		if GetDistanceSqr(myHero, unit) < R.range * R.range and ValidTarget(unit) then
			for _, champion in ipairs(enemyHeros) do
				local fastes_way = {}
				local end_pos = myHero + (Vector(unit) - myHero): normalized() * R.range
				table.insert(fastes_way, Vector(champion.x, champion.z))
				if end_pos ~= nil and end_pos.x then
					table.insert(fastes_way, end_pos)
				end
				local travel_time = 0
				if #fastes_way > 1 then
					for current_index = 1, #fastes_way-1 do
						DrawLine3D(fastes_way[current_index].x, myHero.y, fastes_way[current_index].y, fastes_way[current_index+1].x, myHero.y, fastes_way[current_index+1].y, 5, ARGB(255, 255, 0, 0) )
						if current_index == #fastes_way-1 then
							local endpoint = fastes_way[current_index+1]
							local current_time = GetDistance(fastes_way[current_index], fastes_way[current_index+1])/champion.ms
							travel_time = travel_time + current_time
							return (round(travel_time,3))
						end
					end
				end
			end 
		end
	else 
		travel_time = 0
	end
end

---------------------------------------------------------------------------------
--[[SkinChanger]]--
---------------------------------------------------------------------------------

function StartSkin()
	if Menu.Misc.UseSkin then
		local id = Menu.Misc.SetSkin-1
		SetSkin(myHero, id)
	else
		SetSkin(myHero, -1)
	end
end

---------------------------------------------------------------------------------
--[[AutoUpdater]]--
---------------------------------------------------------------------------------

local ServerResult = GetWebResult("raw.github.com","https://raw.githubusercontent.com/sYREXxBoL/BoL/master/Katarina.version")
if ServerResult then
	ServerVersion = tonumber(ServerResult)
	if version < ServerVersion then
		PrintMsg("A new version is available: v"..ServerVersion..". Attempting to download now.")
		DelayAction(function()PrintMsg("A new version is available: v"..ServerVersion..". Attempting to download now.") end, 0.55)
		DelayAction(function() DownloadFile("https://raw.githubusercontent.com/sYREXxBoL/BoL/master/Katarina.lua".."?rand"..math.random(1,9999), SCRIPT_PATH.."Katarina.lua", function() PrintMsg("Successfully downloaded the latest version: v"..ServerVersion..". Please 2xF9.") end) end, 2)
	else
		DelayAction(function()PrintMsg("You are running the latest version: v"..version..".") end, 0.55)
	end
else
	DelayAction(function()PrintMsg("Error finding server version.") end, 0.55)
end

---------------------------------------------------------------------------------
--[[Orbwalker]]--
---------------------------------------------------------------------------------

function Orb__init()
    local orbwalker = nil

    Menu:addSubMenu("> Orbwalker", "Orbwalker")
        Menu.Orbwalker:addParam("CustomKey", "Use Custom Combat Keys", SCRIPT_PARAM_ONOFF, false)
        Menu.Orbwalker:setCallback("CustomKey", function(v)
        	if v == true then
        		Menu.Orbwalker:removeParam("Orbwalker")
        		Menu.Orbwalker:addParam("Combo", "Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
        		Menu.Orbwalker:addParam("Harass", "Harass Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
        		Menu.Orbwalker:addParam("Laneclear", "Lane Clear Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        		Menu.Orbwalker:addParam("Lasthit", "Last Hit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
        	elseif v == false then
        		Menu.Orbwalker:addParam("Orbwalker", orbwalker .. " Detected, Hotkeys integrated", SCRIPT_PARAM_INFO, "")
        		Menu.Orbwalker:removeParam("Combo")
        		Menu.Orbwalker:removeParam("Harass")
        		Menu.Orbwalker:removeParam("Laneclear")
        		Menu.Orbwalker:removeParam("Lasthit")
        	end
    	end)

    AddTickCallback(function() FindOrbwalker() end)
end

function FindOrbwalker()
    if orbwalker ~= nil then return end

    if _G.Reborn_Initialised and _G.Reborn_Loaded and SAC and SAC.Loaded then
        orbwalker = "SAC:P"
        PrintMsg("Sida's Auto Carry Detected!")
    elseif _G.Reborn_Initialised and _G.Reborn_Loaded and not SAC then
        orbwalker = "SAC:R"
        PrintMsg("Sida's Auto Carry Detected!")
    elseif _G["BigFatOrb_Loaded"] == true then
    	orbwalker = "BigFat"
    	PrintMsg("BigFat Walk Detected!")
    --elseif _G.ZWalker:IsLoaded() then
    	--orbwalker = "0Walk"
    	--PrintMsg("0Walker Detected!")
    end

    if orbwalker ~= nil and not Menu.Orbwalker.CustomKey then
        Menu.Orbwalker:addParam("Orbwalker", orbwalker .. " Detected, Hotkeys integrated", SCRIPT_PARAM_INFO, "")
    elseif orbwalker ~= nil then
        Menu.Orbwalker:addParam("Combo", "Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
        Menu.Orbwalker:addParam("Harass", "Harass Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
        Menu.Orbwalker:addParam("Laneclear", "Lane Clear Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
        Menu.Orbwalker:addParam("Lasthit", "Last Hit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
    end
end

function ComboMode()
    if not Menu.Orbwalker.CustomKey then
        if orbwalker == "SAC:R" or orbwalker == "SAC:P" then
            return _G.AutoCarry.Keys.AutoCarry
        elseif orbwalker == "BigFat" then
        	return _G["BigFatOrb_Mode"] == "Combo"
        elseif orbwalker == "0Walk" then
        	return _G.ZWalker:ActiveMode() == "Combo"
        end
    else
        return Menu.Orbwalker.Combo
    end
end

function HarassMode()
    if not Menu.Orbwalker.CustomKey then
        if orbwalker == "SAC:R" or orbwalker == "SAC:P" then
            return _G.AutoCarry.Keys.MixedMode
        elseif orbwalker == "BigFat" then
        	return _G["BigFatOrb_Mode"] == "Harass"
        elseif orbwalker == "0Walk" then
        	return _G.ZWalker:ActiveMode() == "Harass"
        end
    else
        return Menu.Orbwalker.Harass
    end
end

function LaneclearMode()
    if not Menu.Orbwalker.CustomKey then
        if orbwalker == "SAC:R" or orbwalker == "SAC:P" then
            return _G.AutoCarry.Keys.LaneClear
        elseif orbwalker == "BigFat" then
        	return _G["BigFatOrb_Mode"] == "LaneClear"
        elseif orbwalker == "0Walk" then
        	return _G.ZWalker:ActiveMode() == "LaneClear"
        end
    else
        return Menu.Orbwalker.LaneClear
    end
end

function LasthitMode()
    if not Menu.Orbwalker.CustomKey then
        if orbwalker == "SAC:R" or orbwalker == "SAC:P" then
            return _G.AutoCarry.Keys.LastHit
        elseif orbwalker == "BigFat" then
        	return _G["BigFatOrb_Mode"] == "LastHit"
        elseif orbwalker == "0Walk" then
        	return _G.ZWalker:ActiveMode() == "LastHit"
        end
    else
        return Menu.Orbwalker.Lasthit
    end
end

function GetOrbwalkerTarget()
    if orbwalker == "SAC:R" then
        return _G.AutoCarry.SkillsCrosshair.target
    elseif orbwalker == "SAC:P" then
        return _G.SAC:GetTarget("enemy")
    elseif orbwalker == "BigFat" then
    	--return _G["BigFatOrb_ForcedTarget"] = target
   	elseif orbwalker == "0Walk" then
   		return _G.ZWalker:GetOrbTarget()
   	end
end

function ForceTarget(target)
    if orbwalker == "SAC:R" or orbwalker == "SAC:P" then
        _G.AutoCarry.Crosshair:ForceTarget(target)
    elseif orbwalker == "BigFat" then
    	--_G["BigFatOrb_ForcedTarget"] = target
    elseif orbwalker == "0Walk" then
    	_G.ZWalker:ForceTarget(target)
    end
end

function AllowAttacks(bool)
    if orbwalker == "SAC:R" or orbwalker == "SAC:P" then
        _G.AutoCarry.MyHero:AttacksEnabled(bool)
    elseif orbwalker == "BigFat" then
        _G["BigFatOrb_DisableAttacks"] = not bool
    elseif orbwalker == "0Walk" then
    	if bool then
    		_G.ZWalker:EnableAA()
    	else
    		_G.ZWalker:DisableAA()
    	end
    end
end

function AllowMovement(bool)
    if orbwalker == "SAC:R" or orbwalker == "SAC:P" then
        _G.AutoCarry.MyHero:MovementEnabled(bool)
    elseif orbwalker == "BigFat" then
        _G["BigFatOrb_DisableMove"] = not bool
    elseif orbwalker == "0Walk" then
    	if bool then
    		_G.ZWalker:EnableMovement()
    	else
    		_G.ZWalker:DisableMovement()
    	end
    end
end

---------------------------------------------------------------------------------
--[[Draw]]--
---------------------------------------------------------------------------------

function round(num, idp)
	return string.format("%." .. (idp or 0) .. "f", num)
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvl(x, y, z, radius, 2, color, 50)	
	end
end

function GetHPBarPos(enemy)
	enemy.barData = {PercentageOffset = {x = -0.05, y = 0}}
	local barPos = GetUnitHPBarPos(enemy)
	local barPosOffset = GetUnitHPBarOffset(enemy)
	local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local BarPosOffsetX = -50
	local BarPosOffsetY = 46
	local CorrectionY = 39
	local StartHpPos = 31
	barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos)
	barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)
	local StartPos = Vector(barPos.x , barPos.y, 0)
	local EndPos = Vector(barPos.x + 108 , barPos.y , 0)
	return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function OnDraw()
	if Menu.Draw.lfps then
		if Menu.Draw.drawQrange and isReady(_Q) then 
    		DrawCircle2(myHero.x, myHero.y, myHero.z, Q.range, ARGB(Menu.Draw.Qcolor[1], Menu.Draw.Qcolor[2], Menu.Draw.Qcolor[3], Menu.Draw.Qcolor[4]))
  		elseif Menu.Draw.drawQrange and not isReady(_Q) and isLevel(_Q) then
    		DrawCircle2(myHero.x, myHero.y, myHero.z, Q.range, ARGB(255, 255, 0, 0))
  		end
  		if Menu.Draw.drawErange and isReady(_E) then 
    		DrawCircle2(myHero.x, myHero.y, myHero.z, E.range, ARGB(Menu.Draw.Ecolor[1], Menu.Draw.Ecolor[2], Menu.Draw.Ecolor[3], Menu.Draw.Ecolor[4]))
  		elseif Menu.Draw.drawErange and not isReady(_E) and isLevel(_E) then
    		DrawCircle2(myHero.x, myHero.y, myHero.z, E.range, ARGB(255, 255, 0, 0))
  		end
  		if Menu.Draw.drawRrange and isReady(_R) then 
    		DrawCircle2(myHero.x, myHero.y, myHero.z, R.range, ARGB(Menu.Draw.Rcolor[1], Menu.Draw.Rcolor[2], Menu.Draw.Rcolor[3], Menu.Draw.Rcolor[4]))
  		elseif Menu.Draw.drawRrange and not isReady(_R) and isLevel(_R) then
    		DrawCircle2(myHero.x, myHero.y, myHero.z, R.range, ARGB(255, 255, 0, 0))
  		end
	else
		if Menu.Draw.drawQrange and isReady(_Q) then 
    		DrawCircle(myHero.x, myHero.y, myHero.z, Q.range, ARGB(Menu.Draw.Qcolor[1], Menu.Draw.Qcolor[2], Menu.Draw.Qcolor[3], Menu.Draw.Qcolor[4]))
  		elseif Menu.Draw.drawQrange and not isReady(_Q) and isLevel(_Q) then
    		DrawCircle(myHero.x, myHero.y, myHero.z, Q.range, ARGB(255, 255, 0, 0))
  		end
  		if Menu.Draw.drawErange and isReady(_E) then 
    		DrawCircle(myHero.x, myHero.y, myHero.z, E.range, ARGB(Menu.Draw.Ecolor[1], Menu.Draw.Ecolor[2], Menu.Draw.Ecolor[3], Menu.Draw.Ecolor[4]))
  		elseif Menu.Draw.drawErange and not isReady(_E) and isLevel(_E) then
    		DrawCircle(myHero.x, myHero.y, myHero.z, E.range, ARGB(255, 255, 0, 0))
  		end
  		if Menu.Draw.drawRrange and isReady(_R) then 
    		DrawCircle(myHero.x, myHero.y, myHero.z, R.range, ARGB(Menu.Draw.Rcolor[1], Menu.Draw.Rcolor[2], Menu.Draw.Rcolor[3], Menu.Draw.Rcolor[4]))
  		elseif Menu.Draw.drawRrange and not isReady(_R) and isLevel(_R) then
    		DrawCircle(myHero.x, myHero.y, myHero.z, R.range, ARGB(255, 255, 0, 0))
  		end
	end
	if Menu.Draw.drawD then
		for _, D in pairs(Dagger) do
			if Menu.Draw.drawDCircle then
				DrawCircle2(D.obj.x, D.obj.y, D.obj.z, 145, ARGB(Menu.Draw.Dcolor[1], Menu.Draw.Dcolor[2], Menu.Draw.Dcolor[3], Menu.Draw.Dcolor[4]))
			end
			if Menu.Draw.drawDLine then
				DrawLine3D(myHero.x, myHero.y, myHero.z, D.obj.x, D.obj.y, D.obj.z, 2.5, ARGB(Menu.Draw.Dcolor[1], Menu.Draw.Dcolor[2], Menu.Draw.Dcolor[3], Menu.Draw.Dcolor[4]))
			end
		end
	end

	if Menu.Draw.Damage then
		for _, enemy in pairs(enemyHeros) do
			if enemy and enemy.visible and not enemy.dead then
				local myDmg = GetDamage(_Q, enemy) + GetDamage(_Dagger, enemy) + GetDamage(_E, enemy) + (GetDamage(_R, enemy) * 8) + GetDamage(_Ignite, enemy) + GetDamage(_Cutlass, enemy) + GetDamage(_GunBlade, enemy)
				local textLabel = nil
				local line = 2
				local linePosA  = {x = 0, y = 0 }
				local linePosB  = {x = 0, y = 0 }
				local TextPos   = {x = 0, y = 0 }
				local p = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
				if OnScreen(p.x, p.y) then
					if myDmg >= enemy.health then
						myDmg = enemy.health - 1
						textLabel = "Killable"
					else
						textLabel = "Damage"
					end
					myDmg = math.round(myDmg)
					local StartPos, EndPos = GetHPBarPos(enemy)
					local Real_X = StartPos.x + 44
					local Offs_X = (Real_X + ((enemy.health - myDmg) / enemy.maxHealth) * (EndPos.x - StartPos.x - 2))
					if Offs_X < Real_X then
						Offs_X = Real_X 
					end 
					local mytrans = 350 - math.round(255*((enemy.health-myDmg)/enemy.maxHealth))
					if mytrans >= 255 then 
						mytrans = 254 
					end
					local my_bluepart = math.round(400*((enemy.health-myDmg)/enemy.maxHealth))
					if my_bluepart >= 255 then 
						my_bluepart = 254 
					end
					linePosA.x = Offs_X-150
					linePosA.y = (StartPos.y-(30+(line*15)))    
					linePosB.x = Offs_X-150
					linePosB.y = (StartPos.y-10)
					TextPos.x = Offs_X-148
					TextPos.y = (StartPos.y-(30+(line*15)))
					if myDmg > 0 then
						DrawLine(linePosA.x, linePosA.y, linePosB.x, linePosB.y, 1, ARGB(mytrans, 255, my_bluepart, 0))
						DrawText(tostring(myDmg).." "..tostring(textLabel), 15, TextPos.x, TextPos.y , ARGB(mytrans, 255, my_bluepart, 0))
					end
				end
			end
		end
	end
end
---------------------------------------------------------------------------
--[[OnLoad/OnTick]]--
---------------------------------------------------------------------------------

function OnLoad()
	Menu()

	if FileExist(LIB_PATH..'TRPrediction.lua') then require('TRPrediction') end

	Int()

	StartSkin()

	Orb__init()
	FindOrbwalker()

	DelayAction(function()PrintMsg("Welcome <font color=\"#ddff00\"><b>"..GetUser().."</b></font>. Have Fun and Good Luck !") end, 0.5)
end

function OnTick()
	if myHero.dead then return end

	GetCustomTarget()

	if ComboMode() then
		Combo()
	end

	if HarassMode() or Menu.Harass.HarassToggle then
		Harass()
	end

	if LaneclearMode() then
		Laneclear()
		Jungleclear()
	end

	if LasthitMode() then
		LastHit()
	end

	if Menu.Killsteal.Killsteal then
		Killsteal()
	end

	if Menu.Escape.flee then
		Flee()
	end

	if Menu.ItemsSettings.zhonya then
		Zhonya()
	end

	ChancelR()

	buffs = {[5]=Menu.ItemsSettings.QSS.Stun, [7]=Menu.ItemsSettings.QSS.Silence, [8]=Menu.ItemsSettings.QSS.Taunt, [10]=Menu.ItemsSettings.QSS.Fear, [11]=Menu.ItemsSettings.QSS.Roat, [21]=Menu.ItemsSettings.QSS.Charm, [24]=Menu.ItemsSettings.QSS.Suppression, [25]=Menu.ItemsSettings.QSS.Blind, [29]=Menu.ItemsSettings.QSS.KnockUp}
end
