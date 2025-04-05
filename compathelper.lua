local VERSION = 1

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
    for k, v in pairs(CompatHelper.Entries) do
        if _G[k] then
            v()
        end
    end
end

function CompatHelper:Register(global, fn)
    CompatHelper.Entries[global] = fn
end

if REPENTOGON then
    CompatHelper:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, CompatHelper.Load)
else
    CompatHelper:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, CompatHelper.Load)
end

if Isaac.GetFrameCount() > 0 then
    CompatHelper:Load()
end
