#!/bin/bash

# Compile the kernel and modules using bitbake for quick deployment

set -e

PROG_NAME="./compile.sh"

print_usage()
{
   echo "Usage: ${PROG_NAME} -t [TARGET] [OPTIONS]"
   echo
   echo "Options:"
   echo "  -t   Linux target (required)"
   echo "  -f   Force clean and fetch"
   echo "  -m   modules/dtb only"
   echo
}



target=""
modules_only=0
force=0

while getopts "t:hfm" flag ;do
   case ${flag} in
   t)
      target=$OPTARG
      ;;
	h)
      print_usage
      exit 0
      ;;
	f)
      force=1
      ;;
   m)
      modules_only=1
      ;;
	?)
	    echo "${PROG_NAME}: Invalid option: ${OPTARG}."
	    echo "Try \`${PROG_NAME} -h' for more information."
	    exit 1
	    ;;
    esac
done

if [ -z ${target} ]; then
   print_usage
   exit 1
fi

if [ ${force} -eq 1 ]; then
   echo "Force clean and fetch..."
   bitbake -f ${target} -cclean
   bitbake -f ${target}
else
   if [ ${modules_only} -eq 0 ]; then
      echo "Compiling image..."
      bitbake -f ${target} -ccompile
   fi
   echo "Compiling and deploying..."
   bitbake -f ${target} -cdeploy
fi

echo "done"
