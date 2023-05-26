#!/usr/bin/python

from scapy.all import Ether, IP, sendp, get_if_hwaddr, get_if_list, TCP, Raw, UDP
import sys


def send_order(number, order, price, interface):
    src_ip = "192.168.10.1"
    dst_ip = "192.168.10.2"
    dst_mac = "00:00:00:00:00:01"
    src_mac= "00:00:00:00:00:02"
    total_pkts = 0
    port = 1024
    k=0
    current_price = 50
    for i in range(number):
            if order == "buy":
            	order_bit = 1
            else: 
            	order_bit = 0
            data = [order_bit,price]
            p = Ether(dst=dst_mac,src=src_mac)/IP(dst=dst_ip,src=src_ip)
            p = p/UDP(sport= 50000, dport=port)/Raw(load=data)
            sendp(p, iface = interface, inter = 0.01)
            # If you want to see the contents of the packet, uncomment the line below
            # print(p.show())
            total_pkts += 1
            k=k+1
    print("order sent")
    resp = srp1(pkt, iface=iface,timeout=5, verbose=False)
    print(resp)
#    if resp:
#           	trade=resp[trade]
#            	if trade:
#                	print(trade.result)
#                else:
#                        print("cannot find P4calc header in the packet")
#            else:
#                print("Didn't receive response")
#            except Exception as error:
#                print(error)

if __name__ == '__main__':
    if len(sys.argv) < 5:
        print("Usage: python send.py Order (buy/sell) Price Number_of_shares, interface")
        sys.exit(1)
    else:
        order = sys.argv[1]
        price = sys.argv[2]
        number = sys.argv[3]
        interface = sys.argv[4]
        send_order(int(number), order, price,interface)
