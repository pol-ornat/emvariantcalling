cigar = '3M3D98M'
nuc = '9==?@BB>BCABBCDACADCDDCACBB@ACCBAAAAA@BAAABAAABBBAAAAABB@A@BAB@@ABABA@A@@AB@@BA@?A@@A@?A??@?@@@==><=<'
# nuc=nuc.replace('A','1')
# nuc=nuc.replace('C', '2')
# nuc=nuc.replace('G', '3')
# nuc=nuc.replace('T', '4')
# nuc=nuc.replace('N','0')
lista = []

firsto = True

for k,c in enumerate(cigar):
    if(not c.isdigit()):
        if(firsto):
            lista.append(cigar[0:k+1])
            firsto = False
        else:
            if(cigar[k-2].isdigit()):
                lista.append(cigar[k-2:k+1])
            else:
                lista.append(cigar[k-1:k+1])

# Check list correct requisites
cigarlist = ""
for e in lista:
    cigarlist = cigarlist+e

if(cigar!=cigarlist):
    print("caca")
else:
    nucc=''
    pInit=0
    zeross='zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
    if (('D' in cigar) or ('I' in cigar)):
        for ch in lista:
            if ('M' in ch):
                l = int(ch.split('M', 1)[0])
                nucc=nucc+nuc[pInit:pInit+l]
                pInit=pInit+l;
            if ('D' in ch):
                l = int(ch.split('D', 1)[0])
                nucc = nucc + zeross[0:l]
                # pInit=pInit+l;
            if ('I' in ch):
                l = int(ch.split('I', 1)[0])
                pInit = pInit + l;
        nuc = nucc;

print(nuc)
print(len(nuc))
