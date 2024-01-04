local spell_e2_width = 120/2
local spell_e2_speed = 1600
local spell_e2_range = 850

local sylas_aa_range = 175


local spell_q_width = 90/2
local spell_q_speed = 1700
local spell_q_range = 750
g_last_e_time = g_time

g_last_e2_time = g_time
g_last_q_time = g_time
g_last_w_time = g_time

spell_w_range = 390

i = 0


--Menu start



Script_name = "Sylas 1.02"
local test_navigation = menu.get_main_window():push_navigation(Script_name, 10000)
local my_nav = menu.get_main_window():find_navigation(Script_name)
local combo_sect = my_nav:add_section("Combo Settings")
local harras_sect = my_nav:add_section("Harras Section")


-- Q Settings 


local combo_q_config = g_config:add_bool(true, "Q_in_combo")
local combo_q_box = combo_sect:checkbox("Use Q", combo_q_config)

local harras_q_config = g_config:add_bool(true, "Q_in_Harras")
local harras_q_box = harras_sect:checkbox("Use Q in Harras", harras_q_config)

-- W Settings
local combo_w_config = g_config:add_bool(true, "W_in_combo")
local combo_w_box = combo_sect:checkbox("Use W", combo_w_config)



-- E Settings

local combo_e_config = g_config:add_bool(true, "E_in_combo")
local combo_e_box = combo_sect:checkbox("Use E", combo_e_config)


--E2 Settings

local combo_e2_config = g_config:add_bool(true, "E2_in_combo")
local combo_e2_box = combo_sect:checkbox("Use E2", combo_e2_config)


combo_q_box:set_value(true)
combo_w_box:set_value(true)
combo_e_box:set_value(true)
combo_e2_box:set_value(true)
harras_q_box:set_value(true)

-- Menu end



cheat.register_module({
    champion_name = "Sylas",

    spell_e = function()


        local target = features.target_selector:get_default_target()
        if(target == nil) then
            return false
        end
        local qHit = features.prediction:predict(target.index, spell_q_range, spell_q_speed, spell_q_width, 0.4, g_local.position)
        local e2Hit = features.prediction:predict(target.index, spell_e2_range, spell_e2_speed, spell_e2_width, 0.25, g_local.position)

        local badMinion = features.prediction:minion_in_line(g_local.position, qHit.position, 45, -1) --check minion in line 

        local name_spell_e = g_local:get_spell_book():get_spell_slot(2):get_name()

        local slot_spell_q = g_local:get_spell_book():get_spell_slot(0)
        local slot_spell_w = g_local:get_spell_book():get_spell_slot(1)
        local slot_spell_e = g_local:get_spell_book():get_spell_slot(2)

        local low_health = g_local.max_health / 100 * 80
        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end

        if features.buff_cache:get_buff(g_local.index, "SylasPassiveAttack") ~= nil then
            if (features.buff_cache:get_buff(g_local.index, "SylasPassiveAttack"):get_stacks() > 1 and target:dist_to_local() < sylas_aa_range) then
                return false
            end
        end

        if (features.orbwalker:get_mode() == 1 and target:dist_to_local() < 780) then



            if((name_spell_e == "SylasE" and g_time - g_last_e_time > 0.35 and slot_spell_e:is_ready() and slot_spell_w:is_ready()) and combo_e_box:get_value() or (name_spell_e == "SylasE" and g_time - g_last_e_time > 0.35 and slot_spell_w:is_ready() == false and slot_spell_e:is_ready()) and combo_e_box:get_value() ) then


                if(g_input:cast_spell(e_spell_slot.e, target.position)) then
                    g_last_e_time = g_time

                end
            end

            print(g_time - g_last_w_time)

            if(name_spell_e == "SylasE2" and g_time - g_last_w_time > 0.35 and slot_spell_w:is_ready() and target:dist_to_local() < spell_w_range and combo_w_box:get_value() ) then
                g_last_w_time = g_time
                g_input:cast_spell(e_spell_slot.w, target.network_id)
            end


            if(name_spell_e == "SylasE2" and slot_spell_w:is_ready() == false and target:dist_to_local() < spell_e2_range and qHit.hitchance > 1.0 and badMinion == false and (g_time - g_last_e2_time > 0.35) and combo_e2_box:get_value()) then
                g_last_e2_time = g_time
                g_input:cast_spell(e_spell_slot.e, e2Hit.position)
            end



            

        end
            



                                                                                                                               -- (target:dist_to_local() < spell_w_range and target:dist_to_local() > 290)
    
        if (features.orbwalker:get_mode() == 1 and qHit.hitchance > 1.0 and name_spell_e == "SylasE2" and badMinion == false  and (slot_spell_w:is_ready() == false or (slot_spell_w:is_ready() and spell_w_range < target:dist_to_local())) and combo_e2_box:get_value()) then
            g_last_e2_time = g_time
            g_input:cast_spell(e_spell_slot.e, qHit.position)


        end
    return flase
end,

    spell_q = function()
        local target = features.target_selector:get_default_target()
        if(target == nil) then
            return false
        end
        
        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end

        if features.buff_cache:get_buff(g_local.index, "SylasPassiveAttack") ~= nil then
            if (features.buff_cache:get_buff(g_local.index, "SylasPassiveAttack"):get_stacks() > 1 and target:dist_to_local() < sylas_aa_range) then
                return false
            end
        end
        local qHit = features.prediction:predict(target.index, spell_q_range, spell_q_speed, spell_q_width, 0.4, g_local.position)


        local slot_spell_q = g_local:get_spell_book():get_spell_slot(0)
        local slot_spell_w = g_local:get_spell_book():get_spell_slot(1)
        local slot_spell_e = g_local:get_spell_book():get_spell_slot(2)


        if((features.orbwalker:get_mode() == 1 and qHit.hitchance > 1.0 and g_time - g_last_q_time > 0.35) or (qHit.hitchance > 1.0 and features.orbwalker:get_mode() == 4 and target:dist_to_local() < spell_q_range and g_time - g_last_q_time > 0.35) and combo_q_box:get_value()) then
            g_last_q_time = g_time
            g_input:cast_spell(e_spell_slot.q, qHit.position)

        end




        print("11")
        return false
    end,
    spell_w = function()
        local target = features.target_selector:get_default_target()
        if(target == nil) then
            return false
        end
        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end

        if features.buff_cache:get_buff(g_local.index, "SylasPassiveAttack") ~= nil then
            if (features.buff_cache:get_buff(g_local.index, "SylasPassiveAttack"):get_stacks() > 1 and target:dist_to_local() < sylas_aa_range) then
                return false
            end
        end


        local low_health = g_local.max_health / 100 * 80
        local name_spell_e = g_local:get_spell_book():get_spell_slot(2):get_name()


        if(((features.orbwalker:get_mode() == 1  and target:dist_to_local() < spell_w_range) or (features.orbwalker:get_mode() == 1 and target:dist_to_local() < spell_w_range and target:dist_to_local() > 290) or (features.orbwalker:get_mode() == 1 and target:dist_to_local() < spell_w_range and name_spell_e == "SylasE2")) and combo_w_box:get_value()) then

            g_input:cast_spell(e_spell_slot.w, target.network_id)
            g_last_w_time = g_time
        end


        return false
    end,





get_priorities = function()
    return{
        "spell_e",
        "spell_q",
        "spell_w"
    }
end



})

