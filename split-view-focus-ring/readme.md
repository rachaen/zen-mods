# Split View Focus Ring

![Split View Focus Ring](https://raw.githubusercontent.com/rachaen/zen-mods/main/split-view-focus-ring/image.png)

Zen highlights the active pane in Split View with a 2 px outline whose color is
derived from your **accent color**. With many themes that ring is nearly
invisible, so you click a pane thinking it is focused, hit *Back*, and the
*other* pane navigates.

This mod replaces the ring with one you can actually see, and lets you tune it
from the mod's settings.

## Install

1. Install [Sine](https://github.com/CosmoCreeper/Sine), the mod manager for Zen.
2. Find **Split View Focus Ring** in Sine's marketplace, or add it from this
   folder's URL: `https://github.com/rachaen/zen-mods/tree/main/split-view-focus-ring`.
3. Change the options below in Sine's settings for the mod.

## Options

| Option | Type | Default | Notes |
| --- | --- | --- | --- |
| Ring color | dropdown | Auto | *Auto* uses the complementary hue of your accent color, so it always stands out. *Accent, boosted* keeps the accent hue at full saturation. *Black / White* picks by color scheme. Eight fixed presets, or *Custom*. |
| Custom color | text | empty | Any CSS color (`#ff5c5c`, `rgb(...)`, `light-dark(a, b)`). Only used when Ring color is *Custom*. |
| Ring width | dropdown | 3 px | 2 / 3 / 4 / 6 px |
| Ring opacity | dropdown | 100 % | 100 / 80 / 60 / 40 % |
| Soft glow | checkbox | off | Translucent halo outside the ring. |
| Dim inactive panes | checkbox | off | Lowers opacity of every pane that is not focused. |
| Inactive pane opacity | dropdown | 70 % | 85 / 70 / 50 %, used when dimming is on. |
| Animate focus change | checkbox | on | 120 ms fade of the ring when focus moves between panes. |

## How it works

Zen's own rule lives in `src/zen/split-view/zen-split-view.css`:

```css
.browserSidebarContainer.deck-selected {
  outline: 2px solid var(--zen-active-split-outline-color) !important;
}
```

This mod overrides that declaration (Zen loads mods as a user-origin sheet, so a
mod's `!important` wins) and also repoints `--zen-active-split-outline-color`,
so the drag-handle / unsplit overlay keeps matching the ring.

Dropdown and checkbox values are read with `-moz-pref()` media queries; the
custom color arrives as the CSS variable `--mod-splitfocus-custom_color`.

Verified against Zen 1.22.1b; the relevant selectors are unchanged on the
current `dev` branch.

## Using it without a mod manager

1. Copy `chrome.css` to `<profile>/chrome/userChrome.css`.
2. In `about:config` set `toolkit.legacyUserProfileCustomizations.stylesheets` to `true`.
3. Restart Zen. Without a mod manager, the `mod.splitfocus.*` preferences do not
   exist, so every option runs at its default (Auto color, 3 px, 100 %, animated).
   To try another value locally, create the pref by hand in `about:config`,
   e.g. string `mod.splitfocus.color` = `red`, then restart.
