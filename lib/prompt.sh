# steamship/lib/prompt.sh
# shellcheck shell=sh disable=SC2034

case " ${STEAMSHIP_LIBS_SOURCED} " in *" prompt "*) return ;; esac

# Dependencies
steamship_load_library shell_features

# Global variables to be used by other modules.
STEAMSHIP_PROMPT_PS1=
STEAMSHIP_PROMPT_PS2=

# Order of sections shown in the shell prompt.
STEAMSHIP_PROMPT_ORDER_DEFAULT='
	timestamp
	user
	directory
	host
	git
	container
	tmux
	line_separator
	exit_code
	character
'

steamship_prompt() {
	ssp_order_user=${STEAMSHIP_PROMPT_ORDER-${STEAMSHIP_PROMPT_ORDER_DEFAULT}}

	# Put "colors" first as a special case to ensure that color variables
	# are properly defined before any module "prompt" functions are
	# executed.
	#
	# The colors "prompt" function does not touch the prompt variables,
	# so it doesn't affect any prefix decisions.
	ssp_order=colors

	# Add any prompt sections that are requested by the user.
	ssp_order="${ssp_order} ${ssp_order_user}"

	# Prepend the special delimiter module to the prompt.
	ssp_order="${ssp_order} delimiter"

	# Prepend the newline module to the prompt.
	ssp_order="${ssp_order} prompt_newline"

	# Call the special precmd module to wrap the prompt in a command.
	ssp_order="${ssp_order} precmd"

	# Final fix-ups for non-printable characters.
	ssp_order="${ssp_order} nonprintable"

	# Execute each "prompt" function to progressively build prompt
	# variables as a side-effect.

	STEAMSHIP_PROMPT_PS1=
	STEAMSHIP_PROMPT_PS2=
	for ssp_section in ${ssp_order}; do
		ssp_section_prompt_fn="steamship_${ssp_section}_prompt"
		eval "${ssp_section_prompt_fn}"
	done

	unset ssp_order ssp_order_user ssp_section ssp_section_prompt_fn

	# ${STEAMSHIP_PROMPT_PS1} contains the main prompt string.
	# ${STEAMSHIP_PROMPT_PS2} contains the secondary
	#     (continuation) prompt string.
}

steamship_prompt_refresh() {
	steamship_prompt
	if [ "${STEAMSHIP_PROMPT_PARAM_EXPANSION}" = true ]; then
		eval "PS1='${STEAMSHIP_PROMPT_PS1}'"
		eval "PS2='${STEAMSHIP_PROMPT_PS2}'"
	else
		eval "PS1=${STEAMSHIP_PROMPT_PS1}"
		eval "PS2=${STEAMSHIP_PROMPT_PS2}"
	fi
}

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} prompt"
