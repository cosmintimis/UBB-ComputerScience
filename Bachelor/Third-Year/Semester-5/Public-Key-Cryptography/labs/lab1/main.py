import timeit


def gcd_euclid_by_division(a, b):
    while b != 0:
        a, b = b, a%b
    return a

def prime_factors_with_powers(n):
    factors = {}
    if n == 0:
        return factors
    elif n < 0:
        n = abs(n)

    power = 0
    while n % 2 == 0:
        power += 1
        n //= 2
    if power > 0:
        factors[2] = power

    for i in range(3, int(n ** 0.5) + 1, 2):
        power = 0
        while n % i == 0:
            power += 1
            n //= i
        if power > 0:
            factors[i] = power

    if n > 2:
        factors[n] = 1

    return factors

def gcd_using_prime_factors(a, b):
    factors_a = prime_factors_with_powers(a)
    factors_b = prime_factors_with_powers(b)
    common_factors = {}
    for prime in factors_a:
        if prime in factors_b:
            common_factors[prime] = min(factors_a[prime], factors_b[prime])
    gcd = 1
    for prime, power in common_factors.items():
        gcd *= prime ** power
    return gcd

def gcd_euclid_by_subtraction(a, b):
    a = abs(a)
    b = abs(b)

    if a == 0 or b == 0:
        return max(a, b)

    while a != b:
        if a > b:
            a -= b
        else:
            b -= a
    return a

def run():
    inputs = [
        (48, 18),
        (56, 98),
        (0, 5),
        (5, 0),
        (10, 10),
        (100, 250),
        (15, 5),
        (27, 9),
        (30, 12),
        (17, 19),
        (21, 14),
        (123456789, 987654321),
        (999999999999, 123456789012)
    ]

    inputsBIG = [
        (123456789423, 987654321),
        (32429999999999, 12334236789012),
        (5352456789, 987654321),
        (999234299999, 23523789012),
        (123456789, 987654321),
        (5235299999999, 5235456789012),
        (123456789, 987654321),
        (93523999999, 15235456789012)
    ]

    start_time = timeit.default_timer()
    for pair in inputs:
        a, b = pair
        gcd_using_prime_factors(a, b)
    end_time = timeit.default_timer()
    print(f"Time taken for gcd_using_prime_factors: {end_time - start_time:.10f} seconds")
    start_time = timeit.default_timer()
    for pair in inputs:
        a, b = pair
        gcd_euclid_by_division(a, b)
    end_time = timeit.default_timer()
    print(f"Time taken for gcd_euclid_by_division: {end_time - start_time:.10f} seconds")
    start_time = timeit.default_timer()
    for pair in inputs:
        a, b = pair
        gcd_euclid_by_subtraction(a, b)
    end_time = timeit.default_timer()
    print(f"Time taken for gcd_euclid_by_subtraction: {end_time - start_time:.10f} seconds")


    print('\n Big inputs: \n')

    start_time = timeit.default_timer()
    for pair in inputsBIG:
        a, b = pair
        gcd_euclid_by_division(a, b)
    end_time = timeit.default_timer()
    print(f"Time taken for gcd_euclid_by_division: {end_time - start_time:.10f} seconds")
    start_time = timeit.default_timer()
    for pair in inputsBIG:
        a, b = pair
        gcd_euclid_by_subtraction(a, b)
    end_time = timeit.default_timer()
    print(f"Time taken for gcd_euclid_by_subtraction: {end_time - start_time:.10f} seconds")

run()