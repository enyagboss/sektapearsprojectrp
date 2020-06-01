script_name("id samp")
script_author("enyag")
script_description("Помощь каждой фракции отдельно.")
require "lib.moonloader"

local keys = require "vkeys"
local dlstatus = require("moonloader").download_status
local inicfg = require "inicfg"
local memory = require 'memory'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8

local script_vers = 1
local script_vers_text = "1.00"

local update_url = "https://raw.githubusercontent.com/enyagboss/sektapearsprojectrp/master/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = ""
local script_path = thisScript().path

local main_window_state = imgui.ImBool(false)
local text_buffer = imgui.ImBuffer(256)

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand("sektapearsprojectrp", cmd_sektapearsprojectrp)

    _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

downloadUrlToFile(update_url, update_path, function(id, status)
if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    updateIni = inicfg.load(nil, update_path)
    tonumber(updateIni.info.vers) > script_vers then
        sampAddChatMessage("Есть обновление! Версия:".. updateIni.info.vers_text)
   update_state = true
    end
    os.remove(update_path)
end
end)

    while true do
        wait(0)

        if update_state then
            downloadUrlToFile(update_url, update_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлён.")
                    thisScript():reload()
                end
        end)
        break
    end

        if not main_window_state.v then
        imgui.Process = false
    end
end
end

function cmd_sektapearsprojectrp(arg)
    local sw, sh = getScreenResolution()
    -- center
    imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(300, 200))
main_window_state.v = not main_window_state.v
if imgui.Process == false then
    imgui.Process = main_window_state.v
end

function imgui.OnDrawFrame()
    local sw, sh = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.CondFirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(250, 200), imgui.Cond.FirstUseEver)

        if main_window_state.v then
            imgui.Begin(u8"Главное окно скрипта.", main_window_state)
            imgui.Text(u8"/fakenick [id] [nick]")
            imgui.InputText(u8"Введите айди, затем новый ник.", text_buffer)
            if imgui.Button(u8"Готово.") then
                sampSendChat("/fakenick ".. u8:decode(text_buffer.v))
            end
            imgui.End()
        end
    end
end