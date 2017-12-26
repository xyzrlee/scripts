#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import socket
import struct
import sys
import traceback

def Client(data) :
    host = '127.0.0.1'
    port = 9999
    addrInfos = socket.getaddrinfo(host, port, 0, socket.SOCK_DGRAM, socket.SOL_UDP)
    (addrFamily, sockType, sockProto, canonName, sockAddr) = addrInfos[0]
    clientSocket = socket.socket(addrFamily, sockType, sockProto)
    clientSocket.connect(sockAddr)
    try :
        for i in range(0, len(data), 4096) :
            dataB = data[i:i+4096].encode('utf-8')
            length = len(dataB)
            if 0 == length :
                break
            sendMsg = dataB
            clientSocket.sendall(sendMsg)
    except Exception as e :
        traceback.print_exception(*sys.exc_info())
    clientSocket.close()
    return

if '__main__' == __name__ :
    s = ''
    for i in range(513) :
        s = s + str(i % 10)
    Client(s)

