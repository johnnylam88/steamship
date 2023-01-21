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

steamship_load_module colors
steamship_modules_reset

TESTS="${TESTS} test1"
test1() {
	STEAMSHIP_PROMPT_COLOR='WHITE'
	steamship_colors_prompt

	test1_name=${1}
	test1_base_color=${STEAMSHIP_BASE_COLOR}
	test1_base_color_expected=${STEAMSHIP_WHITE}

	assert_equal "${test1_name}" \
		"base color is WHITE" \
		"${test1_base_color}" \
		"${test1_base_color_expected}"

	unset STEAMSHIP_PROMPT_COLOR
}

TESTS="${TESTS} test2"
test2() {
	STEAMSHIP_PROMPT_COLOR='NORMAL'
	steamship_colors_prompt

	test2_name=${1}
	test2_base_color=${STEAMSHIP_BASE_COLOR}
	test2_base_color_expected=${STEAMSHIP_NORMAL}

	assert_equal "${test2_name}" \
		"base color is NORMAL" \
		"${test2_base_color}" \
		"${test2_base_color_expected}"
}

run_tests
