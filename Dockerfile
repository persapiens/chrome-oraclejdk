FROM persapiens/oraclejdk:8u152
MAINTAINER Marcelo Fernandes <persapiens@gmail.com>

# update and upgrade
RUN apt-get update -qqy && \
    apt-get upgrade -qqy --no-install-recommends

# install file tools
RUN apt-get install -qqy wget

# install headless gui tools
RUN apt-get install -qqy xvfb dbus-x11 fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

# install google chrome
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get install -qqy ${CHROME_VERSION:-google-chrome-stable}

# install chrome launch script modification
COPY chrome_launcher.sh /opt/google/chrome/google-chrome
RUN chmod +x /opt/google/chrome/google-chrome

# fix chrome error
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# clean temporary files
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/* && \
    rm /etc/apt/sources.list.d/google-chrome.list

# create chrome folders
RUN mkdir /.config /.cache /.local /.gnome /.pki && \
    chmod 777 /.config /.cache /.local /.gnome /.pki
