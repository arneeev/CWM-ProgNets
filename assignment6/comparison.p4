/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

/*************************************************************************
*********************** H E A D E R S  ***********************************
*************************************************************************/

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;

header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}

header trade_t {
    bit<8> p;
    bit<8> four;
    bit<8> version;
    bit<32> order;
    bit<32> price;
    bit<32> res;
    }

header current_t {
    bit<32> current_price;

}

struct metadata {
    /* empty */
}

struct headers {
    ethernet_t   ethernet;
    trade_t  trade;
    current_t  current;
}

/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {
        /* TODO: add parser logic */
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            0x1234: parse_trade;
            default:accept;
        }
    }
    
    state parse_trade {
    	packet.extract(hdr.trade);
    	transition accept;
    }
}


/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {   
    apply {  }
}


/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {

    
    action send_back(bit<32> result) {
        /* TODO
         * - put the result back in hdr.p4calc.res
         * - swap MAC addresses in hdr.ethernet.dstAddr and
         *   hdr.ethernet.srcAddr using a temp variable
         * - Send the packet back to the port it came from
             by saving standard_metadata.ingress_port into
             standard_metadata.egress_spec
         */
         bit<48> temp;
         hdr.trade.res = result;
         temp = hdr.ethernet.dstAddr;
         hdr.ethernet.dstAddr = hdr.ethernet.srcAddr;
         hdr.ethernet.srcAddr = temp;
         
         standard_metadata.egress_spec = standard_metadata.ingress_port;
    }
    action compare() {
        hdr.current.current_price = 50;
        if (hdr.trade.order == 1) { //you are trying to buy
           if (hdr.trade.price >= hdr.current.current_price){
              send_back(1);
              }
           else {
              send_back(0);
              }
          }
        else {
           if (hdr.trade.price < hdr.current.current_price){//trying to sell
              send_back(1);
              }
           else {
              send_back(0);    
              }  
        }
        }
           
           
        
    
   // action drop() {
   //     mark_to_drop(standard_metadata);
  apply {  
      compare(); 
        }
    

}
       
       
    


/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply {  }
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers hdr, inout metadata meta) {
     apply {

     }
}


/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.trade);
    }
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
