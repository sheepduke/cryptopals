(in-package cryptopals)

;;;; There's a file here. It's been base64'd after being encrypted with
;;;; repeating-key XOR.
;;;; 
;;;; Decrypt it.
;;;; 
;;;; Here's how:
;;;; 
;;;;     1. Let KEYSIZE be the guessed length of the key; try values from 2 to
;;;;     (say) 40.
;;;;
;;;;     2. Write a function to compute the edit distance/Hamming distance
;;;;     between two strings. The Hamming distance is just the number of
;;;;     differing bits. The distance between:
;;;; 
;;;;     "this is a test"
;;;; 
;;;;     and
;;;; 
;;;;     "wokka wokka!!!"
;;;; 
;;;;     is 37.
;;;;
;;;;     Make sure your code agrees before you proceed.
;;;;     
;;;;     3. For each KEYSIZE, take the first KEYSIZE worth of bytes, and the
;;;;     second KEYSIZE worth of bytes, and find the edit distance between
;;;;     them. Normalize this result by dividing by KEYSIZE.
;;;;     
;;;;     4. The KEYSIZE with the smallest normalized edit distance is probably
;;;;     the key. You could proceed perhaps with the smallest 2-3 KEYSIZE
;;;;     values. Or take 4 KEYSIZE blocks instead of 2 and average the
;;;;     distances.
;;;;     
;;;;     5. Now that you probably know the KEYSIZE: break the ciphertext into
;;;;     blocks of KEYSIZE length.
;;;;     
;;;;     6. Now transpose the blocks: make a block that is the first byte of
;;;;     every block, and a block that is the second byte of every block, and
;;;;     so on.
;;;;     
;;;;     7. Solve each block as if it was single-character XOR. You already
;;;;     have code to do this.
;;;;     
;;;;     8. For each block, the single-byte XOR key that produces the best
;;;;     looking histogram is the repeating-key XOR key byte for that
;;;;     block. Put them together and you have the key.
;;;; 
;;;; This code is going to turn out to be surprisingly useful later
;;;; on. Breaking repeating-key XOR ("Vigenere") statistically is obviously an
;;;; academic exercise, a "Crypto 101" thing. But more people "know how" to
;;;; break it than can actually break it, and a similar technique breaks
;;;; something much more important.

(defun normalized-edit-distance (str keysize)
  "Calculate the edit distance of STR. Take the first KEYSIZE length of string
and calculate the normalized hamming distance."
  (assert (>= (length str) (* keysize 2)))
  (let ((first-substr (subseq str 0 keysize))
        (second-substr (subseq str keysize (* keysize 2))))
    (rem (hamming-distance first-substr second-substr) keysize)))

(defun hamming-distance (str1 str2)
  "Calculate the hamming distance of STR1 and STR2. Hamming distance here
refers to the difference of bits in binary form."
  (-<>> (mapcar (lambda (x y)
                  (count-one-bits (logxor x y)))
                (map 'list #'char-code str1)
                (map 'list #'char-code str2))
        (reduce #'+)))

(defun count-one-bits (number)
  "Given an integer, count how many 1 bits are there in its binary form."
  (iter
    (with result = 0)
    (while (> number 0))
    (when (= (logand number 1) 1)
      (incf result))
    (setf number (ash number -1))
    (finally (return result))))

;; (base64:base64-string-to-usb8-array
;;  (read-file-into-string #P"~/projects/lisp/cryptopals/resources/1-6.txt"))
