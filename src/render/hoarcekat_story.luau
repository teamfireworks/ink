local RunService = game:GetService("RunService")

local mount = require("./mount")
local types = require("../types")

--- Wraps a component as a Hoarcekat story.
const function hoarcekat_story(story: types.Story<nil>): (target: GuiObject) -> types.Cleanup
	return function(target)
		const catcher = Instance.new("Frame")
		catcher.Name = "InkInputCatcher"
		catcher.BackgroundTransparency = 1
		catcher.Size = UDim2.fromScale(1, 1)
		catcher.ZIndex = 2_000_000_000
		catcher.Active = true
		catcher.Parent = target

		const properties: types.StoryProperties<nil> = {
			target = target,
			target_bounds = Rect.new(),
			scope = nil :: any, -- set by mount on the first frame
		}

		const render, unmount = mount(target, catcher, function(s, bounds)
			properties.scope = s
			properties.target_bounds = bounds
			return story.render(properties)
		end)

		const connection = RunService.PreRender:Connect(render)

		return function()
			connection:Disconnect()
			unmount()
			catcher:Destroy()
		end
	end
end

return hoarcekat_story
