local config = fatality.config;
local menu = fatality.menu;
local render = fatality.render;
local input = fatality.input;
local callbacks = fatality.callbacks;

local menu_position_x = config:add_item('visuals_menu_position_x', 0.0);
local menu_position_y = config:add_item('visuals_menu_position_y', 500.0);
local spectator_list_item = config:add_item('visuals_spectator_list', 0);
local spectator_list_checkbox = menu:add_checkbox('Spectator List', 'Visuals', 'Misc', 'Various', spectator_list_item);

local engine_client = csgo.interface_handler:get_engine_client();
local entity_list = csgo.interface_handler:get_entity_list();
local cvar = csgo.interface_handler:get_cvar();

local create_large_font = render:create_font('Tahoma', 20, 300, true);
local create_small_font = render:create_font('Tahoma', 12, 300, true);
local create_icon_font = render:create_font('custom_csgo_icons', 18, 300, true);

local players_name = {};
local players_index = 0;

local function draw_spectator_list(position_x, position_y, position_w, position_h, index)
    render:rect_filled(position_x + 5, position_y + 2, position_w - 10, position_h - 12 + index * 15, csgo.color(10, 10, 10, 240));
    render:rect(position_x + 5, position_y + 2, position_w - 10, 1, csgo.color(180, 180, 180, 240));
    render:text(create_icon_font, position_x + position_w - 230, position_y + 12, 't', csgo.color(190, 190, 190, 240));
    render:text(create_large_font, position_x + position_w - 205, position_y + 10, 'Current spectators', csgo.color(190, 190, 190, 240));
end

local function draw_spectators(position_x, position_y, index, text)
    render:text(create_small_font, position_x + 18, position_y + 36 + index * 15, text, csgo.color(190, 190, 190, 240));
end

local function on_paint()
    if not spectator_list_item:get_bool() then
        return;
    end

    if not engine_client:is_connected() and not engine_client:is_in_game() then
        return;
    end

    local mouse_position = input:get_mouse_pos();

    if input:is_key_down(0x2E) and input:is_key_down(0x01) then
        menu_position_x:set_int(mouse_position.x);
        menu_position_y:set_int(mouse_position.y);
    end

    local local_player = entity_list:get_localplayer();

    if local_player == nil then
        return;
    end

    for i = 1, entity_list:get_max_players(), 1 do
        local player_id = entity_list:get_player(i);

        if player_id == nil then
            goto continue;
        end

        if player_id:is_alive() or player_id:is_dormant() then
            goto continue;
        end

        local player_name = player_id:get_name();

        if player_name == nil then
            goto continue;
        end

        local observer_target_handle = player_id:get_var_handle('CBasePlayer->m_hObserverTarget');
        local observer_target = entity_list:get_from_handle(observer_target_handle);

        if observer_target == nil then
            goto continue;
        end

        if observer_target:get_index() == local_player:get_index() then
            players_name[players_index] = player_name;
            players_index = players_index + 1;
        end

        ::continue::
    end

    draw_spectator_list(menu_position_x:get_int(), menu_position_y:get_int(), 250, 50, players_index);

    for index = 0, players_index, 1 do
        if players_name[index] == nil then
            break;
        end

        if string.len(players_name[index]) > 16 then
            players_name[index] = string.sub(players_name[index], 0, 16);
        end

        draw_spectators(menu_position_x:get_int(), menu_position_y:get_int(), index, players_name[index]);
    end
end

callbacks:add('paint', on_paint);
