## Generate matrix using numpy and the convert it into Matlab
import numpy as np

# Create matrix of zeros
# Select the lenght of your sequence
length_ref = 15001000 # Chromosome 20
shape = (5, length_ref)
shape_r = (1,length_ref)
matrix = np.zeros(shape,dtype=np.int8)

# To remove nucleotides with errors
incorrect_flags = str([73,133,89,121,165,181,101,117,153,185,69,137,77,141])  # unmapped
correct_nucs = str(['A', 'C','G','T','N'])

print("Accessing file...")
# Open SAM file line by line
with open("./sam_12M.sam") as f:
    for line in f:
        splitted = line.split()
        pos = int(splitted[3])
        cigar = splitted[5]
        rnext = splitted[6]
        nuc = splitted[9]

        nuc=nuc.replace('A','1')
        nuc=nuc.replace('C', '2')
        nuc=nuc.replace('G', '3')
        nuc=nuc.replace('T', '4')
        nuc=nuc.replace('N','0')
        flag = splitted[1]


        if (cigar != '101M'):
            continue
        if ('*' in cigar):
            continue
        if ('=' != rnext):
            continue
        if (int(flag) > 256):
            # print("Discarting...", flag)
            continue
        if (flag in incorrect_flags):
            # print("Changing...", flag)
            # print("caca")
            continue
        if (len(nuc) != 101):
            # print("jjjjj", nuc)
            continue

        # row_num is the parameter that will select the row to write the corresponding read
        row_num = -1

        # For each row of the matrix we check if from the position given (pos) until pos+ the length of the read is all zeros (which means there is no
        #  value on it and there is no need to create another row)
        for j, m in enumerate(matrix):
            if (set(m[int(pos) - 1:int(pos) + len(nuc) - 1]) == set([0] * len(nuc))):
                # If the segment is empty we save the value of the row
                row_num = j
                break

        # If row_num is still -1 that means none of the rows is empty for the positions of the segment given (previous for loop)
        # so we need to generate a full empty row
        if (row_num == -1):
            a = np.zeros(shape_r,dtype=np.int8)
            matrix = np.append(matrix, a, axis=0)
            # continue


        # Copy nucs from position given to posgiven + l-1
        for k,value in enumerate(nuc):
            matrix[row_num][pos - 1+k] = value

# Once the matrix is generated, take only the columns whose values differ (ACTG)


print("Big matrix generated")

matrix_splitted = np.hsplit(matrix,100)
first = True
offset = 0
for mat in matrix_splitted:
    # Ms = np.sort(matrix,axis=0)
    #d = np.diff(np.sort(matrix,axis=0), axis=0)
    #M=np.maximum(d,1)
    #m = np.absolute(np.diff(np.sort(matrix,axis=0), axis=0)/np.maximum(np.diff(np.sort(matrix,axis=0), axis=0),1),casting='same_kind')

    suma=np.sum(np.absolute(np.diff(np.sort(mat,axis=0), axis=0)/np.maximum(np.diff(np.sort(mat,axis=0), axis=0),1),casting='same_kind'),axis=0)
    indx=np.array([0])
    for i in range(suma.shape[0]):
        if(suma[i] > 1):
            indx=np.append(indx,i)

    indx=np.delete(indx,0)+int(offset)
    if(not first):
        new_matrix = np.hstack((new_matrix,matrix[:, indx]))
        # print(new_matrix)
        offset=offset+length_ref/100
        indexes=np.append(indexes,indx)
    else:
        new_matrix = matrix[:, indx]
        # print(new_matrix)
        first = False
        offset = length_ref/100
        indexes = indx

# MATLAB CODE
# ---------------------
# %%
# A=diff(Fsorted);
# M=abs(A./max(A,1));
# suma=sum(M);
# indx=find(suma>1);
# %%
# newM6=zeros(num_rows,length(indx));
# newM6=F(:,indx);
# save('matrixM_sg6','newM6');
# real_idx6 = indx + offset;
# save('columns_values6','real_idx6');
# --------------------------------------
#

print("Saving...")

np.savetxt("F_matrix-12M.csv", new_matrix, delimiter=",", newline='\n',fmt='%s')
np.savetxt("index-12M.csv", indexes, delimiter=",", newline='\n',fmt='%s')
