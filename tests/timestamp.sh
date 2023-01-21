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

steamship_load_module timestamp
steamship_modules_reset

[ -z "${BASH_VERSION}" ] || unset BASH_VERSION

STEAMSHIP_TIMESTAMP_SHOW='true'
STEAMSHIP_TIMESTAMP_PREFIX='at '
STEAMSHIP_TIMESTAMP_SUFFIX=' '
STEAMSHIP_TIMESTAMP_12HR='false'
STEAMSHIP_TIMESTAMP_COLOR='YELLOW'

# Mock
date() { echo '12:34:56'; }

TESTS="${TESTS} test1"
test1() {
	STEAMSHIP_PROMPT_PS1=''
	steamship_timestamp_prompt
	# shellcheck disable=SC2016
	STEAMSHIP_PROMPT_PS1='$(echo "'"${STEAMSHIP_PROMPT_PS1}"'")'

	test1_name=${1}
	eval "test1_ps1=${STEAMSHIP_PROMPT_PS1}"
	test1_ps1_expected="${STEAMSHIP_YELLOW}12:34:56${STEAMSHIP_BASE_COLOR} "

	# shellcheck disable=SC2154
	assert_equal "${test1_name}" \
		"without prefix" \
		"${test1_ps1}" \
		"${test1_ps1_expected}"
}

TESTS="${TESTS} test2"
test2() {
	STEAMSHIP_PROMPT_PS1='me '
	steamship_timestamp_prompt
	# shellcheck disable=SC2016
	STEAMSHIP_PROMPT_PS1='$(echo "'"${STEAMSHIP_PROMPT_PS1}"'")'

	test2_name=${1}
	eval "test2_ps1=${STEAMSHIP_PROMPT_PS1}"
	test2_ps1_expected="me at ${STEAMSHIP_YELLOW}12:34:56${STEAMSHIP_BASE_COLOR} "

	# shellcheck disable=SC2154
	assert_equal "${test2_name}" \
		"with prefix" \
		"${test2_ps1}" \
		"${test2_ps1_expected}"
}

run_tests
