_jALIASFILE=~/.j_alias
shopt -s extglob

################################################################################

# j add d ~/Documents # add ~/Documents with alias d
# j d # jump to directory alias'd d
# j list # list aliases
# j rm d # remove alias for d
# j add h # add current dir with alias h

# alias file format
#$ALIAS=$DIR

_jerror () {
    echo "${1}" >&2
}

_jadd () {
	ALIAS=$1
	DIRECTORY=$2
	# check whether dir exists
	if [ ! -d "${DIRECTORY}" ]; then
	    _jerror "${DIRECTORY} does not exist!"
		return 1
	fi
	# check whether alias already exists
	if grep -q "^${ALIAS}=" $_jALIASFILE; then
	    _jerror "The alias ${ALIAS} already exists!"
		return 1
	fi
	# remove trailing slash
	DIRECTORY=`echo ${DIRECTORY} | sed -e 's/\/$//'`
	# add alias to the list
	echo "${ALIAS}=${DIRECTORY}" >> $_jALIASFILE
}

_jrm () {
	ALIAS=$1
	# remove alias from list
	TMP=`grep -v "^${ALIAS}=" ${_jALIASFILE}` && echo "$TMP" > $_jALIASFILE
}

_jlist () {
	# cat aliases
	cat $_jALIASFILE #| sed -e "s/=/ = /"
}


_jjump () {
	ALIAS=$1
	if [[ -d "$ALIAS" ]]; then
		DIR=$ALIAS
	else
		# verify alias name
		DIR=`grep "^${ALIAS}=" $_jALIASFILE | sed 's/^.*=//'`
		if [ "$DIR" == "" ]; then
			_jerror "${ALIAS} does not exist!"
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
			ALIAS=$2
			DIRECTORY=$3
			if [ "$DIRECTORY" == "" ]; then
				DIRECTORY=`pwd`
			fi
			_jadd $ALIAS $DIRECTORY
		  ;;
		"rm")
			if [ "$2" == "" ]; then
				_jerror "Please give at least an alias!"
				return 1
			fi
			shift
			for ALIAS in "$@"
			do
				_jrm $ALIAS
			done
		  ;;
		"")
			_jlist
		  ;;
		"ls")
			_jlist
		  ;;
		*)
			# jump
			ALIAS=$1
			_jjump $ALIAS
		  ;;
	esac
}

_j () {
#    local cur prev opts tmp
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    first="${COMP_WORDS[0]}"

	if [[ "$prev" == "$first" ]]; then
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
	fi
}

complete -o nospace -o dirnames -F _j j
