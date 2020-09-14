# lilypond-mods

These are modifications/bug fixes/enhancements to LilyPond source code which I have been working on. Eventually I will probably try to get some of the actually useful and well-written ones included in the main release or the [LSR][1], but for now I want to make them available for manual inclusion. Also I want to keep my work backed up.

Note: `<top-dir>` is wherever your lilypond source is installed. For the standard Linux distribution, this should be in the current user's home directory.

## song.scm
### Installation:
Replace `<top-dir>/lilypond/usr/share/lilypond/current/scm/song.scm` with this file.

### Description:
Updates the LilyPond Festival XML output function to recognize ties and treat them the same as melismata. This is the expected functionality, where a set of tied notes only receives a single syllable.

## FESTIVAL FIX: There are indeed 60 seconds in a minute, not 50...
### Implementation:
Change the offending line in `festival/lib/singing-mode.scm` once Festival is installed on the system.

### Description:
For some reason, there's a line in the Festival singing code that sets the number of seconds in a minute to 50. It even has a comment that says, "switch this back to 60". So make sure to do that if you're using `BHStemplate-festival.ily`.

[1]: http://lsr.di.unimi.it/LSR/Search
