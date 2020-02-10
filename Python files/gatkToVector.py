# This code gets the GATK VCF File and converts it into a .csv file to import as a vector in Matlab (for positions or variants)

import numpy as np

# print("Getting positions...")


# indx = np.genfromtxt('indx1.csv', delimiter='\n', dtype=np.str)
# indx = list(indx.astype(int))

# ref = np.genfromtxt('refs-est.csv', delimiter='\n', dtype=np.str)
# ref = list(ref.astype(int))



print("Accessing VCF...")
# Open VCF file line by line
gatk_class=[]
poss=[]
basic = ['A','C','G','T']
dual = ['A,C','A,G','A,T','C,G','C,T','G,T']
with open("./gatk_full.vcf") as f:
    for line in f:
        splitted = line.split()
        pos = splitted[1]
        ref = splitted[3]
        if (ref not in basic):
             continue
        variant = splitted[4]
        gt = splitted[9][:3]

        # variant = variant.replace('A', '1')
        # variant = variant.replace('C', '2')
        # variant = variant.replace('G', '3')
        # variant = variant.replace('T', '4')
        # variant = variant.replace('N', '0')

        if (variant in basic):
            if ((gt == '0/1') or (gt == '0|1')):
                nuc = ref + variant
                if ((nuc == 'AC') or (nuc == 'CA')):
                    nuc = int(5)
                if ((nuc == 'AG') or (nuc == 'GA')):
                    nuc = int(6)
                if ((nuc == 'AT') or (nuc == 'TA')):
                    nuc = int(7)
                if ((nuc == 'CG') or (nuc == 'GC')):
                    nuc = int(8)
                if ((nuc == 'CT') or (nuc == 'TC')):
                    nuc = int(9)
                if ((nuc == 'GT') or (nuc == 'TG')):
                    nuc = int(10)

            if ((gt == '1/1') or (gt == '1|1')):
                nuc = variant + variant
                if (nuc == 'AA'):
                    nuc = int(1)
                if (nuc == 'CC'):
                    nuc = int(2)
                if (nuc == 'GG'):
                    nuc = int(3)
                if (nuc == 'TT'):
                    nuc = int(4)
            poss.append(pos)
            gatk_class.append(nuc)

        if (variant in dual):
            if ((gt == '0/1') or (gt == '0|1')):
                nuc = ref + variant[0]
                if ((nuc == 'AC') or (nuc == 'CA')):
                    nuc = int(5)
                if ((nuc == 'AG') or (nuc == 'GA')):
                    nuc = int(6)
                if ((nuc == 'AT') or (nuc == 'TA')):
                    nuc = int(7)
                if ((nuc == 'CG') or (nuc == 'GC')):
                    nuc = int(8)
                if ((nuc == 'CT') or (nuc == 'TC')):
                    nuc = int(9)
                if ((nuc == 'GT') or (nuc == 'TG')):
                    nuc = int(10)

            if ((gt == '1/1') or (gt == '1|1')):
                nuc = variant[0] + variant[0]
                if (nuc == 'AA'):
                    nuc = int(1)
                if (nuc == 'CC'):
                    nuc = int(2)
                if (nuc == 'GG'):
                    nuc = int(3)
                if (nuc == 'TT'):
                    nuc = int(4)

            if ((gt == '1/2') or (gt == '1|2')):
                nuc = variant[0] + variant[2]
                if ((nuc == 'AC') or (nuc == 'CA')):
                    nuc = int(5)
                if ((nuc == 'AG') or (nuc == 'GA')):
                    nuc = int(6)
                if ((nuc == 'AT') or (nuc == 'TA')):
                    nuc = int(7)
                if ((nuc == 'CG') or (nuc == 'GC')):
                    nuc = int(8)
                if ((nuc == 'CT') or (nuc == 'TC')):
                    nuc = int(9)
                if ((nuc == 'GT') or (nuc == 'TG')):
                    nuc = int(10)

            if ((gt == '2/2') or (gt == '2|2')):
                nuc = variant[3] + variant[3]
                if (nuc == 'AA'):
                    nuc = int(1)
                if (nuc == 'CC'):
                    nuc = int(2)
                if (nuc == 'GG'):
                    nuc = int(3)
                if (nuc == 'TT'):
                    nuc = int(4)

            poss.append(pos)
            gatk_class.append(nuc)

np.savetxt("pos-gatk_full.csv", poss, fmt='%s')
np.savetxt("class-gatk_full.csv", gatk_class, fmt='%s')
#  np.savetxt("samepos.csv", same,fmt='%s')