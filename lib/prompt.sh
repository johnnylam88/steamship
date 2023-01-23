# steamship/lib/prompt.sh
# shellcheck shell=sh disable=SC2034

case " ${STEAMSHIP_LIBS_SOURCED} " in *" prompt "*) return ;; esac

# Dependencies
steamship_load_library shell_features

# Global variables to be used by other modules.
STEAMSHIP_PROMPT_PS1=
STEAMSHIP_PROMPT_PS1_1=
STEAMSHIP_PROMPT_PS2=

# Order of sections shown in the shell prompt.
STEAMSHIP_PROMPT_ORDER_DEFAULT='
	user
	directory
	host
	git
	container
	tmux
	line_separator
	timestamp
	shell
	exit_code
	character
'

steamship_prompt() {
	ssp_order=
	ssp_order_pre=
	ssp_order_post=

	# Put "colors" first as a special case to ensure that color variables
	# are properly defined before any module "prompt" functions are
	# executed.
	ssp_order_pre='colors'

	# Append any prompt sections that are requested by the user.
	ssp_order=${STEAMSHIP_PROMPT_ORDER-${STEAMSHIP_PROMPT_ORDER_DEFAULT}}

	# Prepend the special delimiter module to the prompt.
	ssp_order_post="${ssp_order_post} delimiter"

	# Prepend the newline module to the prompt.
	ssp_order_post="${ssp_order_post} prompt_newline"

	# Call the special precmd module to wrap the prompt in a command.
	ssp_order_post="${ssp_order_post} precmd"

	# Final fix-ups for non-printable characters.
	ssp_order_post="${ssp_order_post} nonprintable"

	# Execute each "prompt" function to progressively build prompt
	# variables as a side-effect.

	for ssp_section in ${ssp_order_pre}; do
		ssp_section_prompt_fn="steamship_${ssp_section}_prompt"
		eval "${ssp_section_prompt_fn}"
	done

	STEAMSHIP_PROMPT_PS1=
	STEAMSHIP_PROMPT_PS1_1=
	STEAMSHIP_PROMPT_PS2=

	for ssp_section in ${ssp_order}; do
		ssp_section_prompt_fn="steamship_${ssp_section}_prompt"
		eval "${ssp_section_prompt_fn}"
	done
	# Build ${STEAMSHIP_PROMPT_PS1} here as the "post" modules may need
	# to operate on the entire prompt.
	STEAMSHIP_PROMPT_PS1="${STEAMSHIP_PROMPT_PS1_1}${STEAMSHIP_PROMPT_PS1}"
	STEAMSHIP_PROMPT_PS1_1=

	for ssp_section in ${ssp_order_post}; do
		ssp_section_prompt_fn="steamship_${ssp_section}_prompt"
		eval "${ssp_section_prompt_fn}"
	done

	unset ssp_order ssp_order_pre ssp_order_post
	unset ssp_section ssp_section_prompt_fn

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
