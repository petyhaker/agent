
from pyswip.prolog import Prolog


def main():
    """
    Trying to modify this example https://github.com/yuce/pyswip/blob/master/examples/coins/coins.py 
    to provide a nice pythonic interface to petyhaker's code
    """
    prolog = Prolog()
    prolog.consult("agent.pl")

    count = int(raw_input("How many coins (default: 100)? ") or 100)
    total = int(raw_input("What should be the total (default: 500)? ") or 500)
    for i, soln in enumerate(prolog.query("coins(S, %d, %d)." % (count,total))):
        # [1,5,10,50,100]
        S = zip(soln["S"], [1, 5, 10, 50, 100])
        print i,
        for c, v in S:
            print "%dx%d" % (c,v),
        print
    list(prolog.query("coins(S, %d, %d)." % (count,total)))

    
if __name__ == "__main__":
    main()