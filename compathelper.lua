local VERSION = 1

---@type table<string, function>
local entries = {}

if ModCompatHelper then
    if ModCompatHelper.VERSION > VERSION then
        return
    end

    entries = ModCompatHelper.Entries

    if REPENTOGON then
        ModCompatHelper:RemoveCallback(ModCallbacks.MC_POST_MODS_LOADED, ModCompatHelper.Load)
    end

    ModCompatHelper:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, ModCompatHelper.Load)
end

ModCompatHelper = RegisterMod("Mod Compatibility Helper", 1)
ModCompatHelper.VERSION = VERSION
ModCompatHelper.Entries = entries

function ModCompatHelper:Load()
    for _, v in ipairs(ModCompatHelper.Entries) do
        if _G[v[1]] then
            v[2]()
        end
    end
end

function ModCompatHelper:Register(mod, global, fn)
    ModCompatHelper.Entries[#ModCompatHelper.Entries + 1] = {global, fn, mod}
end

function ModCompatHelper:Init()
    if Isaac.GetFrameCount() > 0 then
        ModCompatHelper:Load()
    end
end

function ModCompatHelper:Clear(mod)
    local copy = {}

    for _, v in ipairs(ModCompatHelper.Entries) do
        if v[3].Name ~= mod.Name then
            copy[#copy + 1] = v
        end
    end

    ModCompatHelper.Entries = copy
end

if REPENTOGON then
    ModCompatHelper:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, ModCompatHelper.Load)
else
    ModCompatHelper:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ModCompatHelper.Load)
end
