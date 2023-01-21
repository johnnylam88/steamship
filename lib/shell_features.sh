# steamship/lib/shell_features.sh
# shellcheck shell=sh

case " ${STEAMSHIP_LIBS_SOURCED} " in *" shell_features "*) return ;; esac

# Global variables for shell features to be used by other modules.
# shellcheck disable=SC2034
STEAMSHIP_PROMPT_PARAM_EXPANSION=
# shellcheck disable=SC2034
STEAMSHIP_PROMPT_COMMAND_SUBST=

STEAMSHIP_LIBS_INIT="${STEAMSHIP_LIBS_INIT} steamship_shell_features_init"

steamship_shell_features_init() {
	# POSIX shell_features will do variable expansion of prompt strings.
	STEAMSHIP_PROMPT_PARAM_EXPANSION='true'

	# The bash, ksh, and zsh shell_features will do command substitution in
	# prompt strings.
	if [ -n "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ]; then
		STEAMSHIP_PROMPT_COMMAND_SUBST='true'
	fi

	# shellcheck disable=SC3044
	if [ -z "${BASH_VERSION}" ] || shopt -q promptvars; then
		: "do nothing"
	else
		# Bash has "promptvars" shell option turned off.
		STEAMSHIP_PROMPT_PARAM_EXPANSION=
		STEAMSHIP_PROMPT_COMMAND_SUBST=
	fi
	if [ -z "${KSH_VERSION}" ] || true; then
		: "do nothing"
	else
		# UNREACHABLE because ksh always does parameter expansion and
		# command substitution in prompt strings.
		: "do nothing"
	fi
	# shellcheck disable=SC3010
	if [ -z "${ZSH_VERSION}" ] || [[ -o PROMPT_SUBST ]]; then
		: "do nothing"
	else
		# For if Zsh has "PROMPT_SUBST" option turned off.
		# shellcheck disable=SC2034
		STEAMSHIP_PROMPT_PARAM_EXPANSION=
		# shellcheck disable=SC2034
		STEAMSHIP_PROMPT_COMMAND_SUBST=
	fi
}

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} shell_features"
