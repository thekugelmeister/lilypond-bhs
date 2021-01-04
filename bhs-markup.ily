%{
Copyright 2018 Jeremy Marcus
This is distributed under the terms of the GNU General Public License.

This file is part of LilyPond Barbershop Template.

LilyPond Barbershop Template is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LilyPond Barbershop Template is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with LilyPond Barbershop Template.  If not, see <http://www.gnu.org/licenses/>.
%}

contestSuitability = \markup {
  \wordwrap {
    As a final note: Questions about the contest suitability of this song/arrangement should be directed to the judging community and measured against current contest rules. Ask \italic before you sing.
  }
}

%% voiceCross: Add a voice crossing mark to a note ('x' placed above it).
voiceCross=#(define-event-function () ()
             #{
             ^\markup { \abs-fontsize #10 { \override #'(font-name . "Arial") x } }
             #}
           )

%% voiceCrosses: Mark the given set notes as crossed.
voiceCrosses =
#(define-music-function
  (parser location music)
  (ly:music?)
  (map-some-music voiceCross music)
)


%% newSection: Demarcate new section with a double bar line and a label
newSection =
#(define-music-function
  (parser location text)
  (markup?)
  #{
  \bar "||" \mark \markup { \abs-fontsize #12 { \override #'(font-name . "Times Bold") #text } }
  #}
)

%% http://lsr.di.unimi.it/LSR/Item?id=538
%% optionalNotes: Given a chord, makes the first note normal size and the remaining notes a smaller size.
optionalNotes =
#(define-music-function (parser location x) (ly:music?)
  (music-map (lambda (x)
              (if (eq? (ly:music-property x 'name) 'EventChord)
               (let ((copy (ly:music-deep-copy x)))
                (let ((elements (cdr (ly:music-property copy 'elements))))
                 (while (pair? elements)
                  (ly:music-set-property! (first elements) 'tweaks
                   (acons 'font-size -3 (ly:music-property (car elements)
                                         'tweaks)))
                  (set! elements (cdr elements))))
                copy) x))
   x))

%% skips: Insert a given number of lyric skips
skips =
#(define-music-function
  (parser location nskips)
  (integer?)
  "From http://lilypond.1069038.n5.nabble.com/Add-lyrics-after-n-measures-td165881.html.
Insert a given number of lyric skips, accounting appropriately for terminating lyric extenders."
  (if (= nskips 1)
   #{ 
  \lyricmode {
   ""
 }
   #}
   #{ 
   \lyricmode {
   ""
   \repeat unfold $(- nskips 1) { \skip 1 }
 }
   #}
 ))

%% adapted from http://lsr.di.unimi.it/LSR/Snippet?id=961
%% melodyTransfer: Indicate a melody transfer between voices.
%% Usage: -\markup { \melodyTransfer #angle #length #xoffset yoffset }
%%% @Section B.10
#(define-markup-command (melodyTransfer layout props angle length xoffset yoffset) 
  (number? number? number? number?)
  (interpret-markup layout props
   #{
   \markup {
   \with-dimensions #'(0 . 0) #'(0 . 0)
   \translate #(cons xoffset yoffset)
   \rotate #angle
   \with-dimensions #'(0 . 0) #'(0 . 0)
   \translate #(cons 0 (- 0 length))
   \draw-dashed-line #(cons 0 length)
 }
   #}))
