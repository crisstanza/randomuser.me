. ./config/config.bash
######################

function delete() {
	request -X 'DELETE' "$@"
}

function get() {
	request -X 'GET' "$@"
}

function head() {
	request -X 'HEAD' "$@"
}

function options() {
	request -X 'OPTIONS' "$@"
}

function patch() {
	request -X 'PATCH' "$@"
}

function post() {
	request -X 'POST' "$@"
}

function put() {
	request -X 'PUT' "$@"
}

##########################################################
# -S, --show-error         Show error even when -s is used
# -s, --silent             Silent mode
# -w, --write-out <format> Use output FORMAT after completion
#
function request() {
	if [[ "${JSON}" == 'yes' ]] ; then
		curl -s -S -w "%{response_code} %{time_total}" "$@" | jq .
	else
		curl -s -S -w "\n\nStatus: %{response_code}\nTime: %{time_total}\n" "$@"
	fi
}
