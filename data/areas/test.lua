local Area = require "class.Area"

area_types['test'] = {
    name  = 'Test',
    width = 20,
    height = 20,
    ["."] = "floor",
    ["#"] = "wall",
    setup = function(instance)
        Area:makeWalled(instance, 20, 20)
    end
}