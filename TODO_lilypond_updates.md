# LilyPond Update To-Do List
List of relevant LilyPond updates that might simplify / modify / otherwise affect functionality added in this package.

## General notes

* I have made changes to the file `lilypond/2.20.0/scm/song.scm` to improve festival synthesis. These should either be pushed to lilypond or documented in this repository.
* Music function definitions are inconsistent in their documentation style; consider defaulting to style in https://github.com/lilypond/lilypond/blob/master/ly/music-functions-init.ly?

## [v2.22](http://lilypond.org/doc/v2.22/Documentation/changes/)

* Swing and irregular rhythmic patterns may now be applied to music expressions made of regular durations, which may be used to render inequal rhythmic interpretation in MIDI.
    * Consider providing an example for this?
    * How does this work with Festival output?
* As announced in version 2.17.3 nearly eight years ago, the 'relative-includes option is now enabled by default; included files that contain an \include command of their own must account for their own path rather than the main file’s directory. That behavior may however be switched off by setting 'relative-includes to #f, either as a command line option or using ly:set-option in source files.
    * This does not break anything, and in fact improves pathing now that everything is in .ly files rather than .scm files. However, maybe it should be documented that turning off relative includes may cause unexpected behavior?
