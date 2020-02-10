# This file gets the vector generated from 'refToVector.py' and generates a new vector with the positions
# given by the input file 'index.csv'

import numpy as np

# indx = np.genfromtxt('index-.csv', delimiter='\n', dtype=np.str)
# indx = indx.astype(int);
# print("Index OK")

# ref = np.genfromtxt('ref_vector.csv', delimiter='\n', dtype=np.str)
# ref = ref.astype(int)
# print("Ref OK")

# ref_diff = ref[indx]
#
#
# np.savetxt("ref_diff.csv", ref_diff,fmt='%s')


indx = np.genfromtxt('index-16M.csv', delimiter='\n', dtype=np.str)
indx = indx.astype(int)+1;
print("Index OK")

np.savetxt("index_16M.csv", indx,fmt='%s')




