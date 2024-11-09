%{ score-spec.ily
Defines the score specification interface for the bhs-lilypond package. This facilitates easier automatic generation of vocal ensemble score layouts.
This is a wrapper around the vocal toolkit templating functionality packaged with LilyPond.

All score specs should be placed in the score-specs directory. In that directory, create a .ily file with the desired name of the
score specification. At the top of that file, include the following:
  \include "../score-spec.ily"

A valid score specification carries out the following 3 operations:
* Define the set of unique voices that are part of the score.
* Define the set of unique staves that contain the defined voices.
* Set the global staff list to contain the defined staves.

See the default specs for examples.
%}

%{ Scheme imports
    (oop goops): enabling simple class definitions; maybe not very scheme-like but makes my life easy?
    (oop goops describe): adds quick easy debug output of class instances 
%}
#(begin
    (use-modules (oop goops)
                 (oop goops describe)))

%{ Defining voices:

<voice-spec>:
class representing a single voice part, i.e. Tenor or Baritone
    #:name : string name of the voice; defines what will be printed to the left of the first bar of music, so ensure capitalization is correct
        getter method: (voice-spec-name <voice-spec>)
    #:clef : defines the desired clef for the given voice; any valid LilyPond clef string
        getter method: (voice-spec-clef <voice-spec>)
Example instantiation:
    (define tenor-spec (make <voice-spec> #:name "Tenor" #:clef "treble_8"))
%}
#(begin
    (define-class <voice-spec> ()
        (name #:getter voice-spec-name #:init-keyword #:name)
        (clef #:getter voice-spec-clef #:init-keyword #:clef))
)

%{ Defining staves:

<staff-spec-base>:
base class for staff specs
    #:name : string name of the staff; may be useful for identifying staves elsewhere, so provide a useful name (e.g. UpperVoices for treble staff, Solo for solo staff)
        getter method: (staff-spec-name <staff-spec-base>)
Not intended for direct instantiation.

<one-voice-staff-spec>:
specification for a staff with a single voice; inherits from <staff-spec-base>
    #:voice : <voice-spec> defining voice for this staff
        getter method: (staff-spec-voice <one-voice-staff-spec>)
Example instantiation:
    (define soprano-staff (make <one-voice-staff-spec> #:name "Soprano" #:voice soprano-voice))

<two-voice-staff-spec>:
specification for a staff with two voices; inherits from <staff-spec-base>
    NOTE: Only the clef of the upper voice is taken into account when generating a staff using this spec.
    #:voice1 : <voice-spec> defining upper voice for this staff
        getter method: (staff-spec-voice1 <two-voice-staff-spec>)
    #:voice2 : <voice-spec> defining lower voice for this staff
        getter method: (staff-spec-voice2 <two-voice-staff-spec>)
Example instantiation:
    (define upper-staff (make <two-voice-staff-spec> #:name "UpperVoices" #:voice1 tenor-voice #:voice2 lead-voice))

(staff-spec-all-voice-names STAFF_SPEC):
utility method returning a list of all voice names on the given staff

(staff-spec-all-prefixes STAFF_SPEC):
utility method returning a list containing the staff name followed by all voice names on the given staff
    TODO: Why does this method need to exist?
        As far as I have been able to determine, this is only ever called as part of (staves-voice-prefixes), which is either confusingly named or doing too much.
        Why should the staff names need be added as music definitions (i.e. in the template base-tkit.ily)?
        At some point, going to need to come back and test whether that's necessary.

(generate-staff-definition STAFF_SPEC):
uses the staff spec to generate a LilyPond staff, using the music functions defined in the built-in LilyPond vocal-tkit.ly
    TODO: The two-voice version specifies the staff name, while the one-voice version appears to automatically name the staff based on the provided voice. Does this cause any problems?
 %}
#(begin
    (define-class <staff-spec-base> ()
        (name #:getter staff-spec-name #:init-keyword #:name))

    (define-class <one-voice-staff-spec> (<staff-spec-base>)
        (voice #:getter staff-spec-voice #:init-keyword #:voice))

    (define-class <two-voice-staff-spec> (<staff-spec-base>)
        (voice1 #:getter staff-spec-voice1 #:init-keyword #:voice1)
        (voice2 #:getter staff-spec-voice2 #:init-keyword #:voice2))
    
    (define-method (staff-spec-all-voice-names (s <staff-spec-base>))
        (list))

    (define-method (staff-spec-all-voice-names (s <one-voice-staff-spec>))
        (list (voice-spec-name (staff-spec-voice s))))

    (define-method (staff-spec-all-voice-names (s <two-voice-staff-spec>))
        (list (voice-spec-name (staff-spec-voice1 s))
              (voice-spec-name (staff-spec-voice2 s))))

    (define-method (staff-spec-all-prefixes (s <staff-spec-base>))
        (cons (staff-spec-name s) (staff-spec-all-voice-names s)))

    (define-method (generate-staff-definition (s <one-voice-staff-spec>))
        (let ((v (staff-spec-voice s)))
            #{
                \make-one-voice-vocal-staff
                #(voice-spec-name v)
                #(voice-spec-clef v)
                #}))

    (define-method (generate-staff-definition (s <two-voice-staff-spec>))
        (let ((v1 (staff-spec-voice1 s))
              (v2 (staff-spec-voice2 s)))
            #{
                \make-two-voice-vocal-staff
                #(staff-spec-name s)
                #(voice-spec-clef v1)
                #(voice-spec-name v1)
                #(voice-spec-name v2)
                #}))
)

%{ Defining the global staff list:

staves:
global list defining the ordered set of staves to include in the score, from top to bottom. Do not modify directly; use (set-staves!)

(set-staves! STAVES_LIST):
sets the global staff list to be the given list of staves

(staves-voice-prefixes):
returns the names of all staves in the global list and the voices they contain, for defining prefixes as in the LilyPond builtin base-tkit.ily
    NOTE: Need to document somewhere that the names of staves/voices also define the prefixes available for defining music, lyrics, etc.
%}
#(begin
    (define staves '())

    (define (set-staves! staves-list)
        (set! staves staves-list))

    (define (staves-voice-prefixes)
        (append-map staff-spec-all-prefixes staves))
)