#!/usr/bin/bash
## FFMpeg timelapse GIF script
## Can be run from home assistant via shell_command in config.yaml
##
##  shell_command:
##    do_gifweek: nohup /bin/bash /config/timelapsegif.sh "{{ start_date }}" "{{ end_date }}" "{{ cam_path }}" "{{ interval }}" &
##
## Then called from a service.
## I hardcoded the path because i'm lazy, but when run by HA, the 'media' folder is where HA will store it's media,
## like screenshots and whatnot, and is browsable via the UI in the "Media" tab. 
## I'd suggest mounting a remote share in the settings>system>storage section of HA as media, and using that 
## remote share to store images, since timelapse really adds up quick.
##
## I store photos as:
##   /<camera name>/YYYYMMDD/YYYYMMDD-HHMMSS.jpg
## That way the files always remain sequential without needing to sort them,but if you don't use day folders it may bug out and not break at your desired end date
## It could also be run however you wanna run it outside of HA, it should be agnostic of the folder/filenaming scheme so long as they're jpg

interval=${4:-3} # use 4th argument as interval, default to 4 if not provided

# Create file list
createFileList() {
    counter=0
    file_list="/tmp/ffmpeg_files_$$.txt"
    echo "Creating file list from $1"
    
    for file in "/media/timelapse/$2/$1"/*.jpg; do
        if ((++counter % interval == 0)); then
            echo "file '$file'" >> "$file_list"
        fi
    done
    echo "$file_list"
}

callFFMpeg() {
    local output_date="$1"
    local camera_folder="$2"
    local start_date="$3"
    local file_list="$4"
    
    if [ ! -s "$file_list" ]; then
        echo "No files to process."
        rm -f "$file_list"
        return
    fi
    
    ffmpeg -f concat -safe 0 -i "$file_list" \
           -vf "fps=30,scale=iw/2:ih/2,format=rgb8" -y \
           "/media/timelapse/$camera_folder-$start_date-$output_date.gif"   
    # Clean up the file list
    rm -f "$file_list"
}

# Main logic
if [[ ${#3} > 0 ]] && [[ "${3}&" != "&" ]]; then
    start_date=$1
    end_date=$2
    camera_folder=${3}
    
    # Create a single file list for all processed images
    master_file_list="/tmp/ffmpeg_master_$$.txt"
    > "$master_file_list"  # Clear/create the file
    
    folders=("/media/timelapse/${camera_folder}"/*)
    foldercounter=0
    copy_us=false
    
    for folder in "${folders[@]}"; do
        folder_name=$(basename "$folder")
        foldercounter=$((foldercounter+1))
        
        if [ "$folder_name" == "$start_date" ]; then
            copy_us=true
        fi
        
        if [ "$copy_us" == true ]; then
            # Add files from this folder to master list
            counter=0
            for file in "/media/timelapse/${camera_folder}/${folder_name}"/*.jpg; do
                if ((++counter % interval == 0)); then
                    echo "file '$file'" >> "$master_file_list"
                fi
            done
            
            if [ "$folder_name" == "$end_date" ] || [ "$foldercounter" == "$end_date" ]; then
                copy_us=false
                break
            fi
        fi
    done
    
    callFFMpeg "$end_date" "$camera_folder" "$start_date" "$master_file_list"
fi
