# lilypond-bhs
Utilities for notating and working with barbershop music in LilyPond!

## Overview
Creating high-quality, beautiful, easy-to-read barbershop music notation can be a difficult task. The [Barbershop Harmony Society][1] provides a [set of notation guidelines][2], intended to ensure uniformity and clarity across all barbershop arrangements. In practice, following these guidelines using modern music engraving software can be a tedious and drawn-out process requiring manual tweaking.

[LilyPond][3] is a free music engraving program designed to automate the process of laying out music. It has all of the necessary functionality to take an arrangement and automatically engrave it as a high-quality, beautiful, and easy-to-read document. Furthermore, its highly-extensible design allows for the addition of new functionality and configuration for specific use cases.

This repository represents a set of utilities for notating, engraving, and working with barbershop arrangements in LilyPond. The core functionality revolves around the notation and engraving of barbershop music, such that the output meets the [Barbershop Notation Manual][2] specification. Other tools are included to augment the experience of working with or arranging barbershop music in LilyPond.

## Requirements
| Software      | Version |
|---------------|---------|
| [LilyPond][3] | 2.20+   |

## Usage
The core funcitonality of this package is based off of the built-in LilyPond choral templates, as used in `satb.ly` and `ssaattbb.ly`. These templates are designed to be included at the end of an input `.ly` file, and automatically format any music that fits their specification. This drastically simplifies the process of laying out multi-part choral music. See the documentation for the [satb template][4] for more details.

<!-- TODO: Expand on the options this brings to the table; especially Key and Time -->

### Basic Usage

As with the LilyPond choral templates, music and lyrics for each part are specified as variables. For a voice named `VoiceOne`, music should be assigned to the variable `VoiceOneMusic`, and lyrics should be assigned to the variable `VoiceOneLyrics`. The available voices and their names are typically pre-defined as part of the score spec. The score spec also handles grouping the voices into staves.

To format a score for a TTBB ensemble (Tenor, Lead, Baritone, Bass), include the following lines at the bottom of the file:
```LilyPond
\include "bhs-init.ily"
\include "score-specs/bhs-ttbb.ily"
\include "lilypond-bhs.ily"
```

To change to another ensemble type, such as SSAA (Tenor, Lead, Baritone, Bass), simply swap out the score spec:
```LilyPond
\include "score-specs/bhs-ssaa.ily"
```

<!-- TODO: Document score specification -->

### BHS Markup: `bhs-markup.ily`
Additional functionality for marking up your score in BHS-specific ways can be found in `bhs-markup.ily`. Include this file at the top of your file.
<!-- TODO: Document available functions -->

## Examples
See `example_tag.ly` for a full example of the use of this package.
<!-- TODO: embed picture? -->
<!-- TODO: If I embed a picture, I should probably move this earlier... -->

## Project History
<!-- TODO: Fill this in to acknowledge reference inspirations and previous work -->


[1]: https://www.barbershop.org/
[2]: http://www.barbershop.org/files/documents/getandmakemusic/Barbershop%20Notation%20Manual.pdf
[3]: http://lilypond.org
[4]: https://lilypond.org/doc/v2.20/Documentation/learning/satb-template
