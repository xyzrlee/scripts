#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import platform
import psutil
import socket
import string
import sys

def GetPidsByProcessName(processName) :
    pPids = []
    for pid in psutil.pids() :
        try :
            process = psutil.Process(pid)
            if processName == process.name() :
                pPids.append(process.pid)
        except psutil.AccessDenied :
            pass
    return pPids

def GetListenPortsByPidsIPs(pPids, pListenIPs) :
    pListenPorts = []
    for pconn in psutil.net_connections() :
        try :
            connmsg = []
            if pconn.pid in pPids :
                if 'LISTEN' == pconn.status :
                    if pconn.laddr[0] in pListenIPs :
                        pListenPorts.append(pconn.laddr[1])
        except psutil.AccessDenied :
            pass
    return pListenPorts

def GetConnMsgByPidsIPsPorts(pPids, pListenIPs, pListenPorts) :
    pConnMsg = []
    for pconn in psutil.net_connections() :
        try :
            connmsg = []
            if pconn.pid in pPids :
                if 'ESTABLISHED' == pconn.status :
                    if pconn.laddr[0] in pListenIPs :
                        if pconn.laddr[1] in pListenPorts :
                            connmsg.append(pconn.laddr[0])
                            connmsg.append(pconn.laddr[1])
                            connmsg.append(pconn.raddr[0])
                            pConnMsg.append(connmsg)
        except psutil.AccessDenied :
            pass
    pConnMsg.sort()
    return pConnMsg

def GenerateResult(pConnMsg) :
    xlast = []
    count = 0
    curPos = 0
    pConnMsgLen = len(pConnMsg)
    result = []

    for x in pConnMsg :
        curPos += 1
        if 1 == curPos :
            xlast = x
        isLastElement = True
        if xlast != x :
            isLastElement = False
        if isLastElement :
            count += 1
        else :
            r = {}
            r['count'] = count
            r['lAddr'] = xlast[0]
            r['lPort'] = xlast[1]
            r['rAddr'] = xlast[2]
            result.append(r)
            count = 1
            xlast = x
        if pConnMsgLen == curPos :
            r = {}
            r['count'] = count
            r['lAddr'] = xlast[0]
            r['lPort'] = xlast[1]
            r['rAddr'] = xlast[2]
            result.append(r)
    return result

def PrintResult(result) :
    maxLenLAddr = 0
    maxLenRAddr = 0
    for r in result :
        lenLAddr = len(r['lAddr'])
        lenRAddr = len(r['rAddr'])
        if lenLAddr > maxLenLAddr :
            maxLenLAddr = lenLAddr
        if lenRAddr > maxLenRAddr :
            maxLenRaddr = lenRAddr
    for r in result :
        format = '%7d %+'+str(maxLenLAddr)+'s:%-5d <-> %+'+str(maxLenRAddr)+'s'
        print(format % (r['count'], r['lAddr'], r['lPort'], r['rAddr']))
    return

def GetProcessConnections(processName, pListenIPs) :
    pPids = GetPidsByProcessName(processName)
    pListenPorts = GetListenPortsByPidsIPs(pPids, pListenIPs)
    pConnMsg = GetConnMsgByPidsIPsPorts(pPids, pListenIPs, pListenPorts) 
    result = GenerateResult(pConnMsg)
    return result

def GetNetworkIPs() :
    publicIPsList = []
    ifAddrs = psutil.net_if_addrs()
    for key in ifAddrs.keys() :
        hasIPv4 = False
        hasIPv6 = False
        for msg in ifAddrs[key] :
            if msg.family in (socket.AF_INET, socket.AF_INET6) :
                publicIPsList.append(msg.address)
            if socket.AF_INET == msg.family :
                hasIPv4 = True
                ipv4Addr = msg.address
            if socket.AF_INET6 == msg.family :
                hasIPv6 = True
                ipv6Addr = msg.address
        if hasIPv4 :
            publicIPsList.append('0.0.0.0')
        if hasIPv6 :
            publicIPsList.append('::')
        if hasIPv6 and hasIPv4 :
            publicIPsList.append('::ffff:'+ipv4Addr)
    publicIPs = set(publicIPsList)
    return(publicIPs)


if '__main__' == __name__ :
    if len(sys.argv) != 2 :
        print('usage: getProcessConnections <processName>')
        exit(-100)
    if sys.argv[1] in ('-h', '--help') :
        print('usage: getProcessConnections <processName>')
        exit
    if os.geteuid() :
        args = [sys.executable] + sys.argv
        os.execlp('sudo', 'sudo', *args)
    processName = sys.argv[1]
    publicIPs = GetNetworkIPs()
    result = GetProcessConnections(processName, publicIPs)
    PrintResult(result)

