#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#=======================================================================
#
# binextract.py
# -------------
# Reads file with read data word logs and extracts the binary data. 
# Redirect std out to target file.
#
# 
# Author: Joachim Strömbergson
# Copyright (c) 2014, Secworks Sweden AB
# 
# Redistribution and use in source and binary forms, with or 
# without modification, are permitted provided that the following 
# conditions are met: 
# 
# 1. Redistributions of source code must retain the above copyright 
#    notice, this list of conditions and the following disclaimer. 
# 
# 2. Redistributions in binary form must reproduce the above copyright 
#    notice, this list of conditions and the following disclaimer in 
#    the documentation and/or other materials provided with the 
#    distribution. 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#=======================================================================
 
#-------------------------------------------------------------------
# Python module imports.
#-------------------------------------------------------------------
import sys
import os

 
#-------------------------------------------------------------------
# Defines.
#-------------------------------------------------------------------
# Verbose operation on/off
VERBOSE = False


#-------------------------------------------------------------------
# main()
#
# Parse any arguments and run the tests.
#-------------------------------------------------------------------
def main():
    num_bytes = 2
    file_name = sys.argv[1]

    with open(file_name, 'r') as my_file:
        for line in my_file:
            byte0 = int(line[34 : 36], 16)
            byte1 = int(line[32 : 34], 16)

            if (num_bytes == 4):
                byte2 = int(line[30 : 32], 16)
                byte3 = int(line[28 : 30], 16)
            else:
                print(chr(byte1), end='')
                print(chr(byte0), end='')

#-------------------------------------------------------------------
# __name__
# Python thingy which allows the file to be run standalone as
# well as parsed from within a Python interpreter.
#-------------------------------------------------------------------
if __name__=="__main__": 
    # Run the main function.
    sys.exit(main())


#=======================================================================
# EOF binextract.py
#=======================================================================
