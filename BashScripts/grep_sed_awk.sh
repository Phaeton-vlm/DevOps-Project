#!/bin/bash


wget -O test1.html https://www.atlassian.com/continuous-delivery/continuous-integration

#1 way
grep -oi "continuous integration" 1.html | wc -l
#2 way
curl https://www.atlassian.com/continuous-delivery/continuous-integration | grep -oi "continuous integration" | wc -l
#3 way
curl https://www.atlassian.com/continuous-delivery/continuous-integration | grep -oi "continuous integration" | awk '$1 {sum++} END {print sum}'



# replace continuous integration
cp -f test1.html test2.html
sed -Ei 's/(continuous integration)/CI/ig' test2.html
grep -o "CI" test2.html | wc -l
