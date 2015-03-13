FROM debian:wheezy

MAINTAINER Julien K. <docker@kassisol.com>

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get install -y --no-install-recommends apache2 libapache2-mod-wsgi python python-pip ca-certificates wget git

RUN apt-get -y autoremove
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD data/proxy.sh /etc/profile.d/proxy.sh

RUN mkdir -p /srv/puppetboard/http
RUN mkdir -p /srv/puppetboard/ssl
RUN mkdir -p /srv/puppetboard/template

ADD data/run-apache /usr/local/bin/run-apache
RUN chmod +x /usr/local/bin/run-apache

ADD data/update-settings.py /usr/local/bin/update-settings.py
RUN chmod +x /usr/local/bin/update-settings.py

ADD data/update-vhost.py /usr/local/bin/update-vhost.py
RUN chmod +x /usr/local/bin/update-vhost.py

RUN cd /usr/local/src ; git clone -b dev https://github.com/juliengk/puppetboard.git
RUN pip install -r /usr/local/src/puppetboard/requirements.txt
RUN cd /usr/local/src/puppetboard ; python setup.py install --old-and-unmanageable
RUN rm -rf /usr/local/src/puppetboard

ADD data/apache2.conf /etc/apache2/apache2.conf
ADD data/puppetboard.jinja /srv/puppetboard/template/puppetboard.jinja
ADD data/wsgi.py /srv/puppetboard/http/wsgi.py
RUN a2dissite default

# Enable the LDAP module
RUN a2enmod authnz_ldap

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD [ "/usr/local/bin/run-apache" ]
