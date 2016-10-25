local Area = require "class.Area"

area_types['test'] = {
    name  = 'Test',
    width = 20,
    height = 20,
    setup = function(instance)
        Area:makeWalled(20, 20)
    end
}