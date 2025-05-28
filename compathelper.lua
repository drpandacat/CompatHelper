local VERSION = 1.1

---@type table<string, function>
local entries = {}

if CompatHelper then
    if CompatHelper.VERSION > VERSION then
        return
    end

    entries = CompatHelper.Entries

    if REPENTOGON then
        CompatHelper:RemoveCallback(ModCallbacks.MC_POST_MODS_LOADED, CompatHelper.Load)
    end

    CompatHelper:RemoveCallback(ModCallbacks.MC_POST_GAME_STARTED, CompatHelper.Load)
end

CompatHelper = RegisterMod("Mod Compatibility Helper", 1)
CompatHelper.VERSION = VERSION
CompatHelper.Entries = entries

function CompatHelper:Load()
    for _, v in ipairs(CompatHelper.Entries) do
        if _G[v[1]] then
            v[2]()
        end
    end
end

function CompatHelper:Register(mod, global, fn)
    CompatHelper.Entries[#CompatHelper.Entries + 1] = {global, fn, mod}
end

function CompatHelper:Init()
    if Isaac.GetFrameCount() > 0 then
        CompatHelper:Load()
    end
end

function CompatHelper:Clear(mod)
    local copy = {}

    for _, v in ipairs(CompatHelper.Entries) do
        if v[3].Name ~= mod.Name then
            copy[#copy + 1] = v
        end
    end

    CompatHelper.Entries = copy
end

if REPENTOGON then
    CompatHelper:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, CompatHelper.Load)
else
    CompatHelper:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, CompatHelper.Load)
end
