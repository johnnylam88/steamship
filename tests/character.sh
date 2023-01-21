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

steamship_load_module character
steamship_modules_reset

STEAMSHIP_CHARACTER_SHOW='true'
STEAMSHIP_CHARACTER_PREFIX=''
STEAMSHIP_CHARACTER_SUFFIX=''
STEAMSHIP_CHARACTER_SYMBOL='$ '
STEAMSHIP_CHARACTER_SYMBOL_ROOT='# '
STEAMSHIP_CHARACTER_SYMBOL_SUCCESS='$ '
STEAMSHIP_CHARACTER_SYMBOL_FAILURE='$ '
STEAMSHIP_CHARACTER_COLOR_SUCCESS='GREEN'
STEAMSHIP_CHARACTER_COLOR_FAILURE='RED'
STEAMSHIP_CHARACTER_SYMBOL_SECONDARY='> '
STEAMSHIP_CHARACTER_COLOR_SECONDARY='YELLOW'

steamship_user_is_root() {
	[ "${STEAMSHIP_USER_IS_ROOT:-true}" = true ]
}

TESTS="${TESTS} test1"
test1() {
	STEAMSHIP_RETVAL='1'
	STEAMSHIP_USER_IS_ROOT='false'

	test1_name=${1}
	test1_with_prefix=$(steamship_character_ps1 -p)
	test1_without_prefix=$(steamship_character_ps1)
	test1_with_prefix_expected="${STEAMSHIP_RED}"'$ '"${STEAMSHIP_NORMAL}"
	test1_without_prefix_expected="${STEAMSHIP_RED}"'$ '"${STEAMSHIP_NORMAL}"

	assert_equal "${test1_name}" \
		"retval 1, user, ps1 with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"retval 1, user, ps1 without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	unset STEAMSHIP_RETVAL STEAMSHIP_USER_IS_ROOT
}

TESTS="${TESTS} test2"
test2() {
	STEAMSHIP_RETVAL='1'
	STEAMSHIP_USER_IS_ROOT='true'

	test2_name=${1}
	test2_with_prefix=$(steamship_character_ps1 -p)
	test2_without_prefix=$(steamship_character_ps1)
	test2_with_prefix_expected="${STEAMSHIP_RED}"'# '"${STEAMSHIP_NORMAL}"
	test2_without_prefix_expected="${STEAMSHIP_RED}"'# '"${STEAMSHIP_NORMAL}"

	assert_equal "${test2_name}" \
		"retval 1, root, ps1 with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"retval 1, root, ps1 without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	unset STEAMSHIP_RETVAL STEAMSHIP_USER_IS_ROOT
}

TESTS="${TESTS} test3"
test3() {
	STEAMSHIP_RETVAL='0'
	STEAMSHIP_USER_IS_ROOT='false'

	test3_name=${1}
	test3_with_prefix=$(steamship_character_ps1 -p)
	test3_without_prefix=$(steamship_character_ps1)
	test3_with_prefix_expected="${STEAMSHIP_GREEN}"'$ '"${STEAMSHIP_NORMAL}"
	test3_without_prefix_expected="${STEAMSHIP_GREEN}"'$ '"${STEAMSHIP_NORMAL}"

	assert_equal "${test3_name}" \
		"retval 0, user, ps1 with prefix" \
		"${test3_with_prefix}" \
		"${test3_with_prefix_expected}"
	assert_equal "${test3_name}" \
		"retval 0, user, ps1 without prefix" \
		"${test3_without_prefix}" \
		"${test3_without_prefix_expected}"

	unset STEAMSHIP_RETVAL STEAMSHIP_USER_IS_ROOT
}

TESTS="${TESTS} test4"
test4() {
	STEAMSHIP_RETVAL='0'
	STEAMSHIP_USER_IS_ROOT='true'

	test4_name=${1}
	test4_with_prefix=$(steamship_character_ps1 -p)
	test4_without_prefix=$(steamship_character_ps1)
	test4_with_prefix_expected="${STEAMSHIP_GREEN}"'# '"${STEAMSHIP_NORMAL}"
	test4_without_prefix_expected="${STEAMSHIP_GREEN}"'# '"${STEAMSHIP_NORMAL}"

	assert_equal "${test4_name}" \
		"retval 0, root, ps1 with prefix" \
		"${test4_with_prefix}" \
		"${test4_with_prefix_expected}"
	assert_equal "${test4_name}" \
		"retval 0, root, ps1 without prefix" \
		"${test4_without_prefix}" \
		"${test4_without_prefix_expected}"

	unset STEAMSHIP_RETVAL STEAMSHIP_USER_IS_ROOT
}

TESTS="${TESTS} test5"
test5() {
	test5_name=${1}
	test5_with_prefix=$(steamship_character_ps2 -p)
	test5_without_prefix=$(steamship_character_ps2)
	test5_with_prefix_expected="${STEAMSHIP_YELLOW}"'> '"${STEAMSHIP_NORMAL}"
	test5_without_prefix_expected="${STEAMSHIP_YELLOW}"'> '"${STEAMSHIP_NORMAL}"

	assert_equal "${test5_name}" \
		"ps2 with prefix" \
		"${test5_with_prefix}" \
		"${test5_with_prefix_expected}"
	assert_equal "${test5_name}" \
		"ps2 without prefix" \
		"${test5_without_prefix}" \
		"${test5_without_prefix_expected}"
}

run_tests
