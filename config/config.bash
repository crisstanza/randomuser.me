ENV=randomuser
# ENV=local

##
# To use json formatted output you need to install "jq": choco install jq
#
JSON=yes
# JSON=no

if [[ "${ENV}" == 'local' ]] ; then
    HOST=http://localhost:9999

elif [[ "${ENV}" == 'randomuser' ]] ; then
    HOST=https://randomuser.me

else
    echo -e "\n[ERROR] Invalid ENV=${ENV}.\n"
    exit 1
fi
