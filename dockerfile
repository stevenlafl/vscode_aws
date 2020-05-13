FROM codercom/code-server:3.2.0

# setup entrypoint file and apply execution rights
ADD ./entrypoint.sh /bootstrap/entrypoint.sh

EXPOSE 8080

# Install neccessary packages for PHP and Xdebug to work
RUN code-server --install-extension felixfbecker.php-debug && \
	code-server --install-extension felixfbecker.php-intellisense && \
	code-server --install-extension donjayamanne.githistory

# send it
ENTRYPOINT ["/bootstrap/entrypoint.sh"]