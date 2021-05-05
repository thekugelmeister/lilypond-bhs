\version "2.20"

\include "vocal-tkit.ly"

#(use-modules (score-spec))
#(use-modules (srfi srfi-1))

%% New Functions
                                % TODO: Move this to bhs-utils.scm or some other file?
BHSBarSandwich =
#(define-music-function (music) (scheme?)
  (_i "Sandwich the given music between a blank bar line and a closing bar line")
  (if music
   #{{\bar "" #music \bar "|."}#}
   (make-music 'SequentialMusic 'void #t)))

#(set-music-definitions!
  (staves-voice-prefixes staves)
  '("Lyrics")
  '())

#(for-each (lambda (name)
            (module-define! (current-module)
             (string->symbol name) (BHSBarSandwich (get-id name))))
  all-music-names)

                                % TODO: Rename this staff.
                                % TODO: Always having this be a chorus staff is convenient for the BHS usecase, but isn't necessarily the desired option for all cases. For example, with a solo 5th part, it might be nice for the solo line to be a member of its own staff. I think this would require a new outer-most class for score specification that defines what type of staff you want. Even better would be a version of generate-staff-definition for choir-staff-spec objects, so this line would barely change.
TestStaff = << \new ChoirStaff << #(make-simultaneous-music (map generate-staff-definition staves)) >> >>


\tagGroup #'(print play)

\layout {
  \context {
    \Staff
    \override VerticalAxisGroup.remove-empty = ##t
    \override VerticalAxisGroup.remove-first = ##t
  }
}

\score {
  \keepWithTag #'print
  % #(if have-music
  %      #{ << \Chords \TestStaff >> #}
  %      #{ { } #} )
  #(if have-music
       #{ << \TestStaff >> #}
       #{ { } #} )
  \layout { $(if Layout Layout) }
}


%% To avoid note collisions for multiple voices voices on one staff, assign the midi performer to the Voice context.
\score {
  \keepWithTag #'play
  % #(if have-music
  %      #{ << \Chords \TestStaff >> #}
  %      #{ { } #} )
  #(if have-music
       #{ << \TestStaff >> #}
       #{ { } #} )
  \midi {
    \context {
      \Staff
      \remove "Staff_performer"
    }
    \context {
      \Voice
      \consists "Staff_performer"
    }
    % \context {
    %   \ChordNames
    %   midiInstrument = #"voice oohs"
    % }
  }
}
