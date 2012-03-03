def primes(kmax):
    p = []
    n = 2
    while len(p) < kmax:
        for i in p:
            if n % i == 0:
                break
        else:
            p.append(n)
        n += 1
    return p


    


