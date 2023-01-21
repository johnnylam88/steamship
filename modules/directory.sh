# steamship/modules/directory.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" directory "*) return ;; esac

# Dependencies
steamship_load_module colors

steamship_directory_init() {
	STEAMSHIP_DIRECTORY_SHOW='true'
	STEAMSHIP_DIRECTORY_PREFIX='in '
	STEAMSHIP_DIRECTORY_SUFFIX=${STEAMSHIP_SUFFIX_DEFAULT}
	STEAMSHIP_DIRECTORY_TRUNCATE='3'
	STEAMSHIP_DIRECTORY_TRUNCATE_PREFIX='…/'
	STEAMSHIP_DIRECTORY_TRUNCATE_REPO='true'
	STEAMSHIP_DIRECTORY_COLOR='CYAN'
	STEAMSHIP_DIRECTORY_LOCK_SYMBOL=' '
	STEAMSHIP_DIRECTORY_LOCK_COLOR='RED'
}

steamship_directory_truncate_repo_path() {
	ssdrp_dir=${PWD}
	ssdrp_toplevel=$(steamship_git_repo_path)
	ssdrp_pwd=
	ssdrp_proj=
	if [ -n "${ssdrp_toplevel}" ]; then
		ssdrp_pwd=$(pwd -P)
		if [ "${ssdrp_pwd}" = "${ssdrp_toplevel}" ]; then
			ssdrp_proj=${ssdrp_dir##*/}
			ssdrp_dir=${ssdrp_proj}
		else
			ssdrp_proj=${ssdrp_toplevel##*/}
			ssdrp_dir="${ssdrp_proj}${ssdrp_pwd#"${ssdrp_toplevel}"}"
		fi
	fi
	echo "${ssdrp_dir}"
	unset ssdrp_dir ssdrp_toplevel ssdrp_pwd ssdrp_proj
}

steamship_directory_truncate_path() {
	ssdtp_dir=${PWD}

	# Tilde substitution for ${HOME}.
	case ${ssdtp_dir} in
	"${HOME}")
		ssdtp_dir='~'
		;;
	"${HOME}"/*)
		# shellcheck disable=SC2088
		ssdtp_dir="~/${ssdtp_dir#"${HOME}/"}"
		;;
	esac

	# Truncate to last ${STEAMSHIP_DIRECTORY_TRUNCATE} components of path.
	ssdtp_chop=
	case ${STEAMSHIP_DIRECTORY_TRUNCATE} in
	1)	ssdtp_chop="${ssdtp_dir%/*}/"
		;;
	2)	case ${ssdtp_dir} in
		*/*)	ssdtp_chop="${ssdtp_dir%/*/*}/" ;;
		esac
		;;
	3)	case ${ssdtp_dir} in
		*/*/*)	ssdtp_chop="${ssdtp_dir%/*/*/*}/" ;;
		esac
		;;
	4)	case ${ssdtp_dir} in
		*/*/*/*)
				ssdtp_chop="${ssdtp_dir%/*/*/*/*}/" ;;
		esac
		;;
	5)	case ${ssdtp_dir} in
		*/*/*/*/*)
				ssdtp_chop="${ssdtp_dir%/*/*/*/*/*}/" ;;
		esac
		;;
	esac
	case X${ssdtp_chop} in
	X/)	;;
	*)	ssdtp_dir=${ssdtp_dir#"${ssdtp_chop}"} ;;
	esac
	case ${ssdtp_dir} in
	'~'|'~'/*|/*)
		;;
	*)	ssdtp_dir="${STEAMSHIP_DIRECTORY_TRUNCATE_PREFIX}${ssdtp_dir}"
		;;
	esac
	echo "${ssdtp_dir}"
	unset ssdtp_dir ssdtp_chop
}

steamship_directory() {
	ssd_dir=
	if [ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ]; then
		if	[ "${STEAMSHIP_DIRECTORY_TRUNCATE_REPO}" = true ] &&
			steamship_is_git
		then
			ssd_dir=$(steamship_directory_truncate_repo_path)
		else
			ssd_dir=$(steamship_directory_truncate_path)
		fi
	elif [ -n "${BASH_VERSION}" ]; then
		ssd_dir='\w'
	else
		# shellcheck disable=SC2016
		ssd_dir='${PWD}'
	fi

	ssd_color=
	ssd_colorvar="STEAMSHIP_${STEAMSHIP_DIRECTORY_COLOR}"
	eval 'ssd_color=${'"${ssd_colorvar}"'}'

	ssd_lock_color=
	ssd_lock_colorvar="STEAMSHIP_${STEAMSHIP_DIRECTORY_LOCK_COLOR}"
	eval 'ssd_lock_color=${'"${ssd_lock_colorvar}"'}'
	ssd_lock="${ssd_lock_color}${STEAMSHIP_DIRECTORY_LOCK_SYMBOL}${STEAMSHIP_BASE_COLOR}"

	ssd_status=${ssd_dir}
	if [ -n "${ssd_status}" ]; then
		ssd_status="${ssd_color}${ssd_status}${STEAMSHIP_BASE_COLOR}"
		if [ ! -w . ]; then
			# Add the lock symbol for a non-writable directory.
			ssd_status="${ssd_status}${ssd_lock}"
		fi
		if [ "${1}" = '-p' ]; then
			ssd_status="${STEAMSHIP_DIRECTORY_PREFIX}${ssd_status}"
		fi
		ssd_status="${ssd_status}${STEAMSHIP_DIRECTORY_SUFFIX}"
	fi

	echo "${ssd_status}"
	unset ssd_lock ssd_lock_color ssd_lock_colorvar
	unset ssd_dir ssd_color ssd_colorvar ssd_status
}

steamship_directory_prompt() {
	[ "${STEAMSHIP_PROMPT_PARAM_EXPANSION}" = true ] || return
	[ "${STEAMSHIP_DIRECTORY_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT_PS1}.
	if [ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ]; then
		if [ -n "${STEAMSHIP_PROMPT_PS1}" ]; then
			# shellcheck disable=SC2016
			STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}"'$(steamship_directory -p)'
		else
			# shellcheck disable=SC2016
			STEAMSHIP_PROMPT_PS1='$(steamship_directory)'
		fi
	else
		if [ -n "${STEAMSHIP_PROMPT_PS1}" ]; then
			STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}$(steamship_directory -p)"
		else
			STEAMSHIP_PROMPT_PS1=$(steamship_directory)
		fi
	fi
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} directory"
