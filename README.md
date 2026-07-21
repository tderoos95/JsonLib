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
`JsonUtils` — `StripColorCodes`, `HexToInt`, `GetChrCode`.

### What `AddString` does, and what it does not

`AddString` **escapes**. It does not **filter**, and it never removes anything.

Anything outside printable ASCII is emitted as `\uXXXX`, so the serialized document is always pure
ASCII and therefore always valid UTF-8 whatever you put in it — accents, Cyrillic, CJK, emoji. Do not
pre-filter your text to make it safe to serialize: it already is, and every character you passed in
comes back out of `Deserialize` exactly as it went in.

The consequence is that **colour codes are escaped, not stripped**. A UT2004 colour code is the escape
byte plus three arbitrary channel bytes, so `AddString` faithfully emits it as four `\uXXXX` sequences
and whoever reads the document gets the markup rather than clean text. If you want it gone, remove it
yourself before serializing:

```unrealscript
// as-is - the markup survives, escaped: {"PlayerName":"\u001b\u0001\u0002\u0003Player"}
Json.AddString("PlayerName", PRI.PlayerName);

// stripped first: {"PlayerName":"Player"}
Json.AddString("PlayerName", class'JsonLib.JsonUtils'.static.StripColorCodes(PRI.PlayerName));
```

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
