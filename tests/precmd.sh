# shellcheck shell=sh disable=SC2034

if [ -z "${STEAMSHIP_ROOT}" ]; then
	if [ -f "${PWD}/steamship.sh" ]; then
		STEAMSHIP_ROOT=${PWD}
	elif [ -f "${PWD%/*}/steamship.sh" ]; then
		STEAMSHIP_ROOT=${PWD%/*}
	fi
fi
if [ -f "${STEAMSHIP_ROOT}/tests/unit_test.sh" ]; then
	. "${STEAMSHIP_ROOT}/tests/unit_test.sh"
fi

STEAMSHIP_PROMPT_COMMAND_SUBST='true'

steamship_load_module precmd
steamship_modules_reset

hook() {
	# shellcheck disable=SC2034
	STEAMSHIP_RETVAL=128
}

TESTS="${TESTS} test1"
test1() {
	# shellcheck disable=SC2016
	STEAMSHIP_PROMPT_PS1='$(echo "${STEAMSHIP_RETVAL}")'
	steamship_precmd_add_hook hook
	steamship_precmd_prompt

	test1_name=${1}
	eval "test1_ps1=${STEAMSHIP_PROMPT_PS1}"
	test1_ps1_expected='128'

	# shellcheck disable=SC2154
	assert_equal "${test1_name}" \
		"add hook in ps1" \
		"${test1_ps1}" \
		"${test1_ps1_expected}"

	unset STEAMSHIP_PROMPT_PS1
}

TESTS="${TESTS} test2"
test2() {
	# shellcheck disable=SC2016
	STEAMSHIP_PROMPT_PS1='$(echo "${STEAMSHIP_RETVAL}")'
	steamship_precmd_add_hook '{ STEAMSHIP_RETVAL=11; }'
	steamship_precmd_prompt

	test2_name=${1}
	eval "test2_ps1=${STEAMSHIP_PROMPT_PS1}"
	test2_ps1_expected='11'

	# shellcheck disable=SC2154
	assert_equal "${test2_name}" \
		"add string in ps1" \
		"${test2_ps1}" \
		"${test2_ps1_expected}"

	unset STEAMSHIP_PROMPT_PS1
}

run_tests
