# Singing Synthesis
One of the secondary goals of this project is to enable the automatic generation of synthesized vocal tracks, to aid in the arranging process. MIDI is great, but sometimes hearing the lyrics really makes a difference.

## Current implementation: OpenUtau [Beta]
That's right, we're going anime, baby!

[OpenUtau][1] is a modern, free, and open-source successor to UTAU, a VOCALOID-like singing synthesis platform. It has the ability to automatically synthesize singing from MIDI tracks with lyric annotations, akin to the ones used in karaoke. This theoretically means one can generate tracks directly from `bhs-lilypond` MIDI output files.

In the current version, doing so actually requires some pre-processing of the MIDI files and modification of the lyrical content. Future versions of `bhs-lilypond` may circumvent the need for this.

### Installation
#### Install OpenUtau and voices
Follow the [OpenUtau installation directions][4] and acquire at least one voicebank.

#### Set up python environment
Follow your favorite process for creating and activating a python environment. Install the requirements with `pip`:
```bash
$ pip install -r requirements.txt
```

### Usage
To start, ensure that you have created a version of your score WITHOUT lyrical skips in any parts. Skipped lyrics do not get synthesized by OpenUtau, and may break the preprocessing scripts. If you plan to use OpenUtau during the arrangement process, consider waiting to create the final layout lyrics with skips until after all tracks have been synthesized.

Suppose you have compiled a score called `my_score.ly`, with standard TLBB part names. Run the following to prep the output MIDI file for OpenUtau synthesis:
```bash
$ python prep_for_openutau.py my_score.midi Tenor Lead Bari Bass
```
This will write a MIDI file named `my_score_openutau.midi` to the current directory. This file can be directly opened with OpenUtau for synthesis.

## History
### Version 1: Festival Singing Synthesis [DEPRECATED]
[Festival][2] is an open source text-to-speech synthesis system that is (mostly?) no longer maintained. Its capacity for modifying tone and pitch enabled it to be a rudimentary yet effective platform for singing synthesis, even though that was not its primary purpose. Historically, LilyPond had Festival integration through the `lilysong` script, which allowed for automatic generation of Festival input at score compilation time. The first version of `bhs-lilypond` added some wrappers around this capability to aid in its utility and interoperability.

While this was a useful starting place, there were issues. Most notably, listeners complained loudly about the quality and utility of the generated tracks, leading to a search for higher quality solutions. Under the hood, this package relied on some small tweaks and bug fixes to `lilysong` that were never pushed to the LilyPond source, making installation difficult. Finally, there were a number of frustrating ways that Festival output could be inconsistent, requiring some less-than-ideal workarounds to hack together viable tracks.

Some time after `bhs-lilypond` transitioned away from Festival, LilyPond officially depricated Festival integration in [version 2.25][3].

## Future:
There are many high-quality nerual network-based singing synthesizers coming out currently, both as research models and as full products. These solutions tend to have drastically improved synthesis quality over existing methods. I have previously played with integrating `bhs-lilypond` with these systems, but the absence of input file standards and general difficulty of use of these systems has stymied progress. As technology improves, additional output modalities may be added to enable more complex synthesis pipelines.

[1]: https://www.openutau.com/
[2]: https://www.cstr.ed.ac.uk/projects/festival/
[3]: https://lilypond.org/doc/v2.25/Documentation/changes/miscellaneous-improvements
[4]: https://github.com/stakira/OpenUtau/wiki/Getting-Started