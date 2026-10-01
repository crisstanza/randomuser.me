########################## HIC SUNT DRACONES ##########################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\e[34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

BOLD='\e[1m'
ITALIC='\e[3m'

RESET='\e[0m'

function _quit() { # pseudo-private
    exit 0;
}

function _invalid_option() { # pseudo-private
    local option="${1}"
    echo -e "${RED}Error.${RESET} Invalid option: ${GREEN}${option}${RESET}.\n"
}

function _print_quit() { # pseudo-private
    echo -e " ${BLUE}q)${RESET} ${ITALIC}quit${RESET}"
}

function _menu() { # pseudo-private
    shopt -s lastpipe
    local COMMANDS=()
    while true ; do
        echo -ne ${CYAN}
        printf '%*s\n' "$(tput cols)" '' | tr ' ' _ ; echo -ne ${RESET}
        echo -e "\n${BOLD}Available commands:${RESET}\n"
        local quitPrinted=no
        local i=1
        local minOption=0
        local maxOption=0
        cat `basename ${0}` | grep -v '^function\s_' | grep '()\s{' | \
        while read functionName ; do
            local command=${functionName%%()*}
            if [[ "${command}" == 'quit' ]]; then
                _print_quit
                quitPrinted=true
            else
                if (( i == 1 )) ; then
                    minOption=1
                fi
                echo -e " ${GREEN}${i})${RESET} ${command}"
                COMMANDS[${i}]=${command}
                ((i++))
            fi
        done
        ((i--))
        maxOption=${i}
        if [[ "${quitPrinted}" == 'no' ]]; then
            _print_quit
        fi
        echo ; echo -n ': ' ; read -e options ; echo
        for option in ${options} ; do
            local commandToRun=''
            if [[ "${option}" =~ ^[0-9]+$ ]]; then
                if (( option < minOption || option > maxOption)) ; then
                    commandToRun=''
                    _invalid_option "${option}"
                else
                    commandToRun=${COMMANDS[option]}
                fi
            elif [[ "${option}" == -* ]]; then
                commandToRun=''
                _invalid_option "${option}"
            else
                if [[ "${option,,}" == 'q' ]]; then
                    commandToRun='_quit'
                else
                    commandToRun=${option}
                fi
            fi
            if [[ "${commandToRun}" != "" ]] ; then
                "${commandToRun}" ; echo ; echo
            fi
        done
    done
}

function _main() { # pseudo-private
    if [ ${#} -eq 0 ] ; then
        echo -e "${BOLD}Usage:${RESET} ${0} [COMMANDS]\n" ; _menu
    else
        for COMMAND in "${@}" ; do "${COMMAND}" ; echo ; done
    fi
}

function _replaceInFile() { # pseudo-private
    local OLD="${1}"
    local NEW="${2}"
    local FILE="${3}"
    sed -i "s/${OLD}/${NEW}/g" "${FILE}"
}

_main "${@}"

########################## /HIC SUNT DRACONES ##########################
