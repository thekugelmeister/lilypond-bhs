\version "2.20"

\include "voice-specs/satb.ily"
#(use-modules (staff-spec))
#(use-modules (score-spec))

#(define soprano-staff (make-one-voice-staff-spec "Soprano" soprano-spec))
#(define alto-staff (make-one-voice-staff-spec "Alto" alto-spec))
#(define tenor-staff (make-one-voice-staff-spec "Tenor" tenor-spec))
#(define bass-staff (make-one-voice-staff-spec "Bass" bass-spec))
#(set-staves! (list soprano-staff alto-staff tenor-staff bass-staff))
