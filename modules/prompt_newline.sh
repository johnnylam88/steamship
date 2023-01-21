# steamship/modules/prompt_newline.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" prompt_newline "*) return ;; esac

steamship_prompt_newline_init() {
	STEAMSHIP_PROMPT_NEWLINE_SHOW='true'
}

# This module does not have configurable prefix, suffix, or color.
# Its sole purpose is to add a newline between the previous output
# and the next prompt.

steamship_prompt_newline_prompt() {
	[ "${STEAMSHIP_PROMPT_NEWLINE_SHOW}" = true ] || return

	# Prepend a newline to ${STEAMSHIP_PROMPT_PS1}.
	STEAMSHIP_PROMPT_PS1='
'"${STEAMSHIP_PROMPT_PS1}"
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} prompt_newline"
