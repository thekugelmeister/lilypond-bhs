(define-module (staff-spec)
  #:use-module (voice-spec)
  #:use-module (oop goops)
  #:export (staff-spec-name
            staff-spec-all-voice-names
            staff-spec-all-prefixes
            <one-voice-staff-spec>
            <two-voice-staff-spec>
            generate-staff-definition))

(define-class <staff-spec-base> ()
  (name #:getter staff-spec-name #:init-keyword #:name))

(define-method (staff-spec-all-voice-names (s <staff-spec-base>))
  (map (lambda (slot-name)
         (voice-spec-name (slot-ref s slot-name)))
       (map slot-definition-name (class-direct-slots (class-of s)))))

(define-method (staff-spec-all-prefixes (s <staff-spec-base>))
  (cons (staff-spec-name s) (staff-spec-all-voice-names s)))

(define-class <one-voice-staff-spec> (<staff-spec-base>)
  (voice #:init-keyword #:voice))

(define-class <two-voice-staff-spec> (<staff-spec-base>)
  (voice1 #:init-keyword #:voice1)
  (voice2 #:init-keyword #:voice2))

(define-method (generate-staff-definition (s <one-voice-staff-spec>))
  (let ((v (slot-ref s 'voice)))
    #{
      \make-one-voice-vocal-staff
      #(voice-spec-name v)
      #(voice-spec-clef v)
      #}))

(define-method (generate-staff-definition (s <two-voice-staff-spec>))
  (let ((v1 (slot-ref s 'voice1))
        (v2 (slot-ref s 'voice2)))
    #{
      \make-two-voice-vocal-staff
      #(staff-spec-name s)
      #(voice-spec-clef v1)
      #(voice-spec-name v1)
      #(voice-spec-name v2)
      #}))

(define-public (make-one-voice-staff-spec name voice)
  (make <one-voice-staff-spec> #:name name #:voice voice))

(define-public (make-two-voice-staff-spec name voice1 voice2)
  (make <two-voice-staff-spec> #:name name #:voice1 voice1 #:voice2 voice2))
