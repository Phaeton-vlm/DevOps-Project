#!/bin/bash

start_time=$(date +%S)

find / -maxdepth 3 -and -type d
#manual delay for test
sleep 2

end_time=$(date +%S)
diff=$(( "${end_time}" - "${start_time}" ))

echo "____________________________________"
echo "It took ${diff} seconds"
