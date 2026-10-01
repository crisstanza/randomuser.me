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

COMMANDS=()
MIN_OPTION=0
MAX_OPTION=0

function _init_commands() { # pseudo-private
    shopt -s lastpipe
    local I=1
    cat `basename ${0}` | grep -v '^function\s_' | grep '()\s{' | \
    while read functionName ; do
        local command=${functionName%%()*}
        if [[ "${command}" != 'quit' ]] ; then
            if (( I == 1 )) ; then
                MIN_OPTION=1
            fi
            COMMANDS[${I}]=${command}
            (( I++ ))
        fi
    done
    (( MAX_OPTION = I - 1 ))
}

function _quit() { # pseudo-private
    exit 0;
}

function _validate_option() {
    local CANDIDATE="${1}"
    if (( CANDIDATE > MAX_OPTION || CANDIDATE < MIN_OPTION )) ; then
        echo 0
    else
        echo 1
    fi
}

function _validate_command() {
    local CANDIDATE="${1}"
    if [[ "${CANDIDATE}" == 'clear' ]] ; then
        echo 1
        return
    fi
    for command in ${COMMANDS[*]} ; do
        if [[ "${command}" == "${CANDIDATE}" ]] ; then
            echo 1
            return
        fi
    done
    echo 0
}

function _invalid_option() { # pseudo-private
    local OPTION="${1}"
    echo -e "${RED}[ERROR]${RESET} Invalid option: ${GREEN}${OPTION}${RESET}.\n"
}

function _invalid_command() { # pseudo-private
    local OPTION="${1}"
    echo -e "${RED}[ERROR]${RESET} Invalid command: ${GREEN}${OPTION}${RESET}.\n"
}

function _print_quit() { # pseudo-private
    echo -e " ${BLUE}q)${RESET} ${ITALIC}quit${RESET}"
}

function _print_environment() { # pseudo-private
    echo -e "${BLUE}[INFO]${RESET} Environment: ${GREEN}${BOLD}${ENV}${RESET}.\n"
}

function _run_commands() { # pseudo-private
    local INPUTS="${@}"
    for input in ${INPUTS} ; do
        local COMMAND_TO_RUN=''
        if [[ "${input}" =~ ^[0-9]+$ ]] ; then
            local IS_VALID_OPTION=`_validate_option "${input}"`
            if (( ${IS_VALID_OPTION} == 1 )) ; then
                COMMAND_TO_RUN=${COMMANDS[input]}
            else
                _invalid_option "${input}"
            fi
        elif [[ "${input}" == -* ]] ; then
            _invalid_option "${input}"
        else
            if [[ "${input,,}" == 'q' ]] ; then
                COMMAND_TO_RUN='_quit'
            else
                local IS_VALID_COMMAND=`_validate_command "${input}"`
                if (( ${IS_VALID_COMMAND} == 1 )) ; then
                    COMMAND_TO_RUN=${input}
                else
                    _invalid_command "${input}"
                fi
            fi
        fi
        if [[ "${COMMAND_TO_RUN}" != "" ]] ; then
            "${COMMAND_TO_RUN}"
            echo
        fi
    done
}

function _menu() { # pseudo-private
    while true ; do
        echo -ne ${CYAN}
        printf '%*s\n' "$(tput cols)" '' | tr ' ' _ ; echo -ne ${RESET}
        echo -e "\n${BOLD}Available commands:${RESET}\n"
        local IS_QUIT_PRINTED=0
        local I=1
        for command in ${COMMANDS[*]} ; do
            if [[ "${command}" == 'quit' ]] ; then
                _print_quit
                IS_QUIT_PRINTED=1
            else
                echo -e " ${GREEN}${I})${RESET} ${command}"
                (( I++ ))
            fi
        done
        if (( ${IS_QUIT_PRINTED} == 0 )) ; then
            _print_quit
        fi
        echo ; echo -n ': ' ; read -e options ; echo
        _run_commands "${options}"
    done
}

function _main() { # pseudo-private
    _init_commands
    if [ ${#} -eq 0 ] ; then
        echo -e "\n${BOLD}Usage:${RESET} ${0} [COMMANDS]\n"
        _print_environment
        _menu
    else
        _run_commands "${@}"
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
