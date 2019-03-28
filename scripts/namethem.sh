#!/usr/bin/env bash


for file in *.tar.gz;
do
	name=$(zcat $file | grep ">" | head -n 1);
	new_name=$(echo $name | sed 's/[ ,\/]/_/g; s/^>//g');
	mv $file ${new_name}.fna.gz
done
