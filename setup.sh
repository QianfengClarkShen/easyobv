#!/bin/bash
if [ -z "`pip3 list | grep libfpga`" ]; then
    pip3 install libfpga
else
    pip3 install libfpga --upgrade
fi
if [ -z "`pip3 list | grep libeasyobv`" ]; then
    pip3 install libeasyobv
else
    pip3 install libeasyobv --upgrade
fi
