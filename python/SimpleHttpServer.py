#!/usr/bin/env python3
nohup python3 -m http.server 8888 --bind 0.0.0.0 >/dev/null 2>&1 echo $! >/tmp/SimpleHttpServer.pid
