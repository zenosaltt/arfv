#!/bin/sh

message=$1
shift

if [ -n "${PROGRESS_LOG:-}" ]; then
	log=$PROGRESS_LOG
	remove_log=0
else
	log=$(mktemp) || exit 1
	remove_log=1
fi
clear_result=${PROGRESS_CLEAR:-0}
hide_success=${PROGRESS_HIDE_SUCCESS:-0}
unset PROGRESS_LOG PROGRESS_CLEAR PROGRESS_HIDE_SUCCESS

spinner_pid=
stop_spinner() {
	if [ -n "$spinner_pid" ]; then
		kill "$spinner_pid" 2>/dev/null || :
		wait "$spinner_pid" 2>/dev/null || :
		printf '\r\033[2K'
		spinner_pid=
	fi
}
cleanup() {
	stop_spinner
	if [ "$remove_log" -eq 1 ]; then
		rm -f "$log"
	fi
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

if [ -t 1 ] && [ "${TERM:-dumb}" != dumb ]; then
	(
		while :; do
			for frame in ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏; do
				printf '\r\033[2K%s %s' "$frame" "$message"
				sleep 0.1
			done
		done
	) &
	spinner_pid=$!
else
	printf '%s\n' "$message"
fi

if "$@" >"$log" 2>&1; then
	status=0
else
	status=$?
fi

if [ -n "$spinner_pid" ]; then
	stop_spinner
	if [ "$clear_result" != 1 ]; then
		if [ "$status" -eq 0 ]; then
			printf '✓ %s\n' "$message"
		else
			printf '✗ %s\n' "$message"
		fi
	fi
fi

if [ "$remove_log" -eq 1 ] && { [ "$status" -ne 0 ] || [ "$hide_success" != 1 ]; }; then
	cat "$log"
fi
exit "$status"
