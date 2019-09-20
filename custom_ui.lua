local config = fatality.config;
local menu = fatality.menu;
local render = fatality.render;
local callbacks = fatality.callbacks;

local custom_ui_item = config:add_item('visuals_custom_ui', 0);
local custom_ui_checkbox = menu:add_checkbox('Custom UI', 'Visuals', 'Misc', 'Various', custom_ui_item);

local engine_client = csgo.interface_handler:get_engine_client();
local entity_list = csgo.interface_handler:get_entity_list();
local cvar = csgo.interface_handler:get_cvar();
local events = csgo.interface_handler:get_events();

local event_player_say = events:add_event('player_say');
local event_player_death = events:add_event('player_death');
local event_player_disconnect = events:add_event('player_disconnect');
local event_round_start = events:add_event('round_start');

local create_large_font = render:create_font('Tahoma', 20, 300, true);
local create_small_font = render:create_font('Tahoma', 12, 300, true);
local screen_size = render:screen_size();

local client_message_sent_by_name = {};
local client_message = {};
local client_killed_by_name = {};
local client_killed_name = {};
local client_killed_by_weapon = {};
local client_message_index = 0;
local client_kill_message_index = 0;

local function map_name(map)
    if map == 'maps\\ar_baggage.bsp' then
        return 'Baggage';
    elseif map == 'maps\\ar_dizzy.bsp' then
        return 'Dizzy';
    elseif map == 'maps\\ar_monastery.bsp' then
        return 'Monastery';
    elseif map == 'maps\\ar_shoots.bsp' then
        return 'Shoots';
    elseif map == 'maps\\cs_agency.bsp' then
        return 'Agency';
    elseif map == 'maps\\cs_assault.bsp' then
        return 'Assault';
    elseif map == 'maps\\cs_italy.bsp' then
        return 'Italy';
    elseif map == 'maps\\cs_militia.bsp' then
        return 'Militia';
    elseif map == 'maps\\cs_office.bsp' then
        return 'Office';
    elseif map == 'maps\\de_bank.bsp' then
        return 'Bank';
    elseif map == 'maps\\de_breach.bsp' then
        return 'Breach';
    elseif map == 'maps\\de_cache.bsp' then
        return 'Cache';
    elseif map == 'maps\\de_canals.bsp' then
        return 'Canals';
    elseif map == 'maps\\de_cbble.bsp' then
        return 'Cobblestone';
    elseif map == 'maps\\de_dust2.bsp' then
        return 'Dust 2';
    elseif map == 'maps\\de_inferno.bsp' then
        return 'Inferno';
    elseif map == 'maps\\de_lake.bsp' then
        return 'Lake';
    elseif map == 'maps\\de_mirage.bsp' then
        return 'Mirage';
    elseif map == 'maps\\de_nuke.bsp' then
        return 'Nuke';
    elseif map == 'maps\\de_overpass.bsp' then
        return 'Overpass';
    elseif map == 'maps\\de_ruby.bsp' then
        return 'Ruby';
    elseif map == 'maps\\de_safehouse.bsp' then
        return 'Safehouse';
    elseif map == 'maps\\de_seaside.bsp' then
        return 'Seaside';
    elseif map == 'maps\\de_shortdust.bsp' then
        return 'Shortdust';
    elseif map == 'maps\\de_shortnuke.bsp' then
        return 'Shortnuke';
    elseif map == 'maps\\de_train.bsp' then
        return 'Train';
    elseif map == 'maps\\de_vertigo.bsp' then
        return 'Vertigo';
    elseif map == 'maps\\de_zoo.bsp' then
        return 'Zoo';
    elseif map == 'maps\\dz_blacksite.bsp' then
        return 'Blacksite';
    elseif map == 'maps\\dz_sirocco.bsp' then
        return 'Sirocco';
    elseif map == 'maps\\gd_rialto.bsp' then
        return 'Rialto';
    else
        return 'Unknown Map';
    end
end

