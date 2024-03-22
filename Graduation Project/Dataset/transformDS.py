# Input and output file paths
input_file = fr"C:\Users\Ahmed\OneDrive\Desktop\DECourse\Tasks\GradProject\Dataset\covid-19.csv"
output_file = "final.csv"

# Read input CSV file and write to output CSV file with commas as delimiter
with open(input_file, 'r') as infile, open(output_file, 'w', newline='') as outfile:
    for line in infile:
        # Remove leading/trailing whitespace and split by tab delimiter
        fields = line.strip().split('\t')
        # Join fields with commas and write to output file
        outfile.write(','.join(fields) + '\n')
