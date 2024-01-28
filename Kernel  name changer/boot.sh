#!/bin/bash

# Dependencies
sudo dpkg -l | grep -qw zip || sudo apt-get install zip -y
sudo dpkg -l | grep -qw lz4 || sudo apt-get install lz4 -y

# Menu
mainmenu() {
    echo -ne "

- "Warning both strings should have the same number of characters!"
1) Boot.img
2) Kernel zip 
0) Exit
Choose an option:  "
    read -r ans
    case $ans in

    1)
        # Variables
        read -e -p "Drag & drop your boot.img : " boot_file
        eval boot_file="$boot_file"
        
        output_file="boot_modified.img"

        # Make sure that the output will be of the same size
        while true; do
            read -e -p "Word to remove: " search_string
            read -e -p "Word to replace: " replace_string

            # Count the number of words
            search_length=$(echo -n "$search_string" | wc -c)
            replace_length=$(echo -n "$replace_string" | wc -c)

            # Checks
            if [ "$search_string" == "$replace_string" ]; then
                echo "Error: Both strings are the same. Please enter different strings."
            elif [ "$search_length" -ne "$replace_length" ]; then
                echo "Error: Both strings should have the same number of characters!"
            else
                echo "Let's continue!"
                break
            fi
        done

        # Replace the words
        if strings "$boot_file" | grep -q "$search_string"; then
            sed "s/$search_string/$replace_string/g" "$boot_file" > "$output_file"
            echo "The process has been completed."
            echo "The final modified file has been saved as: $output_file"
        else
            echo "Failed, that boot.img does not contain that word"
        fi

        ;;
    2)
        # Variables
        read -e -p "Drag & drop your kernel zip  : " zip_kernel 
        eval zip_kernel="$zip_kernel"

        # Copy kernel.zip
        cp "$zip_kernel" . > /dev/null 2>&1

        # Unzip kernel.zip
        unzip $zip_kernel -d out

        # Copy image.lz4
        cp out/Image.lz4 .
        rm out/Image.lz4

        # Make sure that the output will be of the same size
        while true; do
            read -e -p "Word to remove: " search_string
            read -e -p "Word to replace: " replace_string

            # Count the number of words
            search_length=$(echo -n "$search_string" | wc -c)
            replace_length=$(echo -n "$replace_string" | wc -c)

            # Checks
            if [ "$search_string" == "$replace_string" ]; then
                echo "Error: Both strings are the same. Please enter different strings."
            elif [ "$search_length" -ne "$replace_length" ]; then
                echo "Error: Both strings should have the same number of characters!"
            else
                echo "Let's continue!"
                break
            fi
        done

        # Replace the word
        if strings "Image.lz4" | grep -q "$search_string"; then
            lz4 -c -d Image.lz4 | sed "s/$search_string/$replace_string/g" | lz4 -c -l -12 --favor-decSpeed - > Image-patched.lz4 
            echo "The process has been completed."
            echo "The final modified file has been saved as: Image-patched.lz4"
        else
            echo "Failed, Image.lz4 does not contain that word"
            exit
        fi

        # Build the new xip
        mv Image-patched.lz4 out/Image.lz4 
        cd out; zip -r ../KERNEL.zip *
        cd ..

        # Clean
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
