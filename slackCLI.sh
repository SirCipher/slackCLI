#!/bin/bash
message=""
json=""
imageUrl=""
filePath=""
webhook="https://hooks.slack.com/services/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"

function send_message () {  
    create_payload
    curl -s -d "payload=$json" ${webhook}
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
        "channel" : "general",
        "attachments": [{
            "fallback": "",
            "color": "#36a64f",
            "image_url": "'${imageUrl}'"
        }]    
    }'
}

# Uploads the file supplied. Updates the imageUrl variable for the payload.
function upload(){
    wget https://raw.githubusercontent.com/SirCipher/imgur.sh/master/imgur.sh
    chmod a+x imgur.sh
    imageUrl=$(./imgur.sh ${filePath})
    imageUrl="$( cut -d ':' -f 2- <<< "$imageUrl" )";
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

while getopts i:m:h:u: option
do
    case "${option}"
    in
            m)  message=${OPTARG};;
            i)  imageUrl=${OPTARG};;
            h)  howTo;;
            u)  filePath=${OPTARG}
                upload;;
    esac
done

send_message

exit 0


