.PHONY: deploy

deploy:
	ssh -t ark "cd /var/www/earthlyhumans.com &&\
		git pull && \
		./hugo"

nginx:
	ssh -t ark "cd /var/www/earthlyhumans.com/conf && \
		sudo cp earthlyhumans.com.conf /etc/nginx/sites-available/earthlyhumans.com.conf && \
		sudo nginx -t && sudo nginx -s reload"

one_time_setup:
	ssh -t ark "cd /var/www/earthlyhumans.com/conf && \
		sudo cp earthlyhumans.com.conf /etc/nginx/sites-available/earthlyhumans.com.conf && \
		sudo ln -s /etc/nginx/sites-available/earthlyhumans.com.conf /etc/nginx/sites-enabled/ "

