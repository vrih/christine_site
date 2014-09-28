#!/bin/bash

for f in output/*.html
do
	gzip --best -cn ${f} > ${f}.gz
done

rm output/*.html

for f in output/*.html.gz
do
	mv ${f} output/$(basename $f .gz)
done

gzip --best -cn output/theme/css/style.css > output/theme/css/style.css.gz
mv output/theme/css/style.css.gz output/theme/css/style.css

for f in output/feeds/*.xml
do
	gzip --best -cn ${f} > ${f}.gz
done

for f in output/feeds/*.xml.gz
do
	mv ${f} output/feeds/$(basename $f .gz)
done

for f in output/tag/*.html
do
	gzip --best -cn ${f} > ${f}.gz
done

rm output/tag/*.html

for f in output/tag/*.html.gz
do
	mv ${f} output/tag/$(basename $f .gz)
done


# SITEMAP
gzip --best -cn output/sitemap.xml > output/sitemap.xml.gz
mv output/sitemap.xml.gz output/sitemap.xml
