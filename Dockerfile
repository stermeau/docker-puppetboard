FROM debian:wheezy

MAINTAINER Julien K. <docker@kassisol.com>

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
	&& set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		apache2 \
		libapache2-mod-wsgi \
		python \
		python-pip \
		wget \
	&& apt-get -y autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /srv/http

COPY data/run-apache /usr/local/bin/run-apache
COPY data/apache2.conf /etc/apache2/apache2.conf
COPY data/apache-vhost-puppetboard /etc/apache2/sites-available/puppetboard
COPY data/wsgi.py /srv/http/puppetboard/wsgi.py
COPY data/update-settings.py /usr/local/bin/update-settings.py

RUN chmod +x /usr/local/bin/run-apache \
	&& chmod +x /usr/local/bin/update-settings.py

RUN a2dissite default \
	&& a2ensite puppetboard \
	# Enable the LDAP module
	&& a2enmod authnz_ldap

RUN pip install puppetboard

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD ["/usr/local/bin/run-apache"]
