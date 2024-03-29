(in-package :cryptopals/tests)

(deftest test-hex-string-to-base64
  (let ((hex "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"))
    (ok (string-equal (hex-string-to-base64 hex)
                      "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"))))

(deftest test-fixed-xor
  (let ((buffer1 "1c0111001f010100061a024b53535009181c")
        (buffer2 "686974207468652062756c6c277320657965")
        (result "746865206b696420646f6e277420706c6179"))
    (ok (string-equal (fixed-xor buffer1 buffer2) result))))

(deftest test-crack-single-byte-xor-cipher
  (let ((cipher "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736")
        (message "Cooking MC's like a pound of bacon"))
    (ok (string-equal (crack-single-byte-xor-cipher cipher) message))))

(deftest test-string-xor-repeating-key
  (let ((raw-string "Burning 'em, if you ain't quick and nimble
I go crazy when I hear a cymbal")
        (cipher "ICE"))
    (ok (string= (string-xor-repeating-key raw-string cipher)
                 "0B3637272A2B2E63622C2E69692A23693A2A3C6324202D623D63343C2A26226324272765272A282B2F20430A652E2C652A3124333A653E2B2027630C692B20283165286326302E27282F"))))

(deftest test-hamming-distance ()
  (let ((str1 "this is a test")
        (str2 "wokka wokka!!!"))
    (ok (= (hamming-distance str1 str2) 37))))
