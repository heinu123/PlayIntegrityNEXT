#!/bin/bash

# Deps
sudo apt install zip
sudo apt install lz4

# Menu
mainmenu() {
    echo -ne "
1) Boot.img
2) Kernel zip 
0) Exit
Choose an option:  "
    read -r ans
    case $ans in

    1)
        read -e -p "Drag & drop your boot.img : " boot_file
        eval boot_file="$boot_file"
        
        output_file="boot_modified.img"
        
        read -e -p "Word to remove (lineage for example) : " search_string
        read -e -p "Word to replace (lineage for example) : " replace_string

        if strings "$boot_file" | grep -q "$search_string"; then
            sed "s/$search_string/$replace_string/g" "$boot_file" > "$output_file"
            echo "The process has been completed."
            echo "The final modified file has been saved as: $output_file"
        else
            echo "Failed, that boot.img does not contain that word"
        fi

        ;;
    2)
        read -e -p "Drag & drop your kernel zip  : " zip_kernel 
        eval zip_kernel="$zip_kernel"

        cp "$zip_kernel" . > /dev/null 2>&1

        unzip $zip_kernel -d out

        cp out/Image.lz4 .
        rm out/Image.lz4

        read -e -p "Word to remove (lineage for example) : " search_string
        read -e -p "Word to replace (lineage for example) : " replace_string

        if strings "Image.lz4" | grep -q "$search_string"; then
            lz4 -c -d Image.lz4 | sed "s/$search_string/$replace_string/g" | lz4 -c -l -12 --favor-decSpeed - > Image-patched.lz4 
            echo "The process has been completed."
            echo "The final modified file has been saved as: Image-patched.lz4"
        else
            echo "Failed, Image.lz4 does not contain that word"
            exit
        fi

        mv Image-patched.lz4 out/Image.lz4 

        cd out; zip -r ../KERNEL.zip *

        cd ..

        rm Image.lz4
        
        rm -rf out
        ;;
    0)      
            echo "Bye bye."
            exit 0
            ;;
    *)
        echo "Wrong option."
        mainmenu
        ;;
    esac
}

mainmenu
