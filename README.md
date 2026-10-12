# zen-mods

Mods for [Zen Browser](https://zen-browser.app), installable with
[Sine](https://github.com/CosmoCreeper/Sine). Each mod lives in its own folder
(`theme.json`, `chrome.css`, `preferences.json`, `readme.md`, `image.png`).

| Mod | What it does |
| --- | --- |
| [Split View Focus Ring](split-view-focus-ring/) | Makes the active Split View pane obvious: ring color presets or a custom color, width, opacity, glow, dimming of inactive panes. |

![Split View Focus Ring](https://raw.githubusercontent.com/rachaen/zen-mods/main/split-view-focus-ring/image.png)

## Installing

Install Sine, then find the mod in Sine's marketplace or add it from the mod
folder's URL (for example
`https://github.com/rachaen/zen-mods/tree/main/split-view-focus-ring`).

## Trying a mod without a mod manager

Each mod folder has an `install-local.sh` that copies its `chrome.css` into your
Zen profile as `userChrome.css` and enables legacy stylesheet loading. Quit Zen,
run the script, relaunch.

## License

All mods in this repository are licensed under
[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).
