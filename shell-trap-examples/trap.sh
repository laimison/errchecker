#!/bin/sh

# The trap statement tells the script to run cleanup() on signals 1, 2, 3 or 6. The most common one (CTRL-C) is signal 2 (SIGINT).
trap cleanup 1 2 3 6

cleanup()
{
  echo "Caught Signal ... cleaning up."
  rm -rf /tmp/temp_$$.*
  echo "Done cleanup ... quitting."
  exit 1
}

for i in `seq 0 100`
do
  echo $i | tee -a /tmp/temp_$$.${i}
  sleep 1
done
