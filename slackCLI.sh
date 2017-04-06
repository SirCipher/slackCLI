#!/bin/bash
message=""
json=""
imageUrl=""

function send_message () {  
    create_payload
    curl -s -d "payload=$json" https://hooks.slack.com/services/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
}

function howto(){
    echo "Usage:"
    echo
    echo "A simple Slack CLI that can send messages and images to a specified channel."
    echo 
    echo "Args: -m -i -c -h."
    echo "-h displays this."
    echo "-m MESSAGE. Sends a message"
    echo "-i URL. Sends a message with an image url specified."
    echo "-c. To be implemented. This will specify the channel."
    echo "-s. To be implemented. This will specify the API key."
}

# Populates json with the supplied parameterss
function create_payload(){
    json='{
        "text" : "'${message}'",
        "attachments": [{
            "fallback": "",
            "color": "#36a64f",
            "image_url": "'${imageUrl}'",
        }]    
    }'
}

# Check curl availability
type curl &>/dev/null || {
    echo "Curl not found. Required." >&2
    exec 17
}

# Check if arguments are empty
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    echo
    howto
    exit 1
fi

while getopts i:m:c:h: option
do
    case "${option}"
    in
            m)  message=${OPTARG};;
            i)  imageUrl=${OPTARG};;
            h)  howto;; 
    esac
done

exit 0