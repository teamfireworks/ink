<h1>
    <img src="./.luaudocs/public/wordmark.png" alt="Ink" height="200" />
    <br/>
    Roblox UI beyond the instance tree
</h1>

<h3><a href="https://teamfireworks.github.io/ink">Documentation →</a></h3>

Ink is an immediate-mode UI library for Roblox. You build composites from simple
shapes, lay them out with plain functions, and animate anything, without
fighting the instance tree.

<h2>Example Code</h2>

```luau
local function button(s: ink.Scope, label: string, on_click: () -> ())
	local content = ink.pad_xy(ink.text(label, STYLE, WHITE), ink.rem(s, 1), ink.rem(s, 0.75))
	local hit = ink.hit_region(s:key("hit"), content.bounds)

	if hit.clicked then
		on_click()
	end

    local bg_color = if hit.state == Enum.GuiState.Hover then LIGHT else DARK
	local bg = ink.tween(s:key("bg"), bg_color, 0.15, Enum.EasingStyle.Quart)

	return ink.compose({ ink.solid(content.bounds, bg), content, hit }, content.bounds)
end

local function ui()
    local menu = ink.v_stack({
        button(scope:key("play"), "Play", play),
        button(scope:key("settings"), "Settings", open_settings),
    }, 8, ink.ALIGN_MID)

    return ink.align(menu, viewport, ink.ALIGN_MID, ink.ALIGN_MID)
end
```
