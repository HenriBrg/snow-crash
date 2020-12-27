#!/usr/bin python

import sys
output = ""
if len(sys.argv) == 3:
        if sys.argv[1] == "encrypt":
            y = sys.argv[2]
            for index, c in enumerate(y):
                output += chr(ord(c) + index)
        elif sys.argv[1] == "decrypt":
            y = sys.argv[2]
            for index, c in enumerate(y):
                output += chr(ord(c) - index)
print output