ARG SE_IMAGE
ARG SE_VER=3.8.1

FROM selenium/${SE_IMAGE}:${SE_VER}
ARG BROWSER_COMMAND
LABEL authors="Patrick Double <pat@patdouble.com>"

ENV VIDEO_OUT="/opt/video"

USER root

RUN apt-get update -qqy \
    && apt-get -qqy install \
    ffmpeg tmux \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && mkdir -p "${VIDEO_OUT}" && chown seluser "${VIDEO_OUT}"

COPY scripts/wrapper_add_video.sh /opt/bin/wrapper_add_video.sh
RUN /opt/bin/wrapper_add_video.sh $(readlink -f ${BROWSER_COMMAND})

USER seluser

# Prevent the First Run dialog from showing
RUN mkdir -p "/home/seluser/.config/chromium" \
    && touch "/home/seluser/.config/chromium/First Run" \
    && mkdir -p "/home/seluser/.config/google-chrome" \
    && touch "/home/seluser/.config/google-chrome/First Run"
