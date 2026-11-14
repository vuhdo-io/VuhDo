Custom flags are bouquet validators which accept a user defined anonymous function that returns a boolean value. This allows for any custom condition to be used as part of the evaluation of a bouquet's chain of validators. These custom flag validators can be any valid Lua snippet which returns `true` or `false`.

## Table of Contents

* Table of Contents
* Accessing Unit Information
  * Example 1
  * Example 2
  * Example 3
* Checking for an Aura (Midnight)
  * Example 4
  * Example 5
  * Example 6
* Classic: Debuff Icon and HoT Icon APIs
* Secret Values (Midnight)
* More Examples
* Unit Information Table Schema

## Accessing Unit Information

The `VUHDO_unitInfo` table provides the relevant cached information on the subject unit to the anonymous function.

### Example 1

Returns true if the unit is named 'Ivaria'. **Classic** and **Midnight** differ only in secret handling; the condition is the same.

**Midnight** (secret-safe):

```
return not issecretvalue(VUHDO_unitInfo["name"]) and ("Ivaria" == VUHDO_unitInfo["name"])
```

**Classic** (no secret values on player names in this context):

```
return ("Ivaria" == VUHDO_unitInfo["name"])
```

Full details on the unit information available in the `VUHDO_unitInfo` table can be found below.

### Example 2

A common pattern is to require two helpful auras at once. This returns true if the unit has both **Rejuvenation** and **Rejuvenation (Germination)** (Druid), using the Midnight aura cache:

```
return VUHDO_hasUnitAura(VUHDO_unitInfo["unit"], "Rejuvenation", "HELPFUL")
    and VUHDO_hasUnitAura(VUHDO_unitInfo["unit"], "Rejuvenation (Germination)", "HELPFUL")
    or false;
```

Spell names must match what the game uses; add both auras to VuhDo's tracking (bouquets / aura groups) so they appear in the cache.

### Example 3

