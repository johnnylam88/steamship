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

steamship_load_module delimiter
steamship_modules_reset

STEAMSHIP_DELIMITER_SHOW='true'
STEAMSHIP_DELIMITER_PREFIX=''
STEAMSHIP_DELIMITER_SUFFIX=''
STEAMSHIP_DELIMITER_SYMBOL='> '
STEAMSHIP_DELIMITER_SYMBOL_ROOT='| '
STEAMSHIP_DELIMITER_SYMBOL_SUCCESS='> '
STEAMSHIP_DELIMITER_SYMBOL_FAILURE='> '
STEAMSHIP_DELIMITER_COLOR_SUCCESS='GREEN'
STEAMSHIP_DELIMITER_COLOR_FAILURE='RED'

# Mock
steamship_user_is_root() {
	[ "${STEAMSHIP_USER_IS_ROOT:-true}" = true ]
}

TESTS="${TESTS} test1"
test1() {
	STEAMSHIP_RETVAL='1'
	STEAMSHIP_USER_IS_ROOT='false'

	test1_name=${1}
	test1_with_prefix=$(steamship_delimiter -p)
	test1_without_prefix=$(steamship_delimiter)
	test1_with_prefix_expected="${STEAMSHIP_RED}"'> '"${STEAMSHIP_WHITE}"
	test1_without_prefix_expected="${STEAMSHIP_RED}"'> '"${STEAMSHIP_WHITE}"

	assert_equal "${test1_name}" \
		"retval 1, user, with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"retval 1, user, without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	unset STEAMSHIP_RETVAL STEAMSHIP_USER_IS_ROOT
}

TESTS="${TESTS} test2"
test2() {
	STEAMSHIP_RETVAL='1'
	STEAMSHIP_USER_IS_ROOT='true'

	test2_name=${1}
	test2_with_prefix=$(steamship_delimiter -p)
	test2_without_prefix=$(steamship_delimiter)
	test2_with_prefix_expected="${STEAMSHIP_RED}"'| '"${STEAMSHIP_WHITE}"
	test2_without_prefix_expected="${STEAMSHIP_RED}"'| '"${STEAMSHIP_WHITE}"

	assert_equal "${test2_name}" \
		"retval 1, root, with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"retval 1, root, without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	unset STEAMSHIP_RETVAL STEAMSHIP_USER_IS_ROOT
}

TESTS="${TESTS} test3"
test3() {
	STEAMSHIP_RETVAL='0'
	STEAMSHIP_USER_IS_ROOT='false'

	test3_name=${1}
	test3_with_prefix=$(steamship_delimiter -p)
	test3_without_prefix=$(steamship_delimiter)
	test3_with_prefix_expected="${STEAMSHIP_GREEN}"'> '"${STEAMSHIP_WHITE}"
	test3_without_prefix_expected="${STEAMSHIP_GREEN}"'> '"${STEAMSHIP_WHITE}"

	assert_equal "${test3_name}" \
		"retval 0, user, with prefix" \
		"${test3_with_prefix}" \
		"${test3_with_prefix_expected}"
	assert_equal "${test3_name}" \
		"retval 0, user, without prefix" \
		"${test3_without_prefix}" \
		"${test3_without_prefix_expected}"

	unset STEAMSHIP_RETVAL STEAMSHIP_USER_IS_ROOT
}

TESTS="${TESTS} test4"
test4() {
	STEAMSHIP_RETVAL='0'
	STEAMSHIP_USER_IS_ROOT='true'

	test4_name=${1}
	test4_with_prefix=$(steamship_delimiter -p)
	test4_without_prefix=$(steamship_delimiter)
	test4_with_prefix_expected="${STEAMSHIP_GREEN}"'| '"${STEAMSHIP_WHITE}"
	test4_without_prefix_expected="${STEAMSHIP_GREEN}"'| '"${STEAMSHIP_WHITE}"

	assert_equal "${test4_name}" \
		"retval 0, root, with prefix" \
		"${test4_with_prefix}" \
		"${test4_with_prefix_expected}"
	assert_equal "${test4_name}" \
		"retval 0, root, without prefix" \
		"${test4_without_prefix}" \
		"${test4_without_prefix_expected}"

	unset STEAMSHIP_RETVAL STEAMSHIP_USER_IS_ROOT
}

run_tests
