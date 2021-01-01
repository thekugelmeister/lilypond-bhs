\version "2.20"

%% TODO: these may be more sensibly (re)defined as a scm file

#(use-modules (srfi srfi-9))

#(define-record-type <voice-spec>
  (make-voice-spec name clef)
  voice-spec?
  (name    voice-spec-name)
  (clef    voice-spec-clef))
