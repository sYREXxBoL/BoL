version = "1.00"


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
			--OlafMenu.combo:addParam("autoSmite", "Use Smite on Target if QWE Available", SCRIPT_PARAM_ONOFF, true)

		
		OlafMenu:addSubMenu("Harass Settings", "harass")
			--OlafMenu.harass:addParam("harassKey", "Harass key (C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			OlafMenu.harass:addParam("autoQ", "Auto-Q when Target in Range", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey('Z'))
			OlafMenu.harass:addParam("autoE", "Auto-E when Target in Range", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey('Z'))
			
		
		OlafMenu:addSubMenu("Farm Settings", "farming")
			OlafMenu.farming:addParam("farmKey", "Farming Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			OlafMenu.farming:addParam("qFarm", "Last Hit with (Q)", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.farming:addParam("eFarm", "Last Hit with (E)", SCRIPT_PARAM_ONOFF, true)


			
		--OlafMenu:addSubMenu("Jungle Clear Settings", "jungle")
			--OlafMenu.jungle:addParam("jungleKey", "Jungle Clear Key (V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			--OlafMenu.jungle:addParam("jungleQ", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
			--OlafMenu.jungle:addParam("jungleW", "Use (W)", SCRIPT_PARAM_ONOFF, true)
			--OlafhMenu.jungle:addParam("jungleE", "USe (E)", SCRIPT_PARAM_ONOFF, true)
			
			
		OlafMenu:addSubMenu("KillSteal Settings", "ks")
			OlafMenu.ks:addParam("killSteal", "Use Smart Kill Steal", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.ks:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
				

		OlafMenu:addSubMenu("Draw Settings", "drawing")	
			OlafMenu.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
			OlafMenu.drawing:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.drawing:addParam("qDraw", "Draw (Q) Range", SCRIPT_PARAM_ONOFF, true)
			OlafMenu.drawing:addParam("eDraw", "Draw (E) Range", SCRIPT_PARAM_ONOFF, true)


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
			end
		end
	end


	function OnTick()

		ComboKey		= OlafMenu.combo.comboKey
		HarassKey		= OlafMenu.harass.harassKey
		FarmKey			= OlafMenu.farming.farmKey
		--JungleClearKey	= OlafMenu.jungle.jungleKey

		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_PHYSICAL)
		target = ts.target
		ts:update()

		
		enemyMinions 	= minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_MAXHEALTH_ASC)
		jungleMinions = minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)

        qReady = myHero:CanUseSpell(_Q) == READY
        wReady = myHero:CanUseSpell(_W) == READY
        eReady = myHero:CanUseSpell(_E) == READY
        rReady = myHero:CanUseSpell(_R) == READY





        if ComboKey then
			Combo(Target)
		end

		if HarassKey then
			Harass(Target)
		end

		if FarmKey then
			Farm()
		end

		if JungleClearKey then
			JungleClear()
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

			if GetDistance(ts.target) <= 126 then
				CastSpell(_W, ts.target)
			end

			if GetDistance(ts.target) <= 325 then
				CastSpell(_E, ts.target)				
			end
		end
	end


	function HerassAutoQ()

		for each, enemy in ipairs(GetEnemyHeroes()) do

            if enemy and ValidTarget(enemy) then

				if ts.target and ValidTarget(ts.target) then
					CastQ(ts.target)					
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

            	if minions.health <= getDmg("Q",minions,myHero) and OlafMenu.farming.qFarm and GetDistance(minions) >= 125 then
              		CastQ(minions)

          		elseif minions.health <= getDmg("E",minions,myHero) and OlafMenu.farming.eFarm and GetDistance(minions) >= 325 then
              		CastSpell(_E, minions)
          		end
            end
        end
    end


    function JungleClear()
		--soon
	end


	function KillSteal()

		for each, enemy in ipairs(GetEnemyHeroes()) do

            if enemy and ValidTarget(enemy) then

                if enemy.health <= getDmg("Q",enemy,myHero) then
   					CastQ(ts.target)
                elseif GetDistance(enemy) <= 325 and enemy.health <= getDmg("E",enemy,myHero) then
                    CastSpell(_E, enemy)
                elseif enemy.health <= getDmg("Q",enemy,myHero) + getDmg("E",enemy,myHero) then
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



	function CastQ(unit)
		if ValidTarget(unit) and myHero:CanUseSpell(_Q) == READY then 
    		local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, 0.25, 50, 1000, 1600, myHero, true)
    		if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 1005 then
    			CastSpell(_Q, CastPosition.x, CastPosition.z)
    		end
 		end
	end
