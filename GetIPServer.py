#!/usr/bin/python3
# -*- coding: utf-8 -*-

import ipaddress
import socket
import sys
import traceback

def main() :
    host = '::'
    port = 9999
    addrInfos = socket.getaddrinfo(host, port, 0, socket.SOCK_STREAM, socket.SOL_TCP)
    (addrFamily, sockType, sockProto, canonName, sockAddr) = addrInfos[0]
    serverSocket = socket.socket(addrFamily, sockType, sockProto)
    serverSocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    serverSocket.bind(sockAddr)
    serverSocket.listen(5)
    while True :
        try :
            clientSocket, clientAddress = serverSocket.accept()
            ipAddress = ipaddress.ip_address(clientAddress[0])
            if 6 == ipAddress.version :
                if ipAddress.ipv4_mapped :
                    ipAddress = ipAddress.ipv4_mapped
            returnMsg = str(ipAddress).encode('utf-8')
            clientSocket.send(returnMsg)
            clientSocket.close()
        except KeyboardInterrupt as e :
            break 
        except Exception as e :
            traceback.print_exception(*sys.exc_info())
    serverSocket.close()
    return

if '__main__' == __name__ :
    main()
