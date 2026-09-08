# Species Counter

Count organisms in survey photos and export analysis-ready CSVs — a browser app plus the original MATLAB version.

**[🌐 Open in browser](https://avelaxonov.github.io/script-vault/species-counter/)** · **[⤓ Download for offline use](species-counter.html)** *(right-click → Save link as…, then double-click the file)*

Everything runs locally in your browser. Your photos are never uploaded anywhere.

Scroll down for details on MATLAB script version

## Files

| File | What it is |
|---|---|
| [`index.html`](index.html) | The webpage of the app published & powered through GitHub Pages (fully self-contained). |
| [`species-counter.html`](species-counter.html) | Identical copy under a descriptive name, for downloading and running offline. |
| [`SpeciesCounter.m`](SpeciesCounter.m) | The MATLAB version of the same tool. |

## Using the app

1. **Open Folder** and pick a folder of photos.
2. **Add Species** for whatever you're counting.
3. Count by clicking on `+/-` **OR** with the number keys — `1`–`9` add one to that species; `Shift` subtracts.
4. Press `Enter` to log the photo and advance.

| Key | Action |
|---|---|
| `←` `→` | Previous / next photo |
| `1`–`9` | Add one to that species |
| `Shift` + `1`–`9` | Subtract one |
| `Enter` | Log photo and advance |
| `P` / `F` / `0` | Toggle present / flag uncertain / reset count |

The photo counter shows whether the current photo is in your results: 
- plain `12 / 300` means nothing entered,
- amber `● unlogged` means counts entered but not yet written to the CSV,
- green `✓ logged` means written.
Browsing away from unlogged counts never loses them, and the session auto-saves so you can quit and resume.

**Output:** `species_counts.csv` (one row per photo) and `species_counts_long.csv` (one row per photo × species, ready to use for `dplyr`/`ggplot2`). You can also define your own per-photo columns such as `transect` or `depth` under ⚙ → Custom columns.

## Running the MATLAB version

Requires MATLAB R2020b or newer. Download [`SpeciesCounter.m`](/SpeciesCounter.m), then in MATLAB:

```matlab
cd /path/to/folder/containing/SpeciesCounter.m
SpeciesCounter
```

Or add the folder to your path (`addpath`) and run `SpeciesCounter` from anywhere. Use **Add Species** to define your labels, then **Open Folder** to start. Session files (`species_counts.csv`, `species_counts_long.csv`, `sc_species.txt`, `sc_settings.txt`) are written into the photo folder, so the folder resumes on any machine with MATLAB.

Both versions write the same CSV columns, so you can count in one and analyze in the other.
