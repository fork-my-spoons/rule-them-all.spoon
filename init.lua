local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Rule Them All"
obj.version = "1.0"
obj.author = "Pavel Makhov"
obj.homepage = "https://github.com/fork-my-spoons/rule-them-all.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.indicator = nil
obj.iconPath = hs.spoons.resourcePath("icons")
obj.timer = nil
obj.refreshTimer = nil
obj.notificationType = nil
obj.menu = {}


local user_icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})
local loaded_icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})
local not_loaded_icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#8e8e8e'}})

function obj:buildMenu()

    obj.menu = {}
    local spoons = hs.spoons.list()
    table.sort(spoons, function(left, right) return left.loaded and not right.loaded end)
    local cur = nil
    for k, v in pairs(spoons) do
        if (cur ~= v.loaded) then
            if (cur ~= nill) then
                table.insert(obj.menu, {title = '-'})
            end

            table.insert(obj.menu, {
                title = v.loaded and 'Loaded' or 'Not loaded',
                disabled = true
            })
        end

        local sp = require(v.name)
        local item = {
            title = hs.styledtext.new(sp.name == nil and v.name or sp.name .. '\n')
                .. hs.styledtext.new(v.version == nil and '' or v.version .. '   ', {color = {hex = '#8e8e8e'}})
                .. user_icon ..  hs.styledtext.new(sp.author == nil and '' or sp.author, {color = {hex = '#8e8e8e'}})
        }
        
        if (sp.check_for_updates ~= nil) then
            item.menu = {{
                title = 'Check for updates',
                fn = function() sp.check_for_updates() end
            }}
        end

        table.insert(obj.menu, item)
        cur = v.loaded
    end

    return obj.menu
end

function obj:init()
    self.indicator = hs.menubar.new()
    self.indicator:setIcon(hs.image.imageFromPath(self.iconPath .. '/vip-crown-line.png'):setSize({w=16,h=16}), true)

    self.indicator:setMenu(self.buildMenu)

end

function obj:setup(args)
    self.notificationType = args.notificationType or 'alert'
end

return obj