FROM persapiens/oraclejdk:8u171
MAINTAINER Marcelo Fernandes <persapiens@gmail.com>

ARG CHROME_VERSION="google-chrome-stable"

# fix chrome error
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# install headless gui tools, google chrome and create chrome folders
RUN apt-get update -qqy && \
  apt-get upgrade -qqy --no-install-recommends && \
  apt-get install -qqy xvfb dbus-x11 fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic && \
  apt-get install -qqy curl && \
  curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
  apt-get update -qqy && \
  apt-get install -qqy ${CHROME_VERSION:-google-chrome-stable} && \
  apt-get remove --purge --auto-remove -y curl && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/* && \
  rm /etc/apt/sources.list.d/google-chrome.list && \
  mkdir /.config /.cache /.local /.gnome /.pki && \
  chmod 777 /.config /.cache /.local /.gnome /.pki

# install chrome launch script modification
ADD chrome_launcher.sh /opt/google/chrome/google-chrome
RUN chmod +x /opt/google/chrome/google-chrome
