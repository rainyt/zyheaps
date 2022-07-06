#!/bin/sh
# cd $(dirname $0)

# export PATH=$PATH:$(dirname $0)

# echo $PATH

export DYLD_LIBRARY_PATH=$(dirname $0)/../Frameworks
echo DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH

$(dirname $0)/hl $(dirname $0)/main.hl

exit 0