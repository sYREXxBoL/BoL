Version = "0.01"

--[[
  _____             _               _______ _            _   _   ____                _____ _           _ _                            
 |  __ \           (_)          _  |__   __| |          | \ | | |  _ \      /\      / ____| |         | | |                           
 | |  | | __ _ _ __ _ _   _ ___(_)    | |  | |__   ___  |  \| | | |_) |    /  \    | |    | |__   __ _| | | ___ _ __   __ _  ___ _ __ 
 | |  | |/ _` | '__| | | | / __|      | |  | '_ \ / _ \ | . ` | |  _ <    / /\ \   | |    | '_ \ / _` | | |/ _ \ '_ \ / _` |/ _ \ '__|
 | |__| | (_| | |  | | |_| \__ \_     | |  | | | |  __/ | |\  | | |_) |  / ____ \  | |____| | | | (_| | | |  __/ | | | (_| |  __/ |   
 |_____/ \__,_|_|  |_|\__,_|___(_)    |_|  |_| |_|\___| |_| \_| |____/  /_/    \_\  \_____|_| |_|\__,_|_|_|\___|_| |_|\__, |\___|_|   
                                                                                                                       __/ |          
                                                                                                                      |___/           
--]]

local unitStacks = {}
MissingLibsa = false

if myHero.charName ~= "Darius" then return end

if not FileExist(LIB_PATH.."/HPrediction.lua") then
	MissingLibsa = true    
	Host = "raw.githubusercontent.com"
	Path = "/Jaikor/BoL-1/master/HTTF/Common/HPrediction.lua"
	PrintChat("<b><font color=\"#FF3300\">Downloading: </font><font color=\"#0097ff\">HPreditction</font><font color=\"#FF3300\">, don't press F9.</font>")
    DelayAction(function()
    	DownloadFile("https://"..Host..Path, LIB_PATH.."HPrediction.lua", 
    	function() 
    		PrintChat("<b><font color=\"#FF3300\">Downloaded: </font><font color=\"#0097ff\">HPreditction</font><font color=\"#FF3300\">, press 2x F9.</font>") 
    	end)
    end,0.15)
end

if not FileExist(LIB_PATH.."/UOL.lua") then
	MissingLibsa = true    
	Host1 = "raw.githubusercontent.com"
	Path1 = "/nebelwolfi/BoL/master/Common/UOL.lua"
	PrintChat("<b><font color=\"#FF3300\">Downloading: </font><font color=\"#0097ff\">UOL</font><font color=\"#FF3300\">, don't press F9.</font>")
    DelayAction(function()
    	DownloadFile("https://"..Host1..Path1, LIB_PATH.."UOL.lua", 
    	function() 
    		PrintChat("<b><font color=\"#FF3300\">Downloaded: </font><font color=\"#0097ff\">UOL</font><font color=\"#FF3300\">, press 2x F9.</font>") 
    	end)
    end,0.15)
end

if MissingLibsa then return end

-- BoL Tracker --
assert(load(Base64Decode("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"), nil, "bt", _ENV))()
TrackerLoad("")
-- BoL Tracker --

local ATTACKITEMS = {"ItemTiamatCleave", "ItemTitanicHydraCleave", "BilgewaterCutlass", "YoumusBlade", "HextechGunblade", "ItemSwordOfFeastAndFamine"}
local ANTICCITEMS = {"QuicksilverSash", "ItemDervishBlade"}
local TIAMAT, TITANIC, CUTLASS, YOUMU, GUNBLADE, BOTRK, QSS, DERVISH = false
local TIAMATSLOT, TITANICSLOT, CUTLASSSLOT, YOUMUSLOT, GUNBLADESLOT, BOTRKSLOT, QSSSLOT, DERVISHSLOT, SMITESLOT
---------------------------------------------------------------------------------
function OnLoad()
	require "UOL"
	require "HPrediction"
	Variables()
	PrintChat("<b><font color=\"#FF3300\">Darius - The <font color=\"#006bff\">N</font> <font color=\"#ffffff\">B</font> <font color=\"#ff2b00\">A</font> Challenger.</font></b>")
	PrintChat("<b><font color=\"#FF3300\">Welcome </font><font color=\"#0097ff\"><u>"..GetUser().."</u></font><font color=\"#FF3300\"> to Dunk City!</font></b>")
	PrintChat("<b><font color=\"#FF3300\">Contact me on Skype: </font> <font color=\"#0097ff\">dj-koby1.</font></b>")
	Menu()
	AutoUpdater()
end
---------------------------------------------------------------------------------
function AutoUpdater()
	HostUpdate = "raw.githubusercontent.com"
	PathUpdate = "/sYREXxBoL/BoL/master/"
	local ServerVersionDATA = GetWebResult(HostUpdate , PathUpdate.."Darius.version")
	local ServerVersion = tonumber(ServerVersionDATA)
	if ServerVersion then
		if ServerVersion > tonumber(Version) then
			PrintChat("<b><font color=\"#FF3300\">Updating: </font><font color=\"#0097ff\">Darius The NBA Challenger</font><font color=\"#FF3300\"> to version: "..ServerVersion..".</font>")
    		DelayAction(function()
    			DownloadFile("https://"..HostUpdate..PathUpdate.."Darius.lua", SCRIPT_PATH..GetCurrentEnv().FILE_NAME, 
    				function()
    					PrintChat("<b><font color=\"#FF3300\">Updated: </font><font color=\"#0097ff\">Darius The NBA Challenger</font><font color=\"#FF3300\"> to version: "..ServerVersion..", press 2x F9</font>") 
    				end)
   			 end,0.15)
		end
	end
end
---------------------------------------------------------------------------------
function OnTick()
	if myHero.dead then return end
	Checks()
	Keys()

	ts:update()
	target = GetCustomTarget()

	QWalker()
end
---------------------------------------------------------------------------------
--[[Menu]]--
---------------------------------------------------------------------------------
function Menu()
	Menu = scriptConfig("Darius: The N B A Challenger", "DariussYREXx")

		UOL:AddToMenu(scriptConfig("OrbWalker", "OrbWalker"))

		--[[Keybindings]]--
		Menu:addSubMenu("> Keybindings", "Keys")
			Menu.Keys:addParam("Fight", "> Fight ", SCRIPT_PARAM_INFO, "")
			Menu.Keys:addParam("keysCombo", "Combo ", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			Menu.Keys:addParam("keysHarass", "Harass ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			Menu.Keys:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Keys:addParam("Farm", "> Farm keys", SCRIPT_PARAM_INFO, "")
			Menu.Keys:addParam("keysClear", "Clear ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			Menu.Keys:addParam("divider1", "", SCRIPT_PARAM_INFO, "")
			Menu.Keys:addParam("Other", "> Other keys", SCRIPT_PARAM_INFO, "")

		--[[Combo]]--
		Menu:addSubMenu("> Combo", "Combo")
			Menu.Combo:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("walker", "Auto Walk (Q)", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("useItems", "Use Items", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("Mana", "> Manage your mana:", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("ManaCheck", "Check your mana before using a spell", SCRIPT_PARAM_ONOFF, false)
			Menu.Combo:addParam("ManaQ","Minimum % of mana to use (Q)", SCRIPT_PARAM_SLICE, 7, 0, 100, 0)
			Menu.Combo:addParam("ManaW","Minimum % of mana to use (W)", SCRIPT_PARAM_SLICE, 7, 0, 100, 0)
			Menu.Combo:addParam("ManaE","Minimum % of mana to use (E)", SCRIPT_PARAM_SLICE, 7, 0, 100, 0)
			Menu.Combo:addParam("ManaR","Minimum % of mana to use (R)", SCRIPT_PARAM_SLICE, 7, 0, 100, 0)
			Menu.Combo:addParam("divider1", "", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Combo:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("E", "(E) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Combo:addParam("R", "(R) - Use ", SCRIPT_PARAM_ONOFF, true)

		--[[Harass]]--
		Menu:addSubMenu("> Harass", "Harass")
			Menu.Harass:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Harass:addParam("walker", "Auto Walk (Q)", SCRIPT_PARAM_ONOFF, true)
			Menu.Harass:addParam("useItems", "Use Items", SCRIPT_PARAM_ONOFF, true)
			Menu.Harass:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Harass:addParam("Mana", "> Manage your mana:", SCRIPT_PARAM_INFO, "")
			Menu.Harass:addParam("ManaCheck", "Check your mana before using a spell", SCRIPT_PARAM_ONOFF, true)
			Menu.Harass:addParam("ManaQ","Minimum % of mana to use (Q)", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
			Menu.Harass:addParam("ManaW","Minimum % of mana to use (W)", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
			Menu.Harass:addParam("divider1", "", SCRIPT_PARAM_INFO, "")
			Menu.Harass:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Harass:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Harass:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, true)

		--[[Killsteal]]--
		Menu:addSubMenu("> Killsteal", "Killsteal")
			Menu.Killsteal:addParam("generalInfo", "> General settings:", SCRIPT_PARAM_INFO, "")
		    Menu.Killsteal:addParam("Killsteal", "Use Killsteal", SCRIPT_PARAM_ONOFF, true)
		    Menu.Killsteal:addParam("Ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
		    Menu.Killsteal:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Killsteal:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Killsteal:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, false)
			Menu.Killsteal:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, false)
			Menu.Killsteal:addParam("R", "(R) - Use ", SCRIPT_PARAM_ONOFF, false)

		--[[Laneclear]]--
		Menu:addSubMenu("> Laneclear", "Laneclear")
			Menu.Laneclear:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Laneclear:addParam("laneclearItems", "Use Items", SCRIPT_PARAM_ONOFF, true)
			Menu.Laneclear:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Laneclear:addParam("Mana", "> Manage your mana:", SCRIPT_PARAM_INFO, "")
			Menu.Laneclear:addParam("ManaCheck", "Check your mana before using a spell", SCRIPT_PARAM_ONOFF, true)
			Menu.Laneclear:addParam("ManaQ","Minimum % of mana to use (Q)", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
			Menu.Laneclear:addParam("ManaW","Minimum % of mana to use (W)", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
			Menu.Laneclear:addParam("divider1", "", SCRIPT_PARAM_INFO, "")
			Menu.Laneclear:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Laneclear:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Laneclear:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, true)
			
		--[[Jungleclear]]--
		Menu:addSubMenu("> Jungleclear", "Jungleclear")
			Menu.Jungleclear:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Jungleclear:addParam("jungleItems", "Use Items", SCRIPT_PARAM_ONOFF, true)
			Menu.Jungleclear:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Jungleclear:addParam("Mana", "> Manage your mana:", SCRIPT_PARAM_INFO, "")
			Menu.Jungleclear:addParam("ManaCheck", "Check your mana before using a spell", SCRIPT_PARAM_ONOFF, true)
			Menu.Jungleclear:addParam("ManaQ","Minimum % of mana to use (Q)", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
			Menu.Jungleclear:addParam("ManaW","Minimum % of mana to use (W)", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
			Menu.Jungleclear:addParam("divider1", "", SCRIPT_PARAM_INFO, "")
			Menu.Jungleclear:addParam("Spell", "> Choose your spells:", SCRIPT_PARAM_INFO, "")
			Menu.Jungleclear:addParam("Q", "(Q) - Use ", SCRIPT_PARAM_ONOFF, true)
			Menu.Jungleclear:addParam("W", "(W) - Use ", SCRIPT_PARAM_ONOFF, true)

		--[[Drawings]]--
		Menu:addSubMenu("> Drawings", "Draw")
			Menu.Draw:addParam("General", "> General settings:", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("divider", "", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("DrawStacks", "Draw Passive Stacks", SCRIPT_PARAM_ONOFF, true)
			Menu.Draw:addParam("drawPassivColor", "Stack's Color:", SCRIPT_PARAM_COLOR, Passiv.Color)
			Menu.Draw:addParam("drawPassiv5Color", "Finish Him Color:", SCRIPT_PARAM_COLOR, Passiv5.Color)
			Menu.Draw:addParam("divider1", "", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("drawSpellsReady", "Draw spells only if not on cooldown", SCRIPT_PARAM_ONOFF, true)
			Menu.Draw:addParam("drawCircleSize", "Choose the strength of the circle", SCRIPT_PARAM_SLICE, 1, 1, 10, 0)
			Menu.Draw:addParam("divider2", "", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("Spell", "> Draw range of spell:", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("drawQrange", "(Q) - Draw ", SCRIPT_PARAM_ONOFF, true)
			Menu.Draw:addParam("drawErange", "(E) - Draw ", SCRIPT_PARAM_ONOFF, true)
			Menu.Draw:addParam("drawRrange", "(R) - Draw ", SCRIPT_PARAM_ONOFF, true)
			Menu.Draw:addParam("divider3", "", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("Color", "> Draw color of spell:", SCRIPT_PARAM_INFO, "")
			Menu.Draw:addParam("drawQrangeColor", "(Q) Color:", SCRIPT_PARAM_COLOR, Q.Color)
			Menu.Draw:addParam("drawErangeColor", "(E) Color:", SCRIPT_PARAM_COLOR, E.Color)
			Menu.Draw:addParam("drawRrangeColor", "(R) Color:", SCRIPT_PARAM_COLOR, R.Color)
		Menu.Draw:addSubMenu("> Healthbar damage", "HealthbarDamage")
    		Menu.Draw.HealthbarDamage:addParam("drawLineHight", "Startingheight of the lines: ", SCRIPT_PARAM_SLICE, 2,1,5,0)
    		Menu.Draw.HealthbarDamage:addParam("drawSmartDmg", "Draw (Q)+(W)+(E)+(R) damage: ", SCRIPT_PARAM_ONOFF, true)
		   	Menu.Draw.HealthbarDamage:addParam("divider", "", SCRIPT_PARAM_INFO, "")
		   	Menu.Draw.HealthbarDamage:addParam("drawPDmg", "Draw Passiv damage:", SCRIPT_PARAM_ONOFF, false)
		   	Menu.Draw.HealthbarDamage:addParam("drawQDmg", "Draw (Q) damage:", SCRIPT_PARAM_ONOFF, false)
		   	Menu.Draw.HealthbarDamage:addParam("drawWDmg", "Draw (W) damage:", SCRIPT_PARAM_ONOFF, false)
		   	Menu.Draw.HealthbarDamage:addParam("drawEDmg", "Draw (E) damage:", SCRIPT_PARAM_ONOFF, false)
		   	Menu.Draw.HealthbarDamage:addParam("drawRDmg", "Draw (R) damage:", SCRIPT_PARAM_ONOFF, false)
			

		--[[Prediction]]--
		Menu:addSubMenu("> Prediction", "Prediction")
			Menu.Prediction:addParam("Prediction", "Choose your prediction", SCRIPT_PARAM_LIST, 2, {"More Soon", "HPrediction"})
			--Menu.Prediction:addParam("divider","", SCRIPT_PARAM_INFO, "")
			--Menu.Prediction:addParam("VPrediction","> VPrediction", SCRIPT_PARAM_INFO, "")
			--Menu.Prediction:addParam("VPredictionHitchanceE", "Hitchance of (E): ", SCRIPT_PARAM_SLICE, 2,1,5,0)
			Menu.Prediction:addParam("divider1","", SCRIPT_PARAM_INFO, "")
			Menu.Prediction:addParam("HPrediction","> HPrediction", SCRIPT_PARAM_INFO, "")
			Menu.Prediction:addParam("HPredictionHitchanceE", "Hitchance of (E): ", SCRIPT_PARAM_SLICE, 1.5, 1, 3, 2)

		Menu:addParam("info1", "", SCRIPT_PARAM_INFO, "")
  		Menu:addParam("info2", "Creator:", SCRIPT_PARAM_INFO, "sYREXx")
  		Menu:addParam("info3", "Skype:", SCRIPT_PARAM_INFO, "dj-koby1")
end
---------------------------------------------------------------------------------
--[[Variables]]--
---------------------------------------------------------------------------------
function Variables()
	Passiv 	= 	{Color = {255,100,200,200}}
	Passiv5	= 	{Color = {255,100,200,200}}
	Q 		= 	{Color = {255,100,200,200}, range = 425,   radius = 425,		ready = false}
	W 		= 	{Color = {255,100,200,200}, range = 200, 	ready = false}
	E 		= 	{Color = {255,100,200,200}, range = 550, 	speed = math.huge, 	delay =	0.250, 	width = 100, 	ready = false}
	R 		= 	{Color = {255,100,200,200}, range = 460,	ready = false}

	lastCastQ = 0

	HP = HPrediction()
	HPrediction_E = HPSkillshot({type = "DelayArc", delay = 0.5, range = 550, radius = 300, speed = 1500, width = 300, angle =35, collision=false})
	--E = { range = 530, width = 300, speed = 1500, delay = 0.5, collision=false }

	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then Ignite = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then Ignite = SUMMONER_2 end

	if myHero:GetSpellData(SUMMONER_1).name:find("smite") then Smite = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("smite") then Smite = SUMMONER_2 end

	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_PHYSICAL)
	Target = ts.target
	ts:update()

	enemy = GetEnemyHeroes()
end
---------------------------------------------------------------------------------
--[[Skill Checks]]--
---------------------------------------------------------------------------------
function Checks()
	Q.ready = myHero:CanUseSpell(_Q) == READY
	W.ready = myHero:CanUseSpell(_W) == READY
	E.ready = myHero:CanUseSpell(_E) == READY
	R.ready = myHero:CanUseSpell(_R) == READY
	IgniteReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)

	Q.level = myHero:GetSpellData(_Q).level
	W.level = myHero:GetSpellData(_W).level
	E.level = myHero:GetSpellData(_E).level
	R.level = myHero:GetSpellData(_R).level

	enemyMinions 	= minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_MAXHEALTH_ASC)
	jungleMinions 	= minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)
end

function DamageCalculation()
	local QLvL 		= GetSpellData(_Q).level
	local WLvL 		= GetSpellData(_W).level
	local RLvL 		= GetSpellData(_R).level
	local MyLvL		= myHero.level
	local AdDamage 	= myHero.totalDamage
	local AddDamage = myHero.addDamage
	local Stacks 	= GetStacks(unit) --Stacks()

	local PDamage 	= Stacks * (9+ MyLvL +ADdmg * 0.3)
	local QDamage 	= 10 + (QLvL * 30) + (AddDamage * (0.9 + (QLvL * 0.1)))
	local WDamage 	= AdDamage + (AdDamage * 0.4)
	local RDamage 	= ((RLvL * 100) + (AddDamage * 0.75)) + ( Stacks * ((RLvL * 20) + (AddDamage * 0.15)))
end
---------------------------------------------------------------------------------
--[[Keybindings]]--
---------------------------------------------------------------------------------
function Keys()
	ComboKey 	= 	Menu.Keys.keysCombo
	HarassKey 	=  	Menu.Keys.keysHarass
	LaneKey 	=  	Menu.Keys.keysClear
	JungleKey	=  	Menu.Keys.keysClear

	if Menu.Combo.useItems then
		FindItems()
  	end

	if ComboKey then
		Combo()
	end

	if HarassKey then
		Harass()
	end

	if LaneKey then
		LaneClear()
	end

	if JungleKey then
		JungleClear()
	end

	if Menu.Killsteal.KillSteal then
        KillSteal()
    end
end
---------------------------------------------------------------------------------
--[[Draws]]--
---------------------------------------------------------------------------------
function ARGBT(t)
	return ARGB(t[1], t[2], t[3], t[4])
end

function OnDraw()	
	if myHero.dead then return end
	if Menu.Draw.DrawStacks then DrawStacks() end
	if Menu.Draw.drawQrange and ((Menu.Draw.drawSpellsReady and Q.ready) or Menu.Draw.drawSpellsReady == false) then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, Q.range, Menu.Draw.drawCircleSize, ARGBT((Menu.Draw.drawQrangeColor)))
	end
	if Menu.Draw.drawErange and ((Menu.Draw.drawSpellsReady and E.ready) or Menu.Draw.drawSpellsReady == false) then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, E.range, Menu.Draw.drawCircleSize, ARGBT((Menu.Draw.drawErangeColor)))
	end
	if Menu.Draw.drawRrange and ((Menu.Draw.drawSpellsReady and R.ready) or Menu.Draw.drawSpellsReady == false) then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, R.range, Menu.Draw.drawCircleSize, ARGBT((Menu.Draw.drawRrangeColor)))
	end
end

function DrawStacks()
	for _, unit in pairs(GetEnemyHeroes()) do
		if ValidTarget(unit, 1500) then
	      		local barPos = GetHPBarPos(unit)
				if unitStacks[unit.networkID] == nil or unitStacks[unit.networkID] == 0 then return end
				if GetStacks(unit) < 5 then
				    DrawTextA(""..GetStacks(unit).."", 20, barPos.x+135, barPos.y-17, ARGBT((Menu.Draw.drawPassivColor)))
				elseif GetStacks(unit) >= 5 then
     				DrawTextA("FINISH HIM", 20, barPos.x+135, barPos.y-17, ARGBT((Menu.Draw.drawPassiv5Color)))
			end
		end
	end
end

function GetHPBarPos(enemy)
 	enemy.barData = {PercentageOffset = {x = -0.05, y = 0}}
  	local barPos = GetUnitHPBarPos(enemy)
  	local barPosOffset = GetUnitHPBarOffset(enemy)
  	local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
  	local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
  	local BarPosOffsetX = 171
  	local BarPosOffsetY = 46
  	local CorrectionY = 39
  	local StartHpPos = 31

  	barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos)
  	barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)

 	local StartPos = Vector(barPos.x , barPos.y, 0)
  	local EndPos = Vector(barPos.x + 108 , barPos.y , 0)
  	return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end
---------------------------------------------------------------------------------
--[[Skill's]]--
---------------------------------------------------------------------------------

--[[Q Settings]]--
function CastQ(unit)
	if not Q.ready or (GetDistance(unit) >= Q.range) then return end
	if ValidTarget(unit) then
		CastSpell(_Q, unit)
	end
end

function CalcVector(source,target)
	if not target then return end
 	local V = Vector(source.x, source.y, source.z)
 	local V2 = Vector(target.x, target.y, target.z)
 	local vec = V-V2
 	local vec2 = vec:normalized()
 	return vec2
end

function QWalker()
	if target ~= nil then
		if (os.clock() - lastCastQ) < 0.75 then
			local E = myHero-(Vector(ts.target)-myHero): normalized()*(205+410)/2 
			if GetDistance(ts.target) >= (205+435)/2 then
				myHero:MoveTo(target.x, target.z)
			elseif GetDistance(ts.target) <= (205+435)/2 then
				myHero:MoveTo(E.x, E.z)
			end
		end
	end
end

--[[W Settings]]--
function CastW(unit)
	if not W.ready or (GetDistance(unit) > W.range) then return end
	if ValidTarget(unit) then
		CastSpell(_W)
	end
end

--[[E Settings]]--
function CastE(unit)
	if not E.ready or GetDistance(unit) > E.range and GetDistance(unit) <= (350/2) then return end
	if ValidTarget(unit) and not Q.ready then
		if Menu.Prediction.Prediction == 2 then
			local Pos, HitChance = HP:GetPredict(HPrediction_E, unit, myHero)
	 		if Pos and HitChance >= Menu.Prediction.HPredictionHitchanceE then
				CastSpell(_E, Pos.x, Pos.z)
			end
		end
	end
end

--[[R Settings]]--
function CastR(target)
	if not R.ready or (GetDistance(target) > R.range) then return end
	local Enemies = GetEnemyHeroes()
    for i,enemy in pairs(Enemies) do
    	local RLvL 		= GetSpellData(3).level
		local AddDamage = myHero.addDamage
		local Stacks 	= GetStacks(unit)
		local RDamage = ((RLvL*100) + (AddDamage*0.75)) + ( Stacks * ((RLvL*20) + (AddDamage*0.15)))
		if enemy ~= nil and ValidTarget(enemy) then
			if enemy.health <= RDamage then
				CastSpell(_R, enemy)
			end
		end
	end
end
---------------------------------------------------------------------------------
--[[Mode's]]--
---------------------------------------------------------------------------------
function Combo(enemy)
	ListCC = 3, 5, 8, 10, 11, 21, 22, 24, 28, 29
    if Menu.Combo.useItems and ImCC() then
    	CastQSS()
    	CastDervish()
    end
	if ValidTarget(ts.target) then
		if Menu.Combo.W and ManaCheck(Menu.Combo.ManaW, Menu.Combo.ManaCheck) then CastW(ts.target) end
		CastTITANIC() 
		CastTiamat() 
		CastYoumu() 
		CastBOTRK(ts.target)
		CastCutlass(ts.target)
		if Menu.Combo.Q and ManaCheck(Menu.Combo.ManaQ, Menu.Combo.ManaCheck) then CastQ(ts.target) end
		if Menu.Combo.E and ManaCheck(Menu.Combo.ManaE, Menu.Combo.ManaCheck) then CastE(ts.target) end
		if Menu.Combo.R and ManaCheck(Menu.Combo.ManaR, Menu.Combo.ManaCheck) then CastR(ts.target) end
	end
end
---------------------------------------------------------------------------------
function Harass()
	if ValidTarget(ts.target) then
		if Menu.Harass.Q and ManaCheck(Menu.Harass.ManaQ, Menu.Harass.ManaCheck) then
			CastQ(ts.target)
		end
		if Menu.Harass.W and ManaCheck(Menu.Harass.ManaW, Menu.Harass.ManaCheck) then
			CastW(ts.target)
		end
	end
end
---------------------------------------------------------------------------------
function KillSteal()
	local Enemies = GetEnemyHeroes()
    for i,enemy in pairs(Enemies) do
    	local QLvL 		= GetSpellData(_Q).level
		local WLvL 		= GetSpellData(_W).level
		local RLvL 		= GetSpellData(_R).level
		local MyLvL		= myHero.level
		local AdDamage 	= myHero.totalDamage
		local AddDamage = myHero.addDamage
		local Stacks 	= GetStacks(unit) --Stacks()

		local PDamage 	= Stacks * (9+ MyLvL +ADdmg * 0.3)
		local QDamage 	= 10 + (QLvL * 30) + (AddDamage * (0.9 + (QLvL * 0.1)))
		local WDamage 	= AdDamage + (AdDamage * 0.4)
		local RDamage 	= ((RLvL * 100) + (AddDamage * 0.75)) + ( Stacks * ((RLvL * 20) + (AddDamage * 0.15)))
        if enemy ~= nil and ValidTarget(enemy) then
           	if enemy.health <= QDamage and Menu.Killsteal.Q then
               if GetDistance(enemy) < Q.range then
			        CastQ(enemy)
			    end
		    end
		   	if enemy.health <= WDamage and Menu.Killsteal.W then
				if GetDistance(enemy) < 200 then
					CastE(enemy)
			       	CastW(enemy)
				end
	     	end
	     	if enemy.health <= RDamage and Menu.Killsteal.R then
               if GetDistance(enemy) < R.range then
			        CastQ(enemy)
			    end
		    end
			if IgniteReady and enemy.health <= getDmg("IGNITE", enemy, myHero) and Menu.Killsteal.Ignite then
				if GetDistance(enemy) < 600 then 
					CastSpell(ignite, enemy)
				end
			end
		end
    end
end
---------------------------------------------------------------------------------
function LaneClear()
	enemyMinions:update()
	for _, minions in ipairs(enemyMinions.objects) do
		if minions and ValidTarget(minions) then
			if Menu.Laneclear.Q and ManaCheck(Menu.Laneclear.ManaQ, Menu.Laneclear.ManaCheck) then
				local BestPos, BestHit = GetFarmPosition(Q.range, Q.radius-100)
				if BestPos and BestHit and BestHit > 3 then
					if GetDistance(BestPos) < Q.range then
						CastSpell(_Q)
					end
				end
			end
			if Menu.Laneclear.W and ManaCheck(Menu.Laneclear.ManaW, Menu.Laneclear.ManaCheck) then CastW(minions) end
		end
	end
end
---------------------------------------------------------------------------------
function JungleClear()
	jungleMinions:update()
	for _,jm in pairs(jungleMinions.objects) do
		if ValidTarget(jm) then
			if Menu.Jungleclear.Q and ManaCheck(Menu.Jungleclear.ManaQ, Menu.Jungleclear.ManaCheck) then
				CastQ(jm)
			end
			if Menu.Jungleclear.W and ManaCheck(Menu.Jungleclear.ManaW, Menu.Jungleclear.ManaCheck) then
				CastW(jm)
			end
		end
	end
end
---------------------------------------------------------------------------------
--[[Mode's End]]--
---------------------------------------------------------------------------------
function OnProcessSpell(unit, spell)
	--print(spell.name)
	if unit == myHero and spell.name:find("DariusCleave") and ((Menu.Combo.walker and ComboKey) or (Menu.Harass.walker and HarassKey)) then
		UOL:SetMovement(false)
		DelayAction(function() UOL:SetMovement(true) end, 0.75)
		lastCastQ = os.clock()
	end
end

function OnProcessAttack(unit, spell)
    if unit and spell and unit.isMe and spell.name:lower():find("attack") and myHero:CanUseSpell(_W) and (ComboKey or HarassKey) then
        CastSpell(_W)
    end
end
---------------------------------------------------------------------------------
function ManaCheck(ManaValue, ManaMenu)
	if not ManaMenu then return true
	else
		if ManaValue <= 100 * myHero.mana / myHero.maxMana
			then return true
		else
			return false
		end
	end
end
---------------------------------------------------------------------------------
function GetCustomTarget()
	ts:update()	
	if ValidTarget(ts.target) and ts.target.type == myHero.type then
		return ts.target
	else
		return nil
	end
end

  function GetFarmPosition(range, width)
    local BestPos 
    local BestHit = 0
    local objects = enemyMinions.objects
    for i, object in pairs(objects) do
      local hit = CountObjectsNearPos(object.pos or object, range, width, objects)
      if hit > BestHit and GetDistanceSqr(object) < range * range then
        BestHit = hit
        BestPos = Vector(object)
        if BestHit == #objects then
          break
        end
      end
    end
    return BestPos, BestHit
  end

  function CountObjectsNearPos(pos, range, radius, objects)
    local n = 0
    for i, object in pairs(objects) do
      if GetDistance(pos, object) <= radius then
        n = n + 1
      end
    end
    return n
  end

---------------------------------------------------------------------------------
--[[PassiveCheck]]--
---------------------------------------------------------------------------------
function OnUpdateBuff(Unit, Buff, Stacks)
   if Unit and Buff and Unit.team ~= myHero.team and Unit.type == myHero.type and Buff.name == "DariusHemo" then
     	unitStacks[Unit.networkID] = Stacks
   end
end
 
function OnRemoveBuff(Unit, Buff)
   if Unit and Buff and Unit.team ~= myHero.team and Unit.type == myHero.type and Buff.name == "DariusHemo" then
		unitStacks[Unit.networkID] = 0
   end
end

function GetStacks(unit)
	for _, units in pairs(GetEnemyHeroes()) do
		if unit and ValidTarget(unit) then
   			return unitStacks[unit.networkID] or 0
   		elseif not unit and ValidTarget(units) then
   			return unitStacks[units.networkID] or 0
   		end
   	end
end
---------------------------------------------------------------------------------
--[[Items]]--
---------------------------------------------------------------------------------
--[[SpellReady]]--
function SpellReady(spell)
  return myHero:CanUseSpell(spell) == READY
end
--[[FindItems]]--
function FindItems()
  if (Menu.Combo.useItems) then
    GetTiamat()
  end
  if (Menu.Combo.useItems) then
    GetTitanic()
  end
  if (Menu.Combo.useItems) then
    GetBOTRK()
  end
  if (Menu.Combo.useItems) then
    GetCutlass()
  end
  if (Menu.Combo.useItems) then
    GetYoumu()
  end
  if (Menu.Combo.useItems) then
    GetGunblade()
  end
  if (Menu.Combo.useItems) then
    GetQSS()
  end
  if (Menu.Combo.useItems) then
    GetDervish()
  end
end
--[[Get Items]]--
function GetTiamat()
  local slot = GetItem(ATTACKITEMS[1])
  if (slot ~= nil) then
    TIAMAT = true
    TIAMATSLOT = slot
  else
    TIAMAT = false
  end
end
function GetTitanic()
  local slot = GetItem(ATTACKITEMS[2])
  if (slot ~= nil) then
    TITANIC = true
    TITANICSLOT = slot
  else
    TITANIC = false
  end
end
function GetCutlass()
  local slot = GetItem(ATTACKITEMS[3])
  if (slot ~= nil) then
    CUTLASS = true
    CUTLASSSLOT = slot
  else
    CUTLASS = false
  end
end
function GetYoumu()
  local slot = GetItem(ATTACKITEMS[4])
  if (slot ~= nil) then
    YOUMU = true
    YOUMUSLOT = slot
  else
    YOUMU = false
  end
end
function GetGunblade()
  local slot = GetItem(ATTACKITEMS[5])
  if (slot ~= nil) then
    GUNBLADE = true
    GUNBLADESLOT = slot
  else
    GUNBLADE = false
  end
end
function GetBOTRK()
  local slot = GetItem(ATTACKITEMS[6])
  if (slot ~= nil) then
    BOTRK = true
    BOTRKSLOT = slot
  else
    BOTRK = false
  end
end
function GetQSS()
  local slot = GetItem(ANTICCITEMS[1])
  if (slot ~= nil) then
    QSS = true
    QSSSLOT = slot
  else
    QSS = false
  end
end
function GetDervish()
  local slot = GetItem(ANTICCITEMS[2])
  if (slot ~= nil) then
    DERVISH = true
    DERVISHSLOT = slot
  else
    DERVISH = false
  end
end
--[[Cast Items]]--
function CastTiamat()
  if TIAMAT and (GetDistance(ts.target)) <= 350 then
    if (SpellReady(TIAMATSLOT)) then
      CastSpell(TIAMATSLOT)
    end
  end
end
function CastYoumu()
  if YOUMU then
    if (SpellReady(YOUMUSLOT)) then
      CastSpell(YOUMUSLOT)
    end
  end
end
function CastBOTRK(target)
  if BOTRK and (GetDistance(ts.target)) <= 550 then
    if (SpellReady(BOTRKSLOT)) then
      CastSpell(BOTRKSLOT, target)
    end
  end
end
function CastTITANIC()
  if TITANIC then
    if (SpellReady(TITANICSLOT)) then
      CastSpell(TITANICSLOT)
    end
  end
end
function CastCutlass(target)
  if CUTLASS and (GetDistance(ts.target)) <= 550 then
    if (SpellReady(CUTLASSSLOT)) then
      CastSpell(CUTLASSSLOT, target)
    end
  end
end
function CastGunblade(target)
  if GUNBLADE and (GetDistance(ts.target)) <= 700 then
    if (SpellReady(GUNBLADESLOT)) then
      CastSpell(GUNBLADESLOT, target)
    end
  end
end
function CastQSS()
  if QSS then
    if SpellReady(QSSSLOT) then
      CastSpell(QSSSLOT)
    end
  end
end
function CastDervish()
  if DERVISH then
    if SpellReady(DERVISHSLOT) then
      CastSpell(DERVISHSLOT)
    end
  end
end
--[[Find Slot]]--
function FindSlotByName(name)
  if name ~= nil then
    for i=0, 12 do
      if string.lower(myHero:GetSpellData(i).name) == string.lower(name) then
        return i
      end
    end
  end  
  return nil
end
--[[Get Item]]--
function GetItem(name)
  local slot = FindSlotByName(name)
  return slot 
end
---------------------------------------------------------------------------------
--[[CC Check]]--
---------------------------------------------------------------------------------
function HaveBuff(unit, buffs)
    for i = 1, unit.buffCount, 1 do      
        local buff = unit:getBuff(i) 
        if buff.valid and buff.type == buffs then
            return true            
        end                    
    end
end

function ImCC()
    if HaveBuff(myHero, 3) then return true
    elseif HaveBuff(myHero, 5) then return true
    elseif HaveBuff(myHero, 8) then return true
    elseif HaveBuff(myHero, 10) then return true
    elseif HaveBuff(myHero, 11) then return true
    elseif HaveBuff(myHero, 21) then return true
    elseif HaveBuff(myHero, 22) then return true
    elseif HaveBuff(myHero, 24) then return true
    elseif HaveBuff(myHero, 28) then return true
    elseif HaveBuff(myHero, 29) then return true
    else
    return false
	end
end
---------------------------------------------------------------------------------
--[[End]]--
---------------------------------------------------------------------------------
