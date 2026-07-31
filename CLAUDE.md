This is the intellectorboard library's own source repository, distributed as a haxelib library (see `haxelib.json`).

`intellectorboard` implements the core rules and data model of the Intellector board game: hex/piece/ply primitives (`primitives`), position and piece arrangement (`position`), movement rules including premoves (`movement`), ply materialization and application (`plyapplication`), a ply tree with path-based navigation (`plytree`), and notation/label formatters (`mappers`). All source lives under `src/intellectorboard` (`intellectorboard` package and its subpackages).

ANY AMBIGUITY OR MANUAL GAP SURFACING DURING IMPLEMENTATION SHOULD NOT BE RESOLVED SILENTLY. Instead, explicitly ask the question.

If told to take a dubious or possibly suboptimal approach (whether from the UI/UX or technical standpoint), also ask a question, providing details on why you're uncertain about this and what are the better practices or better ways to solve the problem.

# Code style conventions

See `code_style.md`.

# Dependencies

- `morestd` - small, universal utilities (e.g. `Counter`, `MathTools`, `EnumeratingIterator`, `StringIterator`).

See `haxelib.json`'s `dependencies` for the authoritative list.
