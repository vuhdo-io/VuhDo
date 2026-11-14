VuhDo registers two equivalent chat commands, `/vd` and `/vuhdo`. Both run the same handler. VuhDo also registers `/rl` as a shortcut for the standard WoW UI reload (`ReloadUI`).

This page lists every subcommand implemented in the addon. For a short in-game list of the most common commands, type `/vd`, `/vd help`, or `/vd ?`.

## Quick reference

| Command | What it does | Combat | Reloads |
|---------|--------------|--------|---------|
| `/vd`, `/vd help`, `/vd ?` | Show the in-game command list | — | — |
| `/vd opt` | Open the VuhDo options | Can't open in combat | — |
| `/vd show` / `hide` / `toggle` | Show, hide, or toggle the heal panels | Blocked | — |
| `/vd lock` | Lock or unlock panel positions | — | — |
| `/vd reset` | Reset all panel positions | Rebuild skipped | VuhDo only |
| `/vd minimap` | Show or hide the minimap icon | — | — |
| `/vd compartment` | Show or hide the AddOn Compartment icon | — | — |
| `/vd load Profile,Layout` | Load a profile and/or key layout | — | VuhDo only |
| `/vd pt` | Toggle your target as a private tank | Ignored | — |
| `/vd pt Name1,Name2` | Add private tanks by name | Ignored | — |
| `/vd pt vdname` | Macro: add the clicked player as a private tank | Ignored | — |
| `/vd pt clear` | Remove all private tanks | — | — |
| `/vd mt` | Broadcast main tanks to the raid (CTRA) | — | — |
| `/vd roles` | Reset manually assigned roles | Rebuild skipped | VuhDo only |
| `/vd ui` | Rebuild VuhDo's frames | Rebuild skipped | VuhDo only |
| `/vd about` | Show version and credits | — | — |
| `/rl` | Reload the entire WoW UI | — | Full UI |

"VuhDo only" means VuhDo rebuilds its own frames; "Full UI" is a normal `/reload`.

Support and developer commands are listed separately under Advanced and Troubleshooting.

## Introduction

**Case:** Command words are case-insensitive (`/vd OPT` and `/vd opt` are the same).

**Partial matching:** Many commands match if the first word *contains* a substring (for example `/vd options`, `/vd minimap`, and `/vd map` all work). Use the exact forms in this document to avoid surprises.

**Quoted arguments:** `/vd load` and `/vd pt` accept quotes around names that contain spaces. Example: `/vd load "My Profile,My Layout"`.

**Combat:** Several commands refuse to run in combat or ignore changes while in combat. Those are noted per command and in the quick reference tables.

## General Commands

### Options

| | |
|---|---|
| **Syntax** | `/vd opt` or `/vd options` (any first word containing `opt`) |
| **Effect** | Opens or toggles the VuhDo options window. |
| **Combat** | Cannot *open* options in combat if the window is currently hidden. Closing or toggling an already-visible window may still work. |

**Example:** `/vd opt`

### Panel visibility

| | |
|---|---|
| **Syntax** | `/vd show` — show heal panels |
| | `/vd hide` — hide heal panels |
| | `/vd toggle` — flip current visibility |
| **Effect** | Shows or hides all heal panels. The setting is saved to the current profile. |
| **Combat** | Not possible during combat (panels stay as they were). |

**Examples:** `/vd show` · `/vd hide` · `/vd toggle`

### Lock panels

| | |
|---|---|
| **Syntax** | `/vd lock` |
| **Effect** | Toggles whether panel positions are locked against dragging. Saves the current profile. |
| **Combat** | Allowed. |

### Reset panel positions

| | |
|---|---|
| **Syntax** | `/vd reset` or `/vd res` (any first word containing `res`, except `restrict`) |
| **Effect** | Clears saved positions for all panels and Buff Watch, loads default panel setup, and reloads the VuhDo UI (not a full `/reload`). |
| **Combat** | Positions are cleared, but in combat the panels won't redraw until VuhDo next rebuilds (for example `/vd ui` after combat). |

**Note:** Profiling subcommands such as `/vd prof reset` use `prof` as the first word, not `reset`.

### Minimap and compartment icons

