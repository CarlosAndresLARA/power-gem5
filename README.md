
# Contents

## Covert channels
A1 - Use of OP-TEE AES to create a covert channel. ts = 1E-5

A2 - Same experiment, frequency modification is disabled. ts = 1E-5

## Power analysis of AES
C1 - Statistics obtained from the execution of 20 SBOX+ARK operations. ts = 4E-8

C2 - Same data as C1, the statistics are segmented.

C3 - Statistics obtained from the execution of 256 SBOX+ARK operations. ts = 4E-8

C4 - Same data as C2, the statistics are segmented. ts = 4E-7

## Power models
F3 - Stats for a complete boot sequence + OPTEE. ts = 1E-4

F4 - Same experiment. ts = 1E-5

## Timing analysis of modular multiplications
S1 - Five field multiplications @ 600MHz. ts = 4E-8

S1 - Five field multiplications @ 10MHz. ts = 4E-8

## Scripts
process_data.py - Divides the gem5 statistics file into single-statistic files. Extracts timing information.

ensamble_data.m - Joins several parts into a single stat file. Not automated.
