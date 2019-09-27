local config = fatality.config;
local menu = fatality.menu;
local callbacks = fatality.callbacks;

local wall_color_modifier_item = config:add_item('visuals_wall_color_modifier', 0.0);
local wall_color_modifier_checkbox = menu:add_checkbox('Wall Color Modifier', 'Visuals', 'Misc', 'Various', wall_color_modifier_item);

local wall_color_r_item = config:add_item('visuals_wall_color_r', 0.0);
local wall_color_r_slider = menu:add_slider('R Color', 'Visuals', 'Misc', 'Various', wall_color_r_item, -255.0, 255.0, 1.0);
local wall_color_g_item = config:add_item('visuals_wall_color_g', 0.0);
local wall_color_g_slider = menu:add_slider('G Color', 'Visuals', 'Misc', 'Various', wall_color_g_item, -255.0, 255.0, 1.0);
local wall_color_b_item = config:add_item('visuals_wall_color_b', 0.0);
local wall_color_b_slider = menu:add_slider('B Color', 'Visuals', 'Misc', 'Various', wall_color_b_item, -255.0, 255.0, 1.0);

local engine_client = csgo.interface_handler:get_engine_client();
local cvar = csgo.interface_handler:get_cvar();

local mat_ambient_light_r = cvar:find_var('mat_ambient_light_r');
local mat_ambient_light_g = cvar:find_var('mat_ambient_light_g');
local mat_ambient_light_b = cvar:find_var('mat_ambient_light_b');

function on_paint()
    if not engine_client:is_connected() and not engine_client:is_in_game() then
        return;
    end

    if wall_color_modifier_item:get_bool() then
        mat_ambient_light_r:set_int(wall_color_r_item:get_int());
        mat_ambient_light_g:set_int(wall_color_g_item:get_int());
        mat_ambient_light_b:set_int(wall_color_b_item:get_int());
    else
        mat_ambient_light_r:set_int(0);
        mat_ambient_light_g:set_int(0);
        mat_ambient_light_b:set_int(0);
    end
end

callbacks:add('paint', on_paint);
