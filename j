_jALIASFILE=~/.j_alias
shopt -s extglob

################################################################################

# j add d ~/Documents # add ~/Documents with alias d
# j d # jump to directory alias'd d
# j list # list aliases
# j rm d # remove alias for d
# j add h # add current dir with alias h

# alias file format
# alias ${ALIASPREFIX}<alias>='cd <directory> && pwd'

_jerror () {
    echo "${1}" >&2
}

_jadd () {
	jALIAS=$1
	DIRECTORY=$2
	# check whether dir exists
	if [ ! -d "${DIRECTORY}" ]; then
	    _jerror "${DIRECTORY} does not exist!"
		return 1
	fi
	# check whether alias already exists
	if grep -q "^${jALIAS}=" $_jALIASFILE; then
	    _jerror "The alias ${jALIAS} already exists!"
		return 1
	fi
	# remove trailing slash
	DIRECTORY=`echo ${DIRECTORY} | sed -e 's/\/$//'`
	# add alias to the list
	echo "${jALIAS}=${DIRECTORY}" >> $_jALIASFILE
}

_jrm () {
	jALIAS=$1
	# remove alias from list
	TMP=`grep -v "^${jALIAS}=" ${_jALIASFILE}` && echo "$TMP" > $_jALIASFILE 
}

_jlist () {
	# cat aliases
	cat $_jALIASFILE #| sed -e "s/=/ = /"
}


_jjump () {
	_jALIAS=$1
	if [[ -d "$_jALIAS" ]]; then
		DIR=$_jALIAS
	else
	# verify alias name
		DIR=`grep "^${_jALIAS}=" $_jALIASFILE | sed 's/^.*=//'`
		if [ "$DIR" == "" ]; then
			_jerror "${_jALIAS} does not exist!"
		fi
	fi
	# jump
	cd $DIR
}

j () {
	case "$1" in
		"add")
			if [ "$2" == "" ]; then
				_jerror "Please give at least an alias!"
				return 1
			fi
			jALIAS=$2
			DIRECTORY=$3
			if [ "$DIRECTORY" == "" ]; then
				DIRECTORY=`pwd`
			fi
			_jadd $jALIAS $DIRECTORY
		  ;;
		"rm")
			if [ "$2" == "" ]; then
				_jerror "Please give at least an alias!"
				return 1
			fi
			jALIAS=$2
			_jrm $jALIAS
		  ;;
		"")
			_jlist
		  ;;
		"ls")
			_jlist
		  ;;
		*)
			# jump
			jALIAS=$1
			_jjump $jALIAS
		  ;;
	esac
}

_j () {
#    local cur prev opts tmp
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

	# We want auto completion to either complete aliases _or_ to complete directories
	# when the alias has already been expanded. So if the $cur is a valid directory,
	# behave like a normal cd
#	if [[ -d "${cur}" ]]; then
#		COMPREPLY=( `compgen -d -- ${cur}` )
#		echo $COMPREPLY
##		oopts=`ls -d ${cur}*`
##		COMPREPLY=( `compgen -W "${oopts}" -- ${cur}` )
#		return 0
#	fi

			opts=`_jlist | grep ^$cur` # this greps all if $cur is empty
			numopts=`echo "${opts}" | wc -l`
			if [[ "$opts" != "" && "$numopts" -eq 1 ]]; then # exact match, replace alias with actual dir
				# get dir
				opts=`echo "${opts}" | sed -e "s/^.*=//"`
				# replace alias on cmd line with dir
				read tmp<<-EOF
					$opts
				EOF
				COMPREPLY=("${tmp}/") # add '/' to have direct auto-completion support on next [TAB]
				return 0
			elif [[ "$numopts" -gt 1 ]]; then # when there are several choices, print them
#				echo "2"
				COMPREPLY=( `compgen -W "${opts}" -- ${cur}` )
				return 0
			else # no corresponding alias, complete withe dirnames
#				echo "uieuiae"
				COMPREPLY=()
				return 0
			fi
#	if [[ $COMP_CWORD -eq 1 ]]; then # first arg
#	    if [[ ${cur} == "" ]] ; then
			# propose all aliases
#		else
			# propose matching aliases
#			echo $cur
#			opts=`_jlist | grep ^$cur`
#			COMPREPLY=( `compgen -W "${opts}" -- ${cur}` )
#	        return 0
#			if [[ `echo "${opts}" | wc -l` -eq 1 ]]; then # repl
	        #COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
#			echo $opts
			#opts=`echo $opts | sed -e "s/^.*=//"`
#			echo $opts
#			comps="$opts"
#			read k<<EOF
#			$opts
#EOF
#			COMPREPLY=("${k}")
#			while read i
#        	do
#        	    COMPREPLY=("${COMPREPLY[@]}" "${i}")
#        	done <<EOF
#        	$comps
#EOF
	    #fi
#	fi
}

__j () {
        local cur
        cur=${COMP_WORDS[*]:1}
		echo $cur
        comps=$(autojump --bash --completion $cur)
		comps="uiae "
		echo $COMPREPLY
        while read i
        do
            COMPREPLY=("${COMPREPLY[@]}" "${i}")
        done <<EOF
        $comps
EOF
}
#~$ _jlist | sed -e "s/ =.*$//" | paste -sd " "

_k () {
    COMPREPLY=("uiae uiae uiae uiae ")
    COMPREPLY=()
}

alias c='cd'
complete -o dirnames -F _k c
complete -o nospace -o dirnames -F _j j
complete -o dirnames uuu
# MAIN

#if [ $# -eq 1 ]; then
#	jump
#else
#fi

