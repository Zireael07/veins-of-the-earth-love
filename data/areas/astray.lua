local Area = require "class.Area"

area_types['astray'] = {
    name  = 'Cave',
    width = 40,
    height = 40,
    setup = function(instance)
        Area:makeAstray(40, 40)
    end
}