# steamship/modules/git_status.sh
# shellcheck shell=sh

case " ${STEAMSHIP_MODULES_SOURCED} " in *" git_status "*) return ;; esac

# Dependencies
steamship_load_module colors

steamship_git_status_init() {
	STEAMSHIP_GIT_STATUS_SHOW='true'
	STEAMSHIP_GIT_STATUS_PREFIX=' ['
	STEAMSHIP_GIT_STATUS_SUFFIX=']'
	STEAMSHIP_GIT_STATUS_COLOR='RED'
	STEAMSHIP_GIT_STATUS_UNTRACKED='?'
	STEAMSHIP_GIT_STATUS_ADDED='+'
	STEAMSHIP_GIT_STATUS_MODIFIED='!'
	STEAMSHIP_GIT_STATUS_RENAMED='»'
	STEAMSHIP_GIT_STATUS_DELETED='✘'
	STEAMSHIP_GIT_STATUS_STASHED='$'
	STEAMSHIP_GIT_STATUS_UNMERGED='='
	STEAMSHIP_GIT_STATUS_AHEAD='⇡'
	STEAMSHIP_GIT_STATUS_BEHIND='⇣'
	STEAMSHIP_GIT_STATUS_DIVERGED='⇕'
}

steamship_git_status_helper() {
	# This helper function reads from standard input and parses each line
	# to determine the state of the Git work tree relative to the index.
	# It outputs a string that is meant to be evaluated by the function
	# "steamship_git_status" and sets some hardcoded variables names to
	# their correct values.

	ssgsh_eval_str=
	ssgsh_untracked=
	ssgsh_added=
	ssgsh_modified=
	ssgsh_renamed=
	ssgsh_deleted=
	ssgsh_unmerged=

	while IFS= read -r ssgsh_line; do
		case ${ssgsh_line} in
		'?? '*)
			ssgsh_untracked='true' ;;
		esac
		case ${ssgsh_line} in
		' A '*|A[' 'MTD]' '*|'AU '*|'UA '*|'AA '*)
			ssgsh_added='true' ;;
		esac
		case ${ssgsh_line} in
		[MT][' 'MTD]' '*|[' 'MTARC][MT]' '*)
			ssgsh_modified='true' ;;
		esac
		case ${ssgsh_line} in
		R[' 'MTD]' '*|C[' 'MTD]' '*|' R '*|' C '*)
			ssgsh_renamed='true' ;;
		esac
		case ${ssgsh_line} in
		'D  '*|[' 'MTARC]D' '*|'DD '*|'UD '*|'DU '*)
			ssgsh_deleted='true' ;;
		esac
		case ${ssgsh_line} in
		'DD '*|'AU '*|'UD '*|'UA '*|'DU '*|'AA '*|'UU '*)
			ssgsh_unmerged='true'
		esac
	done

	ssgsh_eval_str="ssgs_untracked=${ssgsh_untracked}"
	ssgsh_eval_str="${ssgsh_eval_str}; ssgs_added=${ssgsh_added}"
	ssgsh_eval_str="${ssgsh_eval_str}; ssgs_modified=${ssgsh_modified}"
	ssgsh_eval_str="${ssgsh_eval_str}; ssgs_renamed=${ssgsh_renamed}"
	ssgsh_eval_str="${ssgsh_eval_str}; ssgs_deleted=${ssgsh_deleted}"
	ssgsh_eval_str="${ssgsh_eval_str}; ssgs_unmerged=${ssgsh_unmerged}"

	echo "${ssgsh_eval_str}"

	unset ssgsh_eval_str ssgsh_untracked ssgsh_added ssgsh_modified
	unset ssgsh_renamed ssgsh_deleted ssgsh_unmerged
}

