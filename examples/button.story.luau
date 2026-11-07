const ink = require("../src")

const CONTROLS = {
	label = "Continue Game",
	color = ink.color.INK_ORANGE,
}

return ink.ui_labs_story({
	controls = CONTROLS,
	render = function(properties: ink.StoryProperties<typeof(CONTROLS)>)
		local s = properties.scope:key("button")

		local content_height = ink.rem(s, 1.25)
		local text_style = ink.expensive(s, function(_, text_size: number): ink.TextStyle
			return {
				size = text_size,
				font = Enum.Font.GothamBold,
			}
		end, content_height)

		local content = ink.h_stack({
			ink.image(ink.rect_squared(content_height), "rbxassetid://8517323790"),
			ink.text(properties.controls.label, text_style),
		}, ink.rem(s, 0.5), ink.ALIGN_MID)
		content = ink.pad(content, ink.edges.xy(ink.rem(s, 1.25), ink.rem(s, 1)))

		local bg = ink.solid(content.bounds)
		bg = ink.round(bg, ink.corners.all(ink.rem(s, 1)))

		local shadow = ink.solid(content.bounds)
		shadow = ink.round(shadow, ink.corners.all(ink.rem(s, 1)))

		local hit = ink.hit_region(properties.scope:key("hitbox"), bg.bounds)

		const target_bg = if hit.state == Enum.GuiState.Hover
			then ink.color.shade(properties.controls.color, 0.05)
			elseif hit.state == Enum.GuiState.Press then ink.color.shade(properties.controls.color, -0.05)
			else properties.controls.color
		const target_fg = ink.color.shade(target_bg, -0.25)

		bg = ink.tint(bg, ink.tween(properties.scope:key("color_bg"), target_bg, 0.2))
		content = ink.tint(content, ink.tween(properties.scope:key("color_fg"), target_fg, 0.2))
		shadow = ink.tint(shadow, ink.tween(properties.scope:key("color_shadow"), target_fg, 0.2))

		local surface = ink.compose({ bg, content })
		local inset = ink.tween(
			properties.scope:key("inset"),
			ink.rem(s, hit.state == Enum.GuiState.Press and 0.25 or 0.5),
			0.1,
			Enum.EasingStyle.Quint
		)
		shadow = ink.translate(shadow, 0, inset)

		const count_scope = properties.scope:key("count")
		local count = count_scope:get(0)
		if hit.clicked then
			count += 1
			print(`{count}x presses`)
		end
		count_scope:set(count)

		local button = ink.compose({ shadow, surface, hit }, shadow.bounds)
		button = ink.align(button, properties.target_bounds, 0.5, 0.5)

		return button
	end,
})
