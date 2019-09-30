local config = fatality.config;
local menu = fatality.menu;
local callbacks = fatality.callbacks;

local chat_spam_item = config:add_item('misc_chat_spam', 0.0);
local chat_spam_checkbox = menu:add_checkbox('Chat Spam', 'Visuals', 'Misc', 'Various', chat_spam_item);

local engine_client = csgo.interface_handler:get_engine_client();
local entity_list = csgo.interface_handler:get_entity_list();
local events = csgo.interface_handler:get_events();

local add_player_death_avent = events:add_event('player_death');
local add_bomb_dropped_event = events:add_event('bomb_dropped');
local add_bomb_begin_plant_event = events:add_event('bomb_beginplant');
local add_bomb_planted_event = events:add_event('bomb_planted');
local add_bomb_begin_defuse_event = events:add_event('bomb_begindefuse');
local add_bomb_abort_defuse_event = events:add_event('bomb_abortdefuse');
local add_bomb_defused_event = events:add_event('bomb_defused');

local function on_events(event)
    if not chat_spam_item:get_bool() then
        return;
    end

    if not engine_client:is_connected() and not engine_client:is_in_game() then
        return;
    end

    if event:get_name() == 'player_death' then
        local EVENT_USER_ID = event:get_int('userid');
        local EVENT_ATTACKER = event:get_int('attacker');
        local EVENT_WEAPON = event:get_string('weapon');
        local EVENT_HEADSHOT = event:get_bool('headshot');

        local LOCAL_PLAYER = entity_list:get_localplayer();
        local USER_ID = entity_list:get_player_from_id(EVENT_USER_ID);
        local ATTACKER = entity_list:get_player_from_id(EVENT_ATTACKER);

        if EVENT_WEAPON == nil or EVENT_HEADSHOT == nil or LOCAL_PLAYER == nil or USER_ID == nil or ATTACKER == nil then
            return;
        end

        local PLAYER_NAME = USER_ID:get_name();

        if PLAYER_NAME == nil then
            return;
        end

        if not ATTACKER:get_index() == ATTACKER:get_index() then
            return;
        end

        if ATTACKER:get_index() == LOCAL_PLAYER:get_index() then
            if EVENT_HEADSHOT then
                engine_client:client_cmd('say '.. PLAYER_NAME ..' just died by a headshot to my '.. EVENT_WEAPON ..'!');
            else
                engine_client:client_cmd('say '.. PLAYER_NAME ..' just died to my '.. EVENT_WEAPON ..'!');
            end
        end
    end

    if event:get_name() == 'bomb_dropped' then
        local EVENT_USER_ID = event:get_int('userid');

        local USER_ID = entity_list:get_player_from_id(EVENT_USER_ID);

        if USER_ID == nil then
            return;
        end

        local PLAYER_NAME = USER_ID:get_name();

        if PLAYER_NAME == nil then
            return;
        end

        engine_client:client_cmd('say '.. PLAYER_NAME ..' has dropped the bomb!');
    end

    if event:get_name() == 'bomb_beginplant' then
        local EVENT_USER_ID = event:get_int('userid');

        local USER_ID = entity_list:get_player_from_id(EVENT_USER_ID);

        if USER_ID == nil then
            return;
        end

        local PLAYER_NAME = USER_ID:get_name();

        if PLAYER_NAME == nil then
            return;
        end

        engine_client:client_cmd('say '.. PLAYER_NAME ..' has begun to plant the bomb!');
    end

    if event:get_name() == 'bomb_planted' then
        local EVENT_USER_ID = event:get_int('userid');

        local USER_ID = entity_list:get_player_from_id(EVENT_USER_ID);

        if USER_ID == nil then
            return;
        end

        local PLAYER_NAME = USER_ID:get_name();

        if PLAYER_NAME == nil then
            return;
        end

        engine_client:client_cmd('say '.. PLAYER_NAME ..' has planted the bomb!');
    end

    if event:get_name() == 'bomb_begindefuse' then
        local EVENT_USER_ID = event:get_int('userid');

        local USER_ID = entity_list:get_player_from_id(EVENT_USER_ID);

        if USER_ID == nil then
            return;
        end

        local PLAYER_NAME = USER_ID:get_name();

        if PLAYER_NAME == nil then
            return;
        end

        engine_client:client_cmd('say '.. PLAYER_NAME ..' has began to defuse the bomb!');
    end

    if event:get_name() == 'bomb_abortdefuse' then
        local EVENT_USER_ID = event:get_int('userid');

        local USER_ID = entity_list:get_player_from_id(EVENT_USER_ID);

        if USER_ID == nil then
            return;
        end

        local PLAYER_NAME = USER_ID:get_name();

        if PLAYER_NAME == nil then
            return;
        end

        engine_client:client_cmd('say '.. PLAYER_NAME ..' has aborted defusing the bomb!');
    end

    if event:get_name() == 'bomb_defused' then
        local EVENT_USER_ID = event:get_int('userid');

        local USER_ID = entity_list:get_player_from_id(EVENT_USER_ID);

        if USER_ID == nil then
            return;
        end

        local PLAYER_NAME = USER_ID:get_name();

        if PLAYER_NAME == nil then
            return;
        end

        engine_client:client_cmd('say '.. PLAYER_NAME ..' has defused the bomb!');
    end
end

callbacks:add('events', on_events);
