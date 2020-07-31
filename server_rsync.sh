#!/bin/bash
#
# ©2020 Copyright 2020 Robert D. Chin
#
# Usage: bash server_rsync.sh
#        (not sh server_rsync.sh)
#
# +----------------------------------------+
# |        Default Variable Values         |
# +----------------------------------------+
#
VERSION="2020-07-01 22:56"
THIS_FILE="server_rsync.sh"
TEMP_FILE=$THIS_FILE"_temp.txt"
GENERATED_FILE=$THIS_FILE"_menu_generated.lib"
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
#& Usage: bash server_rsync.sh
#&        (not sh server_rsync.sh)
#
# +----------------------------------------+
# |             Help and Usage             |
# +----------------------------------------+
#
#?    Usage: bash server_rsync.sh [OPTION]
#? Examples:
#?
#?bash server_rsync.sh text       # Use Cmd-line user-interface (80x24 min.).
#?                     dialog     # Use Dialog   user-interface.
#?                     whiptail   # Use Whiptail user-interface.
#?
#?bash server_rsync.sh --help     # Displays this help message.
#?                     -?
#?
#?bash server_rsync.sh --about    # Displays script version.
#?                     --version
#?                     --ver
#?                     -v
#?
#?bash server_rsync.sh --history  # Displays script code history.
#?                     --hist
#
# +----------------------------------------+
# |           Code Change History          |
# +----------------------------------------+
#
## Code Change History
##
## 2020-07-02 *Use library common_bash_function.lib.
##
## 2020-07-01 *Release 1.0 "Amy".
##             Last release without dependency on common_bash_function.lib.
##             *Updated to latest standards.
##
## 2020-05-06 *f_msg_ui_file_box_size, f_msg_ui_file_ok bug fixed in display.
##
## 2020-05-04 *f_update_menu_gui adjusted menu display parameters for Whiptail.
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
## 2015-11-27 *f_rsync_gui2 include the start and end times in the same window
##             as the summary of actions.
##
## 2015-10-10 *f_rsync_text, f_rsync_gui added check for existence of log file
##             /var/log/rsync.
##
## 2015-09-09 *rsync_gui call f_free_gui to display mount-points if a bad
##             mount-point is specified.
##
## 2015-09-07 *f_free, f_free_gui changed options of df command to display
##             local plus networked mount-points and exclude virtual filesystems.
##
## 2015-08-27 *f_free_txt, f_free_gui used "type" command for testing
##             whether "df" command has advanced options.
##
## 2015-08-21 *f_rsync_text2, f_display_log changed to use "more" application
##             if "most" application is not installed (using "type" command).
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
# |          Function f_about          |
# +------------------------------------+
#
#     Rev: 2020-06-27
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: DELIM.
# Outputs: None.
#
#    NOTE: This function needs to be in the same library or file as
#          the function f_display_common.
#
f_about () {
      #
      # Display text (all lines beginning ("^") with "#& " but do not print "#& ").
      # sed substitutes null for "#& " at the beginning of each line
      # so it is not printed.
      DELIM="^#&"
      f_display_common $1 $DELIM
      #
} # End of f_about.
#
# +------------------------------------+
# |      Function f_code_history       |
# +------------------------------------+
#
#     Rev: 2020-06-27
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: DELIM.
# Outputs: None.
#
#    NOTE: This function needs to be in the same library or file as
#          the function f_display_common.
#
f_code_history () {
      #
      # Display text (all lines beginning ("^") with "##" but do not print "##").
      # sed substitutes null for "##" at the beginning of each line
      # so it is not printed.
      DELIM="^##"
      f_display_common $1 $DELIM
      #
} # End of function f_code_history.
#
# +------------------------------------+
# |      Function f_help_message       |
# +------------------------------------+
#
#     Rev: 2020-06-27
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: DELIM.
# Outputs: None.
#
#    NOTE: This function needs to be in the same library or file as
#          the function f_display_common.
#
f_help_message () {
      #
      # Display text (all lines beginning ("^") with "#?" but do not print "#?").
      # sed substitutes null for "#?" at the beginning of each line
      # so it is not printed.
      DELIM="^#?"
      f_display_common $1 $DELIM
      #
} # End of f_help_message.
#
# +------------------------------------+
# |     Function f_display_common      |
# +------------------------------------+
#
#     Rev: 2020-06-27
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2=Delimiter of text to be displayed.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
f_display_common () {
      #
      # Specify $THIS_FILE name of the file containing the text to be displayed.
      # $THIS_FILE may be re-defined inadvertently when a library file defines it
      # so when the command, source [ LIBRARY_FILE.lib ] is used, $THIS_FILE is
      # redefined to the name of the library file, LIBRARY_FILE.lib.
      # For that reason, all library files now have the line
      # THIS_FILE="[LIBRARY_FILE.lib]" deleted.
      #
      #================================================================================
      # EDIT THE LINE BELOW TO DEFINE $THIS_FILE AS THE ACTUAL FILE NAME WHERE THE 
      # ABOUT, CODE HISTORY, AND HELP MESSAGE TEXT IS LOCATED.
      #================================================================================
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
      f_message $1 "OK" "Code History (use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
      #
} # End of function f_display_common.
#
# +----------------------------------------+
# |          Function f_menu_main          |
# +----------------------------------------+
#
#     Rev: 2020-07-01
#  Inputs: None.
#    Uses: ARRAY_FILE, GENERATED_FILE, MENU_TITLE.
# Outputs: None.
#
f_menu_main () { # Create and display the Main Menu.
      #
      THIS_FILE="server_rsync.sh"
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
         #================================================================================
         # EDIT THE LINE BELOW TO DEFINE $ARRAY_FILE AS THE ACTUAL FILE NAME (LIBRARY)
         # WHERE THE MENU ITEM DATA IS LOCATED. THE LINES OF DATA ARE PREFIXED BY "#@@".
         #================================================================================
         #
         # Specify library file name with menu item data.
         ARRAY_FILE="server_rsync.lib"
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
      MENU_TITLE="Main_Menu"  # Menu title must substitute underscores for spaces
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_menu_main_temp.txt"
      #
      f_create_show_menu $GUI $GENERATED_FILE $MENU_TITLE $MAX_LENGTH $MAX_LINES $MAX_CHOICE_LENGTH $TEMP_FILE
      #
      if [ -r $GENERATED_FILE ] ; then
         rm $GENERATED_FILE
      fi
      #
} # End of function f_menu_main.
#
# +----------------------------------------+
# |          f_download_library            |
# +----------------------------------------+
#
#     Rev: 2020-06-23
#  Inputs: $1=GitHub Repository
#          $2=file name to download.
#    Uses: ARRAY_FILE, GENERATED_FILE, MENU_TITLE.
# Outputs: None.
#
# PLEASE NOTE: This function needs to be inserted into each script
#              which depends on the library "common_bash_function.lib".
#
f_download_library_template () { # Create and display the Main Menu.
      #
      wget --show-progress $1$2
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
         echo
         echo "!!! wget download failed !!!"
         echo "from GitHub.com for file: $2"
         echo
         echo "Cannot continue, exiting program script."
         sleep 3
         exit 1  # Exit with error.
      fi
      #
      # Make downloaded file executable.
      chmod 755 $2
      #
      echo
      echo ">>> Please run program again after download. <<<"
      echo 
      # Delay to read messages on screen.
      echo -n "Press \"Enter\" key to continue" ; read X
      exit 0
      #
} # End of function f_download_library_template.
#
# PLEASE NOTE: THIS IS A SAMPLE OF A STANDARD MAIN PROGRAM.
#
# **************************************
# ***     Start of Main Program      ***
# **************************************
#
#     Rev: 2020-06-04
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
clear  # Blank the screen.
#
echo "Running script $THIS_FILE"
echo "***   Rev. $VERSION   ***"
echo
sleep 1  # pause for 1 second automatically.
#
clear # Blank the screen.
#
# Invoke common BASH function library.
FILE_DEPENDENCY="common_bash_function.lib"
if [ -x "$FILE_DEPENDENCY" ] ; then
   source $FILE_DEPENDENCY
