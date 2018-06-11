#!/usr/bin/env python3

import sys
import base64

print(base64.b64encode(sys.argv[1].encode(sys.getdefaultencoding())).decode(sys.getdefaultencoding()))
