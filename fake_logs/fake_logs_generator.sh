#!/bin/bash
#
# This tool simulates Tomcat by generating logs
#
# V1.0
#

# Every Bash script should include this to exit script immediately if non-true value appeared
set -e

logs_dir='/tmp/tomcat-logs'
echo "Logs dir is ${logs_dir}"

# The trap statement tells the script to run received_signal() on signals 1, 2, 3 or 6. The most common one (CTRL-C) is signal 2 (SIGINT).
trap received_signal 1 2 3 6

received_signal()
{
  echo "Caught Signal ... Doing clean up."
  /bin/rm -f ${logs_dir}/fake_*
  echo "Exiting."
  exit 1
}

# I have written this script on Mac OS
if uname -s | grep -iq ^Darwin
then
  script_dir=`greadlink -f $0`
else
  script_dir=`readlink -f $0`
fi
echo "Script dir is ${script_dir}"

script_location=`dirname $script_dir`
echo "Script location is ${script_location}"

mkdir -p $logs_dir

fake_logs () {
  # Going through log files... also ensuring that 1) file type is text 2) there is pipe to while loop because we prefer to use memory instead of disk e.g. /tmp/log_file_list.txt
  file -I ${script_location}/* | grep -E ':[\t ]*text/plain' | awk -F ':' '{print $1}' | while read log_location
  do
    log_name=`basename "${log_location}"`

    case $1 in
	  generate)
      cat "$log_location" >> "${logs_dir}/fake_${log_name}"
		  ;;
	  remove)
		  /bin/rm -f "${logs_dir}/fake_${log_name}"
		  ;;
	  *)
		  echo "Error in function ${FUNCNAME[0]}: Sorry, I don't understand"
      exit 1
		  ;;
    esac

      echo "${1} ${log_name} ..."
  done
}

# Action starts here
fake_logs generate
sleep 5
fake_logs remove
sleep 5
fake_logs generate
sleep 5
fake_logs remove
