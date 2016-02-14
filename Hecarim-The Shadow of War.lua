version = "1.00"

--[[
  _    _                     _                      _______ _             _____ _               _                        __  __          __        
 | |  | |                   (_)                    |__   __| |           / ____| |             | |                      / _| \ \        / /        
 | |__| | ___  ___ __ _ _ __ _ _ __ ___    ______     | |  | |__   ___  | (___ | |__   __ _  __| | _____      __   ___ | |_   \ \  /\  / /_ _ _ __ 
 |  __  |/ _ \/ __/ _` | '__| | '_ ` _ \  |______|    | |  | '_ \ / _ \  \___ \| '_ \ / _` |/ _` |/ _ \ \ /\ / /  / _ \|  _|   \ \/  \/ / _` | '__|
 | |  | |  __/ (_| (_| | |  | | | | | | |             | |  | | | |  __/  ____) | | | | (_| | (_| | (_) \ V  V /  | (_) | |      \  /\  / (_| | |   
 |_|  |_|\___|\___\__,_|_|  |_|_| |_| |_|             |_|  |_| |_|\___| |_____/|_| |_|\__,_|\__,_|\___/ \_/\_/    \___/|_|       \/  \/ \__,_|_|   
                                                                                                                                                   
                                                                                                                                                   
--]]




if myHero.charName ~= "Hecarim" then
	return 
end


	function Hello()

		PrintChat("<font color=\"#4000ff\">Hecarim - The Shadow of War</font>")
	end


	function OnLoad()

		Menu()
		Hello()

		if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then Ignite = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then Ignite = SUMMONER_2 end
	end

	function Menu()

		HecaMenu = scriptConfig("Hecarim - The Shadow of War", "Heca")
		
		HecaMenu:addSubMenu("Combo Settings", "combo")
			HecaMenu.combo:addParam("comboKey", "Full Combo Key (SBTW)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte (" "))
			HecaMenu.combo:addParam("amountenemies", "Only Ult If X Enemies", SCRIPT_PARAM_SLICE, 2, 0, 5, 0) 

		HecaMenu:addSubMenu("Harass Settings", "harass")
			HecaMenu.harass:addParam("autoQ", "Auto-Q when Target in Range", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey('Z'))
			HecaMenu.harass:addParam("harassMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		
		HecaMenu:addSubMenu("Last Hit Settings", "farming")
			HecaMenu.farming:addParam("farmKey", "Farming Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			HecaMenu.farming:addParam("qFarm", "Last Hit with (Q)", SCRIPT_PARAM_ONOFF, true)
			HecaMenu.farming:addParam("FarmMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)


		HecaMenu:addSubMenu("Lane Clear Settings", "lane")
			HecaMenu.lane:addParam("laneKey", "Jungle Clear Key (V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			HecaMenu.lane:addParam("laneQ", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
			HecaMenu.lane:addParam("laneW", "Use (W)", SCRIPT_PARAM_ONOFF, true)
			HecaMenu.lane:addParam("laneE", "Use (E)", SCRIPT_PARAM_ONOFF, true)
			HecaMenu.lane:addParam("laneMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

			
		HecaMenu:addSubMenu("Jungle Clear Settings", "jungle")
			HecaMenu.jungle:addParam("jungleKey", "Jungle Clear Key (V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			HecaMenu.jungle:addParam("jungleQ", "Use (Q)", SCRIPT_PARAM_ONOFF, true)
			HecaMenu.jungle:addParam("jungleW", "Use (W)", SCRIPT_PARAM_ONOFF, true)
			HecaMenu.jungle:addParam("jungleE", "Use (E)", SCRIPT_PARAM_ONOFF, true)
			HecaMenu.jungle:addParam("jungleMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		HecaMenu:addSubMenu("Flee Settings", "flee")
			HecaMenu.flee:addParam("fleeKey", "Flee Key (G)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
			HecaMenu.flee:addParam("fleee", "Use (E)", SCRIPT_PARAM_ONOFF, true)
			HecaMenu.flee:addParam("fleeq", "Cast (Q) Enemy to near", SCRIPT_PARAM_ONOFF, true)
			
		HecaMenu:addSubMenu("KillSteal Settings", "ks")
			HecaMenu.ks:addParam("killSteal", "Use Smart Kill Steal", SCRIPT_PARAM_ONOFF, true)
			HecaMenu.ks:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)

		HecaMenu:addSubMenu("Item Settings", "items")
			HecaMenu.items:addParam("Use", "Use Items", SCRIPT_PARAM_ONOFF, true) 
    		HecaMenu.items:addParam("UseBRK", "Use BRK", SCRIPT_PARAM_ONOFF, true) 
    		HecaMenu.items:addParam("UseHydra", "Use Hydra", SCRIPT_PARAM_ONOFF, true) 
    		HecaMenu.items:addParam("UseYoumu", "Use Youmuu", SCRIPT_PARAM_ONOFF, true)
    		HecaMenu.items:addParam("UseBilgewaterCutlass","Use BilgewaterCutlass", SCRIPT_PARAM_ONOFF, true)
    		HecaMenu.items:addParam("UseTitanicHydra","Use Titanic Hydra", SCRIPT_PARAM_ONOFF, true)
				

		HecaMenu:addSubMenu("Draw Settings", "drawing")	
			HecaMenu.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
			HecaMenu.drawing:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
			HecaMenu.drawing:addParam("qDraw", "Draw (Q) Range", SCRIPT_PARAM_ONOFF, true)
			HecaMenu.drawing:addParam("wDraw", "Draw (E) Range", SCRIPT_PARAM_ONOFF, true)


		HecaMenu:addParam("HecaVer", "Version: ", SCRIPT_PARAM_INFO, version)		
	end

	function OnTick()

		ComboKey		= HecaMenu.combo.comboKey
		HarassKey		= HecaMenu.harass.harassKey
		LastHitKey		= HecaMenu.farming.farmKey
		LaneClearKey	= HecaMenu.lane.laneKey
		JungleClearKey	= HecaMenu.jungle.jungleKey
		FleeKey			= HecaMenu.flee.fleeKey

		ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_PHYSICAL)
		target = ts.target
		ts:update()

		
		enemyMinions 	= minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_MAXHEALTH_ASC)
		jungleMinions = minionManager(MINION_JUNGLE, 1100, myHero, MINION_SORT_MAXHEALTH_DEC)

        qReady = myHero:CanUseSpell(_Q) == READY
        wReady = myHero:CanUseSpell(_W) == READY
        eReady = myHero:CanUseSpell(_E) == READY
        rReady = myHero:CanUseSpell(_R) == READY

        SpellQ = {name = "Rampage",					range =  350	, ready = false, dmg = 0, manaUsage = 0				   }
		SpellW = {name = "Spirit of Dread",			range =  525	, ready = false, dmg = 0, manaUsage = 0				   }
		SpellE = {name = "Devastating Charge",		range =  325	, ready = false, dmg = 0, manaUsage = 0				   }
		SpellR = {name = "Onslaught of Shadows",	range = 1000	, ready = false, dmg = 0, manaUsage = 0				   }


        SpellQ.manaUsage = myHero:GetSpellData(_Q).mana
		SpellW.manaUsage = myHero:GetSpellData(_W).mana
		SpellE.manaUsage = myHero:GetSpellData(_E).mana
		SpellR.manaUsage = myHero:GetSpellData(_R).mana

		 ___GetInventorySlotItem = rawget(_G, "GetInventorySlotItem")
 	 		_G.GetInventorySlotItem = GetSlotItem
  			_G.ITEM_1 = 06
  			_G.ITEM_2 = 07
  			_G.ITEM_3 = 08
  			_G.ITEM_4 = 09
  			_G.ITEM_5 = 10
  			_G.ITEM_6 = 11
 			_G.ITEM_7 = 12


		ItemNames     = {
		    			[3144]        = "BilgewaterCutlass",
		    			[3748]		  =	"TitanicHydra",
		    			[3153]        = "ItemSwordOfFeastAndFamine",
		  				[3405]        = "TrinketSweeperLvl1",
		  				[3166]        = "TrinketTotemLvl1",
		  				[3361]        = "TrinketTotemLvl3",
		  				[3362]        = "TrinketTotemLvl4",
		  				[2003]        = "RegenerationPotion",
		  				[3146]        = "HextechGunblade",
		  				[3187]        = "HextechSweeper",
		  				[3364]        = "TrinketSweeperLvl3",
		  				[3074]        = "ItemTiamatCleave",
		  				[3077]        = "ItemTiamatCleave",
		  				[3340]        = "TrinketTotemLvl1",
		 				[3090]        = "ZhonyasHourglass",
		  				[3142]        = "YoumusBlade",
		  				[3157]        = "ZhonyasHourglass",
		 				[3350]        = "TrinketTotemLvl2",
		 				[3140]        = "QuicksilverSash",
		  				[3139]        = "ItemMercurial",
						}


        if ComboKey then
			Combo(Target)
		end

		if HarassKey then
			Harass(Target)
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

		if HecaMenu.harass.autoQ then
			HerassAutoQ()
		end

        if HecaMenu.ks.killSteal then
           	KillSteal()
        end

        if HecaMenu.ks.autoIgnite then
            --autoIgnite()
        end
	end


	function Combo()
		
		if ts.target and ValidTarget(ts.target) then


			if ComboKey then
				CastSpell(_E)
			end

			if GetDistance(ts.target) <= 325 then
				CastSpell(_Q)
			end

			if GetDistance(ts.target) <= 125 then
				CastSpell(_W)
				CastItems()
			end
		end
	end

	function HerassAutoQ()
		
		for each, enemy in ipairs(GetEnemyHeroes()) do

            if enemy and ValidTarget(enemy) then

            	if not isLow('Mana', myHero, HecaMenu.harass.harassMana) then

					if ts.target and ValidTarget(ts.target) and GetDistance(ts.target) <= 325 then
						CastSpell(_Q)				
					end
				end
			end
		end
	end

	function LastHit()
		
		enemyMinions:update()

		for each, minions in ipairs(enemyMinions.objects) do

            if minions and ValidTarget(minions) then

            	if minions.health <= getDmg("Q",minions,myHero) and HecaMenu.farming.qFarm and GetDistance(minions) >= 125 and not isLow('Mana', myHero, HecaMenu.farming.FarmMana) then
              		CastSpell(_Q)
              	end
            end
        end
	end

	function LaneClear()
		
		enemyMinions:update()

        for each, minions in ipairs(enemyMinions.objects) do

            if minions and ValidTarget(minions) then

            	if GetDistance(minions) <= 525 and HecaMenu.lane.laneW and not isLow('Mana', myHero, HecaMenu.lane.laneMana) then
					CastSpell(_W, minions)
				end

				if GetDistance(minions) <= 350 and HecaMenu.lane.laneQ and not isLow('Mana', myHero, HecaMenu.lane.laneMana) then
					CastSpell(_Q)
				end

				if GetDistance(minions) <= 500 and HecaMenu.lane.laneE and not isLow('Mana', myHero, HecaMenu.lane.laneMana) then
					CastSpell(_E, minions)	
				end
			end
		end
	end

	function JungleClear()
		
		jungleMinions:update()

        for _,jm in pairs(jungleMinions.objects) do

            if jm and ValidTarget(jm) then

            	if GetDistance(jm) <= 525 and HecaMenu.lane.laneW and not isLow('Mana', myHero, HecaMenu.jungle.jungleMana) then
					CastSpell(_W, jm)
				end

				if GetDistance(jm) <= 350 and HecaMenu.lane.laneQ and not isLow('Mana', myHero, HecaMenu.jungle.jungleMana) then
					CastSpell(_Q)
				end

				if GetDistance(jm) <= 500 and HecaMenu.lane.laneE and not isLow('Mana', myHero, HecaMenu.jungle.jungleMana) then
					CastSpell(_E, jm)	
				end
			end
		end
	end

	function Flee()
		
		local rastoyanie = math.sqrt((mousePos.x-myHero.x)*(mousePos.x-myHero.x) + (mousePos.z-myHero.z)*(mousePos.z-myHero.z))
  		myHero:MoveTo(mousePos.x,mousePos.z)

  		if ts.target and ValidTarget(ts.target) then

			if FleeKey then
				CastSpell(_E)
			elseif GetDistance(ts.target) <= 350 then
				CastSpell(_Q)
			end
		end
	end

	function KillSteal()
		
		for each, enemy in ipairs(GetEnemyHeroes()) do

            if enemy and ValidTarget(enemy) then

                if GetDistance(enemy) <= 350 and enemy.health <= getDmg("Q",enemy,myHero) then
   					CastSpell(_Q)
                elseif GetDistance(enemy) <= 525 and enemy.health <= getDmg("W",enemy,myHero) then
                    CastSpell(_W)
                elseif GetDistance(enemy) <= 350 and enemy.health <= getDmg("Q",enemy,myHero) + getDmg("W",enemy,myHero) then
                	CastSpell(_W)
                	CastSpell(_Q)
                end       
            end
        end
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

	function autoIgnite()

		if not Ignite then return end

		for each, enemy in ipairs(GetEnemyHeroes()) do

		       if enemy and ValidTarget(enemy) then

				if enemy.health <= 50 + (20 * myHero.level) and HecaMenu.ks.autoIgnite and myHero:CanUseSpell(Ignite) == READY then
						CastSpell(Ignite, enemy)
				end
			end
		end
	end

	function CastItems()

  		if ts.target ~= nil then
  			if HecaMenu.items.UseBRK then
  				local slot = GetInventorySlotItem(3153)		--"BladeoftheRuinedKing"
  				if ts.target ~= nil and ValidTarget(ts.target) and not ts.target.dead and slot ~= nil and myHero:CanUseSpell(slot) == READY and GetDistance(ts.target) <= 550 then
  					CastSpell(slot, ts.target)
  				end
  			end

  			if HecaMenu.items.UseBilgewaterCutlass then
  				local slot = GetInventorySlotItem(3144)		--"BilgewaterCutlass"
  				if ts.target ~= nil and ValidTarget(ts.target) and not ts.target.dead and slot ~= nil and myHero:CanUseSpell(slot) == READY and GetDistance(ts.target) <= 550 then
  					CastSpell(slot, ts.target)
  				end
  			end

  			if HecaMenu.items.UseHydra then
  				local slot = GetInventorySlotItem(3074)		--"RavenousHydra"
  				if ts.target ~= nil and ValidTarget(ts.target) and not ts.target.dead and slot ~= nil and myHero:CanUseSpell(slot) == READY and GetDistance(ts.target) <= 200 then
  					CastSpell(slot)
  				end
  			end

  			if HecaMenu.items.UseTitanicHydra then
  				local slot = GetInventorySlotItem(3748)		--"TitanicHydra"
  				if ts.target ~= nil and ValidTarget(ts.target) and not ts.target.dead and slot ~= nil and myHero:CanUseSpell(slot) == READY then
  					CastSpell(slot)
  				end
  			end


  			if HecaMenu.items.UseYoumu then
  				local slot = GetInventorySlotItem(3142)		--"Youmuu'sGhostblade"
  				if ts.target ~= nil and ValidTarget(ts.target) and not ts.target.dead and slot ~= nil and myHero:CanUseSpell(slot) == READY then
  					CastSpell(slot)
  				end
  			end
  		end
  	end


  	function GetSlotItem(id, unit)
  
  		unit = unit or myHero

  		if (not ItemNames[id]) then
  			return ___GetInventorySlotItem(id, unit)
  		end

  		local name  = ItemNames[id]
  
  		for slot = ITEM_1, ITEM_7 do
  		local item = unit:GetSpellData(slot).name
  			if ((#item > 0) and (item:lower() == name:lower())) then
  				return slot
  			end
  		end
  	end
