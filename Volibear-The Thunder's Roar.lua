version = "1.00"

--[[
 __      __   _ _ _                           _   _            _______ _                     _           _       _____                  
 \ \    / /  | (_) |                         | | | |          |__   __| |                   | |         ( )     |  __ \                 
  \ \  / /__ | |_| |__   ___  __ _ _ __      | |_| |__   ___     | |  | |__  _   _ _ __   __| | ___ _ __|/ ___  | |__) |___   __ _ _ __ 
   \ \/ / _ \| | | '_ \ / _ \/ _` | '__|     | __| '_ \ / _ \    | |  | '_ \| | | | '_ \ / _` |/ _ \ '__| / __| |  _  // _ \ / _` | '__|
    \  / (_) | | | |_) |  __/ (_| | |        | |_| | | |  __/    | |  | | | | |_| | | | | (_| |  __/ |    \__ \ | | \ \ (_) | (_| | |   
     \/ \___/|_|_|_.__/ \___|\__,_|_|         \__|_| |_|\___|    |_|  |_| |_|\__,_|_| |_|\__,_|\___|_|    |___/ |_|  \_\___/ \__,_|_|   
                                                                                                                                        
                                                                                                                                        
--]]


if myHero.charName ~= "Volibear" then
	return 
end


	function Hello()
		PrintChat("<font color=\"#4000ff\">Volibear - The Thunder's Roar</font>")
	end


	function OnLoad()

		Menu()
		Hello()

		if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then Ignite = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then Ignite = SUMMONER_2 end

	end


	function Menu()
		
		VoliMenu = scriptConfig("Voli - The Thunder's Roar", "Voli")

		VoliMenu:addSubMenu("Combo Settings", "combo")
			VoliMenu.combo:addParam("ComboKey", "Full Combo Key (SBTW)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte (" "))

		VoliMenu:addSubMenu("Harass Settings", "harass")
			VoliMenu.harass:addParam("autoW", "Auto-W when Target in Range", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey('Z'))
			VoliMenu.harass:addParam("autoE", "Auto-E when Target in Range", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey('Z'))
			VoliMenu.harass:addParam("HarassMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		
		VoliMenu:addSubMenu("Last Hit Settings", "lasthit")
			VoliMenu.lasthit:addParam("LastHitKey", "Farming Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			VoliMenu.lasthit:addParam("wLastHit", "Last Hit with (W)", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.lasthit:addParam("eLastHit", "Last Hit with (E)", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.lasthit:addParam("LastHitMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)


		VoliMenu:addSubMenu("Lane Clear Settings", "lane")
			VoliMenu.lane:addParam("LaneKey", "Jungle Clear Key (V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			VoliMenu.lane:addParam("qLane", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.lane:addParam("wLane", "Use (W) as", SCRIPT_PARAM_LIST, 1, { "Clear", "LastHit" })
			VoliMenu.lane:addParam("eLane", "Use (E)", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.lane:addParam("LaneMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

			
		VoliMenu:addSubMenu("Jungle Clear Settings", "jungle")
			VoliMenu.jungle:addParam("JungleKey", "Jungle Clear Key (V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			VoliMenu.jungle:addParam("qJungle", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.jungle:addParam("wJungle", "Use (W) as", SCRIPT_PARAM_LIST, 1, { "Clear", "LastHit" })
			VoliMenu.jungle:addParam("eJungle", "Use (E)", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.jungle:addParam("JungleMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		VoliMenu:addSubMenu("Flee Settings", "flee")
			VoliMenu.flee:addParam("FleeKey", "Flee Key (G)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
			VoliMenu.flee:addParam("qFlee", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.flee:addParam("eFlee", "Use (E)", SCRIPT_PARAM_ONOFF, true)

		VoliMenu:addSubMenu("KillSteal Settings", "ks")
			VoliMenu.ks:addParam("KillSteal", "Use Smart Kill Steal -", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.ks:addParam("KillStealUlt", "+ Ultimate", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.ks:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)

		--VoliMenu:addSubMenu("Misc Settings", "misc")

		VoliMenu:addSubMenu("Item Settings", "items")
		VoliMenu.items:addParam("General", "Items are Disabled", SCRIPT_PARAM_INFO, "")
		--	VoliMenu.items:addParam("Use", "Use Items", SCRIPT_PARAM_ONOFF, true) 
    		--VoliMenu.items:addParam("UseBRK", "Use BRK", SCRIPT_PARAM_ONOFF, true) 
    		--VoliMenu.items:addParam("UseHydra", "Use Hydra", SCRIPT_PARAM_ONOFF, true) 
    		--VoliMenu.items:addParam("UseYoumu", "Use Youmuu", SCRIPT_PARAM_ONOFF, true)
    		--VoliMenu.items:addParam("UseBilgewaterCutlass","Use BilgewaterCutlass", SCRIPT_PARAM_ONOFF, true)
    		--VoliMenu.items:addParam("UseTitanicHydra","Use Titanic Hydra", SCRIPT_PARAM_ONOFF, true)
				

		VoliMenu:addSubMenu("Draw Settings", "drawing")	
			VoliMenu.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
			VoliMenu.drawing:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.drawing:addParam("wDraw", "Draw (W) Range", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.drawing:addParam("eDraw", "Draw (E) Range", SCRIPT_PARAM_ONOFF, true)
			VoliMenu.drawing:addParam("rDraw", "Draw (R) Range", SCRIPT_PARAM_ONOFF, true)


		VoliMenu:addParam("VoliVer", "Version: ", SCRIPT_PARAM_INFO, version)
	end

	function OnDraw()
		
		if not myHero.dead then

			if not VoliMenu.drawing.mDraw then

				if (VoliMenu.drawing.wDraw) and wReady then
					DrawCircle3DW(myHero.x, myHero.y, myHero.z)
				end

				if (VoliMenu.drawing.eDraw) and eReady then
					DrawCircle3DE(myHero.x, myHero.y, myHero.z)
				end

				if (VoliMenu.drawing.rDraw) and rReady then
					DrawCircle3DR(myHero.x, myHero.y, myHero.z)
				end
			end
		end
	end

	function OnTick()

		ComboKey		= VoliMenu.combo.ComboKey
		LastHitKey		= VoliMenu.lasthit.LastHitKey
		LaneClearKey	= VoliMenu.lane.LaneKey
		JungleClearKey	= VoliMenu.jungle.JungleKey
		FleeKey			= VoliMenu.flee.FleeKey
		HarassW 		= VoliMenu.harass.autoW
		HarassE 		= VoliMenu.harass.autoE


		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_PHYSICAL)
		target = ts.target
		ts:update()

		
		enemyMinions 	= minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_MAXHEALTH_ASC)
		jungleMinions = minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)


        qReady = myHero:CanUseSpell(_Q) == READY
        wReady = myHero:CanUseSpell(_W) == READY
        eReady = myHero:CanUseSpell(_E) == READY
        rReady = myHero:CanUseSpell(_R) == READY

        SpellQ = {name = "Rolling Thunder",			range =  	0	, ready = false, dmg = 0, manaUsage = 0				   }
		SpellW = {name = "Frenzy",					range =  	400	, ready = false, dmg = 0, manaUsage = 0				   }
		SpellE = {name = "Majestic Roar",			range =  	425	, ready = false, dmg = 0, manaUsage = 0				   }
		SpellR = {name = "Thunder Claws",			range =		500	, ready = false, dmg = 0, manaUsage = 0				   }

        SpellQ.manaUsage = myHero:GetSpellData(_Q).mana
		SpellW.manaUsage = myHero:GetSpellData(_W).mana
		SpellE.manaUsage = myHero:GetSpellData(_E).mana
		SpellR.manaUsage = myHero:GetSpellData(_R).mana

		if ComboKey then
			Combo(Target)
		end

		if LastHitKey then
			LastHit()
		end

		if LaneClearKey then
			LaneClear()
		end

		if JungleClearKey then
			JungleClear()
		end

		if FleeKey then
			Flee()
		end

		if VoliMenu.harass.autoW then
			HarassAutoW()
		end

		if VoliMenu.harass.autoE then
			HarassAutoE()
		end

        if VoliMenu.ks.KillSteal then
           	KillSteal()
        end

        if VoliMenu.ks.autoIgnite then
            autoIgnite()
        end
	end




	function Combo()
		
		if ts.target and ValidTarget(ts.target) then

				if ComboKey then
					CastSpell(_Q)
				end

				if GetDistance(ts.target) <= 425 then
					CastSpell(_E)
				end

				if GetDistance(ts.target) <= 400 and wReady then
					CastSpell(_W, ts.target)
				end

				if GetDistance(ts.target) <= 500 then
					CastSpell(_R, ts.target)
				end
		end
	end


	function LastHit()
		
		enemyMinions:update()

		for each, minions in ipairs(enemyMinions.objects) do

            if minions and ValidTarget(minions) then

            	if GetDistance(minions) > 125 and minions.health <= getDmg("W",minions,myHero) and VoliMenu.lasthit.wLastHit and not isLow('Mana', myHero, VoliMenu.lasthit.LastHitMana) then
            		CastSpell(_W, minions)
            	elseif GetDistance(minions) > 125 and minions.health <= getDmg("E",minions,myHero) and VoliMenu.lasthit.eLastHit and not isLow('Mana', myHero, VoliMenu.lasthit.LastHitMana) then
            		CastSpell(_E, minions) 
            	end
            end
        end
    end


	function LaneClear()

		enemyMinions:update()

        for each, minions in ipairs(enemyMinions.objects) do

            if minions and ValidTarget(minions) then

            	if GetDistance(minions) <= 125 and VoliMenu.lane.qLane and not isLow('Mana', myHero, VoliMenu.lane.LaneMana) then
					CastSpell(_Q, minions)
				end

				if GetDistance(minions) <= 400 and VoliMenu.lane.wLane == 1 and not isLow('Mana', myHero, VoliMenu.lane.LaneMana) then
					CastSpell(_W, minions)
				end

				if GetDistance(minions) <= 400 and minions.health <= getDmg("W",minions,myHero) and VoliMenu.lane.wLane == 2 and not isLow('Mana', myHero, VoliMenu.lane.LaneMana) then
					CastSpell(_W, minions)
				end

				if GetDistance(minions) <= 425 and GetMinionsaroundMinion(425, enemyMinions) and VoliMenu.lane.eLane and not isLow('Mana', myHero, VoliMenu.lane.LaneMana) then
					CastSpell(_E, minions)	
				end
			end
		end
	end


	function JungleClear()
		
		jungleMinions:update()

		for _,jm in pairs(jungleMinions.objects) do

            if jm and ValidTarget(jm) then

            	if VoliMenu.jungle.qJungle and not isLow('Mana', myHero, VoliMenu.jungle.JungleMana) then
					CastSpell(_Q, jm)
				end

				if GetDistance(jm) <= 400 and VoliMenu.jungle.wJungle == 1 and not isLow('Mana', myHero, VoliMenu.jungle.JungleMana) then
					CastSpell(_W, jm)
				end

				if GetDistance(jm) <= 400 and jm.health <= getDmg("W",jm,myHero) and VoliMenu.jungle.wJungle == 2 and not isLow('Mana', myHero, VoliMenu.jungle.JungleMana) then
					CastSpell(_W, jm)
				end

				if GetDistance(jm) <= 425 and VoliMenu.jungle.eJungle and not isLow('Mana', myHero, VoliMenu.jungle.JungleMana) then
					CastSpell(_E)	
				end
			end
		end
	end


	function Flee()
		
		local rastoyanie = math.sqrt((mousePos.x-myHero.x)*(mousePos.x-myHero.x) + (mousePos.z-myHero.z)*(mousePos.z-myHero.z))
  		myHero:MoveTo(mousePos.x,mousePos.z)

  		if ts.target and ValidTarget(ts.target) then

	  		if FleeKey then

	  			if GetDistance(ts.target) <= 400 then
	  				CastSpell(_E)
	  			end

	  			if GetDistance(ts.target) <= 200 then
	  				CastSpell(_Q)
	  			end
	  		end
	  	end
	end


	function HarassAutoW()
		
		for each, enemy in ipairs(GetEnemyHeroes()) do

            if enemy and ValidTarget(enemy) then

				if ts.target and ValidTarget(ts.target) then

					if GetDistance(ts.target) <= 400 and not isLow('Mana', myHero, VoliMenu.harass.HarassMana) then
						CastSpell(_W, ts.target)
					end
				end
			end
		end
	end

	function HarassAutoE()
		
		for each, enemy in ipairs(GetEnemyHeroes()) do

            if enemy and ValidTarget(enemy) then

				if ts.target and ValidTarget(ts.target) then

					if GetDistance(ts.target) <= 425 and not isLow('Mana', myHero, VoliMenu.harass.HarassMana) then
						CastSpell(_E)
					end
				end
			end
		end
	end

	function KillSteal()
		
		for each, enemy in ipairs(GetEnemyHeroes()) do

            if enemy and ValidTarget(enemy) then

                if GetDistance(enemy) <= 400 and enemy.health <= getDmg("W",enemy,myHero) then
   					CastSpell(_W, enemy)
                elseif GetDistance(enemy) <= 425 and enemy.health <= getDmg("E",enemy,myHero) then
                    CastSpell(_E, enemy)
                elseif GetDistance(enemy) <= 500 and enemy.health <= getDmg("R",enemy,myHero) and (VoliMenu.ks.KillStealUlt) then
                	CastSpell(_R, enemy)
                elseif GetDistance(enemy) <= 400 and enemy.health <= getDmg("E",enemy,myHero) + getDmg("W",enemy,myHero) then
                	CastSpell(_W, enemy)
                	CastSpell(_E, enemy)
                elseif GetDistance(enemy) <= 400 and enemy.health <= getDmg("W",enemy,myHero) + getDmg("R",enemy,myHero) and (VoliMenu.ks.KillStealUlt) then
                	CastSpell(_W, enemy)
                	CastSpell(_R, enemy)
                elseif GetDistance(enemy) <= 425 and enemy.health <= getDmg("E",enemy,myHero) + getDmg("R",enemy,myHero) and (VoliMenu.ks.KillStealUlt) then
                	CastSpell(_E, enemy)
                	CastSpell(_R, enemy)
                end       
            end
        end
	end

	function autoIgnite()

		if not Ignite then return end

		for each, enemy in ipairs(GetEnemyHeroes()) do

		       if enemy and ValidTarget(enemy) then

				if enemy.health <= 50 + (20 * myHero.level) and VoliMenu.ks.autoIgnite and myHero:CanUseSpell(Ignite) == READY then
						CastSpell(Ignite, enemy)
				end
			end
		end
	end



	function DrawCircle3DW(x, y, z, radius, width, color, quality)
                radius = radius or 400
                quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 2294967295)
    end

    function DrawCircle3DE(x, y, z, radius, width, color, quality)
                radius = radius or 425
                quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 2294967295)
    end

    function DrawCircle3DR(x, y, z, radius, width, color, quality)
                radius = radius or 500
                quality = quality and 2 * math.pi / quality or 3 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 4294967280)
    end


    function isLow(what, unit, slider)
		if what == 'Mana' then
			if unit.mana < (unit.maxMana * (slider / 100)) then
				return true
			else
				return false
			end
		elseif what == 'HP' then
			if unit.health < (unit.maxHealth * (slider / 100)) then
				return true
			else
				return false
			end
		end
	end


	function GetMinionsaroundMinion(range, minions)
		local n = 0
		for _,v in pairs(minions.objects) do
			if GetDistance(v) <= range then n = n+1 end
		end
		return n
	end

