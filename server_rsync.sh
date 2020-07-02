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
VERSION="2020-07-01 22:20"
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
# +----------------------------------------+
# |         Function f_script_path         |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $BASH_SOURCE (System variable).
#    Uses: None.
# Outputs: SCRIPT_PATH, THIS_DIR.
#
f_script_path () {
      #
      # BASH_SOURCE[0] gives the filename of the script.
      # dirname "{$BASH_SOURCE[0]}" gives the directory of the script
      # Execute commands: cd <script directory> and then pwd
      # to get the directory of the script.
      # NOTE: This code does not work with symlinks in directory path.
      #
      # !!!Non-BASH environments will give error message about line below!!!
      SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
      THIS_DIR=$SCRIPT_PATH  # Set $THIS_DIR to location of this script.
      #
} # End of function f_script_path.
#
# +----------------------------------------+
# |         Function f_arguments           |
# +----------------------------------------+
#
#     Rev: 2020-06-27
#  Inputs: $1=Argument
#             [--help] [ -h ] [ -? ]
#             [--about]
#             [--version] [ -ver ] [ -v ] [--about ]
#             [--history] [--hist ]
#             [] [ text ] [ dialog ] [ whiptail ]
#             [ --help dialog ]  [ --help whiptail ]
#             [ --about dialog ] [ --about whiptail ]
#             [ --hist dialog ]  [ --hist whiptail ]
#          $2=Argument
#             [ text ] [ dialog ] [ whiptail ] 
#    Uses: None.
# Outputs: GUI, ERROR.
#
f_arguments () {
      #
      # If there is more than two arguments, display help USAGE message, because only one argument is allowed.
      if [ $# -ge 3 ] ; then
         f_help_message text
         #
         clear # Blank the screen.
         #
         exit 0  # This cleanly closes the process generated by #!bin/bash. 
                 # Otherwise every time this script is run, another instance of
                 # process /bin/bash is created using up resources.
      fi
      #
      case $2 in
           "text" | "dialog" | "whiptail")
           GUI=$2
           ;;
      esac
      #
      case $1 in
           --help | "-?")
              # If the one argument is "--help" display help USAGE message.
              if [ -z $GUI ] ; then
                 f_help_message text
              else
                 f_help_message $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           --about | --version | --ver | -v)
              if [ -z $GUI ] ; then
                 f_about text
              else
                 f_about $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           --history | --hist)
              if [ -z $GUI ] ; then
                 f_code_history text
              else
                 f_code_history $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           -*)
              # If the one argument is "-<unrecognized>" display help USAGE message.
              if [ -z $GUI ] ; then
                 f_help_message text
              else
                 f_help_message $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           "text" | "dialog" | "whiptail")
              GUI=$1
           ;;
           "")
           # No action taken as null is a legitimate and valid argument.
           ;;
           *)
              # Check for 1st argument as a valid TARGET DIRECTORY.
              if [ -d $1 ] ; then
                 TARGET_DIR=$1
              else
                 # Display help USAGE message.
                 f_message "text" "OK" "Error Invalid Directory Name" "\Zb\Z1This directory does not exist:\Zn\n $1"
                 f_help_message "text"
                 exit 0  # This cleanly closes the process generated by #!bin/bash. 
                         # Otherwise every time this script is run, another instance of
                         # process /bin/bash is created using up resources.
              fi
           ;;
      esac
      #
}  # End of function f_arguments.
#
# +----------------------------------------+
# |          Function f_detect_ui          |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: None.
#    Uses: ERROR.
# Outputs: GUI (dialog, whiptail, text).
#
f_detect_ui () {
      #
      command -v dialog >/dev/null
      # "&>/dev/null" does not work in Debian distro.
      # 1=standard messages, 2=error messages, &=both.
      ERROR=$?
      # Is Dialog GUI installed?
      if [ $ERROR -eq 0 ] ; then
         # Yes, Dialog installed.
         GUI="dialog"
      else
         # Is Whiptail GUI installed?
         command -v whiptail >/dev/null
         # "&>/dev/null" does not work in Debian distro.
         # 1=standard messages, 2=error messages, &=both.
         ERROR=$?
         if [ $ERROR -eq 0 ] ; then
            # Yes, Whiptail installed.
            GUI="whiptail"
         else
            # No CLI GUIs installed
            GUI="text"
         fi
      fi
      #
} # End of function f_detect_ui.
#
# +----------------------------------------+
# |      Function f_test_environment       |
# +----------------------------------------+
#
#     Rev: 2020-05-01
#  Inputs: $1=GUI.
#          $BASH_VERSION (System variable).
#    Uses: None.
# Outputs: None.
#
f_test_environment () {
      #
      # What shell is used? DASH or BASH?
      f_test_dash $1
      #
      # Test for X-Windows environment. Cannot run in CLI for LibreOffice.
      #if [ x$DISPLAY = x ] ; then
      #   f_message $1 "OK" "Cannot run LibreOffice" "Cannot run LibreOffice without an X-Windows environment.\ni.e. LibreOffice must run in a terminal emulator in an X-Window."
      #   f_abort $1
      #fi
      #
} # End of function f_test_environment.
#
# +----------------------------------------+
# |          Function f_test_dash          |
# +----------------------------------------+
#
#     Rev: 2020-06-22
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $BASH_VERSION (System variable), GUI.
#    Uses: None.
# Outputs: exit 1.
#
# Test the environment. Are you in the BASH environment?
# Some scripts will have errors in the DASH environment that is the
# default command-line interface shell in Ubuntu.
#
f_test_dash () {
      #
      # $BASH_VERSION is null if you are not in the BASH environment.
      # Typing "sh" at the CLI may invoke a different shell other than BASH.
      # if [ -z "$BASH_VERSION" ]; then
      # if [ "$BASH_VERSION" = '' ]; then
      #
      if [ -z "$BASH_VERSION" ]; then 
         # DASH Environment detected, display error message 
         # to invoke the BASH environment.
         f_detect_ui # Automatically detect UI environment.
         #
         TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
         #
         clear  # Blank the screen.
         #
         f_message $1 "OK" ">>> Warning: Must use BASH <<<" "\n                   You are using the DASH environment.\n\n        *** This script cannot be run in the DASH environment. ***\n\n    Ubuntu and Linux Mint default to DASH but also have BASH available."
         f_message $1 "OK" "HOW-TO" "\n  You can invoke the BASH environment by typing:\n    \"bash $THIS_FILE\"\nat the command line prompt (without the quotation marks).\n\n          >>> Now exiting script <<<"
         #
         f_abort $1
      fi
      #
} # End of function f_test_dash
#
# +----------------------------------------+
# |        Function f_test_connection      |
# +----------------------------------------+
#
#     Rev: 2020-06-03
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 Network name of server. 
#    Uses: None.
# Outputs: ERROR. 
#
f_test_connection () {
      #
      # Check if there is an internet connection before doing a download.
      ping -c 1 -q $2 >/dev/null # Ping server address.
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
         f_message $1 "NOK" "Ping Test Network Connection" " \n\Z1\Zb  No network connection to $2.\Zn"
      else
         f_message $1 "NOK" "Ping Test Network Connection" "Network connnection to $2 is good."
      fi
      #
      clear # Blank the screen.
      #
} # End of function f_test_connection.
#
# +----------------------------------------+
# |           Function f_username          |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $1=GUI - "dialog" or "whiptail" The CLI GUI application in use.
#          $2=USERNAME (default).
#          $3=MP - Mount-point to display on --usernamebox.
#    Uses: $TEMP_FILE, ANS.
# Outputs: SMBUSER, ERROR.
#
f_username() {
      #
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      ERROR=0
      #
      case $1 in
           dialog | whiptail)
              $1 --title "User name for $3" --inputbox "Enter SMB mount-point user name:" 10 50 $2 2>$TEMP_FILE
              ERROR=$?
              SMBUSER=$(cat $TEMP_FILE)
           ;;
           text)
              echo
              read -p "Enter user name or n=none ($2): " ANS
              echo
           ;;
      esac
      case $ANS in
              "") SMBUSER=$2 ;;
           N | n) SMBUSER="anonymous" ;;
               *) SMBUSER="$ANS" ;;
      esac
      unset ANS
      #
      if [ -z "$SMBUSER" ] ; then
         SMBUSER=$2
      fi
      #
      case $ERROR in
           1) SMBUSER="" ;;   # <Cancel> button pressed.
           255) SMBUSER="" ;; # <ESC> key pressed.
      esac
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
} # End of function f_username.
#
# +----------------------------------------+
# |           Function f_password          |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $1=GUI - "dialog" or "whiptail" The CLI GUI application in use.
#          $2=MP - Mount-point to display on --passwordbox.
#    Uses: TEMP_FILE.
# Outputs: PASSWORD, ERROR.
#
f_password() {
      #
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      PASSWORD=""
      #
      case $1 in
           dialog)
              $1 --title "Password for $2" --clear --insecure --passwordbox "Enter SMB mount-point password:" 10 70 2>$TEMP_FILE
              ERROR=$?
              PASSWORD=$(cat $TEMP_FILE)
           ;;
           whiptail)
              $1 --title "Password for $2" --clear --passwordbox "Enter SMB mount-point password:" 10 70 2>$TEMP_FILE
              ERROR=$?
              PASSWORD=$(cat $TEMP_FILE)
           ;;
           text)
              echo
              echo "To [Cancel] press \"Enter\" key."
              read -s -p "Password for $2: " PASSWORD
              echo
           ;;
      esac
      case $ERROR in
           1) PASSWORD="" ;;   # <Cancel> button pressed.
           255) PASSWORD="" ;; # <ESC> key pressed.
      esac
      #
      if [ -r  $TEMP_FILE ] ; then
         rm  $TEMP_FILE
      fi
      #
} # End of function f_password.
#
# +----------------------------------------+
# |      Function f_bad_sudo_password      |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $1=GUI.
#    Uses: None.
# Outputs: None.
#
f_bad_sudo_password () {
      #
      f_message $1 "NOK" "Incorrect Sudo password" "\n\Z1\ZbWrong Sudo password. Cannot upgrade software.\Zn"
      #
      clear # Blank the screen.
      #
} # End of function f_bad_sudo_password.
#
# +----------------------------------------+
# | Function f_press_enter_key_to_continue |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: None.
#    Uses: X.
# Outputs: None.
#
f_press_enter_key_to_continue () { # Display message and wait for user input.
      #
      echo
      echo -n "Press '"Enter"' key to continue."
      read X
      unset X  # Throw out this variable.
      #
} # End of function f_press_enter_key_to_continue.
#
# +----------------------------------------+
# |         Function f_exit_script         |
# +----------------------------------------+
#
#     Rev: 2020-05-28
#  Inputs: $1=GUI.
#    Uses: None.
# Outputs: None.
#
f_exit_script() {
      #
      f_message $1 "NOK" "End of script" " \nExiting script." 1
      #
      # Blank the screen. Nicer ending especially if you chose custom colors for this script.
      clear 
      #
      if [ -r  $TEMP_FILE ] ; then
         rm  $TEMP_FILE
      fi
      #
      exit 0
} # End of function f_exit_script
#
# +----------------------------------------+
# |              Function f_abort          |
# +----------------------------------------+
#
#     Rev: 2020-05-28
#  Inputs: $1=GUI.
#    Uses: None.
# Outputs: None.
#
f_abort () {
      #
      # Temporary file has \Z commands embedded for red bold font.
      #
      # \Z commands are used by Dialog to change font attributes 
      # such as color, bold/normal.
      #
      # A single string is used with echo -e \Z1\Zb\Zn commands
      # and output as a single line of string wit \Zn commands embedded.
      #
      # Single string is neccessary because \Z commands will not be
      # recognized in a temp file containing <CR><LF> multiple lines also.
      #
      f_message $1 "NOK" "Exiting script" " \Z1\ZbAn error occurred, cannot continue. Exiting script.\Zn"
      exit 1
      #
      if [ -r  $TEMP_FILE ] ; then
         rm  $TEMP_FILE
      fi
      #
} # End of function f_abort.
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
#     Rev: 2020-06-04
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
         # Specify file name with data.
         ARRAY_FILE="$GENERATED_FILE"
      else
         # Specify file name with data.
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
# # Invoke common BASH function library.
# FILE_DEPENDENCY="common_bash_function.lib"
# if [ -x "$FILE_DEPENDENCY" ] ; then
#    source $FILE_DEPENDENCY
# else
#    echo "File Error"
#    echo
#    echo "Error with required file:"
#    echo "\"$FILE_DEPENDENCY\""
#    echo
#    echo "File is missing or file is not executable."
#    echo
#    echo "Do you want to download the file: $FILE_DEPENDENCY"
#    echo -n "from GitHub.com? (Y/n): " ; read ANS
#    case $2 in
#         "" | [Yy] | [Yy][Ee][Ss])
#            f_download_library "https://raw.githubusercontent.com/rdchin/BASH_function_library/master/" "common_bash_function.lib"
#         ;;
#         *)
#            echo
#            echo "Cannot continue, exiting program script."
#            echo "Error with required file:"
#            echo "\"$FILE_DEPENDENCY\""
#            sleep 3
#            exit 1  # Exit with error.
#         ;;
#    esac
#    #
# fi
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
