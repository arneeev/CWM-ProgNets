# !/usr/bin/python3
import numpy as np
import matplotlib.pyplot as plt

# parameters to modify
filename="pingprocessed3.data"
label='ping'
ylabel = 'cumulative probablity'
xlabel = 'RTT values (ms)'
title='CDF of RTT values, 0.0001s interval'
fig_name='ping0.0001.png'


t = np.loadtxt(filename, delimiter=" ", dtype="float")
N = 1000
data = t
count, bins_count = np.histogram(data, bins=10000)
pdf = count / sum(count)
cdf = np.cumsum(pdf)
plt.plot(bins_count[1:], cdf, label="CDF")
plt.xlabel(xlabel)
plt.ylabel(ylabel)
plt.title(title)
plt.legend()
plt.savefig(fig_name)
plt.show()