local function weapon_name(weapon)
    if weapon == 1 then
        return 'Desert Eagle';
    elseif weapon == 2 then
        return 'Dual Berettas';
    elseif weapon == 3 then
        return 'Five-Seven';
    elseif weapon == 4 then
        return 'Glock-18';
    elseif weapon == 7 then
        return 'AK-47';
    elseif weapon == 8 then
        return 'AUG';
    elseif weapon == 9 then
        return 'AWP';
    elseif weapon == 10 then
        return 'FAMAS';
    elseif weapon == 11 then
        return 'G3SG1';
    elseif weapon == 13 then
        return 'Galil AR';
    elseif weapon == 14 then
        return 'M249';
    elseif weapon == 16 then
        return 'M4A4';
    elseif weapon == 17 then
        return 'MAC-10';
    elseif weapon == 19 then
        return 'P90';
    elseif weapon == 23 then
        return 'MP5-SD';
    elseif weapon == 24 then
        return 'UMP-45';
    elseif weapon == 25 then
        return 'XM1014';
    elseif weapon == 26 then
        return 'PP-Bizon';
    elseif weapon == 27 then
        return 'MAG-7';
    elseif weapon == 28 then
        return 'Negev';
    elseif weapon == 29 then
        return 'Sawed-Off';
    elseif weapon == 30 then
        return 'Tec-9';
    elseif weapon == 31 then
        return 'Zeus x27';
    elseif weapon == 32 then
        return 'P2000';
    elseif weapon == 33 then
        return 'MP7';
    elseif weapon == 34 then
        return 'MP9';
    elseif weapon == 35 then
        return 'Nova';
    elseif weapon == 36 then
        return 'P250';
    elseif weapon == 37 then
        return 'Ballistic Shield';
    elseif weapon == 38 then
        return 'SCAR-20';
    elseif weapon == 39 then
        return 'SG 553';
    elseif weapon == 40 then
        return 'SSG 08';
    elseif weapon == 41 then
        return 'Knife';
    elseif weapon == 42 then
        return 'Knife';
    elseif weapon == 43 then
        return 'Flashbang';
    elseif weapon == 44 then
        return 'High Explosive Grenade';
    elseif weapon == 45 then
        return 'Smoke Grenade';
    elseif weapon == 46 then
        return 'Molotov';
    elseif weapon == 47 then
        return 'Decoy Grenade';
    elseif weapon == 48 then
        return 'Incendiary Grenade';
    elseif weapon == 49 then
        return 'C4 Explosive';
    elseif weapon == 57 then
        return 'Medi-Shot';
    elseif weapon == 59 then
        return 'Knife';
    elseif weapon == 60 then
        return 'M4A1-S';
    elseif weapon == 61 then
        return 'USP-S';
    elseif weapon == 63 then
        return 'CZ75-Auto';
    elseif weapon == 64 then
        return 'R8 Revolver';
    elseif weapon == 74 then
        return 'Knife';
    elseif weapon == 81 then
        return 'Fire Bomb';
    elseif weapon == 82 then
        return 'Diversion Device';
    elseif weapon == 83 then
        return 'Frag Grenade';
    elseif weapon == 84 then
        return 'Snowball';
    elseif weapon == 500 then
        return 'Bayonet';
    elseif weapon == 505 then
        return 'Flip Knife';
    elseif weapon == 506 then
        return 'Gut Knife';
    elseif weapon == 507 then
        return 'Karambit';
    elseif weapon == 508 then
        return 'M9 Bayonet';
    elseif weapon == 509 then
        return 'Huntsman Knife';
    elseif weapon == 512 then
        return 'Falchion Knife';
    elseif weapon == 514 then
        return 'Bowie Knife';
    elseif weapon == 515 then
        return 'Butterfly Knife';
    elseif weapon == 516 then
        return 'Shadow Daggers';
    elseif weapon == 519 then
        return 'Ursus Knife';
    elseif weapon == 520 then
        return 'Navaja Knife';
    elseif weapon == 522 then
        return 'Stiletto Knife';
    elseif weapon == 523 then
        return 'Talon Knife';
    else
        return 'Unknown Weapon';
    end
end

