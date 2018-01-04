if myHero.charName ~= "Katarina" then return end

local version = 1.01

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

if not _G.UOLloaded then
  if FileExist(LIB_PATH .. "/UOL.lua") then
    require("UOL")
  else 
    print("Downloading UOL, please don't press F9")
    DelayAction(function() DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Common/UOL.lua".."?rand="..math.random(1,10000), LIB_PATH.."UOL.lua", function () print("Successfully downloaded UOL. Press F9 twice.") end) end, 3) 
    return
  end
end

local Q = {range = 625}
local W = {range = 340}
local E = {range = 725, speed = math.huge , delay = math.huge, radius = 145}
local R = {range = 550, active = false}

local items = 
{
	[3137] = {Name = "Dervish Blade", nickName = "Dervish Qss", requiresTarget = false, requiresXZ = false, spellRange = nil},
	[3140] = {Name = "Quicksilver Sash", nickName = "Qss", requiresTarget = false, requiresXZ = false, spellRange = nil},
	[3139] = {Name = "Mercurial Scimitar", nickName = "Merc Qss", requiresTarget = false, requiresXZ = false, spellRange = nil},
	[3146] = {Name = "Hextech Gunblade", nickName = "Gunblade", requiresTarget = true, requiresXZ = false, spellRange = 700}
}

local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1500, DAMAGE_PHYSICAL)

local minions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_MAXHEALTH_ASC)
local jungleMinions = minionManager(MINION_JUNGLE, 600, myHero, MINION_SORT_MAXHEALTH_DEC)

local Ignite = nil
if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
	Ignite = SUMMONER_1
elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerdot") then
	Ignite = SUMMONER_2