steamship_git_status() {
	[ "${STEAMSHIP_GIT_STATUS_SHOW}" = true ] || return

	# Get the branch state by parsing the output from `git status --porcelain`.
	# This is mostly just copied from git_status.zsh from spaceship-prompt.

	# This is pretty inefficient as it forks many processes to parse the
	# output for each bit of the state. It can probably be rewritten into
	# an `awk` program to read the input once and output a bitstate of
	# the branch state.

	# Get the working tree status in *porcelain* format.
	ssgs_output=$(command git status --porcelain -b 2>/dev/null)
	ssgs_state=
	if [ -n "${ssgs_output}" ]; then
		# Parse the "Porcelain Format Version 1" output as described in
		# the git-status(1) man page.
		#
		# If a file type changed, then it is treated as a modified file.
		#
		# If a file is copied due to the config option "status.renames"
		# being set to "copies", then it is treated as a renamed file.

		ssgs_untracked=
		ssgs_added=
		ssgs_modified=
		ssgs_renamed=
		ssgs_deleted=
		ssgs_stashed=
		ssgs_unmerged=

		ssgs_eval_str=$(echo "${ssgs_output}" | steamship_git_status_helper)
		eval "${ssgs_eval_str}"
		unset ssgs_eval_str

		# Standalone check for stashed files.
		if command git rev-parse --verify --quiet refs/stash >/dev/null; then
			ssgs_stashed='true'
		fi

		# Describe the full state of the work tree.
		[ "${ssgs_untracked}" != true ] ||
			ssgs_state="${STEAMSHIP_GIT_STATUS_UNTRACKED}${ssgs_state}"
		[ "${ssgs_added}" != true ] ||
			ssgs_state="${STEAMSHIP_GIT_STATUS_ADDED}${ssgs_state}"
		[ "${ssgs_modified}" != true ] ||
			ssgs_state="${STEAMSHIP_GIT_STATUS_MODIFIED}${ssgs_state}"
		[ "${ssgs_renamed}" != true ] ||
			ssgs_state="${STEAMSHIP_GIT_STATUS_RENAMED}${ssgs_state}"
		[ "${ssgs_deleted}" != true ] ||
			ssgs_state="${STEAMSHIP_GIT_STATUS_DELETED}${ssgs_state}"
		[ "${ssgs_stashed}" != true ] ||
			ssgs_state="${STEAMSHIP_GIT_STATUS_STASHED}${ssgs_state}"
		[ "${ssgs_unmerged}" != true ] ||
			ssgs_state="${STEAMSHIP_GIT_STATUS_UNMERGED}${ssgs_state}"

		# Check whether branch has diverged.
		ssgs_count=$(
			command git rev-list --count --left-right "@{upstream}"...HEAD 2>/dev/null
		)
		if [ -n "${ssgs_count}" ]; then
			case ${ssgs_count} in
			"0	0")	# equal to upstream
				;;
			"0	"*)	# ahead of upstream
				ssgs_state="${STEAMSHIP_GIT_STATUS_AHEAD}${ssgs_state}" ;;
			*"	0")	# behind upstream
				ssgs_state="${STEAMSHIP_GIT_STATUS_BEHIND}${ssgs_state}" ;;
			*)		# diverged from upstream
				ssgs_state="${STEAMSHIP_GIT_STATUS_DIVERGED}${ssgs_state}" ;;
			esac
		fi
		unset ssgs_untracked ssgs_added ssgs_modified ssgs_renamed
		unset ssgs_deleted ssgs_stashed ssgs_unmerged ssgs_count
	fi

	ssgs_color=
	ssgs_colorvar="STEAMSHIP_${STEAMSHIP_GIT_STATUS_COLOR}"
	eval 'ssgs_color=${'"${ssgs_colorvar}"'}'
	unset ssgs_colorvar

	ssgs_status=${ssgs_state}
	if [ -n "${ssgs_status}" ]; then
		# Add prefix and suffix as part of the status.
		ssgs_status="${STEAMSHIP_GIT_STATUS_PREFIX}${ssgs_status}"
		ssgs_status="${ssgs_status}${STEAMSHIP_GIT_STATUS_SUFFIX}"
		# Colorize the entire status.
		ssgs_status="${ssgs_color}${ssgs_status}${STEAMSHIP_BASE_COLOR}"
	fi

	echo "${ssgs_status}"
	unset ssgs_state ssgs_color ssgs_colorvar ssgs_status
}

STEAMSHIP_MODULES_SOURCED="${STEAMSHIP_MODULES_SOURCED} git_status"
