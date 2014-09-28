#!/bin/bash

for f in output/images/*
do
    mogrifu $f --resize 'x615'\> $f
done
