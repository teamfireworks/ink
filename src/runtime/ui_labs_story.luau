local RunService = game:GetService("RunService")

local mount = require("./mount")
local types = require("../types")

type Cleanup = () -> ()

type GenericInfo<T> = { __old: T, __new: T }

type SubscribeListener = (values: { [string]: unknown }, info: { [string]: GenericInfo<unknown> }) -> ()

type GenericProperties = {
	controls: { [string]: unknown },
	target: GuiObject,
	converted: { [string]: unknown },
	subscribe: (listener: SubscribeListener) -> Cleanup,
}

type GenericStory<C = nil> = {
	name: string?,
	summary: string?,
	cleanup: Cleanup?,
	controls: C?,
	render: (properties: GenericProperties) -> Cleanup?,
}

--- Wraps a component as a UI Labs story.
const function ui_labs_story<C>(story: types.Story<C>): GenericStory<C>
	return {
		name = story.name,
		summary = story.summary,
		cleanup = story.cleanup,
		controls = story.controls,
		render = function(generic_properties)
			const target = generic_properties.target

			const catcher = Instance.new("Frame")
			catcher.Name = "InkInputCatcher"
			catcher.BackgroundTransparency = 1
			catcher.Size = UDim2.fromScale(1, 1)
			catcher.ZIndex = 2_000_000_000
			catcher.Active = false
			catcher.Parent = target

			const properties: types.StoryProperties<C> = {
				controls = generic_properties.controls :: any,
				target = target,
				target_bounds = Rect.new(),
				scope = nil :: any, -- set by mount on the first frame
			}

			const unsubscribe = generic_properties.subscribe(function(values)
				properties.controls = values :: any
			end)

			const render, unmount = mount(target, catcher, function(s, bounds)
				properties.scope = s
				properties.target_bounds = bounds
				return story.render(properties)
			end)

			const connection = RunService.PreRender:Connect(render)

			return function()
				connection:Disconnect()
				unmount()
				unsubscribe()
				catcher:Destroy()
			end
		end,
	}
end

return ui_labs_story
