# Docker Puppetboard
========

# Quick start

The fastest way to get running:

 * [install docker](https://docs.docker.com/installation/#installation)
 * download image: `docker pull kassis/puppetboard`

Here is an example that launches puppetboard on port 80, using certificates store on the host:

<pre>
docker run -d \
         -v /etc/puppetdb/ssl:/srv/ssl \
         -e PUPPETDB_HOST='puppetdb.example.com' \
         -e PUPPETDB_PORT=8081 \
         -e PUPPETDB_SSL_VERIFY='/srv/ssl/ca.pem' \
         -e PUPPETDB_KEY='/srv/ssl/private.pem' \
         -e PUPPETDB_CERT='/srv/ssl/public.pem' \
         kassis/puppetboard
</pre>

NOTE: The container will try to allocate the port 80. If the port is already taken, find out which container is already using it by running docker ps.

# User Feedback
========

# Issues

If you have any problems with or questions about this image, please contact us through a [GitHub](https://github.com/juliengk/docker-puppetboard/issues) issue.
