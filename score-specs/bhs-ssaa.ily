\version "2.20"

\include "voice-specs/bhs-ssaa.ily"
#(use-modules (staff-spec))
#(use-modules (score-spec))

#(define upper-staff (make-two-voice-staff-spec "UpperVoices" tenor-spec lead-spec))
#(define lower-staff (make-two-voice-staff-spec "LowerVoices" bari-spec bass-spec))
#(set-staves! (list upper-staff lower-staff))
