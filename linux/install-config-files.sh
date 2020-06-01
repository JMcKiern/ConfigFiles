#!/bin/bash

dotfile_dir="${BASH_SOURCE%/*}/../files"
for filename in $(find $dotfile_dir -type f); do
	rel_filename=$(realpath --relative-to=$dotfile_dir $filename)
	echo coping $rel_filename to home dir
	cp $dotfile_dir/$rel_filename ~/$rel_filename
done
