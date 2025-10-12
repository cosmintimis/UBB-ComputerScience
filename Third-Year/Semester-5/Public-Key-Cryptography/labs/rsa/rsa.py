# Library functions for prime
from sympy import primerange, nextprime
from random import randint


def gcd_euclidean(a, b):
    while b != 0:
        a, b = b, a % b
    return a


def modular_exponentiation(a, k, n):
    result = 1
    base = a % n
    while k > 0:
        if k % 2 == 1:  # If k is odd, multiply the result by base
            result = (result * base) % n
        base = (base * base) % n  # Square the base
        k //= 2  # Divide k by 2
    return result


def modular_inverse(a, m):
    # Initial values
    m0, x0, x1 = m, 0, 1

    # If a and m are not coprime, the modular inverse does not exist
    if gcd_euclidean(a, m) != 1:
        return None  # Modular inverse does not exist

    # Extended Euclidean Algorithm
    while a > 1:
        # q is the quotient
        q = a // m
        # Update m and a
        m, a = a % m, m
        # Update x0 and x1
        x0, x1 = x1 - q * x0, x0

    # Make x1 positive
    if x1 < 0:
        x1 += m0

    return x1


# 1. Key generation. Alice creates a public key and a private key.
#  1.1. Generates 2 random large distinct primes p,q of
#  approximately same size.
#  1.2. Computes n = pq and φ(n) = (p −1)(q −1) (the Euler
#  function).
#  1.3. Randomly selects 1 < e < φ(n) with gcd(e,φ(n)) = 1.
#  1.4. Computes d = e^−1 mod φ(n).
#  1.5. Alice’s public key is KE = (n,e); her private key is KD = d.
def key_generation(a, b):
    list_of_primes = list(primerange(a, b))
    p = q = 0
    if len(list_of_primes) >= 2:
        p = list_of_primes[0]
        q = list_of_primes[1]
    elif len(list_of_primes) == 1:
        p = list_of_primes[0]
        q = nextprime(p)
    else:
        p = nextprime(a)
        q = nextprime(p)
    p = 37
    q = 41
    print("Prime p: " + str(p))
    print("Prime q: " + str(q))
    n = p * q
    print("The product of p * q - n: " + str(n))
    euler_fct = (p - 1) * (q - 1)
    print("Euler Function = (p-1)*(q-1) - euler_fct: " + str(euler_fct))
    # e = randint(1, euler_fct)
    # while gcd_euclidean(e, euler_fct) != 1:
    #     e = randint(1, euler_fct)
    e = 3
    while gcd_euclidean(e, euler_fct) != 1:
        e = nextprime(e)
    # e = 67
    print("Encryption exponent - e: " + str(e))
    d = modular_inverse(e, euler_fct)
    print("Decryption exponent - d: " + str(d))
    ke = (n, e)
    print("Public Key - Ke: " + str(ke))
    kd = d
    print("Private Key - Kd: " + str(kd))
    return ke, kd


def split_text(text, n):
    return [text[i:i + n] for i in range(0, len(text), n)]


def to_base_coefficients(c, base):
    number = c.copy()
    coefficients = []
    if number[0] > 0:
        while number[0] > 0:
            remainder = number[0] % base  # Get the coefficient for the current position
            coefficients.insert(0, remainder)  # Insert the coefficient at the beginning
            number[0] //= base  # Update number by integer division with the base
    else:
        while number[1] > 1:
            coefficients.insert(0, 0)
            number[1] -= 1
    return coefficients


# 2. Encryption. Bob sends an encrypted message to Alice.
#  2.1. Gets Alice’s public key Ke = (n,e).
#  2.2. Represents the message as a number m between 0 and n − 1.
#  2.3. Computes c = m^e mod n.
#  2.4. Sends the ciphertext c to Alice
def encrypt(public_key, message, k, alphabet):
    n, e = public_key
    l = len(alphabet)
    print("Alphabet length - l: " + str(l))

    print("Starting Encryption...")

    splited_text = split_text(message, k)
    while len(splited_text[-1]) < k:
        splited_text[-1] += '_'
    print("splited_text: " + str(splited_text))

    print("The numerical equivalents:")
    numerical_equivalents_keys = []
    numerical_equivalents_values = []

    for group in splited_text:
        len_group = len(group)
        numerical_equivalents_int = 0
        for_console = ""
        zero_count = 0
        for letter in group:
            numerical_equivalents_int += alphabet[letter] * pow(l, len_group - 1)
            if alphabet[letter] * pow(l, len_group - 1) == 0:
                zero_count += 1
            len_group -= 1
            for_console += str(alphabet[letter]) + " * " + str(l) + " ^ " + str(len_group) + " + "
        for_console = for_console.removesuffix(" + ")
        for_console += " = " + str(numerical_equivalents_int)
        print(group + " => " + for_console)
        numerical_equivalents_keys.append([numerical_equivalents_int, zero_count])
        numerical_equivalents_values.append(group)

    cs = []
    for m in numerical_equivalents_keys:
        cs.append([modular_exponentiation(m[0], e, n), m[1]])

    print("Encrypt c = (m^e mod n): " + str(cs))

    print("Write the literal equivalents:")
    literal_equivalents_keys = []
    literal_equivalents_values = []

    for c in cs:
        literal_equivalents_str = ""
        for_console = ""
        base_coefficients = to_base_coefficients(c, l)
        len_coef = len(base_coefficients)
        # print(base_coefficients)
        for encrypted_letter_index in base_coefficients:
            literal_equivalents_str += (chr(64 + encrypted_letter_index)) if encrypted_letter_index != 0 else "_"
            len_coef -= 1
            for_console += str(encrypted_letter_index) + " * " + str(l) + " ^ " + str(len_coef) + " + "
        while len(literal_equivalents_str) < 3:
            literal_equivalents_str = "_" + literal_equivalents_str
        for_console = for_console.removesuffix(" + ")
        for_console += " => " + literal_equivalents_str
        output = str(c[0]) + " = " + for_console
        print(output)
        literal_equivalents_keys.append(c)
        literal_equivalents_values.append(literal_equivalents_str)

    encrypted_buff = ""
    for encrypted_group in literal_equivalents_values:
        encrypted_buff += encrypted_group

    return encrypted_buff