| | |
|---|---|
| **Syntax** | `/vd mm`, `/vd map`, or `/vd minimap` (first word contains `mm` or `map`) |
| **Effect** | Toggles visibility of the VuhDo minimap button. |
| **Syntax** | `/vd compartment` (first word contains `compart`) |
| **Effect** | Toggles visibility of the AddOn Compartment icon. |

### Load profile and key layout

| | |
|---|---|
| **Syntax** | `/vd load ProfileName,KeyLayoutName` |
| **Effect** | Loads a saved **profile** and/or **key layout** (spell layout) by name. |

**Requires arguments:** `/vd load` with nothing after `load` does nothing.

**Argument format:**

* A single comma-separated pair: `Profile,Layout`.
* **Profile only:** `/vd load MyProfile` (no layout after the comma, or no comma at all).
* **Layout only:** `/vd load ,MyLayout` — leading comma, layout name in the second segment.
* Names with spaces: quote the combined argument, e.g. `/vd load "My Profile,My Layout"`.

**Order:** If both are present, the **key layout** is activated first, then the **profile** is loaded (full profile init and UI reload).

**Combat:** In combat, loading a profile still applies settings, but the frame rebuild is skipped until you're out of combat.

**Examples:**

* `/vd load Raid`
* `/vd load ,Holy`
* `/vd load "Char Profile,Resto Keys"`

### Private tanks

| | |
|---|---|
| **Syntax** | `/vd pt` — toggle private tank for your **current target** (raid roster unit) |
| | `/vd pt Name1,Name2,...` — add private tanks by name |
| | `/vd pt clear` — remove all private tanks |
| **Effect** | Manages your personal private tank list, which is shown in any panel that displays the Private Tanks group. |
| **Combat** | Add/remove/toggle is skipped in combat. |
| **Names** | Resolved via VuhDo’s name lookup; ambiguous names print a warning. Use comma-separated names without spaces after commas; quote if needed. |

**Examples:** `/vd pt` · `/vd pt Alice,Bob` · `/vd pt clear`

#### Click-to-add private tanks with a mouse or key binding

VuhDo replaces the placeholder `vdname` in custom macros with the name of the player whose frame you clicked or hovered. That lets you bind a mouse button or key that adds whoever you click to the private tank list:

```
/vd pt vdname
```

Create the macro with the VuhDo macro editor and assign it to a mouse button or key in the VuhDo Spells options. Then click (or hover and press the key on) any raid frame to add that player.

* Use `/vd` in the macro, not `/vuhdo`. VuhDo also replaces the word `vuhdo` in macros with the clicked unit's ID, so `/vuhdo pt vdname` would break.
* The macro only **adds** players. To remove one, target them and run `/vd pt`, or run `/vd pt clear` to remove everyone.
* Like every `/vd pt` change, it is ignored in combat.
* In content where player names are secret, VuhDo can't substitute `vdname` and the macro does nothing.

### Main tank broadcast

| | |
|---|---|
| **Syntax** | `/vd mt` or `/vd cast` (first word is `mt` or contains `cast`) |
| **Effect** | Broadcasts VuhDo’s main tank list to the raid using the **CTRA** addon message channel (`CTRA` prefix). Other raids/addons that understand CTRA main-tank messages can consume this. |

**Note:** The in-game help shows `mts`, but only `mt`, `cast`, or `broadcast` actually work.

### Roles

| | |
|---|---|
| **Syntax** | `/vd role` or `/vd roles` (first word contains `role`) |
| **Effect** | Clears any roles you assigned to players by hand, so VuhDo detects roles automatically again, then rebuilds its frames. |
| **Combat** | Does nothing in combat; run it again after combat. |

### Reload VuhDo UI

| | |
|---|---|
| **Syntax** | `/vd ui` |
| **Effect** | Rebuilds VuhDo's frames without reloading the entire game UI. Try this first if the panels look wrong. |
| **Combat** | Does nothing in combat; run it again after combat. |

### About

| | |
|---|---|
| **Syntax** | `/vd about` or `/vd ab` |
| **Effect** | Prints version string and maintainer credit. (Also printed once when VuhDo loads.) |

#### A personal note

I work on VuhDo in honor of my wife Anny and our two daughters. They mean absolutely everything to me in the whole world.