On Classic flavors, use the simpler spell cooldown and health math below (no secret values). On **Midnight**, prefer [Example 2](#example-2) for aura checks, or guard health and cooldown returns with `issecretvalue()` (see [Secret Values (Midnight)](#secret-values-midnight)).

Returns true only if the player's spell 'Prayer of Mending' is off cooldown and the unit is below 90% health:

```
return ((VUHDO_getSpellCooldown("Prayer of Mending") == 0) and ((VUHDO_unitInfo["health"] / VUHDO_unitInfo["healthmax"]) < 0.9)) and true or false;
```

## Checking for an Aura (Midnight)

As of VuhDo for Midnight, aura presence for custom flags is resolved through **VuhDo's aura cache** (`VUHDO_UNIT_AURA_CACHE`). Only auras that VuhDo is already configured to track (for example via bouquets, aura groups, or panel aura displays) are present in this cache. If a spell is not tracked, these APIs will not find it even if the unit has the aura in game.

### `VUHDO_hasUnitAura(unit, spell, filter)`

Returns `true` if the unit has a **cached** aura matching `spell` (spell name string or spell ID number). Optional third argument `filter`:

* `"HARMFUL"` — only harmful (debuff) auras
* `"HELPFUL"` — only helpful (buff) auras
* omitted or `nil` — any cached aura matching the spell

Spell IDs may be passed as numbers or as numeric strings (e.g. `"12345"`).

```
return VUHDO_hasUnitAura(VUHDO_unitInfo["unit"], "Penetrating Cold", "HARMFUL") or false;
```

```
return VUHDO_hasUnitAura(VUHDO_unitInfo["unit"], 123456, "HELPFUL") or false;
```

### `VUHDO_getUnitAura(unit, spell, filter)`

Returns the **cached aura entry table** for the first matching aura. The same `spell` and `filter` rules as `VUHDO_hasUnitAura` apply. This is the same table VuhDo uses internally; treat it as read-only (do not assign into it from custom flags).

Typical keys (values may be Midnight *secret values*; see below):

| Key | Description |
|-----|-------------|
| `auraInstanceID` | Aura instance ID |
| `icon` | Texture file id or path |
| `name` | Aura name |
| `spellId` | Spell ID |
| `applications` | Stack count |
| `duration` | Total duration |
| `expirationTime` | Expiration time (compare with `GetTime()` for remaining time, only if present) |
| `sourceUnit` | Source unit token |
| `isHarmful` | Debuff |
| `isHelpful` | Buff |
| `dispelName` | Dispel type / school info where applicable |

### Example 4

Returns true only if the unit is marked with raid icon 'Green Triangle' (index 4) and has a cached harmful aura named 'Penetrating Cold':

```
local tIcon = VUHDO_unitInfo["raidIcon"];
return not issecretvalue(tIcon) and tIcon == 4 and VUHDO_hasUnitAura(VUHDO_unitInfo["unit"], "Penetrating Cold", "HARMFUL") or false;
```

### Example 5

Returns true only if the unit has a cached helpful aura for 'Atonement':

```
return VUHDO_hasUnitAura(VUHDO_unitInfo["unit"], "Atonement", "HELPFUL") or false;
```

### Example 6

Use `VUHDO_getUnitAura` when you need stacks or timing. Use `issecretvalue()` before comparing or doing arithmetic on numeric fields:

```
local tAura = VUHDO_getUnitAura(VUHDO_unitInfo["unit"], "Renew", "HELPFUL");
local tStacks = tAura and tAura["applications"];
return tStacks and not issecretvalue(tStacks) and tStacks >= 3 or false;
```

## Classic: Debuff Icon and HoT Icon APIs

On **Classic** game flavors (Classic Era, Wrath, Cataclysm, etc.), custom flags should use the Debuff Icon and HoT Icon APIs — these are backed by the active **Debuff Icon** and **HoT Icon** systems:

* `VUHDO_hasUnitDebuff(unit, spell)` — presence of a tracked custom debuff (Debuff Icon list)
* `VUHDO_hasUnitHot(unit, spellName[, sourceType])` — presence of a tracked HoT (HoT Icon list; `VUHDO_UNIT_HOT_TYPE_*` applies)

On **Midnight (Retail)**, those same function names still exist for backward compatibility but are implemented as thin wrappers around the aura cache:

* `VUHDO_hasUnitDebuff` behaves like `VUHDO_hasUnitAura(unit, spell, "HARMFUL")`
* `VUHDO_hasUnitHot` behaves like `VUHDO_hasUnitAura(unit, spellName, "HELPFUL")` (the old `sourceType` argument is ignored)

New **Midnight** custom flags should use **`VUHDO_hasUnitAura`** / **`VUHDO_getUnitAura`** directly (see [Checking for an Aura (Midnight)](#checking-for-an-aura-midnight)).

## Secret Values (Midnight)

In Midnight, some game-provided values are *secret values*: you must not use native Lua comparisons (`==`, `<`, etc.) or arithmetic (`+`, `/`, etc.) on them until you know they are not secret. Use `issecretvalue(x)` to test a value, or read the matching `hasSecretFoo` flag on `VUHDO_unitInfo` when VuhDo provides one.

**`VUHDO_unitInfo`:** Fields such as `health`, `healthmax`, `name`, `range`, `power`, `powermax`, and `raidIcon` may be secret. Prefer checking `VUHDO_unitInfo["hasSecretHealth"]`, `hasSecretHealthMax`, `hasSecretName`, `hasSecretRange`, `hasSecretPower`, or `hasSecretRaidIcon` where applicable, or call `issecretvalue()` on the field before comparing or doing math.

**`VUHDO_getSpellCooldown`:** The returned start time (and related values, when secrets are enabled) may be secret; guard with `issecretvalue()` before comparing to `0` or other numbers.

**`VUHDO_getUnitAura`:** Fields on the cached aura table may be secret; use `issecretvalue()` before comparisons or arithmetic on numeric or string fields (e.g. `applications`, `expirationTime`).

## More Examples

More example bouquets using custom flags of various kinds can be found via Ivaria's profile on wago.io. Note that older examples may need updating to use the Midnight aura APIs above.

## Unit Information Table Schema

Unit information (`VUHDO_unitInfo` table). The **Midnight only** column marks fields that exist only on Midnight (Retail); other keys are available on Classic flavors as well.

| key | type / value | Midnight only | value description |
|-----|--------------|---------------|-------------------|
| afk | boolean | no | true if unit is AFK |
| aggro | boolean | no | true if unit has aggro |
| charmed | boolean | no | true if unit is charmed |
| canAttack | boolean | yes | true if the player can attack the unit |
| class | string | no | the unit's class name |
| classId | number | no | the unit's class ID |
| └ `20` | | — | warrior |
| └ `21` | | — | rogue |
| └ `22` | | — | hunter |
| └ `23` | | — | paladin |
| └ `24` | | — | mage |
| └ `25` | | — | warlock |
| └ `26` | | — | shaman |
| └ `27` | | — | druid |
| └ `28` | | — | priest |
| └ `29` | | — | death knight |
| └ `30` | | — | monk |
| └ `31` | | — | demon hunter |
| └ `32` | | — | evoker |
| className | string | no | the unit's class name prettified |
| connected | boolean | no | true if unit is connected |
| dead | boolean | no | true if unit is dead |
| debuff | number | no | the unit's last active debuff type |
| └ `0` | | — | no active debuff |
| └ `1` | | — | poison |
| └ `2` | | — | disease |
| └ `3` | | — | magic |
| └ `4` | | — | curse |
| └ `6` | | — | custom debuff |
| └ `7` | | — | missing Buff Watch aura |
| └ `8` | | — | bleed |
| debuffName | string | no | the most recent debuff on the unit |
| fullName | string | no | the full name of the unit |
| group | number | no | the group the unit is in |
| health | number | no | the unit's current health |
| healthmax | number | no | the unit's maximum health |
| hasSecretHealth | boolean | yes | true if `health` is a secret value |
| hasSecretHealthMax | boolean | yes | true if `healthmax` is a secret value |
| isAltPower | boolean | no | true if unit has an alt power active |
| isPet | boolean | no | true if unit is a pet |
| isVehicle | boolean | no | true if unit is in a vehicle |
| name | string | no | the name of the unit |
| hasSecretName | boolean | yes | true if `name` is a secret value |
| number | number | no | the unit number from the unit ID (e.g. raid index) |
| ownerUnit | string | no | unit's owner if pet or vehicle |
| petUnit | string | no | the unit's pet unit ID |
| power | number | no | the unit's current power |
| powermax | number | no | the unit's maximum power |
| hasSecretPower | boolean | yes | true if `power` or `powermax` is a secret value |
| powertype | number | no | the type of power (see: <https://warcraft.wiki.gg/wiki/Enum.PowerType>) |
| └ `0` | | — | mana |
| └ `1` | | — | rage |
| └ `2` | | — | focus |
| └ `3` | | — | energy |
| └ `4` | | — | happiness |
| └ `5` | | — | runes |
| raidIcon | number | no | the raid icon if unit is marked |
| └ `1` | | — | yellow 4-point star |
| └ `2` | | — | orange circle |
| └ `3` | | — | purple diamond |
| └ `4` | | — | green triangle |
| └ `5` | | — | white crescent moon |
| └ `6` | | — | blue square |
| └ `7` | | — | red "X" cross |
| └ `8` | | — | white skull |
| hasSecretRaidIcon | boolean | yes | true if `raidIcon` is a secret value |
| range | boolean | no | true if unit is in range |
| hasSecretRange | boolean | yes | true if `range` is a secret value |
| baseRange | boolean | yes | true if the unit passes `UnitInRange` (when not the player) |
| role | number | no | the unit's combat role |
| └ `60` | | — | melee tank |
| └ `61` | | — | melee damage |
| └ `62` | | — | ranged damage |
| └ `63` | | — | ranged heal |
| targetUnit | string | no | the unit's target |
| threat | number | no | the unit's threat status |
| └ `0` | | — | not tanking, lower threat than tank |
| └ `1` | | — | not tanking, higher threat than tank |
| └ `2` | | — | insecurely tanking, another unit has higher threat |
| └ `3` | | — | securely tanking, highest threat |
| threatPerc | number | no | the unit's threat percentage |
| unit | string | no | the unit ID |
| visible | boolean | no | true if the unit is visible |
| zone | string | yes | the unit's zone name |
| map | string | yes | the unit's map name |