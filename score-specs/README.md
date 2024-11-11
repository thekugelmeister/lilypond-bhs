# Score Specs
This directory stores the set of defined score specifications for charts layed out with the `bhs-lilypond` package. To use a score spec with the file name `my-score-spec.ily` in your layout, add the following to your file:
```LilyPond
ScoreSpec = "my-score-spec"
```

## Default score specs
The following score specs are provided with the package, to cover the majority of BHS layout conditions:

### `bhs-ttbb`
TTBB (Tenor, Lead, Bari, Bass) ensemble. Two two-voice staves per system:
* Tenor and Lead, octave treble clef (8va)
* Bari and Bass, bass clef

### `bhs-ssaa`
SSAA (Tenor, Lead, Bari, Bass) ensemble. Two two-voice staves per system:
* Tenor and Lead, treble clef
* Bari and Bass, octave bass clef (8va)

### `satb`
SATB ensemble. Four one-voice staves per system:
* Soprano, treble clef
* Alto, treble clef
* Tenor, octave treble clef (8va),
* Bass, bass clef

## How score specs work
A valid score specification carries out the following 3 operations:
* Define the set of unique voices.
* Assign the voices to the staves that make up the score.
* Set the global staff list to contain the defined staves.

### Voice definition
If a score spec defines a voice named `VoiceOne`, music should be assigned to the variable `VoiceOneMusic`, and lyrics should be assigned to the variable `VoiceOneLyrics`. Any music assigned to variables that do not match the defined voices in the chosen score spec will be silently ignored.

### Staff assignment
Voices can be placed on one-voice or two-voice staves. Two-voice staves handle lyric placement (above and below the staff) appropriately. All defined staves will be grouped together automatically to form systems during layout. Any voices which are not added to staves will be silently omitted from output.

### Global staff list
The global staff list defines the set of staves that make up the systems in the final output. Any staves not added to the global staff list will be silently omitted from output.

## Making your own score spec
An easy way to start is to make a copy of one of the default specs and attempt to modify it to suit your needs. Alternatively, follow the directions below.

To start, add a new `.ily` file to this directory with the desired name of the score spec. At the top of the file, include the score spec utility file:
```LilyPond
\include "../score-spec.ily"
```

Voices and staves are constructed in scheme using GOOPS objects, as defined in the utility file.

To define a voice called `VoiceOne` in octave treble clef, make a `<voice-spec>` object with the appropriate name and clef attributes:
```LilyPond
#(define voiceone-voice (make <voice-spec> #:name "VoiceOne" #:clef "treble_8"))
```
This will make the `VoiceOneMusic` and `VoiceOneLyrics` variables available in your layout file.

To assign `VoiceOne` to a one-voice staff, make a `<one-voice-staff-spec>` object containing the `<voice-spec>` object:
```LilyPond
#(define voiceone-staff (make <one-voice-staff-spec> #:name "VoiceOne" #:voice voiceone-voice))
```

To assign `VoiceOne` and a similarly-defined voice called `VoiceTwo` to a two-voice staff, make a `<two-voice-staff-spec>` object containing the `<voice-spec>` objects:
```LilyPond
#(define upper-staff (make <two-voice-staff-spec> #:name "UpperVoices" #:voice1 voiceone-voice #:voice2 voicetwo-voice))
```

Finally, to add staves to the global staff list, call the `set-staves!` method:
```LilyPond
#(set-staves! (list upper-staff lower-staff))
```

**Some notes:**
* Technically, there is no limit to how many staves can be added to the global staff list. However, at some point, the layout will become too heavily constrained and/or overflow the page size. This template has been designed to work well for two two-voice staves or four one-voice staves; anything larger may cause unintended out-of-scope errors.
* Voices added to the same two-voice staff are expected to have matching clefs. However, no check is performed to enforce this. The clef for the shared staff will always be set to the clef of `#:voice1`.
* The global staff list is an ordered list from top to bottom within each system.