Anny has put up with a lot of "just one more bug" nights so this addon could keep going, and I couldn't do it without her. Our girls are still little, but I hope one day they get to share in the fun their mom and I have playing WoW together. I love the three of you more than anything.

-- Ivaria

## Advanced and Troubleshooting

> **Warning: do not run these commands unless a VuhDo developer asks you to in a support ticket or bug report.**
>
> They exist for diagnosing problems and developing the addon, not for everyday play. Some of them change Blizzard CVars, force VuhDo into rendering modes it would not normally use, turn on profiling that costs performance, or reload your entire UI. Running them on your own can make VuhDo behave incorrectly or slow down your game until you undo the change. When support asks you to run one, use the exact command you were given and include the chat output in your ticket.

### Support and developer quick reference

| Command | What it does | Combat | Reloads |
|---------|--------------|--------|---------|
| `/vd range <unit>` | Range diagnostics | Partial | — |
| `/vd restrict [on\|off\|status]` | Force Blizzard addon restriction CVars | — | Full UI (`on`/`off`/toggle) |
| `/vd aura dump [unit] [indicator] [-v]` | Aura diagnostics | — | — |
| `/vd aura migrate` | Re-run aura configuration migration | Rebuild skipped | VuhDo only |
| `/vd aura rebuild` | Rebuild aura overlay containers | Blocked | — |
| `/vd aura restrict [on\|off\|auto]` | Force aura rendering mode | — | Full UI (`on`/`off`/`auto`) |
| `/vd prof [on\|off\|reset\|test]` | Profiling window and toggles | — | — |
| `/vd hand` / `task` / `pool` / `sem` | Per-subsystem profiling | — | — |
| `/vd pron` / `proff` | Blizzard script profiler on/off | — | Full UI |
| `/vd defer [on\|off\|state]` | Deferred panel redraw | — | — |
| `/vd anim [test N\|hide\|on\|off]` | Animation tests and toggle | — | — |
| `/vd pixel [test\|hide\|spacing\|scale\|cache\|validate N]` | Pixel layout tests | — | — |
| `/vd sync` | Developer audit of the settings-sync catalog | — | — |

### Bug-report diagnostics

#### Range

| | |
|---|---|
| **Syntax** | `/vd range` or `/vd range help` — print range command help |
| | `/vd range <unit>` — dump range diagnostics |
| **Unit** | A unit ID such as `player`, `party2`, or `raid5`. The unit must be shown in your VuhDo frames. Running `/vd range` with no unit only shows help. |
| **Combat** | `CheckInteractDistance` is skipped in combat; other probes still print. |

**Examples:** `/vd range raid5` · `/vd range player`

#### Addon restriction override (`restrict`)

Forces Blizzard **addon restriction** CVars on or off (combat/encounter/challenge-mode style restrictions), then **reloads the entire UI**.

| | |
|---|---|
| **Syntax** | `/vd restrict on` — force restrictions **on** (enables a subset of restriction CVars) |
| | `/vd restrict off` — force restrictions **off** |
| | `/vd restrict status` — print the current restriction settings and whether restrictions are active (no reload) |
| | `/vd restrict` — toggle based on `addonChallengeModeRestrictionsForced` |
| **Reload UI** | Yes, for `on`, `off`, and bare toggle (not for `status`). |

**CVars touched when enabling:** `addonChallengeModeRestrictionsForced`, `addonCombatRestrictionsForced`, `addonEncounterRestrictionsForced`.

**CVars touched when disabling:** additionally includes `addonPvPMatchRestrictionsForced`, `addonMapRestrictionsForced`, `addonChatRestrictionsForced`.

#### Aura dump

| | |
|---|---|
| **Syntax** | `/vd aura dump [unit] [indicator] [-v]` |
| **Default unit** | `player` |
| **Arguments** | Any order. `-v` turns on verbose output. A unit ID (`player`, `target`, `raidN`, `partyN`, etc.) picks the unit. Anything else is treated as an **indicator key** to limit the output to (not case-sensitive). |
| **Indicator keys** | `HEALTH_BAR`, `MANA_BAR`, `BACKGROUND_BAR`, `AGGRO_BAR`, `THREAT_BAR`, `MOUSEOVER_HIGHLIGHT`, `SIDE_LEFT`, `SIDE_RIGHT`, `BAR_BORDER`, `CLUSTER_BORDER`, `SWIFTMEND_INDICATOR`, `THREAT_MARK`, `DISPEL_OVERLAY` |
| **Effect** | Prints compact aura container / overlay diagnostics to chat (for bug reports). |

