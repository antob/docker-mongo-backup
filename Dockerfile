FROM debian:jessie
MAINTAINER Tobias Lindholm <tobias.lindholm@antob.se>

# Set the time zone
ENV TZ Europe/Stockholm
RUN echo "Europe/Stockholm" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# Install packages
RUN apt-get update && \
    apt-get install -y rsyslog cron vim mongodb-clients --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Create the cron log file
RUN touch /var/log/cron.log

ADD backups-cron /etc/cron.d/backups-cron
ADD backups.sh /backups.sh
ADD start.sh /start.sh

CMD ["/start.sh"]
