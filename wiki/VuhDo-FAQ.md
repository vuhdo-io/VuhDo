Answers on this page apply to both **Retail** and **Forever**. **Classic** specific issues are covered under a separate [[VuhDo Classic FAQ|VuhDo-Classic-FAQ]]. Slash commands (e.g. `/vd`) are documented on a separate page: [[VuhDo Slash Commands|VuhDo-Slash-Commands]].

**1. How do I make health bars class colored?**

Select the panel first, then open `VuhDo Options > Panels > Bars > Bar Color` and choose `Class Color`.

To adjust class colors, use `VuhDo Options > Colors > Classes`.

Alternatively, set the health indicator bouquet on `VuhDo Options > Panels > Indicators` to `Health (generic, class col)`.

**2. I want to track a new helpful spell aura (e.g. a HoT). How do I add it?**

**2a. Are you playing on Forever? If so, do the following:**

Select the anchor being used to display HoTs from the dropdown menu under `VuhDo Options > Panels > Auras`. It's likely `Anchor 1` (the default). Then click the `Group` button to take you to the associated aura group's settings under `VuhDo Options > Auras > Groups`. Now click `Copy` to create a copy of that aura group which will allow you to edit it. Your new aura group will have the same name with a `(Copy)` suffix e.g. `My HoTs (Combat Auras) (Copy)`.

Use the `Add Spell` dropdown menu to select the new aura you want to track from the predefined list or just type the spell name or ID in the edit box. Keep in mind the spell ID or name of the actual aura (HoT) that gets placed on the unit can differ from the spell ability name.

Now you'll see a new entry (row) in the list of auras. If you want to track all auras with that same name (e.g. all ranks in Forever), then be sure to click the `Spell` button on the new entry and enable the `Match by name` checkbox.

Now click the `Back` button and assign your new group (e.g. `My HoTs (Combat Auras) (Copy)`) to `Anchor 1` under `VuhDo Options > Panels > Auras`.

**2b. Are you playing on Retail? If so, do the following:**

Go under `VuhDo Options > Auras > Groups` and select the group from the dropdown menu corresponding to your class and specialization e.g. `Holy Priest HoTs`. Now click `Copy` to create a copy of that aura group which will allow you to edit it. Your new aura group will have the same name with a `(Copy)` suffix e.g. `Holy Priest HoTs (Copy)`.

Use the `Add Spell` dropdown menu to select the new aura you want to track from the predefined list or just type the spell name or ID in the edit box. Keep in mind the spell ID or name of the actual aura (HoT) that gets placed on the unit can differ from the spell ability name.

Now you'll see a new entry (row) in the list of auras. If you want to track all auras with that same name, then be sure to click the `Spell` button on the new entry and enable the `Match by name` checkbox.

Now go under `VuhDo Options > Panels > Auras` and assign your new group (e.g. `Holy Priest HoTs (Copy)`) to whichever anchor you are using to track your HoTs (by default this is `Anchor 1`).

**3. How do I stop showing icons for debuffs on group members?**

Select the anchor being used to display debuffs from the dropdown menu under `VuhDo Options > Panels > Auras`.  It's likely `Anchor 2` (the default).  Then deselect the `Enable` checkbox.

**4. My debuff icons are way too big, how do I make them smaller?**

Select the anchor being used to display debuffs from the dropdown menu under `VuhDo Options > Panels > Auras`.  It's likely `Anchor 2` (the default) and set to use the `Relevant Debuffs` aura group.  Adjust its `Size` slider.

**5. My panels has disappeared off screen. How do I get them back?**

Type `/vd reset` (or `/vd res`) to reset panel positions.

**6. I bound a spell to a mouse click but it will not cast, or it hits the wrong unit. Why?**

Check these in order:

1. Under `Game Menu > Options > Gameplay > Combat`, turn off `Auto Self Cast` and set `Self Cast Key` to `None`.
2. Under `Game Menu > Options > Keybindings > Click Casting` make sure you haven't bound the same mouse or key.  Blizzard built-in bindings always override VuhDo spell bindings.
2. Deselect the `Enable` checkbox under `VuhDo Options > Spells > Misc > Auto Trigger`.
3. Remember that a macro with the same name as the spell will override the spell binding.
4. Try clearing the same button under `VuhDo Options > Spells > Hostile` if hostile and friendly bindings conflict.
5. Use `@mouseover` or `@vuhdo` in a macro. In VuhDo macros, `vuhdo` is replaced with the unit ID.
6. Turn off `VuhDo Options > General > Misc > Clique Support` to check if Clique bindings are conflicting.

