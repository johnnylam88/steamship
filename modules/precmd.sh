# steamship/modules/precmd.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" precmd "*) return ;; esac

steamship_precmd_init() {
	steamship_precmd_hooks=
}

steamship_precmd_run_hooks() {
	[ -n "${steamship_precmd_hooks}" ] || return

	# shellcheck disable=SC2086
	eval set -- ${steamship_precmd_hooks}
	for ssprh_hook_fn; do
		eval "${ssprh_hook_fn}"
	done
	unset ssprh_hook_fn
}

steamship_precmd_add_hook() {
	sspah_hook_fn=${1}
	if [ -n "${sspah_hook_fn}" ]; then
		# shellcheck disable=SC2046,SC2086
		eval set -- ${steamship_precmd_hooks} $(steamship_shquote "${sspah_hook_fn}")
		steamship_precmd_hooks=$(steamship_save_argv "${@}")
	fi
	unset sspah_hook_fn
}

steamship_precmd_prompt() {
	[ "${STEAMSHIP_PROMPT_COMMAND_SUBST}" = true ] || return

	# shellcheck disable=SC2089,SC2016
	sspp_prefix='$(STEAMSHIP_RETVAL=$?; steamship_precmd_run_hooks; echo "'
	sspp_suffix='")'
	sspp_prompt="${sspp_prefix}${STEAMSHIP_PROMPT_PS1}${sspp_suffix}"
	STEAMSHIP_PROMPT_PS1=${sspp_prompt}

	unset sspp_prefix sspp_suffix sspp_prompt
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} precmd"
