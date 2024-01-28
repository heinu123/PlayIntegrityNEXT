#!/bin/bash

read -e -p "Drag & drop your boot.img : " boot_file
eval boot_file=$boot_file

output_file="$HOME/boot_modified.img"

read -e -p "Word to remove (lineage for example) : " search_string
read -e -p "Word to replace (lineage for example) : " replace_string

if strings "$boot_file" | grep -q "$search_string"; then
    perl -pe "print if s/$search_string/$replace_string/g" "$boot_file" > "$output_file"
    echo "The process has been completed."
    echo "The final modified file has been saved as: $output_file"
else
    echo "Failed, that boot.img does not contain that word"
fi