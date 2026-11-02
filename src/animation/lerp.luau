const lerp_types = require("./datatypes/lerp_types")
local log = require("../runtime/log")

--- Interpolates between two values of the same type.
const function lerp<T>(initial: T, goal: T, alpha: number): T
	const initial_kind, goal_type = typeof(initial), typeof(goal)
	if initial_kind == goal_type then
		const lerp_type = lerp_types[initial_kind] or log.error(log.messages.cannot_animate(initial_kind))
		return lerp_type(initial, goal, alpha)
	else
		return log.error(log.messages.lerp_mismatch(initial_kind, goal_type))
	end
end

return lerp
