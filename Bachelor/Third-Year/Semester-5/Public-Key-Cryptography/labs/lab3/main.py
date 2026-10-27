from random import randint


# Function to determine gcd of two numbers
def gcd(a, b):
    while b:
        r = a % b
        a = b
        b = r
    return a

# Function to generate all prime numbers up to a specified limit using the Sieve of Eratosthenes
def sieve_of_eratosthenes(limit):
    if limit < 2:
        return []

    # Boolean array to track prime numbers (True = prime, False = not prime)
    is_prime = [True] * (limit + 1)
    is_prime[0] = is_prime[1] = False # 0 and 1 are not prime numbers

    # Loop through numbers and mark their multiples as non-prime
    for i in range(2, int(limit**0.5) + 1):
        if is_prime[i]:
            for j in range(i * i, limit + 1, i):
                is_prime[j] = False

    # Extract indices marked True (primes) and return as a list
    primes = [i for i, prime in enumerate(is_prime) if prime]
    return primes

# Function to multiply a number with itself until the product exceeds a given bound
def multiply_until_bound(x, b):
    if x > b:
        return x
    result = x
    while result * x < b:
       result = result * x
    return result

if __name__ == '__main__':
    # Input number to factorize
    n = int(input("Enter your number:"))
    # Optionally set a custom bound
    custom_bound = input("Want to add custom bound?(yes/no):")
    if custom_bound == 'yes':
        bound = int(input("Your bound:"))
    else:
        bound = 13
    # Number of attempts to try different values of 'a'
    attempts = 10
    # Generate all prime numbers up to the bound
    primes = sieve_of_eratosthenes(bound)
    # Calculate the exponent k using primes up to the bound
    k = 1
    for p in primes:
        k *= multiply_until_bound(p, bound)
    # Initialize flag to check if a factor is found
    found = False
    for i in range(attempts):
        # Choose a random integer 'a' in the range [2, n-2]
        a = randint(2, n - 2)
        # Compute a^k mod n
        a = (a ** k) % n
        # Calculate gcd(a-1, n)
        d = gcd(a - 1, n)
        # Check if gcd produces a factor of n
        if d == 1 or d == n:
            bound += 10
            continue
        else:
            print(f"A factor of {n} is {d}.")
            d2 = int(n / d)
            print(f"So n={d}*{d2}")
            found = True
            break
    if found is False:
        print("Number of attempts exceeded! No non-trivial factor was found within bounds and attempts")



