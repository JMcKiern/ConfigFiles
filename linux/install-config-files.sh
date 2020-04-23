#!/bin/bash

files=()
for filename in $(find ./files -type f); do
	rel_filename=$(realpath --relative-to=files $filename)
	files+=($rel_filename)
	echo Found $rel_filename
done

for filename in "${files[@]}"; do
	echo cp ./files/$filename ~/$filename
	cp ./files/$filename ~/$filename
done
