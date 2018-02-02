#!/bin/bash -e

#
# Wraps the browser binary with video recording
#

# TODO: Add a watchdog to stop the video if it exceeds a certain size

WRAPPER_PATH="$1"

mv "${WRAPPER_PATH}" "${WRAPPER_PATH}.selenium"

cat > "${WRAPPER_PATH}" <<EOF
#!/bin/bash

TMUX_SESSION=\$(echo "Recording\${DISPLAY}" | tr -d -C [:alnum:])

function close_recording {
    echo "Closing recording for session \${TMUX_SESSION} "
    tmux send-keys -t \${TMUX_SESSION} q
    timeout 5 sh -c "while tmux has-session -t \${TMUX_SESSION}; do echo .; sleep 1; done"
    echo "Closed recording for session \${TMUX_SESSION}"
}

if [ -n "\${VIDEO_OUT}" ]; then
    # Clean up previous session
    close_recording

    VIDEO_FILE="\${VIDEO_OUT}/\$(date --rfc-3339=ns | tr ' +' 'TZ'  | tr -d ':']).mp4"
    echo "Opening recording for session \${TMUX_SESSION} to file \${VIDEO_FILE}"
    tmux new-session -d -s \${TMUX_SESSION} "ffmpeg -f x11grab -video_size \${SCREEN_WIDTH}x\${SCREEN_HEIGHT} -i \${DISPLAY} -framerate 12 -codec:v libx264 -crf 0 -preset fast \${VIDEO_FILE}"

    trap close_recording EXIT
fi

echo "Starting browser"

"${WRAPPER_PATH}.selenium" \${BROWSER_OPTS} "\$@"

echo "Browser closed with exit code \$?"
EOF

chmod +x "${WRAPPER_PATH}"