local function draw_hud()
    render:rect_fade(0, screen_size.y / 2 - 540, screen_size.x / 2 - 420, screen_size.y / 2 - 500 + client_message_index * 12, csgo.color(10, 10, 10, 240), csgo.color(30, 30, 30, 240));
    render:rect(0, screen_size.y / 2 - 540, screen_size.x / 2 - 420, screen_size.y / 2 - 500 + client_message_index * 12, csgo.color(255, 255, 255, 240));
    render:text(create_large_font, screen_size.x / 2 - 945, screen_size.y / 2 - 532, 'Client Messages', csgo.color(255, 255, 255, 255));
    render:rect_fade(screen_size.x / 2 + 420, screen_size.y / 2 - 540, screen_size.x / 2 - 420, screen_size.y / 2 - 500 + client_kill_message_index * 12, csgo.color(10, 10, 10, 240), csgo.color(30, 30, 30, 240));
    render:rect(screen_size.x / 2 + 420, screen_size.y / 2 - 540, screen_size.x / 2 - 420, screen_size.y / 2 - 500 + client_kill_message_index * 12, csgo.color(255, 255, 255, 240));
    render:text(create_large_font, screen_size.x / 2 + 435, screen_size.y / 2 - 532, 'Kill Messages', csgo.color(255, 255, 255, 255));

    if client_message_index == nil or client_kill_message_index == nil then
        return;
    end

    for index = 0, client_message_index, 1 do
        if client_message_sent_by_name[index] == nil or client_message[index] == nil then
            break;
        end

        render:text(create_small_font, screen_size.x / 2 - 945, screen_size.y / 2 - 510 + index * 12, ''.. client_message_sent_by_name[index] ..': '.. client_message[index] ..'', csgo.color(255, 255, 255, 255));
    end

    for index = 0, client_kill_message_index, 1 do
        if client_killed_by_name[index] == nil or client_killed_name[index] == nil or client_killed_by_weapon[index] == nil then
            break;
        end

        render:text(create_small_font, screen_size.x / 2 + 435, screen_size.y / 2 - 510 + index * 12, ''.. client_killed_by_name[index] ..' killed '.. client_killed_name[index] ..' with their '.. client_killed_by_weapon[index] ..'', csgo.color(255, 255, 255, 255));
    end

    local local_player = entity_list:get_localplayer(); 

    if local_player == nil then
        return;
    end

    local local_player_name = local_player:get_name();
    local local_player_ping = engine_client:get_ping();
    local local_player_map_name = engine_client:get_map_name();
    local local_player_round_kills = local_player:get_var_int('CCSPlayer->m_iNumRoundKills');
    local local_player_health = local_player:get_var_int('CBasePlayer->m_iHealth');
    local local_player_armor = local_player:get_var_int('CCSPlayer->m_ArmorValue');
    local local_player_weapon_handle = local_player:get_var_handle('CBaseCombatCharacter->m_hActiveWeapon');
    local local_player_active_weapon = entity_list:get_from_handle(local_player_weapon_handle);

    if local_player_active_weapon == nil then
        return;
    end

    local local_player_ammo_clip = local_player_active_weapon:get_var_int('CBaseCombatWeapon->m_iClip1');
    local local_player_ammo_reserved = local_player_active_weapon:get_var_int('CBaseCombatWeapon->m_iPrimaryReserveAmmoCount');
    local local_player_weapon_id = local_player_active_weapon:get_var_int('CBaseAttributableItem->m_iItemDefinitionIndex') & 65535;

    if local_player_name == nil or local_player_ping == nil or local_player_map_name == nil or local_player_round_kills == nil or local_player_health == nil or local_player_armor == nil or local_player_ammo_clip == nil or local_player_ammo_reserved == nil or local_player_weapon_id == nil then
        return;
    end

    render:rect_fade(0, screen_size.y / 2 + 500, screen_size.x / 2 - 420, screen_size.y / 2 - 500, csgo.color(10, 10, 10, 240), csgo.color(30, 30, 30, 240));
    render:rect(0, screen_size.y / 2 + 500, screen_size.x / 2 - 420, screen_size.y / 2 - 500, csgo.color(255, 255, 255, 240));

    if string.len(local_player_name) > 14 then
        local_player_name = string.sub(local_player_name, 0, 14);
    end

    render:text(create_large_font, screen_size.x / 2 - 945, screen_size.y / 2 + 510, 'Player: '.. local_player_name ..' | Ping: '.. local_player_ping ..' | Round Kills: '.. local_player_round_kills ..' | Current Map: '.. map_name(local_player_map_name) ..'', csgo.color(255, 255, 255, 255));
    render:rect_fade(screen_size.x / 2 - 275, screen_size.y / 2 + 500, screen_size.x / 2 - 420, screen_size.y / 2 - 500, csgo.color(10, 10, 10, 240), csgo.color(30, 30, 30, 240));
    render:rect(screen_size.x / 2 - 275, screen_size.y / 2 + 500, screen_size.x / 2 - 420, screen_size.y / 2 - 500, csgo.color(255, 255, 255, 240));

    if local_player_ammo_clip == -1 then
        render:text(create_large_font, screen_size.x / 2 - 260, screen_size.y / 2 + 510, 'Ammo: Infinite | Current Weapon: '.. weapon_name(local_player_weapon_id) ..'', csgo.color(255, 255, 255, 255));
    else
        render:text(create_large_font, screen_size.x / 2 - 260, screen_size.y / 2 + 510, 'Ammo: '.. local_player_ammo_clip ..'/'.. local_player_ammo_reserved ..' | Current Weapon: '.. weapon_name(local_player_weapon_id) ..'', csgo.color(255, 255, 255, 255));
    end

    render:rect_fade(screen_size.x / 2 + 420, screen_size.y / 2 + 500, screen_size.x / 2 - 420, screen_size.y / 2 - 500, csgo.color(10, 10, 10, 240), csgo.color(30, 30, 30, 240));
    render:rect(screen_size.x / 2 + 420, screen_size.y / 2 + 500, screen_size.x / 2 - 420, screen_size.y / 2 - 500, csgo.color(255, 255, 255, 240));
    render:text(create_large_font, screen_size.x / 2 + 435, screen_size.y / 2 + 510, 'Health: '.. local_player_health ..' | Armor: '.. local_player_armor ..'', csgo.color(255, 255, 255, 255));
