local Area = require "class.Area"

area_types['arena'] = {
    name  = 'Arena',
    width = 20,
    height = 20,
    ["."] = "floor_sand",
    ["#"] = "wall",
    setup = function(instance)
        Area:makeWalled(instance, 20, 20)
    end
}