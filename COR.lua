-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    gs c toggle LuzafRing -- Toggles use of Luzaf Ring on and off
    
    Offense mode is melee or ranged.  Used ranged offense mode if you are engaged
    for ranged weaponskills, but not actually meleeing.
    
    Weaponskill mode, if set to 'Normal', is handled separately for melee and ranged weaponskills.
--]]


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(true, "Luzaf's Ring")
    -- Whether a warning has been given for low ammo
    state.warned = M(false)

    define_roll_values()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Melee', 'Ranged', 'Acc')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc', 'Att', 'Mod')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'PDT', 'Refresh')

    gear.RAbullet = "Decimating Bullet"
    gear.WSbullet = "Decimating Bullet"
    gear.MAbullet = "Orichalc. Bullet"
    gear.QDbullet = "Animikii Bullet"
    options.ammo_warning_limit = 15

    -- Additional local binds
    send_command('bind !l gs c toggle LuzafRing')
	send_command('bind !e input /item "Echo Drops" <me>')
	send_command('bind !r input /item "Remedy" <me>')
	send_command('bind !p input /item "Panacea" <me>')
	send_command('bind !h input /item "Holy Water" <me>')
	send_command('bind !w input /equip ring2 "Warp Ring"; /echo Warping; wait 11; input /item "Warp Ring" <me>;')
	send_command('bind !q input /equip ring2 "Dim. Ring (Holla)"; /echo Reisenjima; wait 11; input /item "Dim. Ring (Holla)" <me>;')
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind `')

end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Setsg

    -- Precast sets to enhance JAs
    
    sets.precast.JA['Triple Shot'] = {body="Chasseur's Frac +1"}
    sets.precast.JA['Snake Eye'] = {legs="Lanun Trews +1"}
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +1"}
    sets.precast.JA['Random Deal'] = {body="Lanun Frac +1"}

    sets.precast.CorsairRoll = {head="Lanun Tricorne +1",hands="Chasseur's Gants +1",ring2="Barataria Ring",neck="Regal Necklace",back="Camulus's Mantle",}
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +1"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})
    
    sets.precast.LuzafRing = {ring1="Luzaf's Ring"}
    sets.precast.FoldDoubleBust = {hands="Lanun Gants +2"}
    
    -- Waltz set (chr and vit)
    sets.precast.Waltz = {body="Passion Jacket",}
	
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {ear1="Etiolation Earring",ear2="Loquacious Earring"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {body="Passion Jacket", neck="Magoraga Beads"})

	sets.precast.RA = {
		ammo=gear.RAbullet,
		head="Laksa. Tricorne +3",
    	body="Laksa. Frac +3",
    	hands="Chasseur's Gants +1",
    	legs="Adhemar Kecks",
		feet="Laksa. Boots +2",
    	neck="Comm. Charm +1",
    	waist="Eschan Stone",
    	left_ear="Enervating Earring",
    	right_ear="Navarch's Earring",
    	left_ring="Cacoethic Ring",
    	right_ring="Cacoethic Ring +1",
    	back="Gunslinger's Cape",
	}

    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
	head={ name="Herculean Helm", augments={'Accuracy+23','Pet: "Mag.Atk.Bns."+3','Quadruple Attack +1','Accuracy+17 Attack+17',}},
    body="Laksa. Frac +3",
    hands={ name="Adhemar Wristbands", augments={'STR+10','DEX+10','Attack+15',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+27','"Dual Wield"+1','DEX+10','Attack+6',}},
    neck="Caro Necklace",
    waist="Grunfeld Rope",
    left_ear="Bushinomimi",
    right_ear="Ishvara Earring",
    left_ring="Shukuyu Ring",
    right_ring="Apate Ring",
    back="Laic Mantle",
	}

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.

    sets.precast.WS['Savage Blade']={     
	head={ name="Herculean Helm", augments={'Accuracy+23','Pet: "Mag.Atk.Bns."+3','Quadruple Attack +1','Accuracy+17 Attack+17',}},
    body="Laksa. Frac +3",
    hands={ name="Adhemar Wristbands", augments={'STR+10','DEX+10','Attack+15',}},
    legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    feet={ name="Herculean Boots", augments={'Accuracy+27','"Dual Wield"+1','DEX+10','Attack+6',}},
    neck="Caro Necklace",
    waist="Grunfeld Rope",
    left_ear="Bushinomimi",
    right_ear="Ishvara Earring",
    left_ring="Shukuyu Ring",
    right_ring="Apate Ring",
    back="Laic Mantle",
}

sets.precast.WS['Last Stand'] = {
	ammo=gear.WSbullet,
	head={ name="Herculean Helm", augments={'Accuracy+23','Pet: "Mag.Atk.Bns."+3','Quadruple Attack +1','Accuracy+17 Attack+17',}},
    	body="Laksa. Frac +3",
    	hands={ name="Adhemar Wristbands", augments={'STR+10','DEX+10','Attack+15',}},
    	legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
    	feet={ name="Herculean Boots", augments={'Accuracy+27','"Dual Wield"+1','DEX+10','Attack+6',}},
    	neck="Caro Necklace",
    	waist="Grunfeld Rope",
    	left_ear="Bushinomimi",
    	right_ear="Ishvara Earring",
    	left_ring="Shukuyu Ring",
    	right_ring="Apate Ring",
    	back="Laic Mantle",
	}
    
    sets.precast.WS['Leaden Salute']={
	ammo=gear.MAbullet,
    head="Pixie Hairpin +1",
    body="Laksa. Frac +3",
	hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','Mag. Acc.+13','"Mag.Atk.Bns."+7',}},
    feet={ name="Adhemar Gamashes", augments={'DEX+10','AGI+10','Accuracy+15',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Hecate's Earring",
    right_ear="Friomisi Earring",
    left_ring="Arvina Ringlet +1",
    right_ring="Archon Ring",
    back={ name="Gunslinger's Cape", augments={'Enmity-1','"Mag.Atk.Bns."+2','"Phantom Roll" ability delay -3',}},
	}

	sets.precast.WS['Wildfire']={
	ammo=gear.MAbullet,
    head={ name="Herculean Helm", augments={'Accuracy+23','Pet: "Mag.Atk.Bns."+3','Quadruple Attack +1','Accuracy+17 Attack+17',}},
    body="Laksa. Frac +3",
    hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','Mag. Acc.+13','"Mag.Atk.Bns."+7',}},
    feet={ name="Adhemar Gamashes", augments={'DEX+10','AGI+10','Accuracy+15',}},
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Ishvara Earring",
    right_ear="Friomisi Earring",
    left_ring="Arvina Ringlet +1",
    right_ring="Apate Ring",
    back={ name="Gunslinger's Cape", augments={'Enmity-1','"Mag.Atk.Bns."+2','"Phantom Roll" ability delay -3',}},
	}
		
    -- Midcast Sets
    sets.midcast.FastRecast = {}
        
    -- Specific spells
    sets.midcast.Utsusemi = sets.midcast.FastRecast

    sets.midcast.CorsairShot = {
	ammo="Animikii Bullet",
    head="Laksa. Tricorne +3",
    body="Laksa. Frac +3",
    hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','Mag. Acc.+13','"Mag.Atk.Bns."+7',}},
    feet="Laksa. Boots +2",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Hecate's Earring",
    right_ear="Friomisi Earring",
    left_ring="Arvina Ringlet +1",
    right_ring="Apate Ring",
    back={ name="Gunslinger's Cape", augments={'Enmity-1','"Mag.Atk.Bns."+2','"Phantom Roll" ability delay -3',}},
	}    
        
    sets.midcast.CorsairShot.Acc = {}

    sets.midcast.CorsairShot['Light Shot']={
	ammo="Animikii Bullet",
    head="Laksa. Tricorne +3",
    body="Laksa. Frac +3",
    hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','Mag. Acc.+13','"Mag.Atk.Bns."+7',}},
    feet="Laksa. Boots +2",
    neck="Sanctity Necklace",
    waist="Eschan Stone",
    left_ear="Hecate's Earring",
    right_ear="Friomisi Earring",
    left_ring="Arvina Ringlet +1",
    right_ring="Apate Ring",
    back={ name="Gunslinger's Cape", augments={'Enmity-1','"Mag.Atk.Bns."+2','"Phantom Roll" ability delay -3',}},
	} 

    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']

    -- Ranged gear
    sets.midcast.RA ={
	head="Laksa. Tricorne +3",
    body="Laksa. Frac +3",
    hands="Chasseur's Gants +1",
    legs="Adhemar Kecks", 
    feet="Laksa. Boots +2",
    neck="Comm. Charm +1",
    waist="Eschan Stone",
    left_ear="Enervating Earring",
    right_ear="Navarch's Earring",
    left_ring="Cacoethic Ring",
    right_ring="Cacoethic Ring +1",
    back={ name="Gunslinger's Cape", augments={'Enmity-1','"Mag.Atk.Bns."+2','"Phantom Roll" ability delay -3',}},
}

    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {neck="Sanctity Necklace"}

    -- Idle sets
    sets.idle = {
		ammo=gear.RAbullet,
		head="Laksa. Tricorne +3",
		body="Lanun Frac +1",
		neck="Sanctity Necklace",
		ear1="Etiolation Earring",
		ear2="Infused Earring",
		hands="Kurys Gloves",
		ring1="Paguroidea Ring",
		ring2="Shneddick Ring",
        back="Xucau Mantle",
		waist="Flume Belt +1",
		legs={ name="Herculean Trousers", augments={'Accuracy+22 Attack+22','"Dual Wield"+2','DEX+8','Accuracy+5','Attack+8',}},
		feet="Lanun Bottes +1",
}

    sets.idle.Town={
    ammo="Animikii Bullet",
    head="Laksa. Tricorne +3",
    body="Laksa. Frac +3",
    hands="Carmine Fin. Ga. +1",
	legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','Mag. Acc.+13','"Mag.Atk.Bns."+7',}},
    feet="Laksa. Boots +2",
    neck="Comm. Charm +1",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Digni. Earring",
    left_ring="Archon Ring",
    right_ring="Shneddick Ring",
	back="Camulus's Mantle",
 }
    
    -- Defense sets
    sets.defense.PDT = {}

    sets.defense.MDT = {}
    
    sets.Kiting = {}
	
	sets.Utility = {}

--Comes on while terrored, asleep, etc
	sets.Utility.DerpDT = {
	head="Dampening Tam",
    body="Emet Harness",
    hands="Kurys Gloves",
    legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','Mag. Acc.+13','"Mag.Atk.Bns."+7',}},
    feet="Lanun Bottes +1",
    neck="Twilight Torque",
    waist="Flume Belt +1",
    left_ear="Thureous Earring",
    right_ear="Etiolation Earring",
    left_ring="Fortified Ring",
    right_ring="Persis Ring",
    back="Solemnity Cape",
}

    -- Engaged sets
    
    -- Normal melee group
    sets.engaged.Melee = {
    ammo=gear.RAbullet,
    head={ name="Herculean Helm", augments={'Accuracy+23','Pet: "Mag.Atk.Bns."+3','Quadruple Attack +1','Accuracy+17 Attack+17',}},
    body="Herculean Vest",
    hands={ name="Herculean Gloves", augments={'Accuracy+20 Attack+20','DEX+15','Accuracy+15','Attack+6',}},
    legs={ name="Herculean Trousers", augments={'Accuracy+22 Attack+22','"Dual Wield"+2','DEX+8','Accuracy+5','Attack+8',}},
    feet={ name="Herculean Boots", augments={'Accuracy+27','"Dual Wield"+1','DEX+10','Attack+6',}},
    neck="Lissome Necklace",
    waist="Windbuffet Belt +1",
    left_ear="Cessance Earring",
    right_ear="Digni. Earring",
    left_ring="Chirich Ring",
    right_ring="Chirich Ring",
    back="Camulus's Mantle",
}
    sets.engaged.Acc = {}
	
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end

    -- gear sets
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and state.LuzafRing.value then
        equip(sets.precast.LuzafRing)
    elseif spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
        classes.CustomClass = 'Acc'
    elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'CorsairRoll' and not spell.interrupted then
        display_roll_info(spell)
    end
end

-- Turtle Mode
function buff_change(n, gain, buff_table)
	local name
	name = string.lower(n)
	if S{"terror","petrification","sleep","stun"}:contains(name) then
        if gain then
            ChangeGear(sets.Utility.DerpDT) -- Put this set on when terrored etc
        elseif not has_any_buff_of({"terror","petrification","sleep","stun"}) then
            if player.status == 'Engaged' then
                if LockGearIndex then
                    ChangeGear(LockGearSet)
				elseif not LockGearIndex then
						ChangeGear(sets.TP[sets.TP.index[TP_ind]])
				end
            elseif player.status == 'Idle' then
                if LockGearIndex then
                    ChangeGear(LockGearSet)
                elseif not LockGearIndex then
                    ChangeGear(sets.Idle[sets.Idle.index[Idle_ind]])
                end
            end
        end
    elseif name == "doom" then
        if gain then
            send_command('@input /p Doomed {~o~:} !')
        else
			send_command('@input /p Doom is off {^_^}')
        end
	elseif name == "charm" then
		if gain then
			send_command('@input /p Charmed {<3_<3:} !')
		else
			send_command('@input /p Charm is off {~_^}')
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Return a customized weaponskill mode to use for weaponskill sets.
-- Don't return anything if you're not overriding the default value.
function get_custom_wsmode(spell, spellMap, default_wsmode)
    if buffactive['Transcendancy'] then
        return 'Brew'
    end
end


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    if newStatus == 'Engaged' and player.equipment.main == 'Chatoyant Staff' then
        state.OffenseMode:set('Ranged')
    end
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''
    
    msg = msg .. 'Off.: '..state.OffenseMode.current
    msg = msg .. ', Rng.: '..state.RangedMode.current
    msg = msg .. ', WS.: '..state.WeaponskillMode.current
    msg = msg .. ', QD.: '..state.CastingMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end
    
    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value then
        msg = msg .. ', Target NPCs'
    end

    msg = msg .. ', Roll Size: ' .. ((state.LuzafRing.value and 'Large') or 'Small')
    
    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="XP"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=3, unlucky=7, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies's Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, spell.english..' bonus to '..rollinfo.bonus..'.  Roll size: '..rollsize)
        add_to_chat(104, 'Lucky '..tostring(rollinfo.lucky)..', Unlucky '..tostring(rollinfo.unlucky)..'.')
    end
end

-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.element == 'None' then
                -- physical weaponskills
                bullet_name = gear.WSbullet
            else
                -- magical weaponskills
                bullet_name = gear.MAbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end
    
    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]
    
    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end
    
    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end
    
    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end
        
        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 13)
end
