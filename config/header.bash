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

####################
function request() {
	if [[ "${JSON}" == 'yes' ]] ; then
		curl -s -S -w "%{response_code}" "$@" | jq .
	else
		curl -s -S -w "\n\nStatus: %{response_code}\n" "$@"
	fi
}
