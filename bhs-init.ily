\version "2.20"
\include "base-tkit.ly"
#(load "bhs-utils.scm")

                                % TODO: I need to find somewhere to document these
                                % The following are useful functions for tweaking in scheme
                                % (grob::display-objects grob)
                                % (grob::all-objects grob)

                                % TODO: This is probably not worth it, and I should instead be using (load) to import modules, etc.
%% Force lilypond guile to include this directory in its load path
#(set! %load-path (cons (getcwd) %load-path))


%%% @Section B.9.a
%% An accidental affects only one voice part for one measure, unless the pitch is tied over the bar line, in which case the accidental is in force only for the duration of the tied note. If the tied pitch is repeated in the new measure, then another accidental is required. Accidentals include the flat, sharp, natural, double flat and double sharp. To cancel a double sharp in a measure, simply use a single sharp. Likewise, to cancel a double flat, use a single flat.
%%% @Section B.9.c
%% Use courtesy accidentals, which are given in parentheses, only if the first note of a given measure is a chromatic version of the last note in the preceding measure in the same part.

%% From music-functions.scm:
%% - accidental-styles alist:
%%   "Each accidental style needs three entries for the context properties extraNatural, autoAccidentals and autoCautionaries. An optional fourth entry may specify a default context for the accidental style, for use with the piano styles."
%% - (make-accidental-rule octaveness laziness):
%%     "Create an accidental rule that makes its decision based on the octave of the note and a laziness value.
%%      octaveness is either 'same-octave or 'any-octave and defines whether the rule should respond to accidental changes in other octaves than the current.  'same-octave is the normal way to typeset accidentals -- an accidental is made if the alteration is different from the last active pitch in the same octave.  'any-octave looks at the last active pitch in any octave.
%%      laziness states over how many bars an accidental should be remembered. 0 is the default -- accidental lasts over 0 bar lines, that is, to the end of current measure.  A positive integer means that the accidental lasts over that many bar lines.  -1 is `forget immediately', that is, only look at key signature.  #t is `forever'."

%% The following defines a new accidental style called "bhs-voice-cautionary", which is based on the built-in "voice" and "modern-cautionary" accidental styles:
%% - Sets extraNatural to #f
%% - All rules apply to the Voice context, rather than the Staff context
%% - autoAccidentals: Accidentals are remembered to the end of the measure in which they occur and only in their own octave
                                % TODO: Technically, this implementation is incorrect, but I like it better in most cases.
