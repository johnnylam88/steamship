# steamship/modules/character.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" character "*) return ;; esac

# Dependencies
steamship_load_module colors

steamship_character_init() {
	STEAMSHIP_CHARACTER_SHOW='true'
	STEAMSHIP_CHARACTER_PREFIX=''
	STEAMSHIP_CHARACTER_SUFFIX=''
	STEAMSHIP_CHARACTER_SYMBOL='$ '
	STEAMSHIP_CHARACTER_SYMBOL_ROOT='# '
	STEAMSHIP_CHARACTER_SYMBOL_SUCCESS=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_CHARACTER_SYMBOL_FAILURE=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_CHARACTER_COLOR_SUCCESS=${STEAMSHIP_COLOR_SUCCESS}
	STEAMSHIP_CHARACTER_COLOR_FAILURE=${STEAMSHIP_COLOR_FAILURE}
	STEAMSHIP_CHARACTER_SYMBOL_SECONDARY=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_CHARACTER_COLOR_SECONDARY='YELLOW'
}

steamship_character_ps1() {
	ssc_symbol=
	ssc_color=
	ssc_colorvar=
	if [ -z "${STEAMSHIP_RETVAL}" ]; then
		ssc_colorvar='STEAMSHIP_BASE_COLOR'
		ssc_symbol=${STEAMSHIP_CHARACTER_SYMBOL}
	elif [ "${STEAMSHIP_RETVAL}" = 0 ]; then
		ssc_colorvar="STEAMSHIP_${STEAMSHIP_CHARACTER_COLOR_SUCCESS}"
		ssc_symbol=${STEAMSHIP_CHARACTER_SYMBOL_SUCCESS}
	else
		ssc_colorvar="STEAMSHIP_${STEAMSHIP_CHARACTER_COLOR_FAILURE}"
		ssc_symbol=${STEAMSHIP_CHARACTER_SYMBOL_FAILURE}
	fi
	eval 'ssc_color=${'"${ssc_colorvar}"'}'

	if steamship_user_is_root; then
		ssc_symbol=${STEAMSHIP_CHARACTER_SYMBOL_ROOT}
	fi
	# ${ssc_symbol} is always set and non-null.

	ssc_status=
	if [ -n "${ssc_symbol}" ]; then
		ssc_status=${ssc_symbol}
	fi
	if [ -n "${ssc_status}" ]; then
		# Reset color to *normal* for user text.
		ssc_status="${ssc_color}${ssc_status}${STEAMSHIP_NORMAL}"
		if [ "${1}" = '-p' ]; then
			ssc_status="${STEAMSHIP_CHARACTER_PREFIX}${ssc_status}"
		fi
		ssc_status="${ssc_status}${STEAMSHIP_CHARACTER_SUFFIX}"
	fi

	echo "${ssc_status}"
	unset ssc_symbol ssc_color ssc_colorvar ssc_status
}

steamship_character_ps2() {
	sscs_color=
	sscs_colorvar="STEAMSHIP_${STEAMSHIP_CHARACTER_COLOR_SECONDARY}"
	eval 'sscs_color=${'"${sscs_colorvar}"'}'

	sscs_status=${STEAMSHIP_CHARACTER_SYMBOL_SECONDARY}
	if [ -n "${sscs_status}" ]; then
		# Reset color to *normal* for user text.
		sscs_status="${sscs_color}${sscs_status}${STEAMSHIP_NORMAL}"
		if [ "${1}" = '-p' ]; then
			sscs_status="${STEAMSHIP_CHARACTER_PREFIX}${sscs_status}"
		fi
		sscs_status="${sscs_status}${STEAMSHIP_CHARACTER_SUFFIX}"
	fi

	echo "${sscs_status}"
	unset sscs_color sscs_colorvar sscs_status
}

steamship_character_prompt() {
	[ "${STEAMSHIP_CHARACTER_SHOW}" = true ] || return

	# Append status to ${STEAMSHIP_PROMPT_PS1}.
	if [ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ]; then
		if [ -n "${STEAMSHIP_PROMPT_PS1}" ]; then
			# shellcheck disable=SC2016
			STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}"'$(steamship_character_ps1 -p)'
		else
			# shellcheck disable=SC2016
			STEAMSHIP_PROMPT_PS1='$(steamship_character_ps1)'
		fi
	else
		if [ -n "${STEAMSHIP_PROMPT_PS1}" ]; then
			STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}$(steamship_character_ps1 -p)"
		else
			STEAMSHIP_PROMPT_PS1=$(steamship_character_ps1)
		fi
	fi

	# Append status to ${STEAMSHIP_PROMPT_PS2}.
	if [ -n "${STEAMSHIP_PROMPT_PS2}" ]; then
		STEAMSHIP_PROMPT_PS2="${STEAMSHIP_PROMPT_PS2}$(steamship_character_ps2 -p)"
	else
		STEAMSHIP_PROMPT_PS2=$(steamship_character_ps2)
	fi
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} character"