else
   echo "File Error"
   echo
   echo "Error with required file:"
   echo "\"$FILE_DEPENDENCY\""
   echo
   echo "File is missing or file is not executable."
   echo
   echo "Do you want to download the file: $FILE_DEPENDENCY"
   echo -n "from GitHub.com? (Y/n): " ; read ANS
   case $2 in
        "" | [Yy] | [Yy][Ee][Ss])
           f_download_library "https://raw.githubusercontent.com/rdchin/BASH_function_library/master/" "common_bash_function.lib"
        ;;
        *)
           echo
           echo "Cannot continue, exiting program script."
           echo "Error with required file:"
           echo "\"$FILE_DEPENDENCY\""
           sleep 3
           exit 1  # Exit with error.
        ;;
   esac
   #
fi
#
# Invoke libraries required for this script.
for FILE_DEPENDENCY in server_rsync.lib
    do
       if [ ! -x "$FILE_DEPENDENCY" ] ; then
          f_message "text" "OK" "File Error"  "Error with required file:\n\"$FILE_DEPENDENCY\"\n\n\Z1\ZbFile is missing or file is not executable.\n\n\ZnCannot continue, exiting program script." 3
          echo
          f_abort text
       else
          source "$FILE_DEPENDENCY"
       fi
    done
#
# # Test for files required for this script.
# for FILE_DEPENDENCY in FILE1 FILE2 FILE3
#     do
#        if [ ! -x "$FILE_DEPENDENCY" ] ; then
#           f_message "text" "OK" "File Error"  "Error with required file:\n\"$FILE_DEPENDENCY\"\n\n\Z1\ZbFile is missing or file is not executable.\n\n\ZnCannot continue, exiting program script." 3
#           echo
#           f_abort text
#        fi
#     done
#
# If an error occurs, the f_abort() function will be called.
# trap 'f_abort' 0
# set -e
#
# Set THIS_DIR, SCRIPT_PATH to directory path of script.
f_script_path
#
# Set Temporary file using $THIS_DIR from f_script_path.
TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
#
# Set default TARGET DIRECTORY.
TARGET_DIR=$THIS_DIR
#
# Test for Optional Arguments.
f_arguments $1 $2 # Also sets variable GUI.
#
# If command already specifies GUI, then do not detect GUI i.e. "bash dropfsd.sh dialog" or "bash dropfsd.sh text".
if [ -z $GUI ] ; then
   # Test for GUI (Whiptail or Dialog) or pure text environment.
   f_detect_ui
fi
#
#GUI="whiptail"  # Diagnostic line.
#GUI="dialog"    # Diagnostic line.
#GUI="text"      # Diagnostic line.
#
# Test for BASH environment.
f_test_environment
#
LIB_FILE="server_rsync.lib"
#
# **************************************
# ***           Main Menu            ***
# **************************************
f_menu_main
#
clear   # Blank the screen.
#
 df -hT  # Display hard disk drive statistics mount status.
exit 0  # This cleanly closes the process generated by #!bin/bash. 
        # Otherwise every time this script is run, another instance of
        # process /bin/bash is created using up resources.
        #
# all dun dun noodles.
