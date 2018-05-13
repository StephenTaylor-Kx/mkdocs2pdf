#!/bin/bash
# Title: From MD/s produce sibling XML, FO, and PDF
#        Requires whitepaper.xsl as sibling
# Author: stephen@kx.com

#https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
# defaults
# DESTINATION=`pwd`
HELP=NO
OUTPUT="" # defaults to first MD in manifest
MANIFEST=() # MDs
RES="" # result report
UNKNOWN=() # unidentified options
USAGE='Usage: whitepaper.sh [ [-?|-h|--help] | [ [-o|--output] output] file [file [file] … ] ]'

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    # -d|--destination)
    # DESTINATION="$2" # destination directory
    # shift # past argument
    # shift # past value
    # ;;
    \?|-h|--help)
    HELP=YES
    shift # past argument
    ;;
    -o|--output)
    OUTPUT="$2" # PDF filename withOUT extension, e.g. websoockets
    shift # past argument
    shift # past value
    ;;
    -?)    # unknown option
    UNKNOWN+=("$1") # save it in an array 
    shift # past argument
    ;;
    *)    # unknown something
    MANIFEST+=("$1") # save it in an array
    shift # past argument
    ;;
esac
done
set -- "${MANIFEST[@]}" # restore MANIFEST parameters

COUNT=${#MANIFEST[@]}

# validate arguments
if [ "$HELP" = "YES" ]
	then
	ERR=1
# elif [ ! -d $DESTINATION ]
# then
# 	ERR=2
# 	EMSG="Not a directory: $DESTINATION"
elif [ $COUNT = 0 ]
	then
	ERR=3
	RES+='No file/s specified\n'
elif [ "${#UNKNOWN}" -gt 0 ]
	then 
	ERR=4
	RES+="Unknown options: ${UNKNOWN[*]}\n"
else
	# MD => XML
	# write DocBook XML as sibling of MD/s
	# to retain use of relative filepaths
	SOURCEDIR=`dirname ${MANIFEST[0]}`
	if [ "$OUTPUT" == "" ]
	then
		OUTPUT=`basename ${MANIFEST[0]} .md`
	fi
	filename=$SOURCEDIR/$OUTPUT

	pandoc="pandoc -f markdown+yaml_metadata_block+pipe_tables"
	pandoc+=" --template whitepaper.template"
	pandoc+=" -t docbook5"
	pandoc+=" -o $filename.xml"
	pandoc+=" --section-divs --standalone"
	for MD in ${MANIFEST[@]}
	do
		pandoc+=" $MD"
	done
	printf "$pandoc\n" # db
	eval "$pandoc"
	ERR=$?
	if [ $ERR != 0 ]
		then
		RES+="Pandoc error $ERR\n"
	else
		RES+="Wrote $filename.xml\n"
		# XML => FO
		# Saxon XSLT processor in XEP choking on amespace [?] issue
		# good idea for debugging to write separate FO anyway
		printf "xsltproc -o $filename.fo whitepaper.xsl $filename.xml\n" # db
		eval "xsltproc -o $filename.fo whitepaper.xsl $filename.xml"
		ERR=$?
		if [ $ERR != 0 ]
			then
			RES+="XSLT error $ERR\n"
		else
			RES+="Wrote $filename.fo\n"
			# FO => PDF
			printf "/Users/sjt/Tools/XEP/xep $filename.fo\n" # db
			eval "/Users/sjt/Tools/XEP/xep $filename.fo"
			ERR=$?
			if [ $ERR != 0 ]
				then
				RES+="XEP error $ERR\n"
			else
				RES+="Wrote $filename.pdf\n"
			fi
		fi
	fi
fi

# report results
if [ $ERR != 0 ]
	then
	RES+="$USAGE\n"
fi
echo -e $RES
exit $ERR
