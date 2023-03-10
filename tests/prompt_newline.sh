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

steamship_load_module prompt_newline
steamship_modules_reset

STEAMSHIP_PROMPT_NEWLINE_SHOW='true'

TESTS="${TESTS} test1"
test1() {
	STEAMSHIP_PROMPT_PS1='$ '
	steamship_prompt_newline_prompt

	test1_name=${1}
	test1_ps1=${STEAMSHIP_PROMPT_PS1}
	test1_ps1_expected='
$ '

	assert_equal "${test1_name}" \
		"newline before ps1" \
		"${test1_ps1}" \
		"${test1_ps1_expected}"

	unset STEAMSHIP_PROMPT_PS1
}

run_tests
