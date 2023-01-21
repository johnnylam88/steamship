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

steamship_load_module exit_code
steamship_modules_reset

STEAMSHIP_EXIT_CODE_SHOW='true'
STEAMSHIP_EXIT_CODE_PREFIX=''
STEAMSHIP_EXIT_CODE_SUFFIX=' '
STEAMSHIP_EXIT_CODE_SYMBOL='X '
STEAMSHIP_EXIT_CODE_COLOR='RED'

TESTS="${TESTS} test1"
test1() {
	STEAMSHIP_RETVAL='128'

	test1_name=${1}
	test1_with_prefix=$(steamship_exit_code -p)
	test1_without_prefix=$(steamship_exit_code)
	test1_with_prefix_expected="${STEAMSHIP_RED}X 128${STEAMSHIP_WHITE} "
	test1_without_prefix_expected="${STEAMSHIP_RED}X 128${STEAMSHIP_WHITE} "

	assert_equal "${test1_name}" \
		"retval 128, with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"retval 128, without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	unset STEAMSHIP_RETVAL
}

TESTS="${TESTS} test2"
test2() {
	STEAMSHIP_RETVAL='0'

	test2_name=${1}
	test2_with_prefix=$(steamship_exit_code -p)
	test2_without_prefix=$(steamship_exit_code)
	test2_with_prefix_expected=''
	test2_without_prefix_expected=''

	assert_equal "${test2_name}" \
		"retval 0, with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"retval 0, without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	unset STEAMSHIP_RETVAL
}

run_tests
