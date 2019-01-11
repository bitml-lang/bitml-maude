# bitml-maude
Model-checking verification of Bitml, a specification language for Bitcoin Smart Contracts.

- [Fun with Bitcoin smart contracts](https://eprint.iacr.org/2018/398.pdf) (ISOLA, 2018)
- [BitML: A Calculus for Bitcoin Smart Contracts](https://eprint.iacr.org/2018/122.pdf) (ACM CCS, 2018)

## Download Maude
Download the latest version of Maude from [http://maude.sip.ucm.es/strategies/](http://maude.sip.ucm.es/strategies/):
this is an alpha version of Maude that supports the definition of rewriting strategies. See the link above for details.

Test that everything is working executing `maude model-checker.maude bitml.maude`.
The REPL starts and the output should be similar to this:

```shell
$ maude model-checker.maude bitml.maude
                     \||||||||||||||||||/
                   --- Welcome to Maude ---
                     /||||||||||||||||||\
           Maude alpha120+strat built: Jan 11 2019 12:00:00
            Copyright 1997-2018 SRI International
                   Fri Jan 11 11:35:46 2019
Maude> 
```

Note the version number `alpha120+strat`.


