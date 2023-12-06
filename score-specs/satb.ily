\include "../score-spec.ily"

%{ voice-specs/bhs-ttbb.ily
 %}
#(begin
    (define soprano-voice (make <voice-spec> #:name "Soprano" #:clef "treble"))
    (define alto-voice (make <voice-spec> #:name "Alto" #:clef "treble"))
    (define tenor-voice (make <voice-spec> #:name "Tenor" #:clef "treble_8"))
    (define bass-voice (make <voice-spec> #:name "Bass" #:clef "bass"))
)

%{ score-specs/bhs-ttbb.ily
 %}
#(begin
    (define soprano-staff (make <one-voice-staff-spec> #:name "Soprano" #:voice soprano-voice))
    (define alto-staff (make <one-voice-staff-spec> #:name "Soprano" #:voice alto-voice))
    (define tenor-staff (make <one-voice-staff-spec> #:name "Soprano" #:voice tenor-voice))
    (define bass-staff (make <one-voice-staff-spec> #:name "Soprano" #:voice bass-voice))
    (set-staves! (list soprano-staff alto-staff tenor-staff bass-staff))
)