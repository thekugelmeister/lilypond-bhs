\version "2.20"
\include "festival.ly"
\include "vocal-tkit.ly"
#(use-modules (score-spec))
#(use-modules (ice-9 format))

                                % TODO: sox crashes when only one voice part provided.
                                % TODO: Make FestivalHalfTempo work automatically, instead of requiring user to change tempo globally.
                                % TODO: Should FestivalOctaveDown and FestivalHalfTempo be mutually exclusive options?

%{
FestivalOctaveDown must be used if any part hits a note over 500 Hz (B5 by Festival standards, B4 by most other standards).
This is due to a bug in Festival, in "festival/src/modules/UniSyn/us_prosody.cc" (I am virtually certain). In the
function "f0_to_pitchmarks", there is a hard-coded limit of 500 when checking the frequency track, which attempts to
re-assign any offending frequencies to the frequency of the previous element of the array, without bounds checking.
This is why Festival reproducibly segfaults if the first note is B5 or higher, but changes later too-high notes to B5
and works at other times.

See "speech_tools/sigpr/pda/srpd.h" for more evidence (more hard-coded limits, albeit at different magnitudes).
%}
#(define festival-variable-names
  ;; User-defined options (boolean)
  '("FestivalSyllabify"
    "FestivalOctaveDown"
    "FestivalHalfTempo"
    "FestivalNoCleanup"))

#(define-missing-variables! festival-variable-names)

#(set-music-definitions!
  (staves-voice-prefixes staves)
  '("FestivalLyrics")
  '())

#(define festival-voices (filter (lambda (vp)
                                  (and
                                   (make-id vp "Music")
                                   (make-id vp "FestivalLyrics")))
                          voice-prefixes))


%% \festivalsylslow #"filename" { \tempo N = X } { music }
%% Standard festival output, adjusted to half speed (1 octave down, half as fast) and syllabified if desired.
festivalsylslow =
#(define-music-function
  (filename tempo music)
  (string? ly:music? ly:music?)
  (let ((octave-shift (if FestivalOctaveDown -1 0)))
   (parameterize ((*syllabify* FestivalSyllabify)
                )
    (output-file music tempo filename)))
  music)
                                % (*base-octave-shift* octave-shift)

%% Make a single festival book (to output festival xml file) and run festival on output
festivalsylslow-voicebook =
#(define-void-function
  (voicename)
  (voice-prefix?)
  #{
  \score {
  \festivalsylslow #(string-append voicename ".xml") { \Time } {
    \make-one-voice-vocal-staff #voicename "treble"
  }
}
  #}
(format #t "\nProcessing Festival XML file ~a.xml..."
voicename)
(system (format #f "text2wave -mode singing ~a.xml -o ~a.wav" 
voicename
voicename)))

%% Clean up after festival processing for a single voice
festival-voicecleanup =
#(define-void-function
  (voicename)
  (voice-prefix?)
  (system (format #f "rm ~a.xml ~a.wav"
           voicename
           voicename)))

                                % TODO: The logic for which version of output is kind of flawed. Revisit this.
#(define festival-allvoices-filespec "allvoices")
#(define festival-output-name (ly:parser-output-name))
BHSFestival =
#(define-void-function
  ()
  ()
  (cond
   ((null? festival-voices)
    (display "\nNo FestivalLyrics available; skipping Festival output"))
   (else
    (format #t "\nRunning Festival for the following voices: ~a" festival-voices)
    (map festivalsylslow-voicebook festival-voices)
    (display "\nCombining parts...")
    (cond
     ((> (length festival-voices) 1)
      (system (format #f "sox -m ~{~a.wav ~} ~a.wav"
               festival-voices
               festival-allvoices-filespec)))
     (else
      (system (format #f "mv ~a.wav ~a.wav"
               (car festival-voices)
               festival-allvoices-filespec))))
    (display "\nFinalizing output...")
    (cond
     (FestivalOctaveDown
      (display "Correcting speed...")
      (system (format #f "sox ~a.wav ~a.wav speed 2"
               festival-allvoices-filespec
               festival-output-name)))
     (FestivalHalfTempo
      (display "Correcting tempo...")
      (system (format #f "sox ~a.wav ~a.wav tempo 2"
               festival-allvoices-filespec
               festival-output-name)))
     (else
      (system (format #f "mv ~a.wav ~a.wav"
               festival-allvoices-filespec
               festival-output-name))))
    (cond
     ((not FestivalNoCleanup)
      (display "\nCleaning up after Festival processing...\n")
      (map festival-voicecleanup festival-voices))))))
