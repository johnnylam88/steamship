# steamship/modules/exit_code.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" exit_code "*) return ;; esac

# Dependencies
steamship_load_module colors

steamship_exit_code_init() {
	STEAMSHIP_EXIT_CODE_SHOW='false'
	STEAMSHIP_EXIT_CODE_PREFIX=''
	STEAMSHIP_EXIT_CODE_SUFFIX=${STEAMSHIP_SUFFIX_DEFAULT}
	STEAMSHIP_EXIT_CODE_SYMBOL='✘ '
	STEAMSHIP_EXIT_CODE_COLOR=${STEAMSHIP_COLOR_FAILURE}
}

steamship_exit_code() {
	[ "${STEAMSHIP_RETVAL}" = 0 ] && return

	ssec_color=
	ssec_colorvar="STEAMSHIP_${STEAMSHIP_EXIT_CODE_COLOR}"
	eval 'ssec_color=${'"${ssec_colorvar}"'}'

	ssec_status=
	if [ -n "${STEAMSHIP_RETVAL}" ]; then
		if [ -n "${STEAMSHIP_EXIT_CODE_SYMBOL}" ]; then
			ssec_status=${STEAMSHIP_EXIT_CODE_SYMBOL}
		fi
		ssec_status="${ssec_status}${STEAMSHIP_RETVAL}"
	fi
	if [ -n "${ssec_status}" ]; then
		ssec_status="${ssec_color}${ssec_status}${STEAMSHIP_BASE_COLOR}"
		if [ "${1}" = '-p' ]; then
			ssec_status="${STEAMSHIP_EXIT_CODE_PREFIX}${ssec_status}"
		fi
		ssec_status="${ssec_status}${STEAMSHIP_EXIT_CODE_SUFFIX}"
	fi

	echo "${ssec_status}"
	unset ssec_color ssec_colorvar ssec_status
}

steamship_exit_code_prompt() {
	[ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ] || return
	[ "${STEAMSHIP_EXIT_CODE_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT_PS1}.
	if [ -n "${STEAMSHIP_PROMPT_PS1}" ]; then
		# shellcheck disable=SC2016
		STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}"'$(steamship_exit_code -p)'
	else
		# shellcheck disable=SC2016
		STEAMSHIP_PROMPT_PS1='$(steamship_exit_code)'
	fi
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} exit_code"
