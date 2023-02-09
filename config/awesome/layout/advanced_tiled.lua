--------------------------------------------------------------------------
--             _                               _   _   _ _          _   -- 
--            | |                             | | | | (_) |        | |  --
--    __ _  __| |_   ____ _ _ __   ___ ___  __| | | |_ _| | ___  __| |  --
--   / _` |/ _` \ \ / / _` | '_ \ / __/ _ \/ _` | | __| | |/ _ \/ _` |  --
--  | (_| | (_| |\ V / (_| | | | | (_|  __/ (_| | | |_| | |  __/ (_| |  --
--   \__,_|\__,_| \_/ \__,_|_| |_|\___\___|\__,_|  \__|_|_|\___|\__,_|  --
--                                                                      --
--                                                                      --
--------------------------------------------------------------------------
    -- Vito

local tag = require("awful.tag")
local math = math
local capi =
{
    mouse = mouse,
    screen = screen,
    mousegrabber = mousegrabber
}

local tile = {}

local function stack(gs, cls, workarea, clients)
    
    local y = workarea["y"]
    local step = math.floor(workarea["height"] / (clients.last - clients.first + 1))
    local rest = workarea["height"] - step*(clients.last - clients.first + 1)
    
    
    for i = clients.first,clients.last do
        local height = step
        if i == clients.last then
            height = height + rest
        end

        local geom = {}
        geom["width"] = workarea["width"]
        geom["height"] = height
        geom["x"] = workarea["x"]
        geom["y"] = y

        gs[cls[i]] = geom
        y = y + height
    end

end

local function do_tile(param)

    local t = param.tag or capi.screen[param.screen].selected_tag
    local wa = param.workarea
    local gs = param.geometries
    local cls = param.clients
    local ncl = #(param.clients)

    local data = tag.getdata(t).windowfact
    if not data then
        data = {}
        tag.getdata(t).windowfact = data
    end

    if ncl == 1 then
        local geom = {}
        geom["width"] = wa["width"]
        geom["height"] = wa["height"]
        geom["x"] = wa["x"]
        geom["y"] = wa["y"]
        gs[cls[1]] = geom
    end

    if ncl == 2 then
        local width = math.floor(wa["width"]/4)

        if wa["width"] < wa["height"]*3 then -- falls nöd ultra wide
            width = math.floor(wa["width"]/2)
        end

        local geom1 = {}
        geom1["width"] = width
        geom1["height"] = wa["height"]
        geom1["x"] = wa["x"]
        geom1["y"] = wa["y"]
        gs[cls[1]] = geom1
        local geom2 = {}
        geom2["width"] = wa["width"] - width
        geom2["height"] = wa["height"]
        geom2["x"] = wa["x"] + width
        geom2["y"] = wa["y"]
        gs[cls[2]] = geom2
    end

    if ncl > 2 then
        local geom_left = {}
        geom_left["width"] = math.floor(wa["width"]/4)
        geom_left["height"] = wa["height"]
        geom_left["x"] = wa["x"]
        geom_left["y"] = wa["y"]

        local geom = {}
        geom["width"] = wa["width"] - 2*math.floor(wa["width"]/4)
        geom["height"] = wa["height"]
        geom["x"] = wa["x"] + math.floor(wa["width"]/4)
        geom["y"] = wa["y"]

        local geom_right = {}
        geom_right["width"] = math.floor(wa["width"]/4)
        geom_right["height"] = wa["height"]
        geom_right["x"] = wa["x"] + wa["width"] - math.floor(wa["width"]/4)
        geom_right["y"] = wa["y"]

        stack(gs, cls, geom_right, {first = 1, last = math.floor(ncl/2)})
        gs[cls[ ncl ]] = geom
        stack(gs, cls, geom_left, {first = math.floor(ncl/2)+1, last = ncl-1})
    end

end


tile.arrange = do_tile
tile.name = "advanced tile"

return tile