**7. My spell bindings per spec keeps getting overwritten. What am I doing wrong?**

Spell bindings are saved as a part of your `Key Layout` and not in your `Profile`.

- **Spell bindings and Auras:** `VuhDo Options > Tools > Key Layouts`. Save a layout and tie it to the spec checkboxes on that page (`Spec 1` through `Spec 4` on Midnight; `Primary` and `Secondary` on Forever).
- **Panel and bar appearance:** `VuhDo Options > Tools > Profiles`. Profiles can auto-load by spec and by group size.

To switch manually or via a macro: `/vd load ProfileName` or `/vd load ProfileName,LayoutName`.

**8. In a raid, how do I put my group in the first column?**

1. Put yourself first inside each group: `VuhDo Options > Panels > General > You First`.
2. Put your whole group first among groups: `VuhDo Options > Move`, add a new group. Set the new group's type to `Group` and value to `Own Group`.  Then drag that new group to the left of the existing `Group 1`.
3. Avoid listing your group twice: `VuhDo Options > General > General > Filter > Own Group`.

**9. Can I target someone on click instead of healing them?**

Under `VuhDo Options > Spells`, enter a built-in command instead of a spell name. This are all of the available built-in commands:

- `target`, `focus`, `assist` — set unit or assist
- `menu` — VuhDo unit menu
- `tell` — whisper
- `dropdown` — Blizzard unit menu
- `extraactionbutton` — target the unit, click Extra Action Button 1, then restore the previous target
- `mouselook` — toggle mouselook
- `ping` — Blizzard ping (Attack on hostile, Assist on friendly, otherwise a plain ping)

Under `VuhDo Options > Spells > Hostile` only `target`, `focus`, `assist`, `extraactionbutton`, `mouselook`, and `ping` are supported.

**10. What is the Private Tanks panel?**

This allows you to manage a personal watch list, separate from main tanks e.g. for Evoker buffing. Bind `menu` to a mouse button or key, then use that binding to open the menu on a unit and choose `Private Tank` on that menu. Alternatively, use `/vd pt` and related commands on [[VuhDo Slash Commands|VuhDo-Slash-Commands]] (including the `vdname` macro; additions are ignored in combat and where player names are secret).

**11. After a disconnect in combat, VuhDo panels do not show until combat ends. Why?**

Secure unit frames have restrictions on being created, shown, or rebuilt during combat.

With `VuhDo Options > General > Misc > D/C Shield` enabled (default), VuhDo can install restore macros after a mid-fight disconnect. This requires that you have two **character-specific** macro slots available.

If panels are still missing after you log back in, try `/reload`.

**12. All of my raid health bars look white. What am I doing wrong?**

Under `VuhDo Options > Buffs > Config`, each buff has two checkboxes. The first enables buff watch for that buff. The second, `Missing`, recolors health bars until the buff is present. Uncheck `Missing` for buffs you do not want to change the bar color.

**13. What happened to the old Spell Trace feature I used to track Targeted Spells?**

On Midnight and Forever, Blizzard’s API restrictions hide the combat log data VuhDo needs to see which unit a cast hit. Spell trace, including incoming and targeted spells, cannot track casts on either game until Blizzard allows that data again or provides some other workaround.  Thus far, Blizzard has indicated they do not want this feature to return unfortunately.

**14. Why do some features behave oddly or not work at all during M+ dungeon runs, instanced PvP or raids?**

In restricted content, aura data can be hidden from add-ons. VuhDo still shows auras on frames through Blizzard’s new aura containers system.

Several features are unavailable on both **Retail** and **Forever** for now: overheal text and life text highlight, several hit point modes such as effective health, raid icon bar and text coloring, and Emergency Mode.

**15. How do I hide VuhDo while solo or in a small group?**

Go under `VuhDo Options > General > General > Hide Panels`, then enable `Solo` and/or `Party` as needed.