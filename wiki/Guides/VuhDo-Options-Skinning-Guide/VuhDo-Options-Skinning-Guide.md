Third-party addons can register custom visual themes ("skins") for the **VuhDo Options** configuration UI. Skins support texture file overrides, runtime color tints, backdrop colors, font colors, and structural variants (slider arrow buttons, tab glyph icons, tri-state dot toggles). Skins apply only to the VuhDo Options UI and not the actual VuhDo unit frames.

## Table of Contents

* [Overview](#overview)
* [Quick Start](#quick-start)
* [Skin Data Schema](#skin-data-schema)
* [Texture Keys](#texture-keys)
* [Tab Icon Frame Names](#tab-icon-frame-names)
* [XML KeyValues Hooks](#xml-keyvalues-hooks)
* [Public API](#public-api)
* [Packaging and Distribution](#packaging-and-distribution)
* [Example Addon](#example-addon)

## Overview

VuhDo Options ships two built-in skins registered through the same API third parties use:

| Registry name | Display name | Description |
|---------------|--------------|-------------|
| `Classic` | Classic | Original VuhDo Options look (pill tabs, classic sliders) |
| `Dark` | Dark | Dark theme with arrow sliders, hidden checkbox faces, and badge-only icon buttons |

Users select a skin from the **Theme** combo box in **Tools → Reset → Skin**. The choice persists in `VUHDO_OPTIONS_SETTINGS["SKIN"]`.

When a component is shown, VuhDo applies the active skin via a hook on `VUHDO_lnfPatchFont`. Registering or switching skins while Options is open updates visible frames immediately. Skins affect only the VuhDo Options UI; live displays such as Buff Watch keep their own configured colors and fonts.

## Quick Start

1. Create a standalone addon folder under `Interface\AddOns\YourSkinAddon\`.
2. Declare a dependency on VuhDo Options in your `.toc` file.
3. Call `VUHDO_registerSkin` when your addon loads.

**YourSkinAddon.toc:**

```
## Interface: 120007
## Title: My VuhDo Options Skin
## Dependencies: VuhDoOptions
## LoadOnDemand: 0

YourSkinAddon.lua
```

**YourSkinAddon.lua:**

```lua
VUHDO_registerSkin("MySkin", {
	["displayName"] = "My Skin",
	["sliderStyle"] = "classic",
	["tabStyle"] = "pill",
	["backdropColors"] = {
		["frame"] = {
			["bg"] = { 0.10, 0.10, 0.12, 1 },
			["border"] = { 0.25, 0.25, 0.30, 1 },
		},
	},
	["fontColors"] = {
		["normal"] = { ["TR"] = 0.90, ["TG"] = 0.90, ["TB"] = 0.95, ["TO"] = 1 },
	},
});
```

**Load order:** Your addon must load after VuhDo Options. Using `## Dependencies: VuhDoOptions` in the TOC ensures this. Do **not** modify `VUHDO_OPTIONS_SKINS` directly—always use `VUHDO_registerSkin`.

## Skin Data Schema

All fields are optional except that at least one visual property should differ from defaults for a meaningful skin. Unknown top-level keys produce a `{VuhDo}` chat warning but do not block registration.

### Top-level fields

| Field | Type | Description |
|-------|------|-------------|
| `displayName` | string | Label shown in the Theme combo box. Defaults to the registry name. |
| `sliderStyle` | string | `"classic"` (default) or `"arrows"` (thin track with step buttons). |
| `tabStyle` | string | `"pill"` (default) or `"glyph"` (monochrome icon tabs). Glyph tabs require `tabIcons`. |
| `toggleStyle` | string | `"box"` (default) or `"dot"` for tri-state check buttons. |
| `checkFaceHidden` | boolean | When `true`, hides checkbox/radio button face textures (check mark swatch remains). |
| `checkLabelLeft` | boolean | When `true`, anchors checkbox/radio labels beside the control, vertically centered; two-line labels keep correct top/bottom order. |
| `checkGroupPlate` | table | Optional `{ R, G, B, A? }` faint grouping plate tint when `checkFaceHidden` is also set (not used by bundled Dark). |
| `badgeOnlyButtons` | boolean | When `true`, buttons with XML `skinBadgeOnly` hide their normal/pushed/disabled face (icon badge only). |
| `imagesPath` | string | Base path prefix for indicator preview images (Panel → Indicators schema textures). Defaults to `Interface\AddOns\VuhDoOptions\Images\`. |
| `textures` | table | Map of texture key → full file path override. |
| `textureTints` | table | Map of texture key → `{ R, G, B, A? }` vertex color. |
| `backdropColors` | table | Map of backdrop role → `{ bg, border }` color tables. |
| `fontColors` | table | Map of label role → `{ TR, TG, TB, TO }` text color. |
| `sliderArrowColor` | table | `{ R, G, B, A? }` for arrow slider step buttons. |
| `accentColor` | table | `{ R, G, B, A? }` active glyph/tab accent color and checkbox label hover tint. |
| `glyphColor` | table | `{ R, G, B, A? }` inactive glyph color. |
| `entrySelectColor` | table | `{ R, G, B, A? }` selected list-entry background (bouquet items, key assignments). |
| `swatchBorderColor` | table | `{ R, G, B, A? }` color-picker swatch border (Buffs → Config, etc.). |
| `indicatorPlate` | table | `{ R, G, B, A? }` background plate tint for Panel → Indicators schema previews. When set and `indicatorLabelPlate` is omitted, the indicator name strip behind slot labels is hidden. |
| `indicatorLabelPlate` | table | `{ R, G, B, A? }` vertex tint for the Classic name strip behind each indicator slot label (e.g. "Side Left"). `A = 0` hides the strip. When omitted, the strip is hidden if `indicatorPlate` is set; otherwise Classic uses a white strip at 0.9 alpha. This is **not** a `backdropColors` role. |
| `comboItemColors` | table | `{ normal, hover }` backdrop colors for combo dropdown items. |
| `triStateValueColors` | table | Array of three `{ R, G, B, A? }` colors for tri-state value labels (states 1–3). |
| `tabLabelColors` | table | `{ active, inactive }` font color tables for pill-style tab labels. |
| `tabIcons` | table | Map of tab panel frame name → glyph texture path (required when `tabStyle = "glyph"`). |
| `radioSwatchOffsetY` | number | Vertical anchor offset (pixels) applied to radio/tab swatch frames. |
| `font` | string | Full path to a `.ttf`/`.otf` font face applied to all option labels and edit boxes. Native font size and flags are preserved. See [Custom fonts](#custom-fonts). |

### `backdropColors` keys

| Key | Applied to |
|-----|------------|
| `slider` | Horizontal/vertical sliders, color-picker sliders |
| `frame` | Standard option frames |
| `panel` | Panel containers, list entries |
| `scroll` | Scroll bars and scroll panels |
| `footer` | Bottom append panels (Okay/Cancel bar) |

Each entry may include:

```lua
["bg"] = { 0.11, 0.11, 0.13, 1 },      -- background RGBA (0–1)
["border"] = { 0.23, 0.24, 0.27, 1 },  -- border RGBA (0–1)
```

### Backgrounds: backdrop colors vs textures

Solid panel, frame, slider, scroll, and footer **backgrounds** in VuhDo Options are WoW frame backdrops: a neutral white fill recolored at runtime via `SetBackdropColor`. To change a background, set the matching `backdropColors` role's `bg` (and optionally `border`). These fills are intentionally **not** skinnable through `textures`.

Use `textures` and `textureTints` for discrete image assets—buttons, icons, tab glyphs, slider thumbs, panel edge sets—not for the flat fills behind panels and frames.

### `fontColors` keys

| Key | Applied to |
|-----|------------|
| `normal` | Standard labels (`*Label`, `*Label2`, `*Text`, edit boxes) |
| `title` | Title labels (`*Title`) |
| `active` | Active-state text (fallback checkbox hover tint when `accentColor` is omitted) |
| `value` | Value readouts (`*Value`) |

Each entry uses VuhDo color components:

```lua
["TR"] = 0.91,  -- text red
["TG"] = 0.92,  -- text green
["TB"] = 0.94,  -- text blue
["TO"] = 1,     -- text opacity
```

### `tabLabelColors` keys

| Key | Applied to |
|-----|------------|
| `active` | Checked tab label text |
| `inactive` | Unchecked tab label text |

Uses the same `{ TR, TG, TB, TO }` format as `fontColors`. When omitted, pill tabs restore native label colors.

### Custom fonts

Set `font` to swap the typeface used across the entire VuhDo Options UI (labels, titles, values, and edit boxes):

```lua
["font"] = "Interface\\AddOns\\MySkin\\Fonts\\custom.ttf",
```

- Provide the **full path** to a font bundled with your addon (or any path WoW can load). Relative names are not resolved.
- The skin engine snapshots each region's native font and re-applies your face while **preserving the native size and flags**, so layout stays intact.
- Switching back to Classic (or any skin without `font`) restores the original native faces, so live skin swapping works without a reload.
- CJK substitution: on `zhCN`, `zhTW`, and `koKR` clients VuhDo applies the in-game UI font (`GameFontNormal`) to all Options labels, titles, values, and edit boxes instead of bundled Latin faces or a skin's custom `font`. Size is normalized to 12; font flags and color styling are preserved.

### Color array format

All color arrays (`textureTints` values, `sliderArrowColor`, `accentColor`, backdrop `bg`/`border`, `indicatorPlate`, `indicatorLabelPlate`, etc.) are tables of 3 or 4 **numeric** values in the 0–1 range: `{ R, G, B }` or `{ R, G, B, A }`.

### Panel → Indicators name strip

Classic draws a small white contrast strip (`white_square_16_16` at 0.9 alpha) behind each indicator slot label so dark text stays readable over the schema diagram. That strip is **not** controlled by `backdropColors` or `textures`.

- Set `indicatorLabelPlate` to tint or hide the strip (`{ 0, 0, 0, 0 }` removes it without affecting the schema plate).
- When `indicatorLabelPlate` is omitted, bundled Dark hides the strip automatically because `indicatorPlate` is set; Classic leaves the white strip visible.

Example for a Classic-layout dark skin:

```lua
["indicatorLabelPlate"] = { 0, 0, 0, 0 },
```

### Structural variants

**Slider style `"arrows"`:** Shows `DecLeft`/`DecRight` step buttons on slider frames and uses a thin white track fill. Set `sliderArrowColor` to tint the arrow chevrons.

**Tab style `"glyph"`:** Hides pill tab backgrounds and shows a `$parentGlyph` texture per tab. Requires a `tabIcons` entry for each tab panel frame name. Set `accentColor` / `glyphColor` for checked/unchecked tinting.

**Toggle style `"dot"`:** Replaces tri-state checkbox boxes with a tinted status dot (`status_dot` texture key).

**`checkFaceHidden`:** Hides the normal/pushed face on standard checkboxes and radio buttons while keeping the check-mark swatch visible.

**`checkLabelLeft` + `checkGroupPlate`:** When a flat skin hides the Classic button plate (`checkFaceHidden`), labels can feel disconnected from their controls. Set `checkLabelLeft = true` to anchor `*Label` / `*Label2` beside the control glyph, vertically centered on the button; two-line labels (`*Label` + non-empty `*Label2`) stack in native order. Optionally set `checkGroupPlate` to a faint `{ R, G, B, A? }` tint so the normal texture remains visible as a subtle grouping plate (third-party opt-in; bundled Dark omits this). When `checkGroupPlate` is omitted, the face stays fully hidden.

**Checkbox hover:** On mouseover, checkbox label text uses `accentColor` when defined; otherwise it falls back to `fontColors.active`. On mouse leave, labels restore `fontColors.normal`.

**`badgeOnlyButtons`:** When combined with XML `skinBadgeOnly="true"` on a button, hides the button chrome so only the overlay icon is visible.

## Texture Keys

Override or tint textures by **basename key**. The skin engine snapshots each texture's native path and vertex color on first touch, then applies your override or restores the snapshot when switching skins.

If a skin does not supply a `textures` entry for a key, the default Classic asset path is used (tints still apply).

**Shared fill textures:** The neutral backdrop fill `Interface\AddOns\VuhDo\Images\white_square_16_16` and the tint source `icon_white_square` are shared across many Options widgets **and** live VuhDo unit frames (health/power bars, HoT and aura icons, the `Plain White` statusbar/border SharedMedia entry, target highlight). Do **not** replace these `.tga` files or point skin paths at them. Recolor Options backgrounds via `backdropColors`; recolor widget tints via `textureTints`. Note that `white_square_16_16` is a backdrop `bgFile`, not an overridable skin texture key—it does not appear in the tables below.

### Structural texture keys

These keys correspond to default assets under `Interface\AddOns\VuhDoOptions\Images\`:

| Key | Used for |
|-----|----------|
| `blue_dk_square_16_16` | Dark square backdrop fill, square demo widgets |
| `scroll_bar_bg_16_16` | Scroll bar background fill |
| `blue_lt_square_16_16` | Light square backdrop fill |
| `button_combo_32_32` | Combo box arrow segment |
| `button_combo_edit_128_32` | Combo edit field |
| `button_combo_pressed_32_32` | Combo arrow pressed state |
| `button_normal_128_32` | Standard button normal state |
| `button_pressed_128_32` | Standard button pressed state |
| `button_up_32_32` | Combo dropdown arrow, slider step buttons |
| `icon_black` | Radio/swatch background |
| `icon_aura` | Active swatch highlight |
| `icon_blue_square` | Checkbox swatch |
| `icon_check` | Checkbox check mark |
| `icon_white` | Radio check mark |
| `status_dot` | Tri-state dot toggle, status indicators |
| `combo_select_dot` | Combo item selection dot |
| `input_border_1` | Input border |
| `panel_edges_1` | Panel edge set 1 |
| `panel_edges_2` | Panel edge set 2 |
| `panel_edges_2_append_bottom` | Panel bottom append edge |
| `panel_edges_3` | Panel edge set 3 |
| `panel_edges_4` | Panel edge set 4 |
| `slider_thumb_h` | Horizontal slider thumb |
| `slider_thumb_v` | Vertical slider thumb |
| `tabstop_active` | Active tab check mark |
| `tabstop_inactive` | Inactive tab background |

### Badge icon keys

Used by icon buttons and layout-declared `skinIconKey` / `skinNormalKey` overrides:

| Key | Used for |
|-----|----------|
| `icon_okay` | Okay button |
| `icon_cancel` | Cancel / remove buttons |
| `icon_plus` | Add buttons |
| `icon_share` | Share button |
| `icon_question` | Test button |
| `icon_apply_all` | Apply-to-all button |
| `icon_font` | Font picker button |
| `icon_back` | Back button |
| `icon_arrow_up` | Move-up buttons |
| `icon_arrow_down` | Move-down buttons |

Button names are also matched heuristically (e.g. `*OkayButton*` → `icon_okay`) when no explicit key is set.

### Tint-only keys

These keys have no default standalone asset; they recolor existing textures via `textureTints`:

| Key | Used for |
|-----|----------|
| `icon_red` | Red tint overlay |
| `icon_white_square` | White square tint |
| `icon_check_2` | Alternate check tint |
| `bar_example` | Bar preview tint (Panel → Indicators) |

**Override example:**

```lua
["textures"] = {
	["button_normal_128_32"] = "Interface\\AddOns\\MySkin\\Textures\\button_normal",
},
["textureTints"] = {
	["icon_red"] = { 0.85, 0.25, 0.25, 1 },
},
```

Texture paths must be valid WoW texture paths (typically `.tga` files under your addon folder).

## Tab Icon Frame Names

When `tabStyle` is `"glyph"`, map tab panel global frame names to glyph texture paths in `tabIcons`. Built-in skins use `"pill"` tabs; glyph tabs are intended for third-party skins that supply their own icon set.

| Frame name | Options section |
|------------|-----------------|
| `VuhDoNewOptionsGeneral` | General |
| `VuhDoNewOptionsColors` | Colors |
| `VuhDoNewOptionsTools` | Tools |
| `VuhDoNewOptionsMove` | Move |
| `VuhDoNewOptionsSpell` | Spells |
| `VuhDoNewOptionsPanel` | Panels |
| `VuhDoNewOptionsBuffs` | Buffs |
| `VuhDoNewOptionsAura` | Auras |
| `VuhDoNewOptionsPanelBasic` | Panel → Basic |
| `VuhDoNewOptionsPanelSize` | Panel → Size |
| `VuhDoNewOptionsPanelBars` | Panel → Bars |
| `VuhDoNewOptionsPanelHeader` | Panel → Header |
| `VuhDoNewOptionsPanelTarget` | Panel → Target |
| `VuhDoNewOptionsPanelTooltip` | Panel → Tooltip |
| `VuhDoNewOptionsPanelText` | Panel → Text |
| `VuhDoNewOptionsPanelAuras` | Panel → Auras |
| `VuhDoNewOptionsPanelPrivateAuras` | Panel → Private Auras |
| `VuhDoNewOptionsPanelIndicators` | Panel → Indicators |
| `VuhDoNewOptionsPanelMisc` | Panel → Misc |

Example:

```lua
["tabStyle"] = "glyph",
["tabIcons"] = {
	["VuhDoNewOptionsGeneral"] = "Interface\\AddOns\\MySkin\\glyphs\\tab_general",
	["VuhDoNewOptionsColors"] = "Interface\\AddOns\\MySkin\\glyphs\\tab_colors",
},
["accentColor"] = { 0.45, 0.68, 0.95, 1 },
["glyphColor"] = { 0.55, 0.58, 0.63, 1 },
```

## XML KeyValues Hooks

VuhDo Options XML layouts can declare per-widget skin hints via `<KeyValues>`:

| Key | Type | Description |
|-----|------|-------------|
| `skinIconKey` | string | Texture key for the button's `$parentIcon` overlay (e.g. `"icon_plus"`). |
| `skinNormalKey` | string | Texture key for the button's normal texture (e.g. `"icon_arrow_up"`). |
| `skinBadgeOnly` | boolean | When `true` **and** the active skin sets `badgeOnlyButtons = true`, hides the button face so only the icon badge shows. |

Example (remove button with badge-only icon):

```xml
<Button name="$parentRemoveButton" inherits="VuhDoRemoveItemButtonTemplateSmall">
	<KeyValues>
		<KeyValue key="skinIconKey" value="icon_cancel" type="string"/>
		<KeyValue key="skinBadgeOnly" value="true" type="boolean"/>
	</KeyValues>
</Button>
```

Templates `VuhDoTestButtonTemplate`, `VuhDoFontButtonTemplate`, and `VuhDoShareButtonTemplate` ship with default `skinIconKey` values.

## Public API

### `VUHDO_registerSkin(aName, aSkinData)`

Register or replace a skin. **Last registration wins**—built-in skins can be overridden.

- `aName` — Registry key stored in `VUHDO_OPTIONS_SETTINGS["SKIN"]` (non-blank string).
- `aSkinData` — Skin definition table (see [Skin Data Schema](#skin-data-schema)).

Validation is strict: invalid enum values (`sliderStyle`, `tabStyle`, `toggleStyle`) or malformed color/boolean tables cause registration to fail with a `{VuhDo}` chat message.

If Options is already open and the registered skin is currently active, the UI refreshes immediately.

### `VUHDO_unregisterSkin(aName)`

Remove a registered skin. `"Classic"` cannot be unregistered (it is the fallback). If the removed skin was active, the UI reverts to Classic.

### `VUHDO_isSkinRegistered(aName)`

Returns `true` if `aName` is in the registry.

### `VUHDO_getRegisteredSkins()`

Returns a new array of entries:

```lua
{ ["name"] = "Dark", ["displayName"] = "Dark" }
```

Use this to build custom skin pickers or diagnostics.

### Read-only registry

`VUHDO_OPTIONS_SKINS` remains global for inspection but **must not be modified directly**. Always use the registration API.

## Packaging and Distribution

1. **Standalone addon** — Ship your skin as its own addon folder; do not patch VuhDo files.
2. **Dependencies** — Set `## Dependencies: VuhDoOptions` (and transitively VuhDo) in your TOC.
3. **Assets** — Bundle `.tga` textures in your addon; reference them with full `Interface\AddOns\YourAddon\...` paths.
4. **Naming** — Pick a unique registry `aName` string. Use `displayName` for the user-visible label (can be localized by your addon).
5. **Persistence** — No SavedVariables are needed; VuhDo stores the selected skin name in `VUHDO_OPTIONS_SETTINGS["SKIN"]`.
6. **Override policy** — Registering the same name again replaces the previous definition. Users who saved `"MySkin"` will get your updated definition on next login.

## Example Addon

A complete minimal example ships in the repository:

```
docs/examples/VuhDoSkin_Midnight/
├── VuhDoSkin_Midnight.toc
└── VuhDoSkin_Midnight.lua
```

Copy the folder to `Interface\AddOns\VuhDoSkin_Midnight\` to try it. The example uses color tints and backdrop overrides only (no custom texture files), demonstrating the smallest useful skin with arrow sliders and pill tabs.