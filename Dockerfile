FROM debian:jessie
MAINTAINER Tobias Lindholm <tobias.lindholm@antob.se>

# Set the time zone
ENV TZ Europe/Stockholm
RUN echo "Europe/Stockholm" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# Add MongoDB 3.2 APT repo
#
# pub   4096R/EA312927 2015-10-09 [expires: 2017-10-08]
#       Key fingerprint = 42F3 E95A 2C4F 0827 9C49  60AD D68F A50F EA31 2927
# uid                  MongoDB 3.2 Release Signing Key <packaging@mongodb.com>
#
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys "42F3E95A2C4F08279C4960ADD68FA50FEA312927"
RUN echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" > /etc/apt/sources.list.d/mongodb-org.list

# Install packages
RUN apt-get update && \
    apt-get install -y rsyslog cron vim mongodb-org-tools --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Create the cron log file
RUN touch /var/log/cron.log

ADD backups-cron /etc/cron.d/backups-cron
ADD backups.sh /backups.sh
ADD start.sh /start.sh

CMD ["/start.sh"]
