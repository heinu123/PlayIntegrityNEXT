#!/bin/bash

read -e -p "Drag & drop your boot.img : " boot_file
eval boot_file=$boot_file

output_file="$HOME/boot_modified.img"

read -e -p "Word to remove (lineage for example) : " search_string
read -e -p "Word to replace (lineage for example) : " replace_string

perl -pe "s/$search_string/$replace_string/g" "$boot_file" > "$output_file"

echo "The process has been completed."
echo "The final modified file has been saved as: $output_file"
