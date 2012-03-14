#!/bin/bash

# set some vars
CURRENTFILENAME="j"
NEWFILENAME=".j_source"
NEWFILEPATH=$HOME
BASHRC=~/.bashrc

# copy src file
cp "$CURRENTFILENAME" "$NEWFILEPATH/$NEWFILENAME"

# source it in .bashrc
echo "" >> $BASHRC
echo "# source Jump source file" >> $BASHRC
echo "source ~/${NEWFILENAME}" >> $BASHRC
