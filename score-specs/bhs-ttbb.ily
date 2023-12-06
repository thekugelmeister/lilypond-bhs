\include "../score-spec.ily"

%{ voice-specs/bhs-ttbb.ily
 %}
#(begin
    (define tenor-voice (make <voice-spec> #:name "Tenor" #:clef "treble_8"))
    (define lead-voice (make <voice-spec> #:name "Lead" #:clef "treble_8"))
    (define bari-voice (make <voice-spec> #:name "Bari" #:clef "bass"))
    (define bass-voice (make <voice-spec> #:name "Bass" #:clef "bass"))
)

%{ score-specs/bhs-ttbb.ily
 %}
#(begin
    (define upper-staff (make <two-voice-staff-spec> #:name "UpperVoices" #:voice1 tenor-voice #:voice2 lead-voice))
    (define lower-staff (make <two-voice-staff-spec> #:name "LowerVoices" #:voice1 bari-voice #:voice2 bass-voice))
    (set-staves! (list upper-staff lower-staff))
)