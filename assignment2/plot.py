# !/usr/bin/python3
import numpy as np
import matplotlib.pyplot as plt

# parameters to modify
filename="pingprocessed.data"
label='ping'
ylabel = 'ping test number'
xlabel = 'time (ms)'
title='Ping, 0.01s interval'
fig_name='ping0.01.png'


t = np.loadtxt(filename, delimiter=" ", dtype="float")
k = np.array(range(1, 1001))
plt.plot(k, t, label=label)  # Plot some data on the (implicit) axes.
plt.xlabel(xlabel)
plt.ylabel(ylabel)
plt.title(title)
plt.legend()
plt.savefig(fig_name)
plt.show()
