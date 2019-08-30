page:
	docker run -it --rm -v "$$PWD":/usr/src/app -p "4000:4000" starefossen/github-pages

pages:
	docker run -it --rm -v "$$PWD":/srv/jekyll -p "4000:4000" jekyll/jekyll jekyll build

export:
	ruby export.rb

export_tunnel:
	ssh ssh-114853-tobi@hopit.de -L 0.0.0.0:33360:mysql5.df.eu:3306
	
dep:
	gem install unidecode
	gem install sequel
	gem install jekyll-import
	gem install mysql2

	apk add mariadb-dev
