# steamship/modules/git_branch.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" git_branch "*) return ;; esac

# Dependencies
steamship_load_module colors

steamship_git_branch_init() {
	STEAMSHIP_GIT_BRANCH_SHOW='true'
	STEAMSHIP_GIT_BRANCH_PREFIX=''
	STEAMSHIP_GIT_BRANCH_SUFFIX=''
	STEAMSHIP_GIT_BRANCH_SYMBOL=' '
	STEAMSHIP_GIT_BRANCH_COLOR='MAGENTA'
}

steamship_git_branch_name() {
	command git branch --show-current 2>/dev/null
}

steamship_git_branch() {
	[ "${STEAMSHIP_GIT_BRANCH_SHOW}" = true ] || return

	ssgb_branch=$(steamship_git_branch_name)

	ssgb_color=
	ssgb_colorvar="STEAMSHIP_${STEAMSHIP_GIT_BRANCH_COLOR}"
	eval 'ssgb_color=${'"${ssgb_colorvar}"'}'
	unset ssgb_colorvar

	ssgb_status=
	if [ -n "${ssgb_branch}" ]; then
		if [ -n "${STEAMSHIP_GIT_BRANCH_SYMBOL}" ]; then
			ssgb_status=${STEAMSHIP_GIT_BRANCH_SYMBOL}
		fi
		ssgb_status="${ssgb_status}${ssgb_branch}"
	fi
	if [ -n "${ssgb_status}" ]; then
		# Add prefix and suffix as part of the status.
		ssgb_status="${STEAMSHIP_GIT_BRANCH_PREFIX}${ssgb_status}"
		ssgb_status="${ssgb_status}${STEAMSHIP_GIT_BRANCH_SUFFIX}"
		# Colorize the entire status.
		ssgb_status="${ssgb_color}${ssgb_status}${STEAMSHIP_BASE_COLOR}"
	fi

	echo "${ssgb_status}"
	unset ssgb_branch ssgb_color ssgb_colorvar ssgb_status
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} git_branch"
