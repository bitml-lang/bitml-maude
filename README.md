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


## Structure

Modules tagged as `(internal)` are meant to be used only within the same file, not outside. Their name may change.
Modules tagged as `(external)` are meant to be imported by other modules in other files. Their name should never change.

### `bitml-syntax.maude`
Define the bitml syntax.
  
  - `BITML-SORTS (internal)`
  - `BITML-SYNTAX-CONS (internal)`
  - `BITML-STREQ (internal)`
  - `BITML-SYNTAX (external)`

### `bitml-aux.maude`
Define some auxiliary operations.
Depend on `bitml-syntax.maude` and define the module:

  - `BITML-AUX (external)`

### `bitml-predicate.maude`
Define predicates evaluation.
Depend on `bitml-aux.maude` and define the module:

  - `BITML-PREDICATE-SAT (external)`

### `bitml.maude`
Define the abstract semantic of bitml and the rewriting strategy.
Depend on `bitml-predicate.maude` and define the modules:

  - `BITML-SEM (internal)`
  - `BITML (external)`
  - `BITML-STRAT (internal)`
  - `BITML-PREDS (internal)`
  - `BITML-CHECK (external)`


## Example
Start maude `./maude model-checker.maude /<path>/bitml.maude` and type the following example:

```
mod Examples-LIQUIDITY is
    protecting BITML .

    ops A B C : -> Participant .
    op v : -> Value .
    ops a b : -> Secret .
    ops t t' N M : -> Nat .
    op LOTTERY : -> SemConfiguration .
    op LIQUID-LOTTERY : -> SemConfiguration .
    op S : Contract -> SemConfiguration .
    ops WIN WIN' : -> Contract .

    eq t = 10 .
    eq t' = 15 .
    eq N = 1 .
    eq M = 1 .

    *** lottery
    
    eq LOTTERY = S(WIN) .
    eq LIQUID-LOTTERY = S(WIN') .
    
    eq S(WIN:Contract) = 
        toSemConf
        < split(
            2 BTC ~> ( reveal b if const(0) <= | ref(b) | <= const(1) . withdraw B + after t : withdraw A )
            2 BTC ~> ( reveal a . withdraw A + after t : withdraw B )
            2 BTC ~> WIN:Contract
            ), 6 BTC > 'x
        | { A : a # N } 
        | { B : b # M } .

    eq WIN = reveal (a, b) if | ref(a) | == | ref(b) | . withdraw A
           + reveal (a, b) if | ref(a) | != | ref(b) | . withdraw B .

    eq WIN' = WIN
            + (after t' : reveal a . withdraw A)
            + (after t' : reveal b . withdraw B) .

    *** strategies

    *** A never locks her secrets
    eq strategy(S:SemConfiguration, A lock-reveal a:Secret) = false .

    *** A never locks her authorizations
    eq strategy(S:SemConfiguration, A lock D:GuardedContract in x:Name) = false .

    *** No one destroys a deposit
    ***eq strategy(S:SemConfiguration, A:Participant authorize-destroy-of x:Name) = false .

    *** A reveals any secret (default any participant reveals any secret)
    ***eq strategy(S:SemConfiguration, A reveal a:Secret) = true .

    *** B does not reveal any secret
    ***eq strategy(S:SemConfiguration, B reveal a:Secret) = false .

    *** No one reveal a secret
    ***eq strategy(S:SemConfiguration, A:Participant reveal a:Secret) = false .

    *** B authorizes any contract
    ***eq strategy(S:SemConfiguration, B authorize D:GuardedContract in y:Name) = true .

    *** No one authorize any contract
    ***eq strategy(S:SemConfiguration, A:Participant authorize D:Contract in y:Name) = false .
endm

smod Examples-LIQUIDITY-CHECK is
    protecting BITML-CHECK .
    including Examples-LIQUIDITY .
endsm
```

Model-check liquidity:

```
reduce in Examples-LIQUIDITY-CHECK : modelCheck(LOTTERY, <> contract-free, 'bitml) .           *** false
reduce in Examples-LIQUIDITY-CHECK : modelCheck(LIQUID-LOTTERY, <> contract-free, 'bitml) .    *** true
reduce in Examples-LIQUIDITY-CHECK : modelCheck(LIQUID-LOTTERY, []<> A has-deposit>= 4 BTC, 'bitml) .   *** true
```


