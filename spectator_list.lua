local config = fatality.config;
local menu = fatality.menu;
local render = fatality.render;
local input = fatality.input;
local callbacks = fatality.callbacks;

local spectator_list_item = config:add_item('visuals_spectator_list', 0);
local spectator_list_checkbox = menu:add_checkbox('Spectator List', 'Visuals', 'Misc', 'Various', spectator_list_item);

local screen_size = render:screen_size();
local create_small_font = render:create_font('Calibri Light', 18, 300, true);

local spectator_list_x = config:add_item('visuals_spectator_list_x', 0.0);
local spectator_list_y = config:add_item('visuals_spectator_list_y', screen_size.y / 2);

local engine_client = csgo.interface_handler:get_engine_client();
local entity_list = csgo.interface_handler:get_entity_list();
local cvar = csgo.interface_handler:get_cvar();

local function draw_title(position_x, position_y, title, title_color)
    local TEXT_WIDTH = position_x + 15;
    local TEXT_HEIGHT = position_y - 15;

    render:text(create_small_font, TEXT_WIDTH, TEXT_HEIGHT, title, title_color);
end

local function draw_players(position_x, position_y, index, text, text_color)
    local TEXT_WIDTH = position_x + 28;
    local TEXT_HEIGHT = position_y + index * 15;

    render:text(create_small_font, TEXT_WIDTH, TEXT_HEIGHT, text, text_color);
end

local function draw_spectator_list(position_x, position_y)
    local PLAYER = {};
    local INDEX = 0;

    local LOCAL_PLAYER = entity_list:get_localplayer();

    if LOCAL_PLAYER == nil then
        return;
    end

    for I = 1, entity_list:get_max_players(), 1 do
        local PLAYER_INDEX = entity_list:get_player(I);

        if PLAYER_INDEX == nil or PLAYER_INDEX:is_alive() or PLAYER_INDEX:is_dormant() then
            goto continue;
        end

        local PLAYER_NAME = PLAYER_INDEX:get_name();

        if PLAYER_NAME == nil then
            goto continue;
        end

        PLAYER[INDEX] = PLAYER_NAME;
        INDEX = INDEX + 1;

        ::continue::
    end

    draw_title(position_x, position_y, 'Spectators', csgo.color(255, 255, 255, 255));

    for I = 0, INDEX, 1 do
        if PLAYER[I] == nil then
            break;
        end

        local PLAYER_INDEX = entity_list:get_player(I);

        if PLAYER_INDEX == nil then
            return;
        end

        local PLAYER_NAME = PLAYER_INDEX:get_name();

        if PLAYER_NAME == nil then
            return;
        end

        if PLAYER_INDEX:get_index() == LOCAL_PLAYER:get_index() then
            color = csgo.color(171, 222, 151, 255);
        else
            color = csgo.color(174, 208, 230, 255);
        end

        draw_players(position_x, position_y, I, PLAYER[I] .. ' -> ' .. PLAYER_NAME, color);
    end
end

local function on_paint()
    if not spectator_list_item:get_bool() then
        return;
    end

    local MOUSE_POSITION = input:get_mouse_pos();

    if input:is_key_down(0x2E) and input:is_key_down(0x01) then
        spectator_list_x:set_int(MOUSE_POSITION.x);
        spectator_list_y:set_int(MOUSE_POSITION.y);
    end

    draw_spectator_list(spectator_list_x:get_int(), spectator_list_y:get_int());
end

callbacks:add('paint', on_paint);
