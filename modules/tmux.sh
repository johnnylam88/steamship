# steamship/modules/tmux.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" tmux "*) return ;; esac

# Dependencies
steamship_load_module colors

steamship_tmux_init() {
	STEAMSHIP_TMUX_SHOW='true'
	STEAMSHIP_TMUX_PREFIX=${STEAMSHIP_PREFIX_DEFAULT}
	STEAMSHIP_TMUX_SUFFIX=${STEAMSHIP_SUFFIX_DEFAULT}
	STEAMSHIP_TMUX_SYMBOL='💻 '
	STEAMSHIP_TMUX_COLOR='YELLOW'
}

steamship_tmux() {
	sst_session=
	if [ -n "${TMUX_PANE}" ]; then
		sst_session=$(
			tmux list-panes -t "${TMUX_PANE}" -F '#{session_name}' |
			while read -r name; do echo "${name}"; return; done
		)
	fi

	sst_color=
	sst_colorvar="STEAMSHIP_${STEAMSHIP_TMUX_COLOR}"
	eval 'sst_color=${'"${sst_colorvar}"'}'

	sst_status=
	if [ -n "${sst_session}" ]; then
		if [ -n "${STEAMSHIP_TMUX_SYMBOL}" ]; then
			sst_status=${STEAMSHIP_TMUX_SYMBOL}
		fi
		sst_status="${sst_status}${sst_session}"
	fi
	if [ -n "${sst_status}" ]; then
		sst_status="${sst_color}${sst_status}${STEAMSHIP_BASE_COLOR}"
		if [ "${1}" = '-p' ]; then
			sst_status="${STEAMSHIP_TMUX_PREFIX}${sst_status}"
		fi
		sst_status="${sst_status}${STEAMSHIP_TMUX_SUFFIX}"
	fi

	echo "${sst_status}"
	unset sst_session sst_color sst_colorvar sst_status
}

steamship_tmux_prompt() {
	[ -n "${TMUX_PANE}" ] || return
	[ "${STEAMSHIP_TMUX_SHOW}" = true ] || return
	steamship_exists tmux || return

	# Append status to ${STEAMSHIP_PROMPT_PS1}.
	if [ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ]; then
		if [ -n "${STEAMSHIP_PROMPT_PS1}" ]; then
			# shellcheck disable=SC2016
			STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}"'$(steamship_tmux -p)'
		else
			# shellcheck disable=SC2016
			STEAMSHIP_PROMPT_PS1='$(steamship_tmux)'
		fi
	else
		if [ -n "${STEAMSHIP_PROMPT_PS1}" ]; then
			STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}$(steamship_tmux -p)"
		else
			STEAMSHIP_PROMPT_PS1=$(steamship_tmux)
		fi
	fi
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} tmux"