%% - autoCautionaries: After temporary accidentals, cautionary cancellation marks are printed also in the following measure (for notes in the same octave) and, in the same measure, for notes in other octaves.
#(set! accidental-styles (append accidental-styles
                          `(
                            (bhs-voice-cautionary
                             #f
                             (Voice
                              ,(make-accidental-rule 'same-octave 0))
                             (Voice
                              ,(make-accidental-rule 'any-octave 0)
                              ,(make-accidental-rule 'same-octave 1))))))


%% Generic Settings and Initialization
\pointAndClickOff

#(define other-settings
  '("BHSDebug"
    "TagPage"
    "ShowTempo"))
#(define-missing-variables! other-settings)

#(cond
  (BHSDebug
   (ly:set-option 'debug-skylines)
   (ly:set-option 'debug-page-breaking-scoring)
 ))

%% BHS Settings
%%% @Section A.1.a
%% For men’s voices, each music system consists of two staves, one for treble clef with an 8 beneath it (to be read an octave lower than written, for the lead and tenor parts) and one for bass clef (baritone and bass parts). For women’s voices, each music system consists of two staves, one for treble clef (for the lead and tenor parts) and one for bass clef with an 8 above it (to be read an octave higher than written, for the baritone and bass parts). Indicate each music system by using a choral bracket to connect the two staves.
                                % TODO: Maybe put this documentation in the relevant score-spec files?

%%% @Section A.10
                                % TODO: Medley spec is currently unimplemented.

%%% @Section A.15
%% Place optional passages of songs on a new system following the conclusion of the song. Use the label Optional tag, Optional key change, etc. as needed using 12-point fixed size Times New Roman Italic type.
                                % TODO: Optional tag/etc. spec is currently unimplemented

%%% @Section B.4.b
%% Indicate a change in key by placing a double bar line prior to the indication of the new key. If a key change occurs at the start of a new system, place a double bar line followed by a courtesy key signature at the end of the preceding system.
                                % TODO: Key change bar line spec is currently unimplemented

%%% @Section B.5.b
%% Indicate a change in meter by placing a double bar line prior to the indication of the new meter.
%%% @Section B.5.c
%% Indicate a meter change that preserves the time value of the basic beat
                                % TODO: Time signature change spec is currently unimplemented

\paper {
  annotate-spacing = #BHSDebug
  
  page-breaking = #(if TagPage
                    ly:one-page-breaking
                    ly:optimal-breaking)

%%% @Section A.2
  %% Use 1/2” to 5/8” margins at the top, bottom and sides of all pages. The ends of each music system, including the choral bracket, sit within and abut the side margins.
  #(set-paper-size "letter")
  bottom-margin = 0.50\in
  top-margin = 0.50\in
  inner-margin = 0.50\in
  outer-margin= 0.625\in % 5/8 inch
  line-width = 7.375\in % 8.5 inch page width - ( inner-margin + outer-margin )
  ragged-last-bottom = ##t

%%% @Section A.1.d
  %% The standard format is three or four systems on the first page, and four or five systems on the other pages.  Use good judgment.  Avoid crowding too many systems on a page.  On the first page, save room above the first system for song title, writers and arrangers.
                                % TODO: This does not do a great job. Fix it.
  %% NOTE: This still seems to be pretty much impossible in LilyPond. The current setting is kind of "good enough". It combines max-systems-per-page with flexible vertical spacing settings to make things look good, while hoping that we never hit a scenario where too few systems end up on a page.
                                % min-systems-per-page = 4
  max-systems-per-page = 5
  system-system-spacing.padding = #4 % ensure there is a little space between systems
  top-system-spacing.padding = #3 % ensure there is a little space between the page header and the top system on each page
  top-markup-spacing.padding = #4 % ensure there is a nice amount of space above the title markup
  markup-system-spacing.padding = #4 % ensure there is a nice amount of space below the title markup
  % page-breaking-system-system-spacing.basic-distance = #5 % trick the page breaker into thinking there needs to be a sufficiently large gap between systems, such that the first page will not have 5 systems on it

  #(define fonts
    (set-global-fonts
     #:roman "Times New Roman"
     #:sans "Arial"
     #:factor (/ staff-height pt 20) ; unnecessary if the staff size is default
   ))

  bookTitleMarkup = \markup {
    \column {
%%% @Section A.4.a
      %% Center the song title at the top of the first page. Use all capital letters in 22 point fixed size ARIAL BOLD type.
      \fill-line { \abs-fontsize #22 { \sans \bold \fromproperty-apply #'header:title #(lambda (x) (string-upcase x))} }
%%% @Section A.4.b
      %% If the song title includes a parenthetical phrase or word, center the parenthetical expression and use capital letters, 12-point fixed size ARIAL BOLD type.
      \fill-line { \abs-fontsize #12 { \sans \bold \fromproperty-apply #'header:subtitle #(lambda (x) (string-append "(" (string-upcase x) ")"))} }
%%% @Section A.5
      %% If the song is in public domain, center the year it was written in parentheses directly below the title, in 12-point fixed size Arial Bold.
      \fill-line { \abs-fontsize #12 { \sans \bold \fromproperty-apply #'header:date #(lambda (x) (string-append "(" x ")"))} }
%%% @Section A.9
      %% Center under the title any acknowledgment or indication of the group that popularized the arrangement. Use 10-point fixed size Times New Roman Italictype
      \fill-line { \abs-fontsize #10 { \italic \fromproperty #'header:addinfo } }
%%% @Section A.6-8
      %% See documentation for lyricist-composer-arranger in utilities.
                                % TODO: When there are multiple people, apparently the "and" between names should not be capitalized.
      \abs-fontsize #12 {
        \strut
        \lyricist-composer-arranger
        \strut
      }
    }
  }

  oddFooterMarkup = \markup {
%%% @Section A.14.a
    %% Center the copyright notice at the bottom of the first page of music. Include, at a minimum, the date of the copyright and the name of the copyright owner. Use 9-point regular fixed size Times New Roman type. The copyright owner will specify the form and content of the copyright notice.
%%% @Section A.14.b-g
                                % TODO: Copyright stuff is complicated. It seems reasonable to me to leave copyright formatting as an exercise for the user, but I can see the utility of having pre-formatted inclusions available for the ones given in the spec.
    \on-the-fly #part-first-page
    \column {
      \strut
      \strut
      \abs-fontsize #9 {
        \fill-line { \override #'(align-dir . 0) \override #'(paragraph-spaces . 0) \fromproperties #'header:copyright }
      }
    }
%%% @Section C.5.a
    %% Place Performance Notes after the music in 18-point fixed size Times New Roman bold italic type, with a solid horizontal line separating the last music system from the Performance Notes in Arial 18-point fixed size bold.
%%% @Section C.5.b
    %% Performance notes indicate possible performance options for the music, are in 10-point regular fixed size Times New Roman type, and may include historical information about the song and its author and composer, the arranger, and any artist who popularized the song.
                                % TODO: This section is sometimes way too close to the final staff. Especially true for TagPage layout. Find a way to ensure space is left between them.
    \on-the-fly #last-page
    \generate-perf-notes
  }

%%% @Section A.3
  %% Use the title of the song as a header for each page except page one.
  %% Position the header in the middle at the top of the page in 12-point fixed size Times New Roman Italic type. Use first letter caps except for articles.
  %% Position even page numbers on the left side of the page, and odd pages on the right side in 12-point fixed size Times New Roman Italic type
  oddHeaderMarkup = \markup {
    \fill-line {
      \null
      \abs-fontsize #12 { \on-the-fly #not-part-first-page \italic \fromproperty #'header:title }
      \abs-fontsize #12 { \on-the-fly #print-page-number-check-first \italic \fromproperty #'page:page-number-string }
    }
  }
  evenHeaderMarkup = \markup {
    \fill-line {
      \abs-fontsize #12 { \on-the-fly #print-page-number-check-first \italic \fromproperty #'page:page-number-string }
      \abs-fontsize #12 { \on-the-fly #not-part-first-page \italic \fromproperty #'header:title }
      \null
    }
  }
}

Layout = \layout {
  \context {
    \Score
%%% @Section A.1.b
    %% Indent the first music system so that the names of the four parts (Tenor, Lead, Bari, and Bass), with only the first letter capitalized, can be printed immediately to the left of the system. Left justify the part names flush with the left margin, and in Times New Roman type 10-point fixed size.
    %% NOTE: The following doesn't work, because the staff-tkit hard-codes the instrument name to be in a right-aligned column. Kept here for documentation.
    %% \override InstrumentName.self-alignment-X = #LEFT
    %% NOTE: This is silly, but it works. The staff-tkit hard-codes a lot of things, so I had to overwrite them. Could be avoided by replacing the staff-tkit, but I set out to make use of the pre-built lilypond funcitonality, and I am sticking to my guns. This function extracts the instrument names from the hard-coded markups, then re-packages them with the desired formatting. It also overwrites the short instrument names to force them to be empty.
    %% Based on http://lsr.di.unimi.it/LSR/Item?id=1046
    \override InstrumentName.after-line-breaking = 
    #(lambda (grob)
      (let* ((orig (ly:grob-original grob))
             (siblings (if (ly:grob? orig)
                        (ly:spanner-broken-into orig)
                        '())))
       (if (pair? siblings)
        (let* ((old-inst-name-markup (ly:grob-property grob 'long-text))
               (inst-names (map (lambda (proc) (cadr proc)) (cadr old-inst-name-markup)))
               (inst-markups (map (lambda (name) (markup name)) inst-names))
               (m (markup #:abs-fontsize 10 (make-left-column-markup inst-markups))))
         (ly:grob-set-property! (car siblings) 'long-text m)
         (for-each
          (lambda (g)
           (ly:grob-set-property! g 'text ""))
          (cdr siblings))))))
    
%%% @Section A.11.a
    %% Place names of sections (such as Intro, Verse, Chorus, Reprise, Interlude, or Tag) in 12-point fixed size Times New Roman Bold type, with the first letter aligned with the first note of the section. Capitalize only the first letter of the word.
                                % TODO: Right now this only covers the alignment issue; the rest is part of a function in bhs-markup.ily. If possible, condense things so that it's more standardized.
                                % TODO: Right now this is technically incorrect, as it always aligns to the double bar line, not the first note of the section. Fix this if it is possible to do so in an easy-to-use way.
    \override RehearsalMark.self-alignment-X = #LEFT

%%% @Section B.18
    %% Indicate a vocal glissando, which is a continuous slide in pitch from one note to another, by placing a wavy line from one note head to the next note head.
    %% Glissando style
    \override Glissando.style = #'trill

                                %% Optionally display tempo marking; spec calls for no tempo marking, so default is to hide it.
    tempoHideNote = #(not ShowTempo)

                                % Change context to staff: http://lilypond.1069038.n5.nabble.com/Consistent-bar-number-positioning-td26017.html
    \remove Bar_number_engraver

    %% Limit how close together notes can be, for readibility
    \override SpacingSpanner.base-shortest-duration = #(ly:make-moment 1/16)
  }
  \context {
    \Staff
    \consists Bar_number_engraver
%%% @Section A.12.a
    %% Number every measure, starting with the first full measure. Place the measure number above the treble staff and immediately following the bar line, except for the first measure of each system, where the measure number is placed above the treble staff and immediately after the key signature.
    %%% @Section A.12.c
    %% Use 10-point regular fixed size Times New Roman type for all measure numbers.
    \override BarNumber.break-visibility = #end-of-line-invisible
                                % TODO: This relies on the assumption that the top staff will always be index 0 or 1 in the vertical axis group, and the lower staves will always be of index > 2. Thus far, this assumption has held for all test cases. However, I am uncomfortable with this assumption. Consider robustly checking it, or finding a better way to do it.
    %% NOTE: This also handles the requirement for setting the absolute font size
    \override BarNumber.stencil = #(grob-transformer 'stencil
                                    (lambda (grob default)
                                     (if (member (ly:grob-get-vertical-axis-group-index grob) '(0 1))
                                      (grob-interpret-markup grob (markup (make-abs-fontsize-markup 10 (ly:grob-property grob 'text))))
                                      #f)))
    \override BarNumber.extra-spacing-width = #'(0 . 1)
    %% NOTE: For the following to work, it requires forcibly adding a blank bar in front of the music, so that LilyPond figures out there's a bar there in the first place. This is handled elsewhere in this template.
    barNumberVisibility = #first-bar-number-visible-and-no-parenthesized-bar-numbers
    \override BarNumber.self-alignment-X = #LEFT
    \override BarNumber.break-align-symbols = #'(time-signature key-signature staff-bar)
    \override BarNumber.avoid-slur = #'inside
    \override BarNumber.outside-staff-priority = ##f
%%% @Section A.12.b
    %% For the first measure, or any measure with a key signature and/or meter signature, place the number of the measure above the treble staff immediately after the meter signature.
    \override TimeSignature.break-align-anchor-alignment = #RIGHT
%%% @Section A.12.d (from old version of the spec)
    %% If the last measure of a system must be split to start a new section on the next system with a pickup note(s), take care not to assign a measure number to the pickup portion of the split measure.
                                % TODO: Implement this spec; this might be the automatic functionality, but this needs verification.

    \accidentalStyle bhs-voice-cautionary

%%% @Section A.1.d (continued)
    %% If there is a lot of blank space on a page, let there be some more space between grouped staves in a system, rather than just having more space between systems. This makes things look more comfortable, in most cases
    %% NOTE: This also helps cover up some imperfections in the current solution for sytems-per-page.
    \override VerticalAxisGroup.staff-staff-spacing.stretchability = #60
  }
  \context {
    \Lyrics
%%% @Section C.4
    %% Lyrics are set in 11-point regular fixed size Times New Roman type in the middle of the two staves and wherever a harmony part sings different words or the same words at different times. If the baritone and bass parts have the same set of words but different from the lead, and are singing the same rhythmic notation, simply place the words above the baritone part. If the tenor, baritone, and bass all have the same words, then place the words above the baritone and the tenor lines. If the lead and baritone are the same, but the tenor and bass are different, place words in the middle of the two staves for the lead and baritone, and above the tenor part and below the bass part. If the words are different for each part, however, then each part should be given its own set of words.
                                % TODO: This does not really do what it needs to. Fix it.
    % \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.stretchability = #10
    % \override VerticalAxisGroup.nonstaff-unrelatedstaff-spacing.stretchability = #30
  }
}
