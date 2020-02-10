# This code gets the FASTA File and converts it into a .csv file to import as a vector in Matlab

import numpy as np

# print("Accessing file...")
# # Open FASTA file line by line
# vector=""
# with open("./human_g1k_v37.chr20.fasta") as f:
#     for line in f:
#         line = line.replace('\n','')
#         line = line.replace('A', '1')
#         line = line.replace('C', '2')
#         line = line.replace('G', '3')
#         line = line.replace('T', '4')
#         line = line.replace('N', '0')
#         vector=vector+str(line)
# text = list(vector)
#
# np.savetxt("ref.csv", text,fmt='%s')


print("Accessing file...")

indx = np.genfromtxt('index-9M-obv.csv', delimiter='\n', dtype=np.str)
indx = indx.astype(int)

ref = np.genfromtxt('ref.csv', delimiter='\n', dtype=np.str)
ref = np.array(ref.astype(int))

ref_est=ref[indx]


np.savetxt("refs-9M-obv.csv", ref_est,fmt='%s')

