# OR_identify
1.**Store your queries**, including **query.fas** and **human_OR2J3.fas**.
2.**Manually download genome sequences into the** **2_genome_100_per_line folder**. Convert each genome line from 70 characters to 100 characters for better alignment.
3.**Manually copy query.fas into the** **3_tblastn folder**. Use tblastn to perform comparisons and obtain all possible OR gene sequences.
4.**Remove redundancy**. If the distance between the start site of one possible OR and the start site of the next OR is >2000 base pairs (1000 for the length of the OR itself and 1000 for the distance between them), consider them as two separate OR; otherwise, treat them as a rough large gene.
5.**Separate the genome by chromosome number**.
6.**Extract OR genes from the genome** and extend them 100 amino acids forward and backward (to prevent the start codon and stop codon from being cut off).
7.**Locate the potential open reading frames (ORFs)** from the start codon (ATG) to the stop codon.
8.Manually copy **human_OR2J3.fas** into the **8_Add_human_mafft folder**. Perform alignments of all extracted possible OR genes against any human olfactory receptor gene.
9.**Exclude genes without 7 complete transmembrane conserved regions** (with 5 gaps).
10.**Identify all ATG codons for each gene**. Using the method mentioned in the literature, determine the most appropriate start codon.
11.**Perform alignments again**.
12.**Manually remove genes with frameshift mutations using BioEdit**.
