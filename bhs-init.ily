\version "2.20"
\include "base-tkit.ly"
#(load "bhs-utils.scm")

                                % TODO: This is probably not worth it, and I should instead be using (load) to import modules, etc.
%% Force lilypond guile to include this directory in its load path
#(set! %load-path (cons (getcwd) %load-path))


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
                                % TODO: This was a useful tool in previous versions, but it crashes horribly right now with some wrong type argument errors. Figure out what's going wrong and whether it's my fault. If so, fix it. If not, re-enable this later.
                                % annotate-spacing = #BHSDebug
  
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
  last-bottom-spacing = 0.50\in
  ragged-last-bottom = ##t

%%% @Section A.1.d
  %% The standard format is three or four systems on the first page, and four or five systems on the other pages.  Use good judgment.  Avoid crowding too many systems on a page.  On the first page, save room above the first system for song title, writers and arrangers.
  %% NOTE: This still seems to be pretty much impossible in LilyPond. The current setting is kind of "good enough". It combines max-systems-per-page with flexible vertical spacing stretchability to make things look good, while hoping that we never hit a scenario where too few systems end up on a page.
                                % min-systems-per-page = 4
  max-systems-per-page = 5
  markup-system-spacing.stretchability = #60
  top-markup-spacing.stretchability = #60
  system-system-spacing.padding = #5

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
                                % TODO: It's not clear to me whether I am interpreting this part of the spec correctly. The examples they give appear to me to be formatted incorrectly, so it's hard to tell.
      \fill-line { \abs-fontsize #12 { \sans \bold \fromproperty-apply #'header:subtitle #(lambda (x) (string-append "(" (string-upcase x) ")"))} }
%%% @Section A.5
      %% If the song is in public domain, center the year it was written in parentheses directly below the title, in 12-point fixed size Arial Bold.
      \fill-line { \abs-fontsize #12 { \sans \bold \fromproperty-apply #'header:date #(lambda (x) (string-append "(" x ")"))} }
%%% @Section A.9
      %% Center under the title any acknowledgment or indication of the group that popularized the arrangement. Use 10-point fixed size Times New Roman Italictype
      \fill-line { \abs-fontsize #10 { \italic \fromproperty #'header:addinfo } }
%%% @Section A.6-8
      %% See documentation for lyricist-composer-arranger in utilities.
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
%%% @Section C.5
    %% NOTE: This section is ommitted from the current version of the spec; it is being assumed that this is accurate based on any other sources and observing the notated example in the spec.
                                % TODO: This section is sometimes way too close to the final staff. Especially true for TagPage layout. Find a way to ensure space is left between them.
    \on-the-fly #last-page
    \generate-perf-notes
    % \column {
    %   \override #'(thickness . 4)
    %   \draw-hline
    %   \vspace #0.5
    %   \bold \italic \abs-fontsize #18 "Performance Notes"
    %   \vspace #0.5
    %   \abs-fontsize #10 {
    %     \override #'(align-dir . -1)
    %     \fromproperties #'header:performancenotes
    %   }
    % }
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
        (let* ((props (ly:grob-properties grob))
               (old-inst-name-markup (ly:grob-property grob 'long-text))
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

%%% @Section B.17
    %% NOTE: This section was left out of the current released version of the spec; it is being assumed that this is accurate based on any other sources and observing the notated example in the spec.
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
    \override BarNumber.break-visibility = #end-of-line-invisible
                                % TODO: This relies on the assumption that the top staff will always be index 0 or 1 in the vertical axis group, and the lower staves will always be of index > 2. Thus far, this assumption has held for all test cases. However, I am uncomfortable with this assumption. Consider robustly checking it, or finding a better way to do it.
    \override BarNumber.stencil = #(grob-transformer 'stencil
                                    (lambda (grob default)
                                     (if (member (ly:grob-get-vertical-axis-group-index grob) '(0 1))
                                      default
                                      #f)))
    \override BarNumber.extra-spacing-width = #'(0 . 1)
    %% NOTE: For the following to work, it requires forcibly adding a blank bar in front of the music, so that LilyPond figures out there's a bar there in the first place. This is handled elsewhere in this template.
    barNumberVisibility = #first-bar-number-visible-and-no-parenthesized-bar-numbers
    \override BarNumber.self-alignment-X = #LEFT
    \override BarNumber.break-align-symbols = #'(time-signature key-signature)
    \override BarNumber.avoid-slur = #'inside
    \override BarNumber.outside-staff-priority = ##f
%%% @Section A.12.b
    %% For the first measure, or any measure with a key signature and/or meter signature, place the number of the measure above the treble staff immediately after the meter signature.
    \override TimeSignature.break-align-anchor-alignment = #RIGHT
%%% @Section A.12.c
    %% Use 10-point regular fixed size Times New Roman type for all measure numbers.
                                % TODO: Implement this spec
                                % \override BarNumber.font-size = \absFontSize #10
%%% @Section A.12.d
    %% If the last measure of a system must be split to start a new section on the next system with a pickup note(s), take care not to assign a measure number to the pickup portion of the split measure.
                                % TODO: Implement this spec; this might be the automatic functionality, but this needs verification.

                                % TODO: I personally don't like it when it removes the empty staves, but I can see arguments for having it. Make a decision later.
                                % \RemoveAllEmptyStaves
%%% @Section B.8.c
    %% Use courtesy accidentals, which are given in parentheses, only if the first note of a given measure is a chromatic version of the last note in the preceding measure in the same part.
                                % TODO: modern-voice-cautionary is close, but includes extra marks (which are cautionary, at least) for chromatic versions of previous notes that are further than one note away. IMO, this is actually better, but it's not what the spec says. I'm leaving it for now.
    \accidentalStyle modern-voice-cautionary

%%% @Section A.1.d (continued)
    %% NOTE: See previous explanation; this is part of the vertical spacing stretchability portion of the current solution.
    \override VerticalAxisGroup.staff-staff-spacing.stretchability = #120
  }
  \context {
    \Lyrics
%%% @Section C.4
    %% Lyrics centered between staves when only one lyric line is present.
    %% NOTE: This section is ommitted from the current version of the spec; it is being assumed that this is accurate based on any other sources and observing the notated example in the spec.
    \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.stretchability = #10
    \override VerticalAxisGroup.nonstaff-unrelatedstaff-spacing.stretchability = #30
  }
}
