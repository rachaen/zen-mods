# zen-mods

Mods for [Zen Browser](https://zen-browser.app), each in its own folder in the
layout the [Zen Mods store](https://github.com/zen-browser/theme-store) expects
(`chrome.css`, `preferences.json`, `readme.md`, `image.png`).

| Mod | What it does |
| --- | --- |
| [Split View Focus Ring](split-view-focus-ring/) | Makes the active Split View pane obvious: ring color presets or a custom color, width, opacity, glow, dimming of inactive panes. |

![Split View Focus Ring](https://raw.githubusercontent.com/rachaen/zen-mods/main/split-view-focus-ring/image.png)

## Trying a mod locally

Each mod folder has an `install-local.sh` that copies its `chrome.css` into your
Zen profile as `userChrome.css` and enables legacy stylesheet loading. Quit Zen,
run the script, relaunch.

## License

Mods submitted to the Zen Mods store are distributed under
[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/), as the
store requires.
