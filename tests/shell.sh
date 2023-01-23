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

steamship_load_module shell
steamship_modules_reset

STEAMSHIP_SHELL_SHOW='true'
STEAMSHIP_SHELL_PREFIX=' '
STEAMSHIP_SHELL_SUFFIX=' '
STEAMSHIP_SHELL_COLOR='WHITE'

unset BASH_VERSION KSH_VERSION YASH_VERSION ZSH_VERSION

TESTS="${TESTS} test1"
test1() {
	BASH_VERSION='1'

	test1_name=${1}
	test1_with_prefix=$(steamship_shell -p)
	test1_without_prefix=$(steamship_shell)
	test1_with_prefix_expected=" ${STEAMSHIP_WHITE}[bash]${STEAMSHIP_BASE_COLOR} "
	test1_without_prefix_expected="${STEAMSHIP_WHITE}[bash]${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test1_name}" \
		"bash, with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"bash, without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	unset BASH_VERSION
}

TESTS="${TESTS} test2"
test2() {
	KSH_VERSION='1'

	test2_name=${1}
	test2_with_prefix=$(steamship_shell -p)
	test2_without_prefix=$(steamship_shell)
	test2_with_prefix_expected=" ${STEAMSHIP_WHITE}[ksh]${STEAMSHIP_BASE_COLOR} "
	test2_without_prefix_expected="${STEAMSHIP_WHITE}[ksh]${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test2_name}" \
		"ksh, with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"ksh, without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	unset KSH_VERSION
}

TESTS="${TESTS} test3"
test3() {
	YASH_VERSION='1'

	test3_name=${1}
	test3_with_prefix=$(steamship_shell -p)
	test3_without_prefix=$(steamship_shell)
	test3_with_prefix_expected=" ${STEAMSHIP_WHITE}[yash]${STEAMSHIP_BASE_COLOR} "
	test3_without_prefix_expected="${STEAMSHIP_WHITE}[yash]${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test3_name}" \
		"yash, with prefix" \
		"${test3_with_prefix}" \
		"${test3_with_prefix_expected}"
	assert_equal "${test3_name}" \
		"yash, without prefix" \
		"${test3_without_prefix}" \
		"${test3_without_prefix_expected}"

	unset YASH_VERSION
}

TESTS="${TESTS} test4"
test4() {
	ZSH_VERSION='1'

	test4_name=${1}
	test4_with_prefix=$(steamship_shell -p)
	test4_without_prefix=$(steamship_shell)
	test4_with_prefix_expected=" ${STEAMSHIP_WHITE}[zsh]${STEAMSHIP_BASE_COLOR} "
	test4_without_prefix_expected="${STEAMSHIP_WHITE}[zsh]${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test4_name}" \
		"zsh, with prefix" \
		"${test4_with_prefix}" \
		"${test4_with_prefix_expected}"
	assert_equal "${test4_name}" \
		"zsh, without prefix" \
		"${test4_without_prefix}" \
		"${test4_without_prefix_expected}"

	unset ZSH_VERSION
}

TESTS="${TESTS} test5"
test5() {
	test5_name=${1}
	test5_with_prefix=$(steamship_shell -p)
	test5_without_prefix=$(steamship_shell)
	test5_with_prefix_expected=" ${STEAMSHIP_WHITE}[sh]${STEAMSHIP_BASE_COLOR} "
	test5_without_prefix_expected="${STEAMSHIP_WHITE}[sh]${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test5_name}" \
		"sh, with prefix" \
		"${test5_with_prefix}" \
		"${test5_with_prefix_expected}"
	assert_equal "${test5_name}" \
		"sh, without prefix" \
		"${test5_without_prefix}" \
		"${test5_without_prefix_expected}"
}

run_tests
