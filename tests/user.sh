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

steamship_load_module user
steamship_modules_reset

[ -z "${BASH_VERSION}" ] || unset BASH_VERSION

STEAMSHIP_USER_SHOW='always'
STEAMSHIP_USER_PREFIX='with '
STEAMSHIP_USER_SUFFIX=' '
STEAMSHIP_USER_COLOR='YELLOW'
STEAMSHIP_USER_COLOR_ROOT='RED'

# Mock
steamship_user_is_root() {
	[ "${STEAMSHIP_USER_IS_ROOT:-true}" = true ]
}

TESTS="${TESTS} test1"
test1() {
	STEAMSHIP_USER_IS_ROOT='false'
	USER='me'

	test1_name=${1}
	test1_with_prefix=$(steamship_user -p)
	test1_without_prefix=$(steamship_user)
	test1_user="${STEAMSHIP_YELLOW}me${STEAMSHIP_BASE_COLOR}"
	test1_with_prefix_expected="with ${test1_user} "
	test1_without_prefix_expected="${test1_user} "

	assert_equal "${test1_name}" \
		"user, with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"user, without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	unset STEAMSHIP_USER_IS_ROOT USER
}

TESTS="${TESTS} test2"
test2() {
	STEAMSHIP_USER_IS_ROOT='true'
	USER='root'

	test2_name=${1}
	test2_with_prefix=$(steamship_user -p)
	test2_without_prefix=$(steamship_user)
	test2_user="${STEAMSHIP_RED}root${STEAMSHIP_BASE_COLOR}"
	test2_with_prefix_expected="with ${test2_user} "
	test2_without_prefix_expected="${test2_user} "

	assert_equal "${test2_name}" \
		"root, with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"root, without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	unset STEAMSHIP_USER_IS_ROOT USER
}

run_tests
