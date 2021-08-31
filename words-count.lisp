(defun valid-char-p (char)
  "Can the char be a part of the word?"
  (not (member char '(#\. #\RIGHT_SINGLE_QUOTATION_MARK
 #\! #\? #\; #\, #\Tab #\Space #\Linefeed #\Page #\Return ))))

(defun next-char (stream-to-peek)
  "See next character in the stream without changing the position"
  (peek-char nil stream-to-peek nil :eof))

(defun skip-invalid-chars (stream-to-read)
  "Skip all characters that can't be a part of the word"
  (loop until (valid-char-p (next-char stream-to-read))
        do (read-char stream-to-read nil :eof)))

(defun read-word (stream-to-read)
  "Returns next word from file-based stream or :eof if stream is empty"
  (let ((the-word nil))
    (if (eql (skip-invalid-chars stream-to-read) :eof)
        (return-from read-word :eof))
    (loop while (and (valid-char-p (next-char stream-to-read))
                     (not (eql (next-char stream-to-read) :eof)))
          do (setf the-word (append the-word (list (read-char stream-to-read nil :eof))))
          finally (return-from read-word (coerce the-word 'string)))))

(defun read-words (file)
  "Returns the (unsorted) vocabulary based on text in file"
  (let ((res nil))
    (with-open-file (stream-to-read file)
      (do ((word (read-word stream-to-read)(read-word stream-to-read)))
          ((or (string= "" word)(eql word :eof)))
          (if (not (member word res :test #'string=))
              (setf res (append res (list word))))))
    (return-from read-words res)))

(defun count-words (file)
  "Calculates the number of distinct words in text file"
  (length (read-words file)))

(defun test-count (file wordnum)
  "Runs integration tests for count-words"
  (if (= wordnum (count-words file))
      (print (format nil "Testcase ~a passed" file))
      (print (format nil "ERROR: Testcase ~a failed! ~d (expected) not equals ~d (actual)"
                     file wordnum (count-words file)))))

(test-count "tests/SimpleLine.txt" 13)
(test-count "tests/Empty.txt" 0)
(test-count "tests/OneLine.txt" 16)
(test-count "tests/emoji.txt" 34)
(test-count "tests/Tigres.txt" 86)
(test-count "tests/FoO.txt" 5)
(test-count "tests/foo.txt" 4)
