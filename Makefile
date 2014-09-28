PY=python
PELICAN=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

SSH_HOST=localhost
SSH_PORT=22
SSH_USER=root
SSH_TARGET_DIR=/var/www

S3_BUCKET=intotheglorybox.com

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

help:
	@echo 'Makefile for a pelican Web site                                        '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make html                        (re)generate the web site          '
	@echo '   make clean                       remove the generated files         '
	@echo '   make regenerate                  regenerate files upon modification '
	@echo '   make publish                     generate using production settings '
	@echo '   make serve [PORT=8000]           serve site at http://localhost:8000'
	@echo '   make devserver [PORT=8000]       start/restart develop_server.sh    '
	@echo '   make stopserver                  stop local server                  '
	@echo '   make ssh_upload                  upload the web site via SSH        '
	@echo '   make s3_upload                   upload the web site via S3         '
	@echo '                                                                       '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html'
	@echo '                                                                       '

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve:
ifdef PORT
	cd $(OUTPUTDIR) && $(PY) -m pelican.server $(PORT)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server
endif

devserver:
ifdef PORT
	$(BASEDIR)/develop_server.sh restart $(PORT)
else
	$(BASEDIR)/develop_server.sh restart
endif

stopserver:
	kill -9 `cat pelican.pid`
	kill -9 `cat srv.pid`
	@echo 'Stopped Pelican and SimpleHTTPServer processes running in background.'

publish:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)

ssh_upload: publish
	scp -P $(SSH_PORT) -r $(OUTPUTDIR)/* $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

minify:
	yui-compressor -o $(OUTPUTDIR)/theme/css/style-min.css $(OUTPUTDIR)/theme/css/style.css 
	mv $(OUTPUTDIR)/theme/css/style-min.css $(OUTPUTDIR)/theme/css/style.css 
	mogrify -resize 615x\> ${OUTPUTDIR}/images/*
	jpegoptim --strip-all $(OUTPUTDIR)/images/*


compress:
	./compress_files.sh

s3_upload: publish minify compress
	aws s3 sync $(OUTPUTDIR)/ s3://${S3_BUCKET}/ --exclude "*" --include "*.html" --content-encoding "gzip" --cache-control "max-age=3600"
	aws s3 sync $(OUTPUTDIR)/ s3://${S3_BUCKET}/ --exclude "*" --include "*.xml" --content-encoding "gzip" --cache-control "max-age=3600"
	aws s3 sync $(OUTPUTDIR)/ s3://${S3_BUCKET}/ --exclude "*" --include "*.css" --content-encoding "gzip" --cache-control "max-age=864000"
	aws s3 sync $(OUTPUTDIR)/ s3://${S3_BUCKET}/ --exclude "*" --include "*.jpg" --cache-control "max-age=2520000"
	aws s3 sync $(OUTPUTDIR)/ s3://${S3_BUCKET}/ --exclude "*" --include "*.JPG" --cache-control "max-age=2520000"
	aws s3 sync $(OUTPUTDIR)/ s3://${S3_BUCKET}/ --exclude "*" --include "*.jpeg" --cache-control "max-age=2520000"
	aws s3 sync $(OUTPUTDIR)/ s3://${S3_BUCKET}/ --exclude "*" --include "*.png" --cache-control "max-age=2520000"

local_test: publish minify
	cp -r output/* /var/http/glorybox/

github: publish
	ghp-import $(OUTPUTDIR)
	git push origin gh-pages

.PHONY: html help clean regenerate serve devserver publish ssh_upload rsync_upload dropbox_upload ftp_upload s3_upload cf_upload github
