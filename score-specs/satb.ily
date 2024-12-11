\include "../score-spec.ily"

% Define voices
#(begin
    (define soprano-voice (make <voice-spec> #:name "Soprano" #:clef "treble"))
    (define alto-voice (make <voice-spec> #:name "Alto" #:clef "treble"))
    (define tenor-voice (make <voice-spec> #:name "Tenor" #:clef "treble_8"))
    (define bass-voice (make <voice-spec> #:name "Bass" #:clef "bass"))
)

% Assign voices to staves
#(begin
    (define soprano-staff (make <one-voice-staff-spec> #:name "Soprano" #:voice soprano-voice))
    (define alto-staff (make <one-voice-staff-spec> #:name "Alto" #:voice alto-voice))
    (define tenor-staff (make <one-voice-staff-spec> #:name "Tenor" #:voice tenor-voice))
    (define bass-staff (make <one-voice-staff-spec> #:name "Bass" #:voice bass-voice))
)

% Set the global staff list
#(set-staves! (list soprano-staff alto-staff tenor-staff bass-staff))