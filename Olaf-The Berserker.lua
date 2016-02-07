version = "1.05"


--[[
   ____  _        __            _______ _            ____                          _             
  / __ \| |      / _|          |__   __| |          |  _ \                        | |            
 | |  | | | __ _| |_   ______     | |  | |__   ___  | |_) | ___ _ __ ___  ___ _ __| | _____ _ __ 
 | |  | | |/ _` |  _| |______|    | |  | '_ \ / _ \ |  _ < / _ \ '__/ __|/ _ \ '__| |/ / _ \ '__|
 | |__| | | (_| | |               | |  | | | |  __/ | |_) |  __/ |  \__ \  __/ |  |   <  __/ |   
  \____/|_|\__,_|_|               |_|  |_| |_|\___| |____/ \___|_|  |___/\___|_|  |_|\_\___|_|   
                                                                                                 
                                                                                                 
--]]

if myHero.charName ~= "Olaf" then
	return 
end


	function Hello()

			PrintChat("<font color=\"#4000ff\">Olaf - The Berserker</font>")

		end
		


		function OnLoad()

			Menu()
			Hello()

			if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then Ignite = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then Ignite = SUMMONER_2 end
	 		
	 		require 'VPrediction'
			VP = VPrediction()
		end



	function Menu()

		OlafMenu = scriptConfig("Olaf - The Berserker", "Olaf")
		
		OlafMenu:addSubMenu("Combo Settings", "combo")
			OlafMenu.combo:addParam("comboKey", "Full Combo Key (SBTW)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte (" ")) 
			OlafMenu.combo:addParam("ultimatec", "Use Auto-Ultimate in Combo", SCRIPT_PARAM_ONOFF, true)

		
		OlafMenu:addSubMenu("Harass Settings", "harass")
			--OlafMenu.harass:addParam("harassKey", "Harass key (C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			OlafMenu.harass:addParam("autoQ", "Auto-Q when Target in Range", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey('Z'))
			OlafMenu.harass:addParam("autoE", "Auto-E when Target in Range", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey('Z'))
			OlafMenu.harass:addParam("harassMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		
		OlafMenu:addSubMenu("Last Hit Settings", "farming")
			OlafMenu.farming:addParam("farmKey", "Farming Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			OlafMenu.farming:addParam("qFarm", "Last Hit with (Q)", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.farming:addParam("eFarm", "Last Hit with (E)", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.farming:addParam("FarmMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)


		OlafMenu:addSubMenu("Lane Clear Settings", "lane")
			OlafMenu.lane:addParam("laneKey", "Jungle Clear Key (V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			OlafMenu.lane:addParam("laneQ", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.lane:addParam("laneW", "Use (W)", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.lane:addParam("laneE", "USe (E)", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.lane:addParam("laneMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

			
		OlafMenu:addSubMenu("Jungle Clear Settings", "jungle")
			OlafMenu.jungle:addParam("jungleKey", "Jungle Clear Key (V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			OlafMenu.jungle:addParam("jungleQ", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.jungle:addParam("jungleW", "Use (W)", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.jungle:addParam("jungleE", "USe (E)", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.jungle:addParam("jungleMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		OlafMenu:addSubMenu("Flee Settings", "flee")
			OlafMenu.flee:addParam("fleeKey", "Flee Key (G)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
			OlafMenu.flee:addParam("fleeq", "Throw Q on Enemy", SCRIPT_PARAM_ONOFF, true)
			
		OlafMenu:addSubMenu("KillSteal Settings", "ks")
			OlafMenu.ks:addParam("killSteal", "Use Smart Kill Steal", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.ks:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)

		OlafMenu:addSubMenu("Misc Settings", "misc")
			OlafMenu.misc:addParam("autopickAxe", "Auto Pick Axe", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.misc:addParam("autopickAxerange", "Auto Pick Axe Range", SCRIPT_PARAM_SLICE, 365, 0, 1000)
				

		OlafMenu:addSubMenu("Draw Settings", "drawing")	
			OlafMenu.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
			OlafMenu.drawing:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.drawing:addParam("qDraw", "Draw (Q) Range", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.drawing:addParam("eDraw", "Draw (E) Range", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.drawing:addParam("axeDraw", "Draw Axe", SCRIPT_PARAM_ONOFF, true)


		OlafMenu:addParam("OlafVer", "Version: ", SCRIPT_PARAM_INFO, version)		
	end


	function OnDraw()

		if not myHero.dead then

			if not OlafMenu.drawing.mDraw then

				if (OlafMenu.drawing.qDraw) and qReady then
		            DrawCircle3DQ(myHero.x, myHero.y, myHero.z)
		        end

		        if (OlafMenu.drawing.eDraw) and eReady then
		            DrawCircle3DE(myHero.x, myHero.y, myHero.z)
		        end

		        if (OlafMenu.drawing.axeDraw) then
		        	if axepos ~= nil then
		        		DrawCircle3DAxe(axepos.x, axepos.y, axepos.z)
		        		DrawLine3DAxe(axepos.x, axepos.y, axepos.z, myHero.x, myHero.y, myHero.z)
		        	end
		        end
			end
		end
	end


	function OnTick()

		ComboKey		= OlafMenu.combo.comboKey
		HarassKey		= OlafMenu.harass.harassKey
		FarmKey			= OlafMenu.farming.farmKey
		LaneClearKey	= OlafMenu.lane.laneKey
		JungleClearKey	= OlafMenu.jungle.jungleKey
		FleeKey			= OlafMenu.flee.fleeKey

		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_PHYSICAL)
		target = ts.target
		ts:update()

		
		enemyMinions 	= minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_MAXHEALTH_ASC)
		jungleMinions = minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)

        qReady = myHero:CanUseSpell(_Q) == READY
        wReady = myHero:CanUseSpell(_W) == READY
        eReady = myHero:CanUseSpell(_E) == READY
        rReady = myHero:CanUseSpell(_R) == READY

        SpellQ = {name = "Spear Shot",			range =  1000	, ready = false, dmg = 0, manaUsage = 0				   }
		SpellW = {name = "Aegis of Zeonia",		range =  125	, ready = false, dmg = 0, manaUsage = 0				   }
		SpellE = {name = "Heartseeker Strike",	range =  325	, ready = false, dmg = 0, manaUsage = 0				   }
		SpellR = {name = "Grand Skyfall",		range = 	0	, ready = false, dmg = 0, manaUsage = 0				   }


        SpellQ.manaUsage = myHero:GetSpellData(_Q).mana
		SpellW.manaUsage = myHero:GetSpellData(_W).mana
		SpellE.manaUsage = myHero:GetSpellData(_E).mana
		SpellR.manaUsage = myHero:GetSpellData(_R).mana



        if ComboKey then
			Combo(Target)
		end

		if HarassKey then
			Harass(Target)
		end

		if FarmKey then
			Farm()
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

		if OlafMenu.misc.autopickAxe and axepos and not FleeKey and not qReady and GetDistance(myHero, axepos) <= (OlafMenu.misc.autopickAxerange) then
            pickingaxe = true
            myHero:MoveTo(tonumber(axepos.x), tonumber(axepos.z))
        end

        if OlafMenu.misc.autopickAxe and axepos and not FleeKey and not qReady and GetDistance(myHero, axepos) > (OlafMenu.misc.autopickAxerange) then
            pickingaxe = false
        end

		if OlafMenu.harass.autoQ then
			HerassAutoQ()
		end

		if OlafMenu.harass.autoE then
			HerassAutoE()
		end

        if OlafMenu.ks.killSteal then
           	KillSteal()
        end

        if OlafMenu.ks.autoIgnite then
            autoIgnite()
        end
	end


	function Combo()

		if ts.target and ValidTarget(ts.target) then

			if ComboKey then
				CastQ(ts.target)
			end

			if GetDistance(ts.target) <= 125 then
				CastSpell(_W, ts.target)
			end

			if GetDistance(ts.target) <= 325 then
				CastSpell(_E, ts.target)				
			end

			ListCC = 3, 5, 8, 10, 11, 21, 22, 24, 28, 29
			if OlafMenu.combo.ultimatec and ImCC() then
				CastSpell(_R)				
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

	function HerassAutoQ()

		for each, enemy in ipairs(GetEnemyHeroes()) do

            if enemy and ValidTarget(enemy) then

            	if not isLow('Mana', myHero, OlafMenu.harass.harassMana) then

					if ts.target and ValidTarget(ts.target) then
						CastQ(ts.target)					
					end
				end
			end
		end
	end


    function HerassAutoE()

    	for each, enemy in ipairs(GetEnemyHeroes()) do

            if enemy and ValidTarget(enemy) then

				if ts.target and ValidTarget(ts.target) then

					if GetDistance(ts.target) <= 325  then
						CastSpell(_E, ts.target)
					
					end
				end
			end
		end
    end


    function Farm()
    	enemyMinions:update()

		for each, minions in ipairs(enemyMinions.objects) do

            if minions and ValidTarget(minions) then

            	if minions.health <= getDmg("Q",minions,myHero) and OlafMenu.farming.qFarm and GetDistance(minions) >= 125 and not isLow('Mana', myHero, OlafMenu.farming.FarmMana) then
              		CastQ(minions)

          		elseif minions.health <= getDmg("E",minions,myHero) and OlafMenu.farming.eFarm and GetDistance(minions) >= 325 then
              		CastSpell(_E, minions)
          		end
            end
        end
    end


    function LaneClear()

    	enemyMinions:update()

        for each, minions in ipairs(enemyMinions.objects) do

            if minions and ValidTarget(minions) then

				if GetDistance(minions) <= 1000 and OlafMenu.lane.laneQ and not isLow('Mana', myHero, OlafMenu.lane.laneMana) then
					FarmQ(minions)
				end

				if GetDistance(minions) <= 125 and OlafMenu.lane.laneW then
					CastSpell(_W, minions)
				end

				if GetDistance(minions) <= 325 and OlafMenu.lane.laneE then
					CastSpell(_E, minions)	
				end
			end
		end
    end


    function JungleClear()

		jungleMinions:update()

        for _,jm in pairs(jungleMinions.objects) do
            if jm and ValidTarget(jm) then

            	if GetDistance(jm) <= 125 and OlafMenu.jungle.jungleW then
					CastSpell(_W, jm)
				end

				if GetDistance(jm) <= 1000 and OlafMenu.jungle.jungleQ and not isLow('Mana', myHero, OlafMenu.jungle.jungleMana) then
					CastQ(jm)
				end

				if GetDistance(jm) <= 325 and OlafMenu.jungle.jungleE then
					CastSpell(_E, jm)	
				end
			end
		end
	end


	function Flee()
		
		local rastoyanie = math.sqrt((mousePos.x-myHero.x)*(mousePos.x-myHero.x) + (mousePos.z-myHero.z)*(mousePos.z-myHero.z))
  		myHero:MoveTo(mousePos.x,mousePos.z)

  		if ts.target and ValidTarget(ts.target) then

			if FleeKey and GetDistance(ts.target) <= 600 then
				CastQ(ts.target)
			end
		end
  	end


	function KillSteal()

		for each, enemy in ipairs(GetEnemyHeroes()) do

            if enemy and ValidTarget(enemy) then

                if GetDistance(enemy) <= 1000 and enemy.health <= getDmg("Q",enemy,myHero) then
   					CastQ(ts.target)
                elseif GetDistance(enemy) <= 325 and enemy.health <= getDmg("E",enemy,myHero) then
                    CastSpell(_E, enemy)
                elseif GetDistance(enemy) <= 325 and enemy.health <= getDmg("Q",enemy,myHero) + getDmg("E",enemy,myHero) then
                	CastQ(ts.target)
                	CastSpell(_E, enemy)
                end       
            end
        end
	end


	function DrawCircle3DQ(x, y, z, radius, width, color, quality)
                radius = radius or 1000
                quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 2294967295)
    end

    function DrawCircle3DE(x, y, z, radius, width, color, quality)
                radius = radius or 325
                quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 2294967295)
    end

    function DrawCircle3DAxe(x, y, z, radius, width, color, quality)
                radius = radius or 125
                quality = quality and 3 * math.pi / quality or 3 * math.pi / (radius / 3)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 3, color or 4294967280)
    end

    function DrawLine3DAxe(x1, y1, z1, x2, y2, z2, width, color)
    	local p = WorldToScreen(D3DXVECTOR3(x1, y1, z1))
    	local px, py = p.x, p.y
    	local c = WorldToScreen(D3DXVECTOR3(x2, y2, z2))
    	local cx, cy = c.x, c.y
    	if OnScreen({ x = px, y = py }, { x = px, y = py }) then
        	DrawLine(cx, cy, px, py, width or 3, color or 4294967295)
    	end
	end


	function autoIgnite()

		if not Ignite then return end

		for each, enemy in ipairs(GetEnemyHeroes()) do

		       if enemy and ValidTarget(enemy) then

				if enemy.health <= 50 + (20 * myHero.level) and OlafMenu.ks.autoIgnite and myHero:CanUseSpell(Ignite) == READY then
						CastSpell(Ignite, enemy)
				end
			end
		end
	end


	function HaveBuff(unit, buffs)
        for i = 1, unit.buffCount, 1 do      
            local buff = unit:getBuff(i) 
            if buff.valid and buff.type == buffs then
                return true            
            end                    
        end
	end


	function CastQ(unit)
		if ValidTarget(unit) and myHero:CanUseSpell(_Q) == READY then 
    		local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, 0.25, 50, 1000, 1600, myHero, true)
    		if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 1005 then
    			CastSpell(_Q, CastPosition.x, CastPosition.z)
    		end
 		end
	end


	function FarmQ(unit)

		if ValidTarget(unit) and myHero:CanUseSpell(_Q) == READY then 
    		local CastPosition, NumHit = GetBestLineFarmPosition(1000, 75, enemyMinions.objects)
    		if CastPosition then
    			CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end

	function GetBestLineFarmPosition(range, width, objects)
	 	local BestPos 
	 	local BestHit = 0
	  	for i, object in ipairs(objects) do
	  		local EndPos = Vector(myHero.pos) + range * (Vector(object) - Vector(myHero.pos)):normalized()
	  		local hit = CountObjectsOnLineSegment(myHero.pos, EndPos, width, objects)
	    		if hit > BestHit then
	    			BestHit = hit
	    			BestPos = Vector(object)
	    		if BestHit == #objects then
	    		break
	    		end
	    	end
	  	end
	  	return BestPos, BestHit
	end

	function CountObjectsOnLineSegment(StartPos, EndPos, width, objects)
		local n = 0
		for i, object in ipairs(objects) do
			local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, object)
			local w = width
				if isOnSegment and GetDistanceSqr(pointSegment, object) < w * w and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, object) then
					n = n + 1
				end
			end
		return n
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


	function OnCreateObj(object)

	    if myHero.dead then return end
	    if object ~= nil and object.name ~= nil and object.name == "olaf_axe_totem_team_id_green.troy" and object.x ~= nil and object.z ~= nil then
	        axepos = object
	    end
	end


	function OnDeleteObj(object)
	    if object ~= nil and object.name ~= nil and object.name == "olaf_axe_totem_team_id_green.troy" and object.x ~= nil and object.z ~= nil then
	        axepos = nil
	        pickingaxe = false
	    end
	end
