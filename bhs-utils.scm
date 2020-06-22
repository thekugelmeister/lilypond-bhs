(ly:load "define-markup-commands.scm")

(define (zip-flatten a b)
  (reduce-right append! '() (zip a b)))

(define-markup-command (fromproperties layout props symbol)
  (symbol?)
  #:category other
  #:properties ((align-dir #f)
                (word-space)
                (baseline-skip)
                (paragraph-spaces 1))
  "Modified from https://lists.gnu.org/archive/html/lilypond-user/2014-02/msg00657.html (by Thomas Morley)
- Adding vspace to get around bugs with vertical spacing of wordwrapped text in columns
Read the @var{symbol} from property settings, and produce a stencil
from the markup or markuplist contained within.
If @var{align-dir} is set @code{#f} the stencil is one line.  Setting
@var{align-dir} to a number will output a column, vertically aligned according
to @var{align-dir}.
Interleaves the elements of a given markuplist with vspaces of size @var{paragraph-spaces}.
If @var{symbol} is not defined, it returns an empty markup.
"
  (let ((m (chain-assoc-get symbol props))
        ;; prevent infinite loops by clearing the interpreted property:
        (new-props
         (cons (list (cons symbol `(,property-recursive-markup ,symbol)))
               props)))
    (cond
     ((markup? m)
      (interpret-markup layout new-props m))
     ((markup-list? m)
      (let* ((spaced_m (zip-flatten m (make-list (length m) (markup #:vspace paragraph-spaces))))
             (stencils (interpret-markup-list layout new-props spaced_m)))
        (cond
         (align-dir (general-column align-dir baseline-skip stencils))
         (else (stack-stencil-line word-space stencils)))))
     (else empty-stencil))))

(define-markup-command (fromproperty-apply layout props symbol proc)
  (symbol? procedure?)
  "Identical to fromproperty, but applies the given scheme procedure to the markup prior to interpretation."
  (let ((m (chain-assoc-get symbol props)))
    (if (markup? m)
        ;; prevent infinite loops by clearing the interpreted property:
        (interpret-markup layout (cons (list (cons symbol `(,property-recursive-markup ,symbol))) props)
                          (proc m))
        empty-stencil)))

(define-public (first-bar-number-visible-and-no-parenthesized-bar-numbers barnum mp)
  "Enables display of first measure bar number and suppresses parenthesization of bar numbers for partial measures."
  (= (ly:moment-main-numerator mp) 0))

(define default-lyricist-composer-arranger "UNKNOWN")

(define-markup-command (lyricist-composer-arranger layout props)
  ()
  "
TODO: I'm pretty sure that this relies on the user only setting these header variables as strings, not as other valid markups. This is undesirable. Refactor to allow arbitrary markup if possible.

This function is designed to provide the logic for displaying the lyricist, composer, and arranger name sections correctly based on their inclusion in the header block. See sections A.6-8 in the BHS Notation Manual for further documentation.

This information is displayed on a maximum of two lines, each with a left-aligned component and a right-aligned component, making a total of four 'quadrants' to fill.

Taking 'unset' variables into account leads to redundancy in the mapping for no good reason. Therefore, the mappings are defined assuming that any unset variables are already set to the placeholder 'UNKNOWN' value. This leaves us with only five cases to consider:
  0: All three are the same (@Section A.8.b)
  1: Lyricist and Composer are the same (@Section A.7.a)
  2: Lyricist and Arranger are the same (NOT COVERED IN SPEC)
  3: Composer and Arranger are the same (NOT COVERED IN SPEC)
  4: All three are different (@Sections A.6, A.7.b, A.8.a)
NOTE: Some of these cases are not explicitly covered in the manual, so I made educated guesses...
"
  (let* ((lyricist (string-upcase (chain-assoc-get 'header:lyricist props default-lyricist-composer-arranger)))
         (composer (string-upcase (chain-assoc-get 'header:composer props default-lyricist-composer-arranger)))
         (arranger (string-upcase (chain-assoc-get 'header:arranger props default-lyricist-composer-arranger)))
         (lyco (string-ci= lyricist composer))
         (lyar (string-ci= lyricist arranger))
         (coar (string-ci= composer arranger)))
    (cond
     ((and lyco coar)
      (interpret-markup layout props #{ \markup \column {
                                                 \fill-line { \null "Words, Music, and Arrangement by" }
                                                 \fill-line { \null #lyricist }
                                                 }
                                        #}))
     (lyco
      (interpret-markup layout props #{ \markup {
                                                 \fill-line { #(string-append "Words and Music by " lyricist) #(string-append "Arrangement by " arranger) }
                                                 }
                                        #}))
     (lyar
      (interpret-markup layout props #{ \markup {
                                                 \fill-line { #(string-append "Music by " composer) #(string-append "Words and Arrangement by " lyricist) }
                                                 }
                                        #}))
     (coar
      (interpret-markup layout props #{ \markup {
                                                 \fill-line { #(string-append "Words by " lyricist) #(string-append "Music and Arrangement by " composer) }
                                                 }
                                        #}))
     (else
      (interpret-markup layout props #{ \markup \column {
                                                 \fill-line { #(string-append "Words by " lyricist) #(string-append "Music by " composer) }
                                                 \fill-line { \null #(string-append "Arrangement by " arranger) }
                                                 }
                                        #})))))
