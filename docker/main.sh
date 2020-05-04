#!/usr/bin/env bash

# Input:
#     --params  Json parameters folder
#     --data    Input  folder
#     --output  Output folder
#     --nproc   Number of processors (int)

while test -n "$1"; do
    case "$1" in
        --data)
            shift
            DATA="$1"
            ;;

        --src)
            shift
            SRC="$1"
            ;;

        --output)
            shift
            OUTPUT="$1"
            ;;

        --params)
            shift
            JSON_FOLDER="$1"
            ;;

        --nproc)
            shift
            NPROC="$1"
            ;;

        *)
            echo "Invalid option $1; allowed: --src --data --params --output --nproc" >&2
            exit 1
            ;;
    esac
    shift
done

#############
# This is where the single-run modelling R command can go ... ?
#############

# IMPORTANT! /pfs/ filesystem uses symlinks
# So need -L in the find command.
paramsFILE=$(find -L "$JSON_FOLDER" -type f | sed 1q)
SEED=$(jq -r '.seed' ${paramsFILE})

ERROR_CHECK_THIS=$(find -L "$JSON_FOLDER" -type f | wc -l)
if ! test $ERROR_CHECK_THIS = 1; then
    echo "Wrong number of parameters?!?!" >&2
    find -L "$JSON_FOLDER" -type f >&2
    echo "There should be one file." >&2
    exit 1
fi

  dataDIR="$DATA"
  codeDIR="$SRC"
outputDIR="$OUTPUT/$SEED"
mkdir -p ${outputDIR}

if test -z "$NPROC"; then
    # default
    NPROC=2
fi


 myRscript=${codeDIR}/main-pachyderm.R
stdoutFile=${outputDIR}/stdout.R.`basename ${myRscript} .R`
stderrFile=${outputDIR}/stderr.R.`basename ${myRscript} .R`
R --no-save --args ${dataDIR} ${paramsFILE} ${codeDIR} ${outputDIR} ${NPROC} < ${myRscript} > >(tee -a ${stdoutFile}) 2> >(tee -a ${stderrFile} >&2)

echo 'R finished.'
