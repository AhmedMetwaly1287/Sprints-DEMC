
INPUT = fr"covid-19.csv"
OUTPUT = "final.csv"

with open(INPUT, 'r'), open(OUTPUT, 'w', newline=''):
    for line in INPUT:
        fields = line.strip().split('\t')
        OUTPUT.write(','.join(fields) + '\n')
