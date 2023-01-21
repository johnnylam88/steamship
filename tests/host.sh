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

steamship_load_module host
steamship_modules_reset

[ -z "${BASH_VERSION}" ] || unset BASH_VERSION
[ -z "${SSH_CONNECTION}" ] || unset SSH_CONNECTION

STEAMSHIP_HOST_SHOW='always'
STEAMSHIP_HOST_SHOW_FULL='false'
STEAMSHIP_HOST_PREFIX='at '
STEAMSHIP_HOST_SUFFIX=' '
STEAMSHIP_HOST_COLOR='BLUE'
STEAMSHIP_HOST_COLOR_SSH='GREEN'
STEAMSHIP_HOST_SYMBOL_SSH='@'

TESTS="${TESTS} test1"
test1() {
	STEAMSHIP_HOST_SHOW_FULL='false'
	HOST='myhost.local'
	HOSTNAME=${HOST}

	test1_name=${1}
	test1_with_prefix=$(steamship_host -p)
	test1_without_prefix=$(steamship_host)
	test1_host="${STEAMSHIP_BLUE}myhost${STEAMSHIP_BASE_COLOR}"
	test1_with_prefix_expected="at ${test1_host} "
	test1_without_prefix_expected="${test1_host} "

	assert_equal "${test1_name}" \
		"short host, with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"short host, without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	unset STEAMSHIP_HOST_SHOW_FULL HOST HOSTNAME
}

TESTS="${TESTS} test2"
test2() {
	STEAMSHIP_HOST_SHOW_FULL='true'
	HOST='myhost.local'
	HOSTNAME=${HOST}

	test2_name=${1}
	test2_with_prefix=$(steamship_host -p)
	test2_without_prefix=$(steamship_host)
	test2_host="${STEAMSHIP_BLUE}myhost.local${STEAMSHIP_BASE_COLOR}"
	test2_with_prefix_expected="at ${test2_host} "
	test2_without_prefix_expected="${test2_host} "

	assert_equal "${test2_name}" \
		"full host, with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"full host, without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	unset STEAMSHIP_HOST_SHOW_FULL HOST HOSTNAME
}

TESTS="${TESTS} test3"
test3() {
	STEAMSHIP_HOST_SHOW_FULL='false'
	SSH_CONNECTION='true'
	HOST='myhost.local'
	HOSTNAME=${HOST}

	test3_name=${1}
	test3_with_prefix=$(steamship_host -p)
	test3_without_prefix=$(steamship_host)
	test3_host="${STEAMSHIP_GREEN}@myhost${STEAMSHIP_BASE_COLOR}"
	test3_with_prefix_expected="at ${test3_host} "
	test3_without_prefix_expected="${test3_host} "

	assert_equal "${test3_name}" \
		"ssh, with prefix" \
		"${test3_with_prefix}" \
		"${test3_with_prefix_expected}"
	assert_equal "${test3_name}" \
		"ssh, without prefix" \
		"${test3_without_prefix}" \
		"${test3_without_prefix_expected}"

	unset STEAMSHIP_HOST_SHOW_FULL HOST HOSTNAME
}

run_tests
