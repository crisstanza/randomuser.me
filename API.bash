#!/bin/bash
clear ; cd "$(dirname "${0}")" ; . ./config/header.bash
#######################################################

me() {
	local ENDPOINT="${HOST}/api/?nat=br"
	get "${ENDPOINT}" --header 'Accept: application/json'
}

list() {
	local ENDPOINT="${HOST}/api/?results=5"
	get "${ENDPOINT}" --header 'Accept: application/json'
}

include_fields_example() {
	local ENDPOINT="${HOST}/api/?inc=name,email"
	get "${ENDPOINT}" --header 'Accept: application/json'
}

######################
. ./config/footer.bash
