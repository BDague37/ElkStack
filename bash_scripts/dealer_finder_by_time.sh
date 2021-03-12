#!/bin/bash

grep $2 $1_Dealer_schedule| grep $3 | awk '{print $1,$2,$5,$6}'