end

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
			Menu.Combo:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("E", "(E) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("R", "(R) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("RSettings", "> R Settings:", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("RAmount", "min. Enemy Hit", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
			Menu.Combo:addParam("Rkill", "If Killable", SCRIPT_PARAM_ONOFF, true)

		--[[Harass]]--
		Menu:addSubMenu("> Harass", "Harass")
			Menu.Harass:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Harass:addParam("useItems", "Use Items", SCRIPT_PARAM_ONOFF, true)
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


		--[[Escape]]--
		Menu:addSubMenu("> Escape","Escape")
			Menu.Escape:addParam("flee", "Flee Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("G"))
			Menu.Escape:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Escape:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Escape:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, true)

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
			Menu.Draw:addParam("drawD", "(Dagger) - Draw ", SCRIPT_PARAM_ONOFF, true)
			Menu.Draw:addParam("Dcolor", "(Dagger) Color", SCRIPT_PARAM_COLOR, {255, 186, 85, 211})
			Menu.Draw:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("drawPath", "(Path) - Draw ", SCRIPT_PARAM_ONOFF, true)

	--[[Def Item Settings]]
		Menu:addSubMenu("> QSS Settings", "ItemsSettings")
			Menu.ItemsSettings:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.ItemsSettings:addParam("ItemsSettings", "Use Def Item", SCRIPT_PARAM_ONOFF, true)
			Menu.ItemsSettings:addParam("Humanizer", "Humanizer", SCRIPT_PARAM_SLICE, 250, 0, 500, 0)
			Menu.ItemsSettings:addSubMenu("QSS","QSS")
				Menu.ItemsSettings.QSS:addParam("Stun", "Remove Stun", SCRIPT_PARAM_ONOFF, true) --5
				Menu.ItemsSettings.QSS:addParam("Silence", "Remove Silence", SCRIPT_PARAM_ONOFF, true)--7
				Menu.ItemsSettings.QSS:addParam("Taunt", "Remove Taunt", SCRIPT_PARAM_ONOFF, true)--8
				Menu.ItemsSettings.QSS:addParam("Root", "Remove Root", SCRIPT_PARAM_ONOFF, true)--11
				Menu.ItemsSettings.QSS:addParam("Fear", "Remove Dear", SCRIPT_PARAM_ONOFF, true)--10
				Menu.ItemsSettings.QSS:addParam("Charm", "Remove Charm", SCRIPT_PARAM_ONOFF, true)--21
				Menu.ItemsSettings.QSS:addParam("Suppression", "Remove Suppression", SCRIPT_PARAM_ONOFF, true)--24
				Menu.ItemsSettings.QSS:addParam("Blind", "Remove Blind", SCRIPT_PARAM_ONOFF, true)--25
				Menu.ItemsSettings.QSS:addParam("KnockUp", "Remove Knock up", SCRIPT_PARAM_ONOFF, true)--29

	--[[Misc]]--
		Menu:addSubMenu("> Skin SkinChanger", "Misc")
			Menu.Misc:addParam("SkinChanger", "> SkinChanger:", SCRIPT_PARAM_INFO, "")
			Menu.Misc:addParam("UseSkin", "Use Skin", SCRIPT_PARAM_ONOFF, false) 
			Menu.Misc:setCallback("UseSkin", StartSkin)
			Menu.Misc:addParam("SetSkin", myHero.charName.. " Skins", SCRIPT_PARAM_LIST, 1, skins[myHero.charName])
			Menu.Misc:setCallback("SetSkin", StartSkin)

			Menu:addSubMenu("> Orbwalker", "Orbwalker")
			UOL:AddToMenu(Menu.Orbwalker)
end

function OnLoad()
	Menu()
	if FileExist(LIB_PATH..'TRPrediction.lua') then require('TRPrediction') end
	Int()
	StartSkin()
	DelayAction(function()PrintMsg("Welcome <font color=\"#ddff00\"><b>"..GetUser().."</b></font>. Have Fun and Good Luck !") end, 0.5)
end

function OnTick()
	if myHero.dead then return end

	GetCustomTarget()

	if UOL:GetOrbWalkMode() == "Combo" then
		Combo()
	end

	if UOL:GetOrbWalkMode() == "Harass" then
		Harass()
	end

	if UOL:GetOrbWalkMode() == "LaneClear" then
		Laneclear()
		Jungleclear()
	end

	if Menu.Killsteal.Killsteal then
		Killsteal()
	end

	if Menu.Escape.flee then
		Flee()
	end

	ChancelR()

	buffs = {[5]=Menu.ItemsSettings.QSS.Stun, [7]=Menu.ItemsSettings.QSS.Silence, [8]=Menu.ItemsSettings.QSS.Taunt, [10]=Menu.ItemsSettings.QSS.Fear, [11]=Menu.ItemsSettings.QSS.Roat, [21]=Menu.ItemsSettings.QSS.Charm, [24]=Menu.ItemsSettings.QSS.Suppression, [25]=Menu.ItemsSettings.QSS.Blind, [29]=Menu.ItemsSettings.QSS.KnockUp}
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
	local AD = myHero.totalDamage
	local AP = myHero.ap
	local bAD = myHero.addDamage

	if spell == _Q and isReady(_Q) then
		truedamage = myHero:CalcMagicDamage(unit, ((Level(_Q) * 30 + 45) + (AP * 0.6)))
	elseif spell == _E and isReady(_E) then
		truedamage = myHero:CalcMagicDamage(unit, ((Level(_E) * 15) + (AD * 0.6) + (AP * 0.25))) 
	elseif spell == _R and isReady(_R) then
		truedamage = myHero:CalcMagicDamage(unit, (((Level(_R) * 25) - ((Level(_R) - 1) * 12.5)) + (bAD * 0.22) + (AP * 0.19))) -- every 0.166 sec#
	elseif spell == Ignite and isReady(Ignite) then
		truedamage = (50 + (mylvl * 20))
	end
	return truedamage
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
	if isReady(_W) and GetDistanceSqr(unit) < W.range * W.range then
		CastSpell(_W)
	end
end

function GetECast(unit)
	if dgr > 0 then
		CastEDagger(unit)
	elseif dgr < 1 then
		CastETarget(unit)
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

function CastR(unit)
	if isReady(_R) and GetDistanceSqr(unit) < R.range * R.range then
		CastSpell(_R)
	end
end

function ChancelR()
	if R.active and CountEnemyHeroInRange(R.range, myHero) < 1 then
		myHero:MoveTo(mousePos.x, mousePos.z)
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
			end
			CastW(target)
		end

		if (Menu.Combo.Q and Menu.Combo.W and Menu.Combo.E) and Distance <= E.range * E.range and not R.active then
			GetECast(target)
			if Menu.Combo.useItems then
				CastItem(3146, target)
			end
			CastW(target)
			CastQ(target)
		end
		if GetDistanceSqr(myHero, target) < R.range * R.range then
			if (Menu.Combo.R and CountEnemyHeroInRange(W.range, myHero) >= Menu.Combo.RAmount) or Menu.Combo.Rkill and (target.health <= (GetDamage(_R, target) * (RTime(target) / 0.13))) then
				CastR(target)
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
				if dgr > 0 then
					for _, D in pairs(Dagger) do
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

function Jungleclear()
	jungleMinions:update()
	for _, minions in pairs(jungleMinions.objects) do
		if minions and ValidTarget(minions) then
			if minions.name:find("Plant") then return end
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
	for _, enemy in pairs(GetEnemyHeroes()) do
		local realHPi = (enemy.health + (enemy.hpRegen * 0.05))
		if Ignite and isReady(Ignite) then
			local iDamage = (50 + (20 * myHero.level))
			if enemy ~= nil and enemy.valid and GetDistanceSqr(enemy) < 600 * 600 and realHPi <= iDamage then
				CastSpell(Ignite, enemy)
			end
		elseif Menu.Killsteal.Q and isReady(_Q) then
			if enemy ~= nil and enemy.valid and GetDistanceSqr(enemy) < Q.range * Q.range and realHPi <= GetDamage(_Q, enemy) then
				CastQ(enemy)
			end
		elseif Menu.Killsteal.E and isReady(_E) then
			if enemy ~= nil and enemy.valid and GetDistanceSqr(enemy) < E.range * E.range and realHPi <= GetDamage(_E, enemy) then
				GetECast(enemy)
			end


		elseif Menu.Killsteal.Q and isReady(_Q) then


		elseif Menu.Killsteal.Q and isReady(_Q) then
		end
	end
end

function Flee()
	myHero:MoveTo(mousePos.x, mousePos.z)
	if Menu.Escape.W then
		CastSpell(_W)
	end
end

---------------------------------------------------------------------------------
--[[Callback's]]--
---------------------------------------------------------------------------------

function OnCreateObj(obj)
	if obj and obj.valid and obj.networkID and obj.networkID ~= 0 then
        if obj.name:find("Katarina_Base_W_Indicator_Ally") then
            Dagger[obj.networkID] = {obj = Vector(obj)}
            dgr = dgr + 1
        end
    end
end

function OnDeleteObj(obj)
	if obj and obj.valid and obj.networkID and obj.networkID ~= 0 then
        if obj.name:find("Katarina_Base_W_Indicator_Ally") then
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

	if unit and unit.isMe and buff.name:find("katarinarsound") then
		R.active = true
	end
end

function OnRemoveBuff(unit, buff)
	if unit and unit.isMe and buff.name:find("katarinarsound") then
		R.active = false
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
			DrawCircle2(D.obj.x, D.obj.y, D.obj.z, 145, ARGB(Menu.Draw.Dcolor[1], Menu.Draw.Dcolor[2], Menu.Draw.Dcolor[3], Menu.Draw.Dcolor[4]))
			DrawLine3D(myHero.x, myHero.y, myHero.z, D.obj.x, D.obj.y, D.obj.z, 5, ARGB(Menu.Draw.Dcolor[1], Menu.Draw.Dcolor[2], Menu.Draw.Dcolor[3], Menu.Draw.Dcolor[4]))
		end
	end
	local target = ts.target
	if ValidTarget(target) then
		if GetDistanceSqr(myHero, target) < R.range * R.range then
			local end_pos = myHero + (Vector(target) - myHero): normalized() * R.range
			DrawLine3D(end_pos.x, end_pos.y, end_pos.z, target.x, target.y, target.z, 5, ARGB(Menu.Draw.Dcolor[1], Menu.Draw.Dcolor[2], Menu.Draw.Dcolor[3], Menu.Draw.Dcolor[4]))
		end
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
	if GetDistanceSqr(myHero, unit) < R.range * R.range and ValidTarget(unit) then
		for _, champion in ipairs(GetEnemyHeroes()) do
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
		DelayAction(function() DownloadFile("https://raw.githubusercontent.com/sYREXxBoL/BoL/master/Katarina.lua".."?rand"..math.random(1,9999), SCRIPT_PATH.."Katarina.lua", function() PrintMsg("Successfully downloaded the latest version: v"..ServerVersion..".") end) end, 2)
	else
		DelayAction(function()PrintMsg("You are running the latest version: v"..version..".") end, 0.55)
	end
else
	DelayAction(function()PrintMsg("Error finding server version.") end, 0.55)
end
