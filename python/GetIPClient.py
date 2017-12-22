#!/usr/bin/python3
# -*- coding: utf-8 -*-

import ipaddress
import socket
import sys
import traceback

def GetIP(host, port) :
    ipAddrStr = None
    addrInfos = socket.getaddrinfo(host, port, 0, socket.SOCK_STREAM, socket.SOL_TCP)
    (addrFamily, sockType, sockProto, canonName, sockAddr) = addrInfos[0]
    try :
        clientSocket = socket.socket(addrFamily, sockType, sockProto)
        clientSocket.connect(sockAddr)
        returnMsg = b''
        while True :
            buf = clientSocket.recv(4096)
            returnMsg = returnMsg + buf
            if 0 == len(buf) :
                break
        ipAddrStr = returnMsg.decode('utf-8')
        clientSocket.close()
    except OSError as e :
        if 101 == e.errno :
            pass
        else :
            traceback.print_exception(*sys.exc_info())
    except ConnectionRefusedError as e :
        print('[%s]:%d connection refused.' % sockAddr)
    except Exception as e :
        traceback.print_exception(*sys.exc_info())
    ipAddress = None
    if None != ipAddrStr :
        ipAddress = ipaddress.ip_address(ipAddrStr)
        if 6 == ipAddress.version :
            if ipAddress.ipv4_mapped :
                ipAddress = ipAddress.ipv4_mapped
    return(ipAddress)

if '__main__' == __name__ :
    ipAddr4 = GetIP('106.186.121.152', 9999)
    ipAddr6 = GetIP('2400:8900::f03c:91ff:fe89:1aa3', 9999)
    ipAddr = (ipAddr4, ipAddr6)
    print(ipAddr)
