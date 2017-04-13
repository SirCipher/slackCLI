# SlackCLI

A very simple Slack command line interface (CLI) for Slack (Slack.com)
----------------------------------------------------------------------

This script was designed to fulfill some CI requirements for an Android project. As part of my final year university project.

Features
--------
    - Send a message to a channel.
    - Attach an image to the message.
    - Provide a local image to be uploaded and attached.
    - Add footer/author name to an image upload.
    - A quiet mode that silences the output of curl.

Requirements
------------
    - Curl

Setting up the script:
======================

Clone the project:

``` git clone https://github.com/SirCipher/slackCLI.git ```

Grant permissions on the file:

``` chmod a+x slackCLI.sh ```

Slack webhook:
--------------

Go to [apps on the Slack website](https://api.slack.com/apps?new_app) and create a new app. 
Enable incoming webhooks for the new application. 
At the bottom of the page click "Add New Webhook to Team" and then grant permission of the app to a channel of your choice. 
Add the new webhook URL to the slackCLI.sh variable ```$webhook```


Using the script:
=================
Basic usage
-----------
``` ./slackCLI.sh [args]
    -m Message
    -f Footer
    -i Image URL to attach
    -u Image to upload and attach
    -q quiet mode. Stops curl output.
    -h Help
```

Example usage on CircleCI. Capturing, pulling and uploading a screenshot from an Android device to a Slack chat
---------------------------------------------------------------------------------------------------------------
```    
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png
wget https://raw.githubusercontent.com/SirCipher/slackCLI/master/slackCLI.sh
chmod a+x slackCLI.sh
./slackCLI.sh -m "CircleCI build no $CIRCLE_BUILD_NUM" -u "screen.png"
```

Help 
----
``` ./slackCLI.sh -h ``` 

Sending a message
-----------------
``` ./slackCLI.sh -m "message" ```

Adding an image
---------------
``` ./slackCLI.sh -i "url" ```

Adding a footer to the uploaded image
-------------------------------------
``` ./slackCLI.sh -f "text" ```

Uploading an image
------------------
``` ./slackCLI.sh -u "file's local path" ```

Image uploading is done with a fork of [Tremby's](https://github.com/tremby/imgur.sh) imgur.sh script. See the fork [here](https://github.com/SirCipher/imgur.sh).

Quiet mode
----------
``` ./slackCLI.sh -q ```
