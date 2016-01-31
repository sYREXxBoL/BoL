

version = "1.02"


--[[
  _____            _   _                                 _______ _                          _   _                          __  __          __        
 |  __ \          | | | |                               |__   __| |              /\        | | (_)                        / _| \ \        / /        
 | |__) |_ _ _ __ | |_| |__   ___  ___  _ __    ______     | |  | |__   ___     /  \   _ __| |_ _ ___  __ _ _ __     ___ | |_   \ \  /\  / /_ _ _ __ 
 |  ___/ _` | '_ \| __| '_ \ / _ \/ _ \| '_ \  |______|    | |  | '_ \ / _ \   / /\ \ | '__| __| / __|/ _` | '_ \   / _ \|  _|   \ \/  \/ / _` | '__|
 | |  | (_| | | | | |_| | | |  __/ (_) | | | |             | |  | | | |  __/  / ____ \| |  | |_| \__ \ (_| | | | | | (_) | |      \  /\  / (_| | |   
 |_|   \__,_|_| |_|\__|_| |_|\___|\___/|_| |_|             |_|  |_| |_|\___| /_/    \_\_|   \__|_|___/\__,_|_| |_|  \___/|_|       \/  \/ \__,_|_|   
                                                                                                                                                     
                                                                                                                                                     
--]]                                                                                                                                                  


if myHero.charName ~= "Pantheon" then
	return 
end

	function Hello()

		PrintChat("<font color=\"#4000ff\">Pantheon - The Artisan of War</font>")

	end
	


	function OnLoad()

		Menu()
		Hello()

		if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then Ignite = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then Ignite = SUMMONER_2 end
 		
	end


	function Menu()

		PanthMenu = scriptConfig("Pantheon - The Artisan of War", "Panth")
		
		PanthMenu:addSubMenu("Combo Settings", "combo")
			PanthMenu.combo:addParam("comboKey", "Full Combo Key (SBTW)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte (" "))
			--PanthMenu.combo:addParam("autoSmite", "Use Smite on Target if QWE Available", SCRIPT_PARAM_ONOFF, true)

		
		PanthMenu:addSubMenu("Harass Settings", "harass")
			--PanthMenu.harass:addParam("harassKey", "Harass key (C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			PanthMenu.harass:addParam("autoQ", "Auto-Q when Target in Range", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey('Z'))
			--PanthMenu.harass:addParam("aQT", "Don't Auto-Q if in enemy Turret Range", SCRIPT_PARAM_ONOFF, true)
			
		
		PanthMenu:addSubMenu("Farm Settings", "farming")
			PanthMenu.farming:addParam("farmKey", "Farming Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			PanthMenu.farming:addParam("qFarm", "Last Hit with (Q)", SCRIPT_PARAM_ONOFF, true)

			
		--PanthMenu:addSubMenu("Jungle Clear Settings", "jungle")
			--PanthMenu.jungle:addParam("jungleKey", "Jungle Clear Key (V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			--PanthMenu.jungle:addParam("jungleQ", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
			--PanthMenu.jungle:addParam("jungleW", "Use (W)", SCRIPT_PARAM_ONOFF, true)
			--PanthMenu.jungle:addParam("jungleE", "USe (E)", SCRIPT_PARAM_ONOFF, true)
			
			
		PanthMenu:addSubMenu("KillSteal Settings", "ks")
			PanthMenu.ks:addParam("killSteal", "Use Smart Kill Steal", SCRIPT_PARAM_ONOFF, true)
			PanthMenu.ks:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
				

		PanthMenu:addSubMenu("Draw Settings", "drawing")	
			PanthMenu.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
			PanthMenu.drawing:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
			PanthMenu.drawing:addParam("qDraw", "Draw (Q) Range", SCRIPT_PARAM_ONOFF, true)
			PanthMenu.drawing:addParam("wDraw", "Draw (W) Range", SCRIPT_PARAM_ONOFF, true)
			PanthMenu.drawing:addParam("eDraw", "Draw (E) Range", SCRIPT_PARAM_ONOFF, true)
			PanthMenu.drawing:addParam("rDraw", "Draw (R) Range on the Minimap", SCRIPT_PARAM_ONOFF, true)


		PanthMenu:addSubMenu("Info - Ultimate Alert", "ultAlert")
			PanthMenu.ultAlert:addParam("drawulttext", "Enable Ultimate Alert", SCRIPT_PARAM_ONOFF, true)
			PanthMenu.ultAlert:addParam("alertInfo", "It will print a text in the middle of the screen if an Enemy is Killable", SCRIPT_PARAM_INFO, "")


		PanthMenu:addParam("panthVer", "Version: ", SCRIPT_PARAM_INFO, version)		
	end


	function OnDraw()
		if not myHero.dead then

			if not PanthMenu.drawing.mDraw then

				if (PanthMenu.drawing.qDraw) and qReady then
		            DrawCircle3DQ(myHero.x, myHero.y, myHero.z)
		        end

		        if (PanthMenu.drawing.wDraw) and wReady then
		            DrawCircle3DE(myHero.x, myHero.y, myHero.z)
		        end

		        if (PanthMenu.drawing.eDraw) and eReady then
		            DrawCircle3DW(myHero.x, myHero.y, myHero.z)
		        end

				if (PanthMenu.drawing.rDraw) and rReady then
					DrawCircleMinimapR(myHero.x, myHero.y, myHero.z)
				end        

				if (PanthMenu.ultAlert.drawulttext) and rReady then
					ultAlert()
				end
			end
		end
	end


	function OnTick()

		ComboKey		= PanthMenu.combo.comboKey
		HarassKey		= PanthMenu.harass.harassKey
		FarmKey			= PanthMenu.farming.farmKey
		--JungleClearKey	= PanthMenu.jungle.jungleKey

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

		if PanthMenu.harass.autoQ then
			HerassAutoQ()
		end


		if PanthMenu.ultAlert.drawulttext then
			ultAlert()
		end

        if PanthMenu.ks.killSteal then
            KillSteal()
        end

        if PanthMenu.ks.autoIgnite then
            autoIgnite()
        end
	end


	function Combo()

		if ts.target and ValidTarget(ts.target) then

			if GetDistance(ts.target) <= 600 then
				CastSpell(_Q, ts.target)
			end

			if GetDistance(ts.target) <= 600 then
				CastSpell(_W, ts.target)
			end

			if GetDistance(ts.target) <= 600 then
				if HaveBuffs(ts.target, 5) then
					CastSpell(_E, ts.target)
				end
			end
		end
	end


    function HerassAutoQ()

    	if ts.target and ValidTarget(ts.target) then
			if GetDistance(ts.target) <= 600 then
				CastSpell(_Q, ts.target)
			end
		end
    end


	function Farm()

		enemyMinions:update()

		for each, minions in ipairs(enemyMinions.objects) do

            if minions and ValidTarget(minions) then

            	if GetDistance(minions) > 150 and minions.health <= getDmg("Q",minions,myHero) and PanthMenu.farming.qFarm then
              		CastSpell(_Q, minions)
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

                if GetDistance(enemy) <= 600 and enemy.health <= getDmg("Q",enemy,myHero) then
                    CastSpell(_Q, enemy)
                elseif GetDistance(enemy) <= 600 and enemy.health <= getDmg("W",enemy,myHero) then
                    CastSpell(_W, enemy)
                elseif GetDistance(enemy) <= 600 and enemy.health <= getDmg("E",enemy,myHero) then
                    CastSpell(_E, enemy)
                elseif GetDistance(enemy) <= 600 and enemy.health <= getDmg("Q",enemy,myHero) + getDmg("W",enemy,myHero) then
                	CastSpell(_W, enemy)
                	CastSpell(_Q, enemy)
                elseif GetDistance(enemy) <= 600 and enemy.health <= getDmg("W",enemy,myHero) + getDmg("E",enemy,myHero) then
                	CastSpell(_W, enemy)
                	CastSpell(_E, enemy)
                elseif GetDistance(enemy) <= 600 and enemy.health <= getDmg("Q",enemy,myHero) + getDmg("W",enemy,myHero) + getDmg("E",enemy,myHero) then
                	CastSpell(_W, enemy)
                	CastSpell(_E, enemy)
                	CastSpell(_Q, enemy)
                end       
            end
        end
    end


    function DrawCircle3DQ(x, y, z, radius, width, color, quality)
                radius = radius or 600
                quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 2294967295)
    end

    function DrawCircle3DW(x, y, z, radius, width, color, quality)
                radius = radius or 600
                quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 2294967295)
    end

    function DrawCircle3DE(x, y, z, radius, width, color, quality)
                radius = radius or 600
                quality = quality and 2 * math.pi / quality or 2 * math.pi / (radius / 5)
                local points = {}
                    for theta = 0, 2 * math.pi + quality, quality do
                        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
                        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
                    end
                DrawLines2(points, width or 1, color or 2294967295)
    end

	function DrawCircleMinimapR(x, y, z, radius, width, color, quality)
	    radius = radius or 5500
	    quality = math.min(quality and 2 * math.pi / quality or 2 * math.pi / (radius / 100), 0.785)
	    local points = {}
	    	for theta = 0, 2 * math.pi + quality, quality do
	        	points[#points + 1] = D3DXVECTOR2(GetMinimapX(x + radius * math.cos(theta)), GetMinimapY(z - radius * math.sin(theta)))
	    	end
	    DrawLines2(points, width or 1, color or 4294967295)
	end


	function ultAlert()

		for each, enemy in ipairs(GetEnemyHeroes()) do

	        if enemy and ValidTarget(enemy) then

				if enemy.visible and enemy ~= nil and not enemy.dead then

					if enemy.health < getDmg("R",enemy,myHero) + getDmg("Q",enemy,myHero) + getDmg("W",enemy,myHero) + getDmg("E",enemy,myHero) then
						DrawText("Drop the Man out of "..enemy.charName, 24, 300, 400, 0xFFFF0000)						
					end
				end
			end
		end
	end

	
	function HaveBuffs(unit, buffs)
        for i = 1, unit.buffCount, 1 do      
            local buff = unit:getBuff(i) 
            if buff.valid and buff.type == buffs then
                return true            
            end                    
        end
	end


	function autoIgnite()

		if not Ignite then return end

		for each, enemy in ipairs(GetEnemyHeroes()) do

		       if enemy and ValidTarget(enemy) then

				if enemy.health <= 50 + (20 * myHero.level) and PanthMenu.ks.autoIgnite and myHero:CanUseSpell(Ignite) == READY then
						CastSpell(Ignite, enemy)
				end
			end
		end
	end
