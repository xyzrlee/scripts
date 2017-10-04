#!/usr/bin/python3
# -*- coding: utf-8 -*-

import socketserver

class EchoUDPServerHandler(socketserver.BaseRequestHandler) :
    def handle(self) :
        print(self.client_address)
        msg, clientSock = self.request
        print(msg)

if '__main__' == __name__ :
    server = socketserver.UDPServer(('', 9999), EchoUDPServerHandler)
    server.serve_forever()
