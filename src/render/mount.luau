const input_collector = require("../inputs/input_collector")
const rect_sized = require("../rects/rect_sized")
const renderer = require("./renderer")
const scope = require("../state/scope")
const types = require("../types")

const function mount(
	target: GuiObject,
	source: types.InputSource,
	render_ui: (s: scope.Scope, bounds: Rect) -> types.Composite
): ((dt: number) -> (), () -> ())
	const root = scope.new()
	const view = renderer.new(target)
	const input = input_collector.new(source, function(point)
		return point - target.AbsolutePosition
	end)

	const function render(dt: number)
		root:next(dt)
		input:advance()
		const size = target.AbsoluteSize
		const composite = render_ui(root, rect_sized(size.X, size.Y))
		input:commit(composite)
		view:render(composite)
	end

	const function destroy()
		input:destroy()
		view:destroy()
	end

	return render, destroy
end

return mount
