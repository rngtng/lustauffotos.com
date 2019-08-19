build:
	docker build . -t local
	
page:
	docker run -it --rm -v "$$PWD":/usr/src/app -p "4000:4000" local:latest
