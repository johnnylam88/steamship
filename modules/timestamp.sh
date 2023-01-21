# steamship/modules/timestamp.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" timestamp "*) return ;; esac

# Dependencies
steamship_load_module colors

steamship_timestamp_init() {
	STEAMSHIP_TIMESTAMP_SHOW='false'
	STEAMSHIP_TIMESTAMP_PREFIX='at '
	STEAMSHIP_TIMESTAMP_SUFFIX=${STEAMSHIP_SUFFIX_DEFAULT}
	STEAMSHIP_TIMESTAMP_12HR='false'
	STEAMSHIP_TIMESTAMP_COLOR='YELLOW'

	steamship_timestamp_available='false'
	if	[ -n "${BASH_VERSION}" ] ||
		[ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ]
	then
		steamship_timestamp_available='true'
	fi
}

steamship_timestamp() {
	sstc_time=
	if [ -n "${BASH_VERSION}" ]; then
		if [ "${STEAMSHIP_TIMESTAMP_12HR}" = true ]; then
			sstc_time='\T'
		else
			sstc_time='\t'
		fi
	elif [ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ]; then
		if [ "${STEAMSHIP_TIMESTAMP_12HR}" = true ]; then
			# shellcheck disable=SC2016
			sstc_time='$(date +%I:%M:%S)'
		else
			# shellcheck disable=SC2016
			sstc_time='$(date +%T)'
		fi
	fi

	sstc_color=
	sstc_colorvar="STEAMSHIP_${STEAMSHIP_TIMESTAMP_COLOR}"
	eval 'sstc_color=${'"${sstc_colorvar}"'}'

	sstc_status=${sstc_time}
	if [ -n "${sstc_status}" ]; then
		sstc_status="${sstc_color}${sstc_status}${STEAMSHIP_BASE_COLOR}"
		if [ "${1}" = '-p' ]; then
			sstc_status="${STEAMSHIP_TIMESTAMP_PREFIX}${sstc_status}"
		fi
		sstc_status="${sstc_status}${STEAMSHIP_TIMESTAMP_SUFFIX}"
	fi

	echo "${sstc_status}"
	unset sstc_time sstc_color sstc_colorvar sstc_status
}

steamship_timestamp_prompt() {
	[ "${steamship_timestamp_available}" = true ] || return
	[ "${STEAMSHIP_TIMESTAMP_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT_PS1}.
	if [ -n "${STEAMSHIP_PROMPT_PS1}" ]; then
		STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}$(steamship_timestamp -p)"
	else
		STEAMSHIP_PROMPT_PS1=$(steamship_timestamp)
	fi
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} timestamp"
