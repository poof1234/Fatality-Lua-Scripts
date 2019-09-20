local config = fatality.config;
local menu = fatality.menu;
local callbacks = fatality.callbacks;

local chat_spam_item = config:add_item('misc_chat_spam', 0.0);
local chat_spam_checkbox = menu:add_checkbox('Chat Spam', 'Visuals', 'Misc', 'Various', chat_spam_item);

local engine_client = csgo.interface_handler:get_engine_client();
local entity_list = csgo.interface_handler:get_entity_list();
local cvar = csgo.interface_handler:get_cvar();
local events = csgo.interface_handler:get_events();

local event_player_death = events:add_event('player_death');
local event_bomb_dropped = events:add_event('bomb_dropped');
local event_bomb_begin_plant = events:add_event('bomb_beginplant');
local event_bomb_planted = events:add_event('bomb_planted');
local event_bomb_begin_defuse = events:add_event('bomb_begindefuse');
local event_bomb_abort_defuse = events:add_event('bomb_abortdefuse');
local event_bomb_defused = events:add_event('bomb_defused');

local function on_events(event)
    if not chat_spam_item:get_bool() then
        return;
    end

    if not engine_client:is_connected() and not engine_client:is_in_game() then
        return;
    end

    if event:get_name() == 'player_death' then
        local event_user_id = event:get_int('userid');
        local event_attacker = event:get_int('attacker');
        local event_weapon = event:get_string('weapon');
        local event_headshot = event:get_bool('headshot');

        local local_player = entity_list:get_localplayer();
        local user_id = entity_list:get_player_from_id(event_user_id);
        local attacker = entity_list:get_player_from_id(event_attacker);

        if local_player == nil or user_id == nil or attacker == nil or event_headshot == nil then
            return;
        end

        local player_name = user_id:get_name();

        if player_name == nil then
            return;
        end

        if not attacker:get_index() == local_player:get_index() then
            return;
        end

        if attacker:get_index() == local_player:get_index() then
            if event_headshot then
                engine_client:client_cmd('say '.. player_name ..' just died by a headshot to my '.. event_weapon ..'!');
            else
                engine_client:client_cmd('say '.. player_name ..' just died to my '.. event_weapon ..'!');
            end
        end
    end

    if event:get_name() == 'bomb_dropped' then
        local event_user_id = event:get_int('userid');

        local user_id = entity_list:get_player_from_id(event_user_id);

        if user_id == nil then
            return;
        end

        local player_name = user_id:get_name();

        if player_name == nil then
            return;
        end

        engine_client:client_cmd('say '.. player_name ..' has dropped the bomb!');
    end

    if event:get_name() == 'bomb_beginplant' then
        local event_user_id = event:get_int('userid');

        local user_id = entity_list:get_player_from_id(event_user_id);

        if user_id == nil then
            return;
        end

        local player_name = user_id:get_name();

        if player_name == nil then
            return;
        end

        engine_client:client_cmd('say '.. player_name ..' has begun to plant the bomb!');
    end

    if event:get_name() == 'bomb_planted' then
        local event_user_id = event:get_int('userid');

        local user_id = entity_list:get_player_from_id(event_user_id);

        if user_id == nil then
            return;
        end

        local player_name = user_id:get_name();

        if player_name == nil then
            return;
        end

        engine_client:client_cmd('say '.. player_name ..' has planted the bomb!');
    end

    if event:get_name() == 'bomb_begindefuse' then
        local event_user_id = event:get_int('userid');

        local user_id = entity_list:get_player_from_id(event_user_id);

        if user_id == nil then
            return;
        end

        local player_name = user_id:get_name();

        if player_name == nil then
            return;
        end

        engine_client:client_cmd('say '.. player_name ..' has began to defuse the bomb!');
    end

    if event:get_name() == 'bomb_abortdefuse' then
        local event_user_id = event:get_int('userid');

        local user_id = entity_list:get_player_from_id(event_user_id);

        if user_id == nil then
            return;
        end

        local player_name = user_id:get_name();

        if player_name == nil then
            return;
        end

        engine_client:client_cmd('say '.. player_name ..' has aborted defusing the bomb!');
    end

    if event:get_name() == 'bomb_defused' then
        local event_user_id = event:get_int('userid');

        local user_id = entity_list:get_player_from_id(event_user_id);

        if user_id == nil then
            return;
        end

        local player_name = user_id:get_name();

        if player_name == nil then
            return;
        end

        engine_client:client_cmd('say '.. player_name ..' has defused the bomb!');
    end
end

callbacks:add('events', on_events);
