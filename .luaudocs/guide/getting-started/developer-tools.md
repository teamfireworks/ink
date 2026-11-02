---
title: Developer Tools
sidebar_position: 3
---

# Developer Tools

## Storybooks

Ink supports several storybook plugins on Roblox that allow you to preview and
hot-reload your UI components.

### UI Labs

Construct your story with `ink.ui_labs_story`:

```luau
return ink.ui_labs_story({
	controls = {
		label = "Press Me"
	},
	render = function(properties)
		local btn = button(properties.scope:key("btn"), properties.controls.label)
		btn = ink.align(btn, properties.target_bounds, ink.ALIGN_MID, ink.ALIGN_MID)
		return btn
	end
})
```

::: warning

Luau incorrectly throws a type error when `:key`-ing the story's scope. You can
work around this by defining controls outside the story, and then annotating
`properties` with the `ink.StoryProperties` type:

```luau
const CONTROLS = {
	label = "Press Me"
}

return ink.ui_labs_story({
	controls = CONTROLS,
	render = function(properties: ink.StoryProperties<typeof(CONTROLS)>)
		local btn = button(properties.scope:key("btn"), properties.controls.label)
		btn = ink.align(btn, properties.target_bounds, ink.ALIGN_MID, ink.ALIGN_MID)
		return btn
	end
})
```

:::

### Hoarcekat

Construct your story with `ink.hoarcekat_story`:

```luau
return ink.hoarcekat_story({
	render = function(properties: ink.StoryPropertie)
		local btn = button(properties.scope:key("btn"), "Continue Game")
		btn = ink.align(btn, properties.target_bounds, ink.ALIGN_MID, ink.ALIGN_MID)
		return btn
	end
})
```

### Flipbook

Girl, I'm really sorry but just use UI Labs ✌️
