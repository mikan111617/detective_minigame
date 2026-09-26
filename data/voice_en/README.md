# English voice files

When the game language is **English**, battle voices are loaded from this directory automatically.

## Folder and file naming

Use exactly the same relative paths as the Japanese voices in `data/voice/`:

```
data/voice_en/{character_id}/{category}_{index}.wav
```

Examples:

```
data/voice_en/mahoru/doubt_0.wav
data/voice_en/airi/place_calm_0.wav
data/voice_en/reido/ability_1.wav
```

The language switch does not change IDs or indices. The English line at a given index corresponds to the Japanese line at the same index in `doubt_data.js`.

- Japanese: `data/voice/{character_id}/...`
- English: `data/voice_en/{character_id}/...`
- Audio format: `.wav`
- Missing files are skipped silently, so voices can be added gradually.

## English recording script

The authoritative English battle lines are defined by:

```
data/others/lang/en/others/plugin/doubt/doubt_data.js.json
```

At runtime that dictionary translates the `lines` arrays in:

```
data/others/plugin/doubt/doubt_data.js
```

Keep the array order unchanged after recording, because the array index is part of the audio filename.
