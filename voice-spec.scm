(define-module (voice-spec)
  #:use-module (oop goops)
  #:export (<voice-spec>
            voice-spec-name
            voice-spec-clef))

(define-class <voice-spec> ()
  (name #:getter voice-spec-name #:init-keyword #:name)
  (clef #:getter voice-spec-clef #:init-keyword #:clef))

(define-public (make-voice-spec name clef)
  (make <voice-spec> #:name name #:clef clef))
