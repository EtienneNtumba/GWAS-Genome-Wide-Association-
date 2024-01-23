import fileinput
import sys

rows = {}
L = {}

with open(sys.argv[4], "wt") as fin:  # Using a 'with' statement for file handling
    fin.write("\t".join(["CHR", "BP", "SNP", "MAF", "A1/A2", "BETA", "SE", "P"]) + "\n")

    for line in fileinput.input(sys.argv[1]):  # Freq
        data = line.split()
        L[data[1]] = [data[4], data[2] + "/" + data[3]]

    for line in fileinput.input(sys.argv[2]):  # EMMAX RESULTS
        data = line.split()
        if data[0] in L:
            rows[data[0]] = [data[0]] + L[data[0]] + data[1:]

    for line in fileinput.input(sys.argv[3]):  # bim file
        data = line.split()
        if data[1] in rows:
            if "KI27" not in data[1] and float(rows[data[1]][-1]) < 0.0001:
                print([data[0], data[3]] + rows[data[1]])
            fin.write("\t".join([data[0], data[3]] + rows[data[1]]) + "\n")

