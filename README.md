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

<!-- TODO: Add optional requirements (festival) -->

## Usage
### Engraving Template: `bhs-tlbb.ily`
The core funcitonality of this package is based off of the built-in LilyPond choral templates, `satb.ly` and `ssaattbb.ly`. These templates are designed to be included at the end of an input `.ly` file, and automatically format any music that fits their specification. This drastically simplifies the process of laying out multi-part choral music. `bhs-tlbb.ily` is simply a wrapper around these built-in templates.

To use it, simply follow the specification for the template and include the following line at the bottom of the file:
```LilyPond
\include "bhs-tlbb.ily"
```

To understand the available layout variables and options, view the documentation for the built-in [satb template][4]. All of the variables and options from that template are available for use with `bhs-tlbb.ily`, with the following exceptions:
* Part names are changed to match the Tenor, Lead, Bari, Bass configuration
  * For now, this only affects the Music and Lyrics variables; others remain unaffected.
* The following variable sets will be automatically overwritten to conform to the specification:
  * InstrumentName
  * ShortInstrumentName
  * TwoVoicesPerStaff

## Project History
<!-- TODO: Fill this in to acknowledge reference inspirations and previous work -->


[1]: https://www.barbershop.org/
[2]: http://www.barbershop.org/files/documents/getandmakemusic/Barbershop%20Notation%20Manual.pdf
[3]: http://lilypond.org
[4]: https://lilypond.org/doc/v2.20/Documentation/learning/satb-template
<!-- [4]: http://festvox.org/festival/ -->
