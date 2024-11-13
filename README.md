# bhs-lilypond
This repository represents a set of utilities for notating and engraving barbershop scores in LilyPond, such that the output meets the [Barbershop Notation Manual][2] specification. Other tools are included to augment the experience of working with or arranging barbershop music in LilyPond.

## Overview
Creating high-quality, beautiful, easy-to-read barbershop music notation can be a difficult task. The [Barbershop Harmony Society][1] provides a [set of notation guidelines][2], intended to ensure uniformity and clarity across all barbershop arrangements. In practice, following these guidelines using modern music engraving software can be a tedious and drawn-out process requiring manual tweaking.

[LilyPond][3] is a free music engraving program designed to automate the process of laying out music. It has all of the necessary functionality to take a score and engrave it as a high-quality, beautiful, and easy-to-read document. Furthermore, its highly-extensible design allows for the addition of new functionality and configuration for specific use cases.

## Requirements
| Software      | Version |
|---------------|---------|
| [LilyPond][3] | 2.24+   |

## Usage

### Basic Usage

After cloning this repository, to begin creating a score, create a `.ly` file in the top level `bhs-lilypond` directory.

Creating a barbershop score with this package requires the following basic steps:
* Select a pre-defined score specification that defines the desired voice parts and layout
* Provide music and lyrics that match that score specification
* Include the template at the bottom of the file, to automatically generate PDF and MIDI output with the correct formatting

In practice, this looks something like the following for a TTBB (Tenor, Lead, Baritone, Bass) ensemble:
```LilyPond
% Select score spec
ScoreSpec = "bhs-ttbb"

% Define music and lyrics
TenorMusic = \relative c'' {
    ...
}

TenorLyrics = \lyricmode {
    ...
}

...

% Include template
\include "bhs-lilypond.ily"
```

Music and lyrics for each part are specified as variables. For a voice named `VoiceOne`, music should be assigned to the variable `VoiceOneMusic`, and lyrics should be assigned to the variable `VoiceOneLyrics`. The available voices and their names are defined as part of the score spec, which also handles grouping the voices into staves.

To change to another ensemble type, such as SSAA (Tenor, Lead, Baritone, Bass), simply swap out the score spec:
```LilyPond
ScoreSpec = "bhs-ssaa"
```

All score specs should be stored in the `score-specs` directory. See the [README in that directory](score-specs/README.md) for details on available score specs, as well as instructions on how to make your own.

After your score is put together, simply compile the score with LilyPond:
```bash
$ lilypond FILE_NAME.ly
```
This will generate both `FILE_NAME.pdf` and `FILE_NAME.midi`.

### BHS Markup: `bhs-markup.ily`
Additional functionality for marking up your score in BHS-specific ways can be found in `bhs-markup.ily`. To include these, add the following to the top of your file:
```LilyPond
\include "bhs-markup.ily"
```
<!-- TODO: Document available functions -->

## Examples
See `example_tag.ly` and `example.ly` for full examples of the use of this package.
<!-- TODO: embed picture? -->
<!-- TODO: If I embed a picture, I should probably move this earlier... -->

## Important Notes
<!-- TODO: It looks as if the location of this documentation is changing in v2.25; be on the lookout for where it ends up -->
* LilyPond now provides methods for enhancing MIDI output, most notably by automatically applying swing rhythms. For details, see the relevant [LilyPond documentation][9].
* Starting in [v2.22], the `'relative-includes` option is now enabled by default by LilyPond. Included files that contain an `\include` command of their own must account for their own path rather than the main file’s directory. `bhs-lilypond` has been updated to reflect this change. **Setting `'relative-includes` to `#f` will likely break import logic in this template; do so at your own risk.**
    * Scheme files and LilyPond files appear to follow different relative path rules within LilyPond. As a result of this change, to unify interfaces within this template and make life easier, all scheme definitions in this repository have been moved into `.ily` files.

## Project History

