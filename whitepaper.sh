#!/bin/bash
# Title: From MD/s produce sibling XML, FO, and PDF
#        Requires whitepaper.xsl as sibling
# Author: stephen@kx.com
# Version: 2018.10.21

#https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
# defaults
# DESTINATION=`pwd`
HELP=NO
OUTPUT="" # defaults to first MD in manifest
MANIFEST=() # MDs
PAPERSIZES=("a4" "us")
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
		for ps in ${PAPERSIZES[@]}
		do
			output=$filename-$ps
			# XML => FO
			# Saxon XSLT processor in XEP choking on amespace [?] issue
			# good idea for debugging to write separate FO anyway
			cmd="xsltproc -o $output.fo --stringparam paper-size \"$ps\" whitepaper.xsl $filename.xml" # db
			printf "$cmd\n" # db
			eval $cmd
			ERR=$?
			if [ $ERR != 0 ]
			then
				RES+="XSLT error $ERR\n"
			else
				RES+="Wrote $output.fo\n"
				# FO => PDF
				cmd="/Users/sjt/Tools/XEP/xep $output.fo" # db
				printf "$cmd\n" # db
				eval $cmd
				ERR=$?
				if [ $ERR != 0 ]
				then
					RES+="XEP error $ERR\n"
				else
					RES+="Wrote $output.pdf\n"
					eval "rm $output.fo"
					RES+="Removed $output.fo\n"
				fi
			fi
		done
		if [ $ERR = 0 ]
		then
			# remove XML
			eval "rm $filename.xml"
			RES+="Removed $filename.xml\n"
			# remove consolidated MD
			cmd="rm "
			for MD in ${MANIFEST[@]}
			do
				cmd+=" $MD"
			done
			eval $cmd
			RES+="Removed $cmd\n"
		fi
	fi
fi

# clean up and report results
if [ $ERR != 0 ]
then
	RES+="$USAGE\n"
fi
echo -e $RES
exit $ERR
