\version "2.20"

\include "voice-specs/voice-spec.ily"
\include "vocal-tkit.ly"

#(use-modules (srfi srfi-1))
#(use-modules (srfi srfi-9))

#(define-record-type <staff-spec>
  (make-staff-spec name voices)
  staff-spec?
  (name    staff-spec-name)
  (voices  staff-spec-voices))

#(define (staff-spec-all-voice-names staff-spec)
  (map (lambda (voice-spec) (voice-spec-name voice-spec)) (staff-spec-voices staff-spec)))

#(define (staves-all-voice-names staves-list)
  (newline)
  (display "------------------------\n")
  (display "staff-spec.ily\n")
  (display staves)
  (newline)
  (newline)
  (display (map staff-spec? staves))
  (newline)
  (append-map staff-spec-all-voice-names staves-list))

#(define (staves-voice-prefixes staves-list)
  (append (staves-all-voice-names staves-list) (map staff-spec-name staves-list)))

#(define (generate-staff-definition staff-spec)
  (case (length (staff-spec-voices staff-spec))
   ((1) (let ((voice-spec (car (staff-spec-voices staff-spec))))
         #{
         \make-one-voice-vocal-staff
         #(voice-spec-name voice-spec)
         #(voice-spec-clef voice-spec)
         #}
        ))
   ((2) (let ((voice1-spec (car (staff-spec-voices staff-spec)))
              (voice2-spec (cadr (staff-spec-voices staff-spec))))
         #{
         \make-two-voice-vocal-staff
         #(staff-spec-name staff-spec)
         #(voice-spec-clef voice1-spec)
         #(voice-spec-name voice1-spec)
         #(voice-spec-name voice2-spec)
         #}
        ))
   (else (error "generate-staff-definition: Invalid number of voices:" staff-spec)))
)
