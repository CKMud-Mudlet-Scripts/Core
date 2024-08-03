local fried = {}


function fried:run_init(what, func)
    -- Return an init function that prints out whats going on

    local function init()
        cecho("<green>[ FRIED ] - Calling " .. what .. " Init!\n")
        func()
    end

    return init
end

function fried:make_enum(name, alist)
    -- Create an Enum Table with helpful enum values
    local atable = {}
    for _, v in ipairs(alist) do
        atable[v] = { name .. "." .. v }
    end
    setmetatable(
        atable,
        {
            __index =
                function(self, key)
                    error(string.format("%q is not a valid member of %s", tostring(key), name), 2)
                end,
        }
    )
    return atable
end

local mydb = db:create("fried_settings", {
    Toggles = {
        name = "",
        value = 0,
        _unique = { "name" },
        _violations = "REPLACE",
    },
    Constants = {
        name = "",
        value = "",
        _unique = { "name" },
        _violations = "REPLACE",
    }
})

fried.settings_db = mydb

function fried:set_constant(name, value)
    db:add(mydb.Constants, { name = name, value = value })
end

function fried:read_constant(name)
    rec = db:fetch(mydb.Constants, db:eq(mydb.Constants.name, name))
    if not rec[1] then
        return nil
    end
    return rec[1].value
end

function fried:delete_constant(name)
    db:delete(mydb.Constants, db:eq(mydb.Constants.name, name))
end

function fried:toggle(name, value)
    if value == nil then
        value = true
    end
    db:add(mydb.Toggles, { name = name, value = value and 1 or 0 })
end

function fried:read_toggle(name)
    rec = db:fetch(mydb.Toggles, db:eq(mydb.Toggles.name, name))
    if not rec[1] then
        return nil
    end
    return rec[1].value == 1
end

function fried:delete_toggle(name)
    db:delete(mydb.Toggles, db:eq(mydb.Toggles.name, name))
end

return fried
