# steamship/lib/config.sh
# shellcheck shell=sh

case " ${STEAMSHIP_LIBS_SOURCED} " in *" config "*) return ;; esac

# Global variables to be used by other modules.
STEAMSHIP_PREFIX_DEFAULT=
STEAMSHIP_SUFFIX_DEFAULT=
STEAMSHIP_COLOR_SUCCESS=
STEAMSHIP_COLOR_FAILURE=

# Default location of user configuration file.
STEAMSHIP_CONFIG_DEFAULT="${HOME}/.steamshiprc"

STEAMSHIP_LIBS_INIT="${STEAMSHIP_LIBS_INIT} steamship_config_init"

steamship_config_init() {
	# shellcheck disable=SC2034
	STEAMSHIP_PREFIX_DEFAULT='via '
	# shellcheck disable=SC2034
	STEAMSHIP_SUFFIX_DEFAULT=' '
	# shellcheck disable=SC2034
	STEAMSHIP_COLOR_SUCCESS='GREEN'
	# shellcheck disable=SC2034
	STEAMSHIP_COLOR_FAILURE='RED'

	steamship_config_sourcing=
}

steamship_config()
{
	# Find configuration file.
	if [ -z "${STEAMSHIP_CONFIG}" ]; then
		for ssc_config_file in \
			"${STEAMSHIP_CONFIG_DEFAULT}" \
			"${XDG_CONFIG_HOME:-"${HOME}/.config"}/steamship.sh" \
			"${XDG_CONFIG_HOME:-"${HOME}/.config"}/steamship/steamship.sh"
		do
			if [ -f "${ssc_config_file}" ]; then
				STEAMSHIP_CONFIG=${ssc_config_file}
			fi
		done
		unset ssc_config_file
		# Set a default value for ${STEAMSHIP_CONFIG} if no configuration
		# file is found.
		: "${STEAMSHIP_CONFIG:=${STEAMSHIP_CONFIG_DEFAULT}}"
	fi

	# Load configuration file if it's available.
	if [ -n "${STEAMSHIP_CONFIG}" ] && [ -f "${STEAMSHIP_CONFIG}" ]; then
		# Ensure that the configuration file isn't recursively sourced.
		if [ -z "${steamship_config_sourcing}" ]; then
			steamship_config_sourcing='yes'
			# shellcheck disable=SC1090
			. "${STEAMSHIP_CONFIG}"
			steamship_config_sourcing=
		fi
	fi
}

STEAMSHIP_LIBS_SOURCED="${STEAMSHIP_LIBS_SOURCED} config"
