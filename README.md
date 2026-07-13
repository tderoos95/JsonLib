# JsonLib — UT2004

A JSON library for UnrealScript on **Unreal Tournament 2004**. Pure script, no native code: build it,
add it to `EditPackages`, and you have JSON.

A UT99 / OldUnreal 469 port lives at [jsonlib-ut99](https://github.com/Tunnelcast/jsonlib-ut99) —
same API.

## What you get

```unrealscript
local JsonObject Json;

Json = new class'JsonObject';
Json.AddString("PlayerName", "Cali");
Json.AddInt("Score", 12);
Json.AddBool("IsSpectator", false);

log(Json.ToString());   // {"PlayerName":"Cali","Score":12,"IsSpectator":false}
```

and back again:

```unrealscript
Json = class'JsonConvert'.static.Deserialize("{\"Score\":12}");
log("" $ Json.GetInt("Score"));   // 12
```

`JsonObject` — `AddString` / `AddInt` / `AddFloat` / `AddBool` / `AddJson` / `AddArray*`,
`GetString` / `GetInt` / `GetFloat` / `GetBool` / `GetArray*` (key lookup is case-insensitive by
default), `RemoveValue`, `Clear`, `ToString`.
`JsonConvert` — `Deserialize`, `DeserializeIntoExistingObject`, `StartsWith`, `EndsWith`.
`JsonUtils` — `StripIllegalCharacters`.

## Install

Drop the package next to your mod (a sibling of `System`), and list it **before** your own package:

```ini
[Editor.EditorEngine]
EditPackages=JsonLib
EditPackages=YourMod
```

`JsonObject` is a plain `Object`, so it is server-side only unless you replicate it yourself; it does
not need to go in `ServerPackages`.

## Notes

The parser is flat: nested objects serialize correctly but are not parsed back into child objects.

## Licence

MIT. Provided as-is, no support guarantee.