### Credits and Inspiration
This project originated as a fork of [tahongawaka/LilyPond-BHS-Template][8]. This repository was an invaluable inspiration and reference for learning how to format LilyPond vocal scores. Over time, as my understanding of the language improved, I began to replace components of the template to better match the notation guidelines and make score building easier. Once I became familiar with the built-in LilyPond choral template system, I decided to implement my own system completely from scratch.

### Core LilyPond Functionality
The core funcitonality of this package is based off of the built-in LilyPond choral templates, as used in `satb.ly` and `ssaattbb.ly`. These templates are designed to be included at the end of an input `.ly` file, and automatically format any music that fits their specification. This drastically simplifies the process of laying out multi-part choral music. See the documentation for the [satb template][4] for more details.

<!-- TODO: Expand on the options this brings to the table; especially Key and Time -->

### Singing Synthesis
One of the secondary goals of this project was to enable the automatic generation of synthesized vocal tracks, to aid in the arranging process. MIDI is great, but sometimes hearing the lyrics really makes a difference.

#### Version 1: Festival Singing Synthesis [DEPRECATED]
[Festival][5] is an open source text-to-speech synthesis system that is (mostly?) no longer maintained. Its capacity for modifying tone and pitch enabled it to be a rudimentary yet effective platform for singing synthesis, even though that was not its primary purpose. Historically, LilyPond had Festival integration through the `lilysong` script, which allowed for automatic generation of Festival input at score compilation time. The first version of `bhs-lilypond` added some wrappers around this capability to aid in its utility and interoperability.

While this was a useful starting place, there were issues. Most notably, listeners complained loudly about the quality and utility of the generated tracks, leading to a search for higher quality solutions. Under the hood, this package relied on some small tweaks and bug fixes to `lilysong` that were never pushed to the LilyPond source, making installation difficult. Finally, there were a number of frustrating ways that Festival output could be inconsistent, requiring some less-than-ideal workarounds to hack together viable tracks.

Some time after `bhs-lilypond` transitioned away from Festival, LilyPond officially depricated Festival integration in [version 2.25][6].

#### Version 2: OpenUtau [Current][Beta]
That's right, we're going anime, baby!

[OpenUtau][7] is a modern, free, and open-source successor to UTAU, a VOCALOID-like singing synthesis platform. It has the ability to automatically synthesize singing from MIDI tracks with lyric annotations, akin to the ones used in karaoke. This theoretically means one can generate tracks directly from `bhs-lilypond` MIDI output files.

In the current version, doing so actually requires some pre-processing of the MIDI files and modification of the lyrical content. Future versions may circumvent the need for this.

#### Future:
There are many high-quality nerual network-based singing synthesizers coming out currently, both as research models and as full products. These solutions tend to have drastically improved synthesis quality over existing methods. I have previously played with integrating `bhs-lilypond` with these systems, but the absence of input file standards and general difficulty of use of these systems has stymied progress. As technology improves, additional output modalities may be added to enable more complex synthesis pipelines.

## LilyPond TODO items
List of relevant LilyPond updates that might simplify / modify / otherwise affect functionality added in this package.

### General notes

* Music function definitions in this template are inconsistent in their documentation style; consider defaulting to style in https://github.com/lilypond/lilypond/blob/master/ly/music-functions-init.ly


[1]: https://www.barbershop.org/
[2]: http://www.barbershop.org/files/documents/getandmakemusic/Barbershop%20Notation%20Manual.pdf
[3]: http://lilypond.org
[4]: https://lilypond.org/doc/v2.20/Documentation/learning/satb-template
[5]: https://www.cstr.ed.ac.uk/projects/festival/
[6]: https://lilypond.org/doc/v2.25/Documentation/changes/miscellaneous-improvements
[7]: https://www.openutau.com/
[8]: https://github.com/tahongawaka/LilyPond-BHS-Template
[9]: https://lilypond.org/doc/Documentation/notation/enhancing-midi-output
[10]: http://lilypond.org/doc/v2.22/Documentation/changes/