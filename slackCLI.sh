#!/bin/bash

# Script by Thomas Klapwijk. https://www.github.com/sircipher/slackCLI/
# This script was designed to fulfill some CI requirements for an Android project.
# As part of my final year university project.

message=""
json=""
imageUrl=""
filePath=""
footer=""
displayVar=''

# Replace this variable with the Slack incoming webhook.
webHook="https://hooks.slack.com/services/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"

function send_message () {  
    create_payload

    if [ "$displayVar" = "true" ]; then 
        curl -s -d "payload=$json" ${webHook} > /dev/null
    else
        curl -s -d "payload=$json" ${webHook}
    fi
}

function howTo(){
    echo "Usage:"
    echo
    echo "A simple Slack CLI that can send messages and images to a specified channel."
    echo 
    echo "Args: -m -i -c -h."
    echo "-h displays this."
    echo "-m MESSAGE. Sends a message"
    echo "-i URL. Sends a message with an image url specified."
}

# Populates json with the supplied parameters.
function create_payload(){
    json='{
        "text" : "'${message}'",
        "attachments": [
        {
            "fallback": "",
            "author_name": "'${footer}'",
            "color": "#36a64f",
            "image_url": "'${imageUrl}'"
        }
    ]
    }'
}

# Uploads the file supplied. Updates the imageUrl variable for the payload.
function upload(){
    wget https://raw.githubusercontent.com/SirCipher/imgur.sh/master/imgur.sh
    chmod a+x imgur.sh

    # Upload the file and get the file URL.
    imageUrl=$(./imgur.sh ${filePath})

    # Cut the start of the string to get absolute URL.
    imageUrl="$( cut -d ':' -f 2- <<< "$imageUrl" )";

    # Remove whitespace at start of retreived URL.
    imageUrl="${imageUrl#"${imageUrl%%[![:space:]]*}"}"
    echo ${imageUrl}
}

# Check curl availability.
type curl &>/dev/null || {
    echo "Curl not found. Required." >&2
    exec 17
}

# Check if arguments are empty.
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    echo
    howTo
    exit 1
fi

while getopts i:m:h:u:f:q option
do
    case "${option}"
    in
            f)  footer=${OPTARG};;
            m)  message=${OPTARG};;
            i)  imageUrl=${OPTARG};;
            h)  howTo;;
            u)  filePath=${OPTARG}
                upload;;
            q)  displayVar=true;;
    esac
done

send_message

exit 0