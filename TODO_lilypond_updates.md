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

## [v2.24](http://lilypond.org/doc/v2.24/Documentation/changes/)

* The \rhythm markup command has been added. It is a simple way to enter rhythms mixed with text, such as in “swing” indications.
    * Consider adding an example of this?
* \bar "" is no longer necessary to print the first bar number. It now suffices to set barNumberVisibility to all-bar-numbers-visible, or one of the other visibility settings where the first bar number is visible.
    * I think this should suffice to render any fixes in the current version unnecessary
* Due to changes in the internals of \bar, it is no longer supported to use it before creating lower contexts with \new. Such uses will now create an extra staff. This is similar to what happens with commands such as \override Staff… (see An extra staff appears).
    * I do not believe this affects this package, but should verify
* The comma glyph shape, as used in the \breathe command, has been changed to a more common form.
    * I do not believe this affects this package, but should verify
* The new context property breathMarkType selects the mark that \breathe produces from several predefined types.
    * Does this affect the definition of caesura?
* New commands \textMark and \textEndMark are available to add an arbitrary piece of text between notes, called a text mark. These commands improve over the previously existing syntax with the \mark command called as \mark markup (i.e., \mark "…" or \mark \markup …).
    * Should improve text markup
    * Consider adding an example of this?
* \smallCaps now works on any markup, not just on a bare string.
    * This may have impacts; verify
* The syntax for conditions in markups was made more flexible and user-friendly. It uses the new markup commands \if and \unless. Here are example replacements:
    * This should have impacts on layout definitions
* Text replacements can now replace strings with any markup, not just with a string.
    * This should not have impacts, but could take a look
* The new show-horizontal-skylines and show-vertical-skylines properties allow to display an object’s skylines. This is more flexible than the already existing debug-skylines option because it works for all grobs. While primarily meant for debugging LilyPond, this can be useful when trying to understand spacing decisions or overriding stencils in Scheme.
    * Relevant to debug settings
* The new command \vshape is like \shape, but also shows the control points and polygon for easier tweaking.
    * Could this allow for easier melody transitions, in any way? Unclear.
* SCHEME TRANSLATOR IMPROVEMENTS
    * Would need to come back to understand more
