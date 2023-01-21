# shellcheck shell=sh

if [ -z "${STEAMSHIP_ROOT}" ]; then
	if [ -f "${PWD}/steamship.sh" ]; then
		STEAMSHIP_ROOT=${PWD}
	elif [ -f "${PWD%/*}/steamship.sh" ]; then
		STEAMSHIP_ROOT=${PWD%/*}
	fi
fi
if [ -f "${STEAMSHIP_ROOT}/lib/utils.sh" ]; then
	. "${STEAMSHIP_ROOT}/lib/utils.sh"
fi

steamship_load_module() {
	if [ -f "${STEAMSHIP_ROOT}/modules/${1}.sh" ]; then
		# shellcheck disable=SC1090
		. "${STEAMSHIP_ROOT}/modules/${1}.sh"
	fi
}

steamship_modules_reset() {
	if [ -n "${STEAMSHIP_MODULES_SOURCED}" ]; then
		for module in ${STEAMSHIP_MODULES_SOURCED}; do
			module_init_fn="steamship_${module}_init"
			eval "${module_init_fn}"
		done
	fi
}

TESTS=

run_tests() {
	if [ -n "${TESTS}" ]; then
		for test_fn in ${TESTS}; do
			eval "${test_fn}" "${test_fn}"
		done
	fi
}

assert_equal()
{
	if [ "${3}" = "${4}" ]; then
		echo "${0} > ${1} > ${2}: pass"
	else
		echo "${0} > ${1} > ${2}: FAIL"
		echo "    expected: ${4}"
		echo "    got:      ${3}"
	fi
}
