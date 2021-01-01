(define-module (score-spec)
  #:use-module (staff-spec)
  #:use-module (srfi srfi-1))

(define-public staves '())

(define-public (set-staves! staves-list)
  (set! staves staves-list))

(define-public (staves-voice-prefixes staves-list)
  (append-map staff-spec-all-prefixes staves-list))
