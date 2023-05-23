# !/usr/bin/python3
import numpy as np
import matplotlib.pyplot as plt

# parameters to modify
#filename="iperf3_tcp_proc.data"
label='iperf3'
ylabel = 'Percentage of packets lost'
xlabel = 'Bandwidth (Mbits/sec)'
title='iperf3 UDP percentage of packets dropped at different bandwidths'
fig_name='iperf3_packets.png'
k=[0.1,1,100]
t=[0,0,0]

#t = np.loadtxt(filename, delimiter=" ", dtype="float")
#k = np.array(range(1, 11))
plt.plot(k, t, label=label)  # Plot some data on the (implicit) axes.
plt.xlabel(xlabel)
plt.ylabel(ylabel)
plt.title(title)
plt.legend()
plt.savefig(fig_name)
plt.show()
