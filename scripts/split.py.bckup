#!/usr/bin/env python

import dnaprocedures as dp
from sys import argv, exit

input_file = argv[1]
size = int(argv[2])
steps = int(argv[3])
directory = "/".join(input_file.split("/")[:-1])

genome = dp.load(input_file)
splited_genome = dp.split_seqs(genome, size, steps)
total_seqs = splited_genome.length()
if dp.write_to_file(splited_genome, "fasta", directory + "/splited-genome.fas"):
    print "[SPLIT   ][MESSAGE!] - " + str(total_seqs) + " sequences were alllocated at splited-genome.fas"
else:
    print "[SPLIT   ][ERROR!] - Something went wrong in writing sequences"
    exit(1)
