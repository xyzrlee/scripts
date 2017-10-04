#!/usr/bin/python3
# -*- coding: utf-8 -*-

import socket
import sys
import traceback

def Server() :
    host = '::'
    port = 9999
    addrInfos = socket.getaddrinfo(host, port, 0, socket.SOCK_DGRAM, socket.SOL_UDP)
    (addrFamily, sockType, sockProto, canonName, sockAddr) = addrInfos[0]
    serverSocket = socket.socket(addrFamily, sockType, sockProto)
    serverSocket.bind(sockAddr)
    while True :
        try :
            data, clientAddr = serverSocket.recvfrom(4)
            print(data)
            serverSocket.sendto(data, clientAddr)
        except KeyboardInterrupt :
            break
        except Exception as e :
            traceback.print_exception(*sys.exc_info())
            break
    serverSocket.close()
    return

if '__main__' == __name__ :
    Server()

