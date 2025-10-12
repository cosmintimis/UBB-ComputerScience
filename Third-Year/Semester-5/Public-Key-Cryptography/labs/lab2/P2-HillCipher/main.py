# Simple implementation of encoding using Hill Cipher (m=2)
# n = 27, K = ( 11 8   ;  K^-1 = ( 20 8
#               3 7 )               3 16)
# _ a b c d e f g h i j k l m n o p q r s t u v w x y z


alphabet = {
    "_": 0,
    "a": 1,
    "b": 2,
    "c": 3,
    "d": 4,
    "e": 5,
    "f": 6,
    "g": 7,
    "h": 8,
    "i": 9,
    "j": 10,
    "k": 11,
    "l": 12,
    "m": 13,
    "n": 14,
    "o": 15,
    "p": 16,
    "q": 17,
    "r": 18,
    "s": 19,
    "t": 20,
    "u": 21,
    "v": 22,
    "w": 23,
    "x": 24,
    "y": 25,
    "z": 26
}

reverse_alphabet = {v: k for k, v in alphabet.items()}

K = [[11, 8], [3, 7]]
inverseOfK = [[20, 8], [3, 16]]
m = 2
n = 27

# from alphabet to numerical
def convertTextToNumerical(text):
    result = []
    for s in text:
        result.append(alphabet[s])
    return result

# multiply 1x2 with 2x2 matrix only
def multiply_matrices(mat1, mat2, n):
    # Result will be a 1x2 matrix
    result = [
        ((mat1[0] * mat2[0][0]) % n + (mat1[1] * mat2[1][0]) % n) % n,
        ((mat1[0] * mat2[0][1]) % n + (mat1[1] * mat2[1][1]) % n) % n
    ]
    return result


def prepareText(text, K, n):
    numerical = convertTextToNumerical(text.lower())
    if len(numerical) % 2 == 1:
        numerical.append(0)  # padding with extra underscore in case of odd text length
    blocks = [numerical[i:i + 2] for i in range(0, len(numerical), 2)]
    numericalText = []
    for block in blocks:
        res = multiply_matrices(block, K, n)
        numericalText.extend(res)
    return numericalText


def encode(plainText, K, n):
    encodedNumerical = prepareText(plainText, K, n)
    cipherText = []
    for x in encodedNumerical:
        cipherText.append(reverse_alphabet[x])
    return ''.join(cipherText).upper()


def decode(cipherText, inverseOfK, n):
    decodedNumerical = prepareText(cipherText, inverseOfK, n)
    decodedText = []
    for x in decodedNumerical:
        decodedText.append(reverse_alphabet[x])
    return ''.join(decodedText)


if __name__ == '__main__':
   userText = input("Please enter the text to be encoded:")
   cipherText = encode(userText, K, n)
   print("Your encoded plain text is:", cipherText)
   decodedCipherText = decode(cipherText, inverseOfK, n)
   print("Your decoded cipher text is:", decodedCipherText)