# 3. Decryption. Alice decrypts the message from Bob.
#  3.1 Alice uses the private key KD = d to get the message
#  m = c^d mod n.
def decrypt(public_key, private_key, cipher_text, i, alphabet):
    print("Starting Decryption...")

    n = public_key[0]
    d = private_key
    splited_text = split_text(cipher_text, i)
    print("splited_text: " + str(splited_text))

    print("The numerical equivalents:")
    numerical_equivalents_keys = []
    numerical_equivalents_values = []

    for group in splited_text:
        len_group = len(group)
        numerical_equivalents_int = 0
        for_console = ""
        zero_count = 0
        for letter in group:
            numerical_equivalents_int += alphabet[letter] * pow(l, len_group - 1)
            if alphabet[letter] * pow(l, len_group - 1) == 0:
                zero_count += 1
            len_group -= 1
            for_console += str(alphabet[letter]) + " * " + str(l) + " ^ " + str(len_group) + " + "
        for_console = for_console.removesuffix(" + ")
        for_console += " = " + str(numerical_equivalents_int)
        print(group + " => " + for_console)
        numerical_equivalents_keys.append([numerical_equivalents_int, zero_count])
        numerical_equivalents_values.append(group)

    ms = []
    for c in numerical_equivalents_keys:
        ms.append([modular_exponentiation(c[0], d, n), c[1]])

    print("Decryption m = (c^d mod n): " + str(ms))

    print("Write the literal equivalents:")
    literal_equivalents_keys = []
    literal_equivalents_values = []

    cont = 1
    for m in ms:
        literal_equivalents_str = ""
        for_console = ""
        base_coefficients = to_base_coefficients(m, l)
        len_coef = len(base_coefficients)
        # print(base_coefficients)
        for decrypted_letter_index in base_coefficients:
            literal_equivalents_str += (chr(64 + decrypted_letter_index)) if decrypted_letter_index != 0 else "_"
            len_coef -= 1
            for_console += str(decrypted_letter_index) + " * " + str(l) + " ^ " + str(len_coef) + " + "
        if m[0] == 0:
            pass
        elif m[0] < 27:
            literal_equivalents_str = "_" + literal_equivalents_str
        # else:
        #     literal_equivalents_str = literal_equivalents_str.removesuffix(" ")
        for_console = for_console.removesuffix(" + ")
        literal_equivalents_str = literal_equivalents_str.lower()
        for_console += " => " + literal_equivalents_str
        output = str(m[0]) + " = " + for_console
        print(output)
        literal_equivalents_keys.append(m)
        literal_equivalents_values.append(literal_equivalents_str)
        cont += 1

    decrypted_buff = ""
    for decrypted_group in literal_equivalents_values:
        decrypted_buff += decrypted_group

    return decrypted_buff


if __name__ == '__main__':
    ke, kd = key_generation(30, 100)
    alphabet = {chr(65 + i): i + 1 for i in range(26)}
    alphabet['_'] = 0
    print("Alphabet: " + str(alphabet))

    # poate ar fi bine sa faci un meniu in care sa selectezi daca vrei
    # sa criptezi sau sa decriptezi un mesaj...
    # asta ca sa respecti cerinta de la laborator...
    # (atunci trebuie sa validezi si un input de tip cipher-text)
    flag = True
    while flag:
        flag = False
        message = input("Give me a message: ")
        for letter in message:
            if letter.upper() not in alphabet.keys() and letter != " ":
                flag = True
        if flag:
            print("The letters of the message doesn't belong to english Alphabet! Try again!")

    l = len(alphabet)
    k = 0
    i = 1
    message = message.upper()
    while not (pow(l, k) < ke[0] < pow(l, i)):
        k += 1
        i += 1
    print("Plain Text => Blocks of k letters - k: " + str(k))
    print("Cipher Text => Blocks of i letters - i: " + str(i))
    cipher_text = encrypt(ke, message, k, alphabet)
    print("After Encryption => ciphertext: " + cipher_text)

    # cipher_text = "AYX RLAGABAR8"
    flag = False
    for letter in cipher_text:
        if letter not in alphabet.keys():
            flag = True
    if flag:
        print("The letters of the cipher_text doesn't belong to english Alphabet! Try again!")
    else:
        plain_text = decrypt(ke, kd, cipher_text, i, alphabet)
        print("After Decryption => plaintext: " + plain_text)

        # ai putea sa faci un if dupa lungimea mesajului primit ca input
        # in care, daca aceasta lungime este impara, stergi ultimul spatiu
        # din plain-textul decriptat
        # altfel le compari asa cum sunt
        try:
            assert message.lower().strip() == plain_text.strip()
            print("Assertation => message: " + message.lower().strip() + " = " + plain_text.strip() + " :plaintext")
        except:
            print("Assertation failed!")
