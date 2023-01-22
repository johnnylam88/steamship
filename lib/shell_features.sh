# steamship/lib/shell_features.sh
# shellcheck shell=sh disable=SC2034

case " ${STEAMSHIP_LIBS_SOURCED} " in *" shell_features "*) return ;; esac

# Global variables for shell features to be used by other modules.
STEAMSHIP_PROMPT_PARAM_EXPANSION=
STEAMSHIP_PROMPT_COMMAND_SUBST=

STEAMSHIP_LIBS_INIT="${STEAMSHIP_LIBS_INIT} steamship_shell_features_init"

steamship_shell_features_init() {
	# POSIX shells will do variable expansion of prompt strings.
	STEAMSHIP_PROMPT_PARAM_EXPANSION='true'

	if [ -n "${BASH_VERSION}" ]; then
		if eval 'shopt -q promptvars'; then
			STEAMSHIP_PROMPT_COMMAND_SUBST='true'
		else
			# Bash has "promptvars" shell option turned off.
			STEAMSHIP_PROMPT_PARAM_EXPANSION=
			STEAMSHIP_PROMPT_COMMAND_SUBST=
		fi
	elif [ -n "${KSH_VERSION}" ]; then
		STEAMSHIP_PROMPT_COMMAND_SUBST='true'
	elif [ -n "${YASH_VERSION}" ]; then
		STEAMSHIP_PROMPT_COMMAND_SUBST='true'
	elif [ -n "${ZSH_VERSION}" ]; then
		if eval '[[ -o PROMPT_SUBST ]]'; then
			STEAMSHIP_PROMPT_COMMAND_SUBST='true'
		else
			# For if Zsh has "PROMPT_SUBST" option turned off.
			STEAMSHIP_PROMPT_PARAM_EXPANSION=
			STEAMSHIP_PROMPT_COMMAND_SUBST=
		fi
	fi
}

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} shell_features"
