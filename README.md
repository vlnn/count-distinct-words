# Create vocabulary for file using LISP

"... count the number of unique distinct words in the file and returns this number."

## Three general approaches: 

* to read whole file in memory and then remove duplicates (good for small files that fit into the memory together with the vocabulary. It needs at least twice as much memory available as the file size itself to cover corner case of file having only unique words in it).
* to read file word by word and add only new words to the vocabulary (slow but reliable for big files).
* to read file line-by-line and read through every line (big files having only one line will make it same as 1st solution).

## Things to consider:

* How different are the words `WoRd` and `worD`? Depends on the context (e.g. is it classic english, modern english taken from chat messages, or Pascal source code).
* What delimiters are being used in the file? Set of sane defaults may be one solution, that could be extended with optional arguments.
* Are word wrap rules supported? I.e. is `Some-#Linefeed-word` one word `Some-word` or two different words?
* Are the `__word__` or `|` (pipe symbol) really words in this context (which is useful for code but not so much for natural languages).

## Implementation details:

* File is read word by word (second of *Three general approaches*)
* Words are defined by the inversion of delimiters in separate function 'valid-char-p' so the list can be expanded (this is also the reason not to rely on non-graphic-char-p as whitespaces).
* Case sensitive (see different results for `tests\foo.txt` and `tests\FoO.txt`).
* UTF-8 seems to be working (e.g. check `(read-words "tests\emoji.txt"))`.
* Dots in abbreviations are splitting it to different "words" (e.g. `e.g.` becomes `e`,`g`).
* Plurals are different from singulars (e.g. file with "`word words`" provide 2 as a result).

## Usage:

``` sh
sbcl --script words-count.lisp
```
will output results for some test files stored in `.\tests\` directory. Change the paths in tests calls in `words-count.lisp` in order to run with your text files.
