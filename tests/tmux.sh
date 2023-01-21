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

steamship_load_module tmux
steamship_modules_reset

STEAMSHIP_TMUX_SHOW='true'
STEAMSHIP_TMUX_PREFIX='via '
STEAMSHIP_TMUX_SUFFIX=' '
STEAMSHIP_TMUX_SYMBOL='%'
STEAMSHIP_TMUX_COLOR='YELLOW'

# Mock
tmux() { echo 'tmux'; }

TESTS="${TESTS} test1"
test1() {
	if steamship_exists tmux; then
		: "do nothing"
	else
		echo "${0} > ${1}: \`tmux' not found: skip"
		return 0
	fi

	TMUX_PANE='0'

	test1_name=${1}
	test1_with_prefix=$(steamship_tmux -p)
	test1_without_prefix=$(steamship_tmux)
	test1_with_prefix_expected="via ${STEAMSHIP_YELLOW}%tmux${STEAMSHIP_BASE_COLOR} "
	test1_without_prefix_expected="${STEAMSHIP_YELLOW}%tmux${STEAMSHIP_BASE_COLOR} "

	assert_equal "${test1_name}" \
		"in tmux, with prefix" \
		"${test1_with_prefix}" \
		"${test1_with_prefix_expected}"
	assert_equal "${test1_name}" \
		"in tmux, without prefix" \
		"${test1_without_prefix}" \
		"${test1_without_prefix_expected}"

	unset TMUX_PANE
}

TESTS="${TESTS} test2"
test2() {
	[ -z "${TMUX_PANE}" ] || unset TMUX_PANE

	test2_name=${1}
	test2_with_prefix=$(steamship_tmux -p)
	test2_without_prefix=$(steamship_tmux)
	test2_with_prefix_expected=
	test2_without_prefix_expected=

	assert_equal "${test2_name}" \
		"no tmux, with prefix" \
		"${test2_with_prefix}" \
		"${test2_with_prefix_expected}"
	assert_equal "${test2_name}" \
		"no tmux, without prefix" \
		"${test2_without_prefix}" \
		"${test2_without_prefix_expected}"

	unset steamship_tmux_env_file
}

run_tests
