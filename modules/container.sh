# steamship/modules/container.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" container "*) return ;; esac

# Dependencies
steamship_load_module colors

steamship_container_init() {
	STEAMSHIP_CONTAINER_SHOW='true'
	STEAMSHIP_CONTAINER_PREFIX='on '
	STEAMSHIP_CONTAINER_SUFFIX=${STEAMSHIP_SUFFIX_DEFAULT}
	STEAMSHIP_CONTAINER_SYMBOL='⬢ '
	STEAMSHIP_CONTAINER_COLOR='CYAN'

	steamship_container_env_file='/run/.containerenv'
}

steamship_container() {
	ssc_name=
	if [ -f "${steamship_container_env_file}" ]; then
		# shellcheck disable=SC1090,SC2154
		ssc_name=$(. "${steamship_container_env_file}" && printf '%s' "${name}")
	fi
	ssc_color=
	ssc_colorvar="STEAMSHIP_${STEAMSHIP_CONTAINER_COLOR}"
	eval 'ssc_color=${'"${ssc_colorvar}"'}'

	ssc_status=
	if [ -n "${ssc_name}" ]; then
		if [ -n "${STEAMSHIP_CONTAINER_SYMBOL}" ]; then
			ssc_status=${STEAMSHIP_CONTAINER_SYMBOL}
		fi
		ssc_status="${ssc_status}${ssc_name}"
	fi
	if [ -n "${ssc_status}" ]; then
		ssc_status="${ssc_color}${ssc_status}${STEAMSHIP_BASE_COLOR}"
		if [ "${1}" = '-p' ]; then
			ssc_status="${STEAMSHIP_CONTAINER_PREFIX}${ssc_status}"
		fi
		ssc_status="${ssc_status}${STEAMSHIP_CONTAINER_SUFFIX}"
	fi

	echo "${ssc_status}"
	unset ssc_name ssc_color ssc_colorvar ssc_status
}

steamship_container_prompt() {
	[ "${STEAMSHIP_CONTAINER_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT_PS1}.
	if [ -n "${STEAMSHIP_PROMPT_PS1}" ]; then
		STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}$(steamship_container -p)"
	else
		STEAMSHIP_PROMPT_PS1=$(steamship_container)
	fi
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} container"
