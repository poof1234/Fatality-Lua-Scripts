local menu = fatality.menu;
local config = fatality.config;
local callbacks = fatality.callbacks;

local radio_command_spam_item = config:add_item('misc_radio_command_spam', 0.0);
local radio_command_spam_checkbox = menu:add_checkbox('Radio Command Spam', 'Visuals', 'Misc', 'Various', radio_command_spam_item);

local engine_client = csgo.interface_handler:get_engine_client();
local global_vars = csgo.interface_handler:get_global_vars();

local tickcount = global_vars.tickcount;

local commands = {
    'go',
    'fallback',
    'sticktog',
    'holdpos',
    'followme',
    'coverme',
    'regroup',
    'roger',
    'negative',
    'cheer',
    'compliment',
    'thanks',
    'enemydown',
    'reportingin',
    'enemyspot',
    'needbackup',
    'takepoint',
    'sectorclear',
    'inposition',
    'report',
    'getout'
};

local function on_paint()
    if not radio_command_spam_item:get_bool() then
        return;
    end

    if not engine_client:is_connected and not engine_client:is_in_game() then
        return;
    end

    if global_vars.tickcount - tickcount > 32 then
        engine_client:client_cmd(commands[math.random(#commands)]);
        tickcount = global_vars.tickcount;
    end
end

callbacks:add('paint', on_paint);