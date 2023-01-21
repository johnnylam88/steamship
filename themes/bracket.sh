# shellcheck shell=sh disable=SC2034
# steamship/themes/bracket.sh

STEAMSHIP_THEMES="${STEAMSHIP_THEMES} bracket"

steamship_theme_bracket() {
	# Delimiter and character symbols that form a left bracket
	# between the two lines of the prompt.

	STEAMSHIP_CHARACTER_SHOW='true'
	STEAMSHIP_CHARACTER_SYMBOL='└ '
	STEAMSHIP_CHARACTER_SYMBOL_ROOT=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_CHARACTER_SYMBOL_SUCCESS=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_CHARACTER_SYMBOL_FAILURE=${STEAMSHIP_CHARACTER_SYMBOL}
	STEAMSHIP_CHARACTER_SYMBOL_SECONDARY='├ '

	STEAMSHIP_DELIMITER_SHOW='true'
	STEAMSHIP_DELIMITER_SYMBOL='┌ '
	STEAMSHIP_DELIMITER_SYMBOL_ROOT=${STEAMSHIP_DELIMITER_SYMBOL}
	STEAMSHIP_DELIMITER_SYMBOL_SUCCESS=${STEAMSHIP_DELIMITER_SYMBOL}
	STEAMSHIP_DELIMITER_SYMBOL_FAILURE=${STEAMSHIP_DELIMITER_SYMBOL}

	# Always disable exit_code because it will break the alignment of
	# the delimiter and character symbols.
	STEAMSHIP_EXIT_CODE_SHOW='false'

	# Always show the line separator within the prompt so that it will
	# span two lines, which allows for the delimiter and character
	# symbols to align.
	STEAMSHIP_LINE_SEPARATOR_SHOW='true'
}