**Examples:** `/vd aura dump` · `/vd aura dump raid3 -v` · `/vd aura dump player health_bar`

### Aura system

Run `/vd aura` with no recognized subcommand for in-game aura help.

| Command | Effect | Combat | Reload UI |
|---------|--------|--------|-----------|
| `/vd aura migrate` | Clears aura anchor migration state, reloads default panel setup, remigrates auras | Rebuild skipped | VuhDo UI reload |
| `/vd aura rebuild` | Releases and rebuilds all aura overlay containers | **Blocked** | No (internal sync) |
| `/vd aura restrict` | Prints aura mode (containers on/off), data restricted state, forced mode | No | No |
| `/vd aura restrict on` | Force AuraContainer mode | No | **Yes** (`ReloadUI`) |
| `/vd aura restrict off` | Force legacy `UNIT_AURA` path | No | **Yes** |
| `/vd aura restrict auto` | Clear forced mode (auto) | No | **Yes** |

### Profiling

VuhDo can profile OnUpdate/OnEvent handlers, deferred tasks, table pools, semaphores, and aura container metrics.

#### Master profiling (`prof`)

| | |
|---|---|
| `/vd prof` | Opens the profiling UI and captures a combined metrics dump |
| `/vd prof on` | Enables handler, task, pool, and semaphore profiling |
| `/vd prof off` | Disables all of the above |
| `/vd prof reset` | Resets all profiling metrics (including aura container metrics) |
| `/vd prof test` | Runs an internal sanity test of the profiling math |

**Note:** Any first word **containing** `prof` is treated as this command (for example `/vd profiling` is not valid—use `/vd load` to load a profile). `/vd proff` is a separate command (script profiling off, below).

#### Per-subsystem commands

Each accepts `on`, `off`, `reset` (substring `res` in the second word), or no second word to print metrics:

| Command | Subsystem |
|---------|-----------|
| `/vd hand` | OnUpdate / OnEvent handler segments |
| `/vd task` | Deferred task queue |
| `/vd pool` | Table pool hit/miss |
| `/vd sem` | Semaphores |

#### Blizzard script profiler

| | |
|---|---|
| `/vd pron` | Sets `scriptProfile` CVar to `1` and **ReloadUI** |
| `/vd proff` | Sets `scriptProfile` CVar to `0` and **ReloadUI** |

### Rendering and performance experiments

#### Deferred panel redraw (`defer`)

| | |
|---|---|
| `/vd defer on` | Spread panel redraws across frames instead of doing them all at once |
| `/vd defer off` | Use immediate redraw |
| `/vd defer state` | Print deferred reload / semaphore state |
| `/vd defer` | Print whether deferred redraw is enabled |

#### Debuff icon animations (`anim`)

| | |
|---|---|
| `/vd anim` | Help + current animation method (AnimationGroup vs OnUpdate) |
| `/vd anim test [N]` | Spawn comparison test frames (default **N=5**, max **40**) |
| `/vd anim hide` | Remove test frames |
| `/vd anim on` / `off` | Switch debuff icon animations between the AnimationGroup and OnUpdate methods (reload recommended after change) |

#### Pixel-perfect layout (`pixel`)

| | |
|---|---|
| `/vd pixel` | Command list |
| `/vd pixel test` | Show draggable pixel test frames |
| `/vd pixel hide` | Hide and clean up test frames |
| `/vd pixel spacing` | Print spacing values per panel |
| `/vd pixel scale` | Print UI scale / pixel scale |
| `/vd pixel cache` | Backdrop cache statistics |
| `/vd pixel validate [panel]` | Validate pixel spacing (all panels if omitted) |

### Developer-only commands

Not intended for regular players.

| Command | Effect |
|---------|--------|
| `/vd sync` | Developer audit of the profile-sync settings catalog; prints uncovered settings. Only works after the options window has been opened this session. |
