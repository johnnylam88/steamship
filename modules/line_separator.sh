# steamship/modules/line_separator.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" line_separator "*) return ;; esac

steamship_line_separator_init() {
	STEAMSHIP_LINE_SEPARATOR_SHOW='true'
}

# This module does not have configurable prefix, suffix, or color.
# Its sole purpose is to add a newline character into the prompt
# so that it spans multiple lines.

steamship_line_separator_prompt() {
	[ "${STEAMSHIP_LINE_SEPARATOR_SHOW}" = true ] || return

	# Append a newline to ${STEAMSHIP_PROMPT_PS1}.
	STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1}"'
'
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} line_separator"
