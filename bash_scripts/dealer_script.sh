#!/bin/bash

grep '05:00:00 AM' $1 | awk '{print $1,$2,$5,$6}' >> Dealer_Losses_log
grep '08:00:00 AM' $1 | awk '{print $1,$2,$5,$6}' >> Dealer_Losses_log
grep '02:00:00 PM' $1 | awk '{print $1,$2,$5,$6}' >> Dealer_Losses_log
grep '08:00:00 PM' $1 | awk '{print $1,$2,$5,$6}' >> Dealer_Losses_log
grep '11:00:00 PM' $1 | awk '{print $1,$2,$5,$6}' >> Dealer_Losses_log
