#!/bin/bash

wget -nv -q -O ~/~password http://www.passwordrandom.com/query?command=password

echo "Password generated: $(cat ~/~password)"
