.PHONY: deploy deploy2 nginx one_time_setup

help: ## Print this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deploy:
	./hugo && rsync -avz --exclude='.git/' --delete . ark:/var/www/computableverse.com

deploy2:
	ssh -t ark "cd /var/www/computableverse.com &&\
		git pull && \
		./hugo"

nginx:
	ssh -t ark "cd /var/www/computableverse.com/conf && \
		sudo cp computableverse.com.conf /etc/nginx/sites-available/computableverse.com.conf && \
		sudo nginx -t && sudo nginx -s reload"

one_time_setup:
	ssh -t ark "cd /var/www/computableverse.com/conf && \
		sudo cp computableverse.com.conf /etc/nginx/sites-available/computableverse.com.conf && \
		sudo ln -s /etc/nginx/sites-available/computableverse.com.conf /etc/nginx/sites-enabled/ "

