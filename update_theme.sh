#!/bin/bash
# This script is to update the repo of theme and re-install the theme.


THEME_DIR=$HOME/.themes
WALLPAPERS_DIR=$HOME/Pictures/wallpapers
PROJECTS_DIR=$HOME/Projects

WORK_DIR=${PROJECTS_DIR}/lib/WhiteSur-gtk-theme
COMMAND_INSTALL=${WORK_DIR}/install.sh
COMMAND_TWEAK=${WORK_DIR}/tweaks.sh


function update_repo() {
    echo "Update the repository of the theme."

    echo "rm old themes."
    rm -rf ${THEME_DIR}/WhiteSur*

    cd ${WORK_DIR}

    git pull

    echo "Install new themes."
    bash ${COMMAND_INSTALL} \
        -c dark -c light \
        -t green \
        -s 280 \
        -i ubuntu
}


function install_theme() {
    echo "Install $1 theme."

    update_repo

    gsettings set org.gnome.desktop.interface gtk-theme WhiteSur-$1-solid-green
    gsettings set org.gnome.shell.extensions.user-theme name WhiteSur-$1-solid-green
    gsettings set org.gnome.desktop.background picture-uri file://${WALLPAPERS_DIR}/$1.jpg

    echo "Tweak the gdm theme."
    sudo bash ${COMMAND_TWEAK} \
        -g \
        -b ${WALLPAPERS_DIR}/$1.jpg \
        -c $1 \
        -t green \
        -i ubuntu
}


USAGE="
This script is to update and change theme.

Usage:
    -c color, [dark, light] is valid
"


while getopts ":hc:" opt; do
    case ${opt} in
        c)
            if [ ${OPTARG} == "light" ] || [ ${OPTARG} == "dark" ]; then
                install_theme ${OPTARG}
                exit 0
            else
                echo "Invalid value of argument $opt, only [light, dark] is valid." 1>&2
                exit 1
            fi
        ;;
        h | *)
            echo "${USAGE}"
            exit 0
        ;;
    esac
done

echo "${USAGE}"
exit 1