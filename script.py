##
# usage:   python3 xxx.py default_latency.txt improved_latency.txt  start_from_line  totaly_read_lines
##

import numpy as np
import sys
import statsmodels.api as sm
import matplotlib.pyplot as plt

a = np.genfromtxt(sys.argv[1], delimiter=',', skip_header=int(sys.argv[3]), max_rows=int(sys.argv[4]))
a2 = np.genfromtxt(sys.argv[2], delimiter=',', skip_header=int(sys.argv[3]), max_rows=int(sys.argv[4]))

#a = np.genfromtxt(sys.argv[1], delimiter=',', skip_header=5)

#a2 = np.genfromtxt(sys.argv[2], delimiter=',', skip_header=5)
print('removing these from default file:')
while a.max() > 1000000:
    t = np.argmax(a, axis=0)
    print(a.max(),t)
    a = np.delete(a, t)

print('removing these from improved file:')
while a2.max() > 1000000:
    t = np.argmax(a2, axis=0)
    print(a.max(), t)
    a2 = np.delete(a2, t)

print('\npercentile\tdefault\timproved')
p = np.percentile(a, 99,axis=0)
p2 = np.percentile(a2, 99,axis=0)
print('99\t\t', p, '\t\t', p2)
p = np.percentile(a, 99.9,axis=0)
p2 = np.percentile(a2, 99.9,axis=0)
print('99.9\t',p, '\t', p2)
p = np.percentile(a, 99.99,axis=0)
p2 = np.percentile(a2, 99.99,axis=0)
print('99.99\t',p, '\t', p2)

ecdf = sm.distributions.ECDF(a)
x1 = np.linspace(min(a), max(a), 300000)
y1 = ecdf(x1)

ecdf = sm.distributions.ECDF(a2)
x2 = np.linspace(min(a2), max(a2), 300000)
y2 = ecdf(x2)

plt.axis([200, 5000, 0.99, 1.001])
p = plt.plot(x1, y1, 'r', x2, y2, 'g')
plt.xlabel('uSeconds')
plt.ylabel('Percentile')
plt.setp(p, linewidth=2.0)
plt.grid(True, which='both')

plt.show()
