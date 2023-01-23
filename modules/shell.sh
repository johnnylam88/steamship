# steamship/modules/shell.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" shell "*) return ;; esac

# Dependencies
steamship_load_module colors

steamship_shell_init() {
	STEAMSHIP_SHELL_SHOW='false'
	STEAMSHIP_SHELL_PREFIX=''
	STEAMSHIP_SHELL_SUFFIX=${STEAMSHIP_SUFFIX_DEFAULT}
	STEAMSHIP_SHELL_COLOR='WHITE'
}

steamship_shell() {
	sss_name=
	if [ -n "${BASH_VERSION}" ]; then
		sss_name='bash'
	elif [ -n "${KSH_VERSION}" ]; then
		sss_name='ksh'
	elif [ -n "${YASH_VERSION}" ]; then
		sss_name='yash'
	elif [ -n "${ZSH_VERSION}" ]; then
		sss_name='zsh'
	else
		# It's not obvious which Bourne-compatible shell it is.
		sss_name='sh'
	fi

	sss_color=
	sss_colorvar="STEAMSHIP_${STEAMSHIP_SHELL_COLOR}"
	eval 'sss_color=${'"${sss_colorvar}"'}'

	sss_status=
	if [ -n "${sss_name}" ]; then
		sss_status="${sss_status}[${sss_name}]"
	fi
	if [ -n "${sss_status}" ]; then
		sss_status="${sss_color}${sss_status}${STEAMSHIP_BASE_COLOR}"
		if [ "${1}" = '-p' ]; then
			sss_status="${STEAMSHIP_SHELL_PREFIX}${sss_status}"
		fi
		sss_status="${sss_status}${STEAMSHIP_SHELL_SUFFIX}"
	fi

	echo "${sss_status}"
	unset sss_name sss_color sss_colorvar sss_status
}

steamship_shell_prompt() {
	[ "${STEAMSHIP_SHELL_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT_PS1}.
	if [ -n "${STEAMSHIP_PROMPT_PS1}" ]; then
		STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}$(steamship_shell -p)"
	else
		STEAMSHIP_PROMPT_PS1=$(steamship_shell)
	fi
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} shell"