end

local function draw_crosshair()
    render:rect_filled(screen_size.x / 2 - 10, screen_size.y / 2, 20, 1, csgo.color(255, 255, 255, 255));
    render:rect_filled(screen_size.x / 2, screen_size.y / 2 - 10, 1, 20, csgo.color(255, 255, 255, 255));
end

local function on_paint()
    if not engine_client:is_connected() and not engine_client:is_in_game() then
        return;
    end

    local draw_hud_cvar = cvar:find_var('cl_drawhud');
    local crosshair_cvar = cvar:find_var('crosshair');

    if custom_ui_item:get_bool() then
        draw_hud_cvar:set_int(0);
        crosshair_cvar:set_int(0);

        draw_hud();
        draw_crosshair();
    else
        draw_hud_cvar:set_int(1);
        crosshair_cvar:set_int(1);
    end
end

local function on_events(event)
    if not engine_client:is_connected() and engine_client:is_in_game() then
        return;
    end

    if event:get_name() == 'player_say' then
        local event_user_id = event:get_int('userid');
        local event_text = event:get_string('text');
        local user_id = entity_list:get_player_from_id(event_user_id);

        if event_text == nil or user_id == nil then
            return;
        end

        local player_name = user_id:get_name();

        if player_name == nil then
            return;
        end

        if string.len(player_name) > 16 or string.len(event_text) > 50 then
            player_name = string.sub(player_name, 0, 16);
            event_text = string.sub(event_text, 0, 50);
        end

        client_message_sent_by_name[client_message_index] = player_name;
        client_message[client_message_index] = event_text;
        client_message_index = client_message_index + 1;
    end

    if event:get_name() == 'player_death' then
        local event_user_id = event:get_int('userid');
        local event_attacker = event:get_int('attacker');
        local event_weapon = event:get_string('weapon');
        local user_id = entity_list:get_player_from_id(event_user_id);
        local attacker = entity_list:get_player_from_id(event_attacker);

        if event_weapon == nil or user_id == nil or attacker == nil then
            return;
        end

        local player_name = user_id:get_name();
        local attacker_name = attacker:get_name();

        if player_name == nil or attacker_name == nil then
            return;
        end

        client_killed_by_name[client_kill_message_index] = attacker_name;
        client_killed_name[client_kill_message_index] = player_name;
        client_killed_by_weapon[client_kill_message_index] = event_weapon;
        client_kill_message_index = client_kill_message_index + 1;
    end

    if event:get_name() == 'player_disconnect' then
        client_killed_by_name = {};
        client_killed_name = {};
        client_killed_by_weapon = {};
        client_kill_message_index = 0;
        client_message_sent_by_name = {};
        client_message = {};
        client_message_index = 0;
    end

    if event:get_name() == 'round_start' then
        client_killed_by_name = {};
        client_killed_name = {};
        client_killed_by_weapon = {};
        client_kill_message_index = 0;
        client_message_sent_by_name = {};
        client_message = {};
        client_message_index = 0;
    end
end

callbacks:add('paint', on_paint);
callbacks:add('events', on_events);
