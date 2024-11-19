\include "../score-spec.ily"

% Define voices
#(begin
    (define tenor-voice (make <voice-spec> #:name "Tenor" #:clef "treble"))
    (define lead-voice (make <voice-spec> #:name "Lead" #:clef "treble"))
    (define bari-voice (make <voice-spec> #:name "Bari" #:clef "bass^8"))
    (define bass-voice (make <voice-spec> #:name "Bass" #:clef "bass^8"))
)

% Assign voices to staves
#(begin
    (define upper-staff (make <two-voice-staff-spec> #:name "UpperVoices" #:voice1 tenor-voice #:voice2 lead-voice))
    (define lower-staff (make <two-voice-staff-spec> #:name "LowerVoices" #:voice1 bari-voice #:voice2 bass-voice))
)

% Set the global staff list
#(set-staves! (list upper-staff lower-staff))