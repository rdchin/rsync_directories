#!/bin/bash
#
# ©2023 Copyright 2023 Robert D. Chin
# Email: RDevChin@Gmail.com
#
# Usage: bash server_rsync.sh
#        (not sh server_rsync.sh)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# +----------------------------------------+
# |        Default Variable Values         |
# +----------------------------------------+
#
VERSION="2024-01-05 19:40"
THIS_FILE="$0"
TEMP_FILE=$THIS_FILE"_temp.txt"
GENERATED_FILE=$THIS_FILE"_menu_generated.lib"
#
#
#================================================================
# EDIT THE LINES BELOW TO SET REPOSITORY SERVERS AND DIRECTORIES
# AND TO INCLUDE ALL DEPENDENT SCRIPTS AND LIBRARIES TO DOWNLOAD.
#================================================================
#
#
#-------------------------------------------------
# Set variables to check for network connectivity.
#-------------------------------------------------
#
# Ping Local File Server Repository
# PING_LAN_TARGET="[FILE SERVER NAME]"
PING_LAN_TARGET="file_server"
#
# Ping Web File Server Repository
# PING_WAN_TARGET="[WEB FILE REPOSITORY]"
PING_WAN_TARGET="raw.githubusercontent.com"
#
#--------------------------------------------------------------
# Set variables to mount the Local Repository to a mount-point.
#--------------------------------------------------------------
#
# LAN File Server shared directory.
SERVER_DIR="//file_server/public"
#
# Local PC mount-point directory.
MP_DIR="/mnt/file_server/public"
#
# Local PC target directory, sub-directory below mount-point directory.
# TARGET_DIR="[ LOCAL MOUNT-POINT DIRECTORY/REPOSITORY SUB-DIRECTORY PATH GOES HERE ]"
TARGET_DIR="/mnt/file_server/public/Repository"
#
#
#=================================================================
# EDIT THE LINES BELOW TO SPECIFY THE FILE NAMES TO UPDATE.
# FILE NAMES INCLUDE ALL DEPENDENT SCRIPTS LIBRARIES.
#=================================================================
#
#
# --------------------------------------------
# Create a list of all dependent library files
# and write to temporary file, FILE_LIST.
# --------------------------------------------
#
# Temporary file FILE_LIST contains a list of file names of dependent
# scripts and libraries.
# Format: [File Name]^[Local/
#
FILE_LIST=$THIS_FILE"_file_temp.txt"
#
# Format: [File Name]^[Local/Web]^[Local repository directory]^[web repository directory]
echo "$THIS_FILE^Local^/mnt/file_server/public/Repository"        > $FILE_LIST
echo "server_rsync.lib^Local^/mnt/file_server/public/Repository" >> $FILE_LIST
echo "common_bash_function.lib^Web^/mnt/file_server/public/Repository^https://raw.githubusercontent.com/rdchin/BASH_function_library/master/" >> $FILE_LIST
#
# Create a list of files FILE_DL_LIST, which need to be downloaded.

# From FILE_LIST (list of script and library files), find the files which
# need to be downloaded and put those file names in FILE_DL_LIST.
#
FILE_DL_LIST=$THIS_FILE"_file_dl_temp.txt"
# Format: [File Name]^[Local/Web]^[Local repository directory]^[web repository directory]
#
# +----------------------------------------+
# |            Brief Description           |
# +----------------------------------------+
#
#& Brief Description
#&
#& This script synchronizes two directories using rsync.
#& Choose and select the directories to synchronize using either
#& the Dialog or Whiptail GUI or a text interface.
#&
#& Required scripts: server_rsync.sh
#&                   server_rsync.lib
#&                   common_bash_function.lib
#&
#& Usage: bash server_rsync.sh
#&        (not sh server_rsync.sh)
#&
#&    This program is free software: you can redistribute it and/or modify
#&    it under the terms of the GNU General Public License as published by
#&    the Free Software Foundation, either version 3 of the License, or
#&    (at your option) any later version.
#&
#&
#&    This program is distributed in the hope that it will be useful,
#&    but WITHOUT ANY WARRANTY; without even the implied warranty of
#&    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#&    GNU General Public License for more details.
#&
#&    You should have received a copy of the GNU General Public License
#&    along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# +----------------------------------------+
# |             Help and Usage             |
# +----------------------------------------+
#
#?    Usage: bash server_rsync.sh [OPTION(S)]
#?
#? Examples:
#?
#?                                 Force display to use a different UI.
#? bash server_rsync.sh text       Use Cmd-line user-interface (80x24 min.)
#?                      dialog     Use Dialog   user-interface.
#?                      whiptail   Use Whiptail user-interface.
#?
#? bash server_rsync.sh --help     Displays this help message.
#?                      -?
#?
#? bash server_rsync.sh --about    Displays script version.
#?                      --version
#?                      --ver
#?                      -v
#?
#? bash server_rsync.sh --update   Update script.
#?                      -u
#?
#? bash server_rsync.sh --history  Displays script code history.
#?                      --hist
#?
#? Examples using 2 arguments:
#?
#? bash server_rsync.sh --hist text
#?                      --ver dialog
#
# +----------------------------------------+
# |           Code Change History          |
# +----------------------------------------+
#
## Code Change History
##
## 2024-01-05 *f_go_nogo_rsync deleted question to rename log file.
##
## 2024-01-03 *f_any changed names of LOG_FILE and TIME_FILE so there would
##             not be double-underscores in the names.
##
## 2023-12-17 *f_any, f_source_target_selected improved user messages.
##
## 2023-12-11 *f_any_select, f_source_target_selected, f_go_nogo_rsync,
##             f_go_nogo_rsync_2, f_rsync2, f_rsync_command improved user
##             messages and improved exit/cancel program flow.
##
## 2023-12-01 *f_source_target_selected allowed the selection of a source
##             or target mount-point and then the selection of a specific
##             directory under that mount-point.
##
## 2023-11-30 *TO-DO f_go_nogo_rsync bug.
##             /home/robert/server_rsync.lib: line 578: [: too many arguments
##
## 2023-11-23 *f_any_source, f_any_target changed the default mount points.
##
## 2023-11-22 *Main Menu bug fixed that generated script would fail
##             server_rsync.sh_menu_main_generated.lib: 
##             line 49: syntax error.
##             `scotty                    "Exit") break  ;;'
##
##             I changed the menu item "File Managers" and put quotation
##             marks around the parameter which specified the directory.
##             The forward slashes caused the syntax error.
##
##             Change from: #@@f_file_manager_select^$GUI^/mnt/scotty
##               Change to: #@@f_file_manager_select^$GUI^"/mnt"
##
##            *f_any added automatic detection of the Target filesystem by
##              using the findmnt command.
##            *f_rsync_command changed to use case statements rather than
##             if-then statements. Also added more rsync options for the
##             linux filesystems to preserve file permissions, group, owner,
##             times, and symlinks.
##            *f_show_mount_points moved to common_bash_function.lib.
##             Changed display for "md" RAID devices
##             to show under "local mounted block devices" rather than
##             under "remote file servers".
##
## 2023-11-19 *f_any, f_any_source, f_any_target improved error checking
##             and added question on filesystem.
##
## 2023-11-16 *Main Menu (Note: Please see 2023-11-22 bug fix for actual
##             solution to the bug below).
##            *Main Menu deleted a forward-slash in a menu item description
##             which caused the script to exit on first run. Subsequent
##             runs worked. On first run, the generated code for the Main
##             Menu was corrupted on the first menu item even though it
##             was not the item which included the forward-slash.
##
## 2023-11-15 *f_any_source, f_any_target updated to use f_ask_question,
##             and f_select_dir.
##
## 2023-11-13 *f_show_mount_points changed options for lsblk command
##             to improve display of RAID member devices.
##            *f_rsync_go_nogo_rsync added changing name of log file.
##
## 2023-11-10 *f_show_mount_points added "FSTYPE" on local storage drives
##             when displaying the information for the local drives.
##             This indicates the local drives which are part of a RAID.
##
## 2023-11-05 *f_show_mount_points updated (from script, mountup.lib).
##             Improved display of information, includes information on
##             both mounted and unmounted local drive devices.
##
## 2022-12-01 *f_check_version, f_show_mount_points updated to latest
##             standards.
##            *f_any, f_any_source, f_any_target, f_go_nogo_rsync,
##             f_rsync, f_rsync2, f_display_log improved comments,
##             log file management, obscure bug fixed.
##            *f_display_var_log_rsync added to preserve the original
##             f_display_log code which finds latest log file.
##
## 2022-06-22 *f_go_nogo_rsync, f_rsync, f_rsync2, f_rsync_command added
##             parameter passing of directories and files.
##             f_go_nogo_rsync added check for empty source directory and
##             abort if empty.
##            *f_rsync_command changed log file date/time stamp format.
##
## 2022-04-20 *fdl_download_missing_scripts fixed bug to prevent downloading
##             from the remote repository if the local repository was
##             unavailable and the script was only in the local repository.
##
## 2022-04-02 *f_any_target changed default mount-point
##             from /media/robert/usb1
##               to /media/usb-dev1
##
## 2022-03-28 *f_file_manager_select added.
##            *Section "Main Menu" added "File Managers".
##            *f_free removed, f_show_mount_points added for better display.
##            *f_show_mount_points added information from lsblk command.
##
## 2022-03-25 *f_rsync_command added manpage documentation in comment lines.
##             deleted rsync option -l --links to create symlinks on the
##             destination. Changed the command to use the GNU standardized
##             parameters (long form) which is more descriptive.
##            *f_rsync2 no longer have an automatic display of the time log
##             summary which is now incorporated into the log file.
##
## 2022-03-22 *f_any_source, f_any_target changed default directory.
##
## 2022-03-13 *Section "Server_Rsync_Menu" updated to latest standards.
##             Added version checking to menu.
##            *f_rsync2 included the time log summary into the
##             /var/log/rsync/ log file.
##            *f_rsync_command renamed log files to latest standard.
##            *f_any renamed TIME_FILE, LOG_FILE to be more descriptive.
##
## 2021-09-23 *f_show_log_gui deleted as obsolete.
##            *f_go_nogo_rsync, f_rsync fixed bug with go-nogo question and
##             moved question to f_go_nogo_rsync.
##            *Improved comments and readability.
##
## 2021-02-13 *Updated to latest standards.
##
## 2020-07-02 *Use library common_bash_function.lib.
##
## 2020-07-01 *Release 1.0 "Amy".
##             Last release without dependency on common_bash_function.lib.
##             *Updated to latest standards.
##
## 2020-05-06 *f_msg_ui_file_box_size, f_msg_ui_file_ok bug fixed.
##
## 2020-05-04 *f_update_menu_gui adjusted Whiptail menu display parameters.
##
## 2020-04-25 *Updated to latest versions of functions.
##
## 2018-04-03 *f_rsync_gui, f_code_history_gui allow dynamic resize of
##             dialog display to improve visibility.
##
## 2017-11-20 *f_main_menu_gui improve visibility of menu choices.
##
## 2017-04-04 *Updated Brief Description.
##
## 2017-02-26 *f_any, f_any_source, f_any_target rewritten to allow
##             cleaner return to Main Menu when "Cancel" button is pressed.
##
## 2016-12-28 *Improved readability of case statements.
##
## 2016-12-17 *Total rewrite of code eliminates some automation such as
##             auto-mounting of share-points, but makes code much simpler.
##            *Text menus no longer based on cliappmenu.sh menu code and
##             have been rewritten for simplicity.
##
## 2016-08-03 *Replace PC server "Peapod" with "Parsley". Peapod died.
##
## 2016-05-04 *TO DO Fix bug false error message, "File has vanished"
##             if file name contains ":" or "?".
##
## 2016-04-18 *Changed dialog msgbox to infobox to simplify user messages.
##
## 2016-03-31 *f_rsync changed from:
##             sudo rsync -rltvhi --progress --delete --force
##             --exclude '.gvfs' --log-file=$LOG_FILE $SOURCE $TARGET
##
##                       changed to:
##             sudo rsync -rltvhi --progress --delete --size-only
##             --exclude '.gvfs' --log-file=$LOG_FILE $SOURCE $TARGET
##
## 2015-11-27 *f_rsync_gui2 include the start and end times in the same
##             window as the summary of actions.
##
## 2015-10-10 *f_rsync_text, f_rsync_gui added check for existence of
##             log file /var/log/rsync.
##
## 2015-09-09 *rsync_gui call f_free_gui to display mount-points if a bad
##             mount-point is specified.
##
## 2015-09-07 *f_free, f_free_gui changed options of df command to display
##             local and networked mount-points, while excluding virtual
##             file systems.
##
## 2015-08-27 *f_free_txt, f_free_gui used "type" command for testing
##             whether "df" command has advanced options.
##
## 2015-08-21 *f_rsync_text2, f_display_log changed to use the "more" app
##             if the "most" application is not installed.
##
## 2015-08-19 *f_display_log, f_display_log_gui added.
##
## 2015-08-17 *f_free_gui trapped error if version of df has no advanced
##             options and if so use basic options instead.
##             Also add ability to show mount-points in the largest screen
##             size/window possible.
##            *f_free use only the most basic options.
##
## 2015-08-16 *f_show_log_file_gui, f_more_gui added ability to show
##             log file in the largest screen size/window possible.
##
## 2015-08-06 *f_free, f_free_gui rewrote to display free space only
##             on mount-points.
##
## 2015-06-27 *f_rsync_command changed from rsync -avhi to -rltvhi for
##             linux partitions so permissions are not preserved.
##             Permissions were causing needless rsync since same
##             users had different UIDs across servers.
##
## 2015-06-25 *f_test_connection added GUI dialog box.
## 2015-06-24 *f_go_nogo_rsync created a textbox for /etc/mtab.
##
## 2015-06-22 *f_password_gui added to prompt for mount-point password.
##            *f_code_history_gui added.
##
## 2015-06-03 *f_main_menu_gui, prompt to use arrow keys or letters only.
##
## 2015-02-17 *f_main_menu_text, f_main_menu_gui changed D1, D2 to X1, X2
##             and changed "df" to "Free".
##            *Change TIME_FILE from rsync_last_date.null*
##             to rsync_time_stamp*.
##
## 2015-01-27_*f_pub2, f_pnb2 corrected spelling of log file.
##
## 2015-01-26 *f_rsync_gui2 added a 4 second pause to read ping messages.
##            *f_test_connection deleted a 5 second pause.
##
## 2015-01-20 *f_test_connection added a 5 second pause.
##
## 2015-01-16 *Added network connectivity test and finished creating GUI
##             dialog boxes for all menus and menu choices.
##
## 2015-01-15 *Fixed bug not detecting previously mounted mount-points.
##
## 2015-01-14 *Changed menus to use "dialog" or "whiptail" if available.
##
## 2015-01-10 *Main Menu change title.
##
## 2015-01-08 *f_drop changed to skip if null source or target PC.
##
## 2015-01-03 *f_drop changed to pattern matching case statements.
##
## 2015-01-02 *f_drop fixed bug if PC Cabbage is target for Dropbox rsync.
##
## 2014-12-28 *Made functional improvements, log and time file names.
##
## 2014-12-26 *Created script using template cli-app-menu-template.sh.
##
## After each edit made, update the "Code Change History" and
## version (date stamp string).
#
# +------------------------------------+
# |     Function f_display_common      |
# +------------------------------------+
#
#     Rev: 2021-03-31
#  Inputs: $1=UI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2=Delimiter of text to be displayed.
#          $3="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $4=Pause $4 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
# Summary: Display lines of text beginning with a given comment delimiter.
#
# Dependencies: f_message.
#
f_display_common () {
      #
      # Set $THIS_FILE to the file name containing the text to be displayed.
      #
      # WARNING: Do not define $THIS_FILE within a library script.
      #
      # This prevents $THIS_FILE being inadvertently re-defined and set to
      # the file name of the library when the command:
      # "source [ LIBRARY_FILE.lib ]" is used.
      #
      # For that reason, all library files now have the line
      # THIS_FILE="[LIBRARY_FILE.lib]" commented out or deleted.
      #
      #
      #==================================================================
      # EDIT THE LINE BELOW TO DEFINE $THIS_FILE AS THE ACTUAL FILE NAME
      # CONTAINING THE BRIEF DESCRIPTION, CODE HISTORY, AND HELP MESSAGE.
      #==================================================================
      #
      #
      THIS_FILE="server_rsync.sh"  # <<<--- INSERT ACTUAL FILE NAME HERE.
      #
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      #
      # Set $VERSION according as it is set in the beginning of $THIS_FILE.
      X=$(grep --max-count=1 "VERSION" $THIS_FILE)
      # X="VERSION=YYYY-MM-DD HH:MM"
      # Use command "eval" to set $VERSION.
      eval $X
      #
      echo "Script: $THIS_FILE. Version: $VERSION" > $TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning ("^") with $2 but do not print $2).
      # sed substitutes null for $2 at the beginning of each line
      # so it is not printed.
      sed -n "s/$2//"p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      case $3 in
           "NOK" | "nok")
              f_message $1 "NOK" "Message" $TEMP_FILE $4
           ;;
           *)
              f_message $1 "OK" "(use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
           ;;
      esac
      #
} # End of function f_display_common.
#
# +----------------------------------------+
# |          Function f_menu_main          |
# +----------------------------------------+
#
#     Rev: 2021-03-07
#  Inputs: $1 - "text", "dialog" or "whiptail" the preferred user-interface.
#    Uses: ARRAY_FILE, GENERATED_FILE, MENU_TITLE.
# Outputs: None.
#
# Summary: Display Main-Menu.
#          This Main Menu function checks its script for the Main Menu
#          options delimited by "#@@" and if it does not find any, then
#          it it defaults to the specified library script.
#
# Dependencies: f_menu_arrays, f_create_show_menu.
#
f_menu_main () { # Create and display the Main Menu.
      #
      GENERATED_FILE=$THIS_DIR/$THIS_FILE"_menu_main_generated.lib"
      #
      # Does this file have menu items in the comment lines starting with "#@@"?
      grep --silent ^\#@@ $THIS_DIR/$THIS_FILE
      ERROR=$?
      # exit code 0 - menu items in this file.
      #           1 - no menu items in this file.
      #               file name of file containing menu items must be specified.
      if [ $ERROR -eq 0 ] ; then
         # Extract menu items from this file and insert them into the Generated file.
         # This is required because f_menu_arrays cannot read this file directly without
         # going into an infinite loop.
         grep ^\#@@ $THIS_DIR/$THIS_FILE >$GENERATED_FILE
         #
         # Specify file name with menu item data.
         ARRAY_FILE="$GENERATED_FILE"
      else
         #
         #
         #================================================================================
         # EDIT THE LINE BELOW TO DEFINE $ARRAY_FILE AS THE ACTUAL FILE NAME (LIBRARY)
         # WHERE THE MENU ITEM DATA IS LOCATED. THE LINES OF DATA ARE PREFIXED BY "#@@".
         #================================================================================
         #
         #
         # Specify library file name with menu item data.
         # ARRAY_FILE="[FILENAME_GOES_HERE]"
           ARRAY_FILE="$THIS_DIR/server_rsync.lib"
      fi
      #
      # Create arrays from data.
      f_menu_arrays $ARRAY_FILE
      #
      # Calculate longest line length to find maximum menu width
      # for Dialog or Whiptail using lengths calculated by f_menu_arrays.
      let MAX_LENGTH=$MAX_CHOICE_LENGTH+$MAX_SUMMARY_LENGTH
      #
      # Create generated menu script from array data.
      #
      # Note: ***If Menu title contains spaces,
      #       ***the size of the menu window will be too narrow.
      #
      # Menu title MUST use underscores instead of spaces.
      MENU_TITLE="Server_Rsync_Menu"
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_menu_main_temp.txt"
      #
      f_create_show_menu $1 $GENERATED_FILE $MENU_TITLE $MAX_LENGTH $MAX_LINES $MAX_CHOICE_LENGTH $TEMP_FILE
      #
      if [ -r $GENERATED_FILE ] ; then
         rm $GENERATED_FILE
      fi
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
} # End of function f_menu_main.
#
# +----------------------------------------+
# |  Function fdl_dwnld_file_from_web_site |
# +----------------------------------------+
#
#     Rev: 2021-03-08
#  Inputs: $1=GitHub Repository
#          $2=file name to download.
#    Uses: None.
# Outputs: None.
#
# Summary: Download a list of file names from a web site.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: wget.
#
#
fdl_dwnld_file_from_web_site () {
      #
      # $1 ends with a slash "/" so can append $2 immediately after $1.
      echo
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<"
      echo ">>> Download file from Web Repository <<<"
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<"
      echo
      wget --show-progress $1$2
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
            echo
            echo ">>>>>>>>>>>>>><<<<<<<<<<<<<<"
            echo ">>> wget download failed <<<"
            echo ">>>>>>>>>>>>>><<<<<<<<<<<<<<"
            echo
            echo "Error copying from Web Repository file: \"$2.\""
            echo
      else
         # Make file executable (useable).
         chmod +x $2
         #
         if [ -x $2 ] ; then
            # File is good.
            ERROR=0
         else
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> File Error after download from Web Repository <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
            echo "$2 is missing or file is not executable."
            echo
         fi
      fi
      #
      # Make downloaded file executable.
      chmod 755 $2
      #
} # End of function fdl_dwnld_file_from_web_site.
#
# +-----------------------------------------------+
# | Function fdl_dwnld_file_from_local_repository |
# +-----------------------------------------------+
#
#     Rev: 2021-03-08
#  Inputs: $1=Local Repository Directory.
#          $2=File to download.
#    Uses: TEMP_FILE.
# Outputs: ERROR.
#
# Summary: Copy a file from the local repository on the LAN file server.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: None.
#
fdl_dwnld_file_from_local_repository () {
      #
      echo
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<"
      echo ">>> File Copy from Local Repository <<<"
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<"
      echo
      eval cp -p $1/$2 .
      ERROR=$?
      #
      if [ $ERROR -ne 0 ] ; then
         echo
         echo ">>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<"
         echo ">>> File Copy Error from Local Repository <<<"
         echo ">>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<"
         echo
         echo -e "Error copying from Local Repository file: \"$2.\""
         echo
         ERROR=1
      else
         # Make file executable (useable).
         chmod +x $2
         #
         if [ -x $2 ] ; then
            # File is good.
            ERROR=0
         else
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> File Error after copy from Local Repository <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
            echo -e "File \"$2\" is missing or file is not executable."
            echo
            ERROR=1
         fi
      fi
      #
      if [ $ERROR -eq 0 ] ; then
         echo
         echo -e "Successful Update of file \"$2\" to latest version.\n\nScript must be re-started to use the latest version."
         echo "____________________________________________________"
      fi
      #
} # End of function fdl_dwnld_file_from_local_repository.
#
# +-------------------------------------+
# |       Function fdl_mount_local      |
# +-------------------------------------+
#
#     Rev: 2021-03-10
#  Inputs: $1=Server Directory.
#          $2=Local Mount Point Directory
#          TEMP_FILE
#    Uses: TARGET_DIR, UPDATE_FILE, ERROR, SMBUSER, PASSWORD.
# Outputs: ERROR.
#
# Summary: Mount directory using Samba and CIFS and echo error message.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: Software package "cifs-utils" in the Distro's Repository.
#
fdl_mount_local () {
      #
      # Mount local repository on mount-point.
      # Write any error messages to file $TEMP_FILE. Get status of mountpoint, mounted?.
      mountpoint $2 >/dev/null 2>$TEMP_FILE
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
         # Mount directory.
         # Cannot use any user prompted read answers if this function is in a loop where file is a loop input.
         # The read statements will be treated as the next null parameters in the loop without user input.
         # To solve this problem, specify input from /dev/tty "the keyboard".
         #
         echo
         read -p "Enter user name: " SMBUSER < /dev/tty
         echo
         read -s -p "Enter Password: " PASSWORD < /dev/tty
         echo sudo mount -t cifs $1 $2
         sudo mount -t cifs -o username="$SMBUSER" -o password="$PASSWORD" $1 $2
         #
         # Write any error messages to file $TEMP_FILE. Get status of mountpoint, mounted?.
         mountpoint $2 >/dev/null 2>$TEMP_FILE
         ERROR=$?
         #
         if [ $ERROR -ne 0 ] ; then
            echo
            echo ">>>>>>>>>><<<<<<<<<<<"
            echo ">>> Mount failure <<<"
            echo ">>>>>>>>>><<<<<<<<<<<"
            echo
            echo -e "Directory mount-point \"$2\" is not mounted."
            echo
            echo -e "Mount using Samba failed. Are \"samba\" and \"cifs-utils\" installed?"
            echo "------------------------------------------------------------------------"
            echo
         fi
         #
         # Discard these variables.
         unset SMBUSER PASSWORD
      fi
      #
} # End of function fdl_mount_local.
#
# +------------------------------------+
# |        Function fdl_source         |
# +------------------------------------+
#
#     Rev: 2021-03-25
#  Inputs: $1=File name to source.
# Outputs: ERROR.
#
# Summary: Source the provided library file and echo error message.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: None.
#
fdl_source () {
      #
      # Initialize ERROR.
      ERROR=0
      #
      if [ -x "$1" ] ; then
         # If $1 is a library, then source it.
         case $1 in
              *.lib)
                 source $1
                 ERROR=$?
                 #
                 if [ $ERROR -ne 0 ] ; then
                    echo
                    echo ">>>>>>>>>><<<<<<<<<<<"
                    echo ">>> Library Error <<<"
                    echo ">>>>>>>>>><<<<<<<<<<<"
                    echo
                    echo -e "$1 cannot be sourced using command:\n\"source $1\""
                    echo
                 fi
              ;;
         esac
         #
      fi
      #
} # End of function fdl_source.
#
# +----------------------------------------+
# |  Function fdl_download_missing_scripts |
# +----------------------------------------+
#
#     Rev: 2021-03-11
#  Inputs: $1 - File containing a list of all file dependencies.
#          $2 - File name of generated list of missing file dependencies.
# Outputs: ANS.
#
# Summary: This function can be used when script is first run.
#          It verifies that all dependencies are satisfied.
#          If any are missing, then any missing required dependencies of
#          scripts and libraries are downloaded from a LAN repository or
#          from a repository on the Internet.
#
#          This function allows this single script to be copied to any
#          directory and then when it is executed or run, it will download
#          automatically all other needed files and libraries, set them to be
#          executable, and source the required libraries.
#
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: None.
#
fdl_download_missing_scripts () {
      #
      # Delete any existing temp file.
      if [ -r  $2 ] ; then
         rm  $2
      fi
      #
      # ****************************************************
      # Create new list of files that need to be downloaded.
      # ****************************************************
      #
      # While-loop will read the file names listed in FILE_LIST (list of
      # script and library files) and detect which are missing and need
      # to be downloaded and then put those file names in FILE_DL_LIST.
      #
      while read LINE
            do
               FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
               if [ ! -x $FILE ] ; then
                  # File needs to be downloaded or is not executable.
                  # Write any error messages to file $TEMP_FILE.
                  chmod +x $FILE 2>$TEMP_FILE
                  ERROR=$?
                  #
                  if [ $ERROR -ne 0 ] ; then
                     # File needs to be downloaded. Add file name to a file list in a text file.
                     # Build list of files to download.
                     echo $LINE >> $2
                  fi
               fi
            done < $1
      #
      # If there are files to download (listed in FILE_DL_LIST), then mount local repository.
      if [ -s "$2" ] ; then
         echo
         echo "There are missing file dependencies which must be downloaded from"
         echo "the local repository or web repository."
         echo
         echo "Missing files:"
         while read LINE
               do
                  echo $LINE | awk -F "^" '{ print $1 }'
               done < $2
         echo
         echo "You will need to present credentials."
         echo
         echo -n "Press '"Enter"' key to continue." ; read X ; unset X
         #
         #----------------------------------------------------------------------------------------------
         # From list of files to download created above $FILE_DL_LIST, download the files one at a time.
         #----------------------------------------------------------------------------------------------
         #
         while read LINE
               do
                  # Get Download Source for each file.
                  DL_FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
                  DL_SOURCE=$(echo $LINE | awk -F "^" '{ print $2 }')
                  TARGET_DIR=$(echo $LINE | awk -F "^" '{ print $3 }')
                  DL_REPOSITORY=$(echo $LINE | awk -F "^" '{ print $4 }')
                  #
                  # Initialize Error Flag.
                  ERROR=0
                  #
                  # If a file only found in the Local Repository has source changed
                  # to "Web" because LAN connectivity has failed, then do not download.
                  if [ -z $DL_REPOSITORY ] && [ $DL_SOURCE = "Web" ] ; then
                     ERROR=1
                  fi
                  #
                  case $DL_SOURCE in
                       Local)
                          # Download from Local Repository on LAN File Server.
                          # Are LAN File Server directories available on Local Mount-point?
                          fdl_mount_local $SERVER_DIR $MP_DIR
                          #
                          if [ $ERROR -ne 0 ] ; then
                             # Failed to mount LAN File Server directory on Local Mount-point.
                             # So download from Web Repository.
                             fdl_dwnld_file_from_web_site $DL_REPOSITORY $DL_FILE
                          else
                             # Sucessful mount of LAN File Server directory.
                             # Continue with download from Local Repository on LAN File Server.
                             fdl_dwnld_file_from_local_repository $TARGET_DIR $DL_FILE
                             #
                             if [ $ERROR -ne 0 ] ; then
                                # Failed to download from Local Repository on LAN File Server.
                                # So download from Web Repository.
                                fdl_dwnld_file_from_web_site $DL_REPOSITORY $DL_FILE
                             fi
                          fi
                       ;;
                       Web)
                          # Download from Web Repository.
                          fdl_dwnld_file_from_web_site $DL_REPOSITORY $DL_FILE
                          if [ $ERROR -ne 0 ] ; then
                             # Failed so mount LAN File Server directory on Local Mount-point.
                             fdl_mount_local $SERVER_DIR $MP_DIR
                             #
                             if [ $ERROR -eq 0 ] ; then
                                # Successful mount of LAN File Server directory.
                                # Continue with download from Local Repository on LAN File Server.
                                fdl_dwnld_file_from_local_repository $TARGET_DIR $DL_FILE
                             fi
                          fi
                       ;;
                  esac
               done < $2
         #
         if [ $ERROR -ne 0 ] ; then
            echo
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> Download failed. Cannot continue, exiting program. <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
         else
            echo
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> Download is good. Re-run required, exiting program. <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
         fi
         #
      fi
      #
      # Source each library.
      #
      while read LINE
            do
               FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
               # Invoke any library files.
               fdl_source $FILE
               if [ $ERROR -ne 0 ] ; then
                  echo
                  echo ">>>>>>>>>><<<<<<<<<<<"
                  echo ">>> Library Error <<<"
                  echo ">>>>>>>>>><<<<<<<<<<<"
                  echo
                  echo -e "$1 cannot be sourced using command:\n\"source $1\""
                  echo
               fi
            done < $1
      if [ $ERROR -ne 0 ] ; then
         echo
         echo
         echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
         echo ">>> Invoking Libraries failed. Cannot continue, exiting program. <<<"
         echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
         echo
      fi
      #
} # End of function fdl_download_missing_scripts.
#
#
# **************************************
# **************************************
# ***     Start of Main Program      ***
# **************************************
# **************************************
#     Rev: 2021-03-11
#
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
# Blank the screen.
clear
#
echo "Running script $THIS_FILE"
echo "***   Rev. $VERSION   ***"
echo
# pause for 1 second automatically.
sleep 1
#
# Blank the screen.
clear
#
#-------------------------------------------------------
# Detect and download any missing scripts and libraries.
#-------------------------------------------------------
#
#----------------------------------------------------------------
# Variables FILE_LIST and FILE_DL_LIST are defined in the section
# "Default Variable Values" at the beginning of this script.
#----------------------------------------------------------------
#
# Are any files/libraries missing?
fdl_download_missing_scripts $FILE_LIST $FILE_DL_LIST
#
# Are there any problems with the download/copy of missing scripts?
if [ -r  $FILE_DL_LIST ] || [ $ERROR -ne 0 ] ; then
   # Yes, there were missing files or download/copy problems so exit program.
   #
   # Delete temporary files.
   if [ -e $TEMP_FILE ] ; then
      rm $TEMP_FILE
   fi
   #
   if [ -r  $FILE_LIST ] ; then
      rm  $FILE_LIST
   fi
   #
   if [ -r  $FILE_DL_LIST ] ; then
      rm  $FILE_DL_LIST
   fi
   #
   exit 0  # This cleanly closes the process generated by #!bin/bash.
           # Otherwise every time this script is run, another instance of
           # process /bin/bash is created using up resources.
fi
#
#***************************************************************
# Process Any Optional Arguments and Set Variables THIS_DIR, GUI
#***************************************************************
#
# Set THIS_DIR, SCRIPT_PATH to directory path of script.
f_script_path
#
# Set Temporary file using $THIS_DIR from f_script_path.
TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
#
# If command already specifies GUI, then do not detect GUI.
# i.e. "bash menu.sh dialog" or "bash menu.sh text".
if [ -z $GUI ] ; then
   # Test for GUI (Whiptail or Dialog) or pure text environment.
   f_detect_ui
fi
#
# Final Check of Environment
#GUI="whiptail"  # Diagnostic line.
#GUI="dialog"    # Diagnostic line.
#GUI="text"      # Diagnostic line.
#
# Test for Optional Arguments.
# Also sets variable GUI.
f_arguments $1 $2
#
# Delete temporary files.
if [ -r  $FILE_LIST ] ; then
   rm  $FILE_LIST
fi
#
if [ -r  $FILE_DL_LIST ] ; then
   rm  $FILE_DL_LIST
fi
#
# Test for X-Windows environment. Cannot run in CLI for LibreOffice.
# if [ x$DISPLAY = x ] ; then
#    f_message text "OK" "\Z1\ZbCannot run LibreOffice without an X-Windows environment.\ni.e. LibreOffice must run in a terminal emulator in an X-Window.\Zn"
# fi
#
# Test for BASH environment.
f_test_environment $1
#
# If an error occurs, the f_abort() function will be called.
# trap 'f_abort' 0
# set -e
#
#********************************
# Show Brief Description message.
#********************************
#
f_about $GUI "NOK" 1
#
#***************
# Run Main Code.
#***************
#
f_menu_main $GUI
#
# Delete temporary files.
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
if [ -e  $FILE_LIST ] ; then
   rm  $FILE_LIST
fi
#
if [ -e  $FILE_DL_LIST ] ; then
   rm  $FILE_DL_LIST
fi
#
# Nicer ending especially if you chose custom colors for this script.
# Blank the screen.
clear
#
exit 0  # This cleanly closes the process generated by #!bin/bash.
        # Otherwise every time this script is run, another instance of
        # process /bin/bash is created using up resources.
        #
# All dun dun noodles.
