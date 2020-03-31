FROM ubuntu:18.04

# Install Chrome
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -SsfL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists

# Install other tools
RUN apt-get update && \
    apt-get install -y xvfb pulseaudio ffmpeg sudo xdotool && \
    rm -rf /var/lib/apt/lists

# Add chrome-user
RUN useradd -m chrome-user && \
    usermod -aG sudo chrome-user && \
    echo '%sudo ALL=NOPASSWD: ALL' > /etc/sudoers.d/sudo-nopasswd
USER chrome-user
