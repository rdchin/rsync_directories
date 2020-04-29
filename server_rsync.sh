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
VERSION="2020-04-28 23:03"
THIS_FILE="server_rsync.sh"
TEMP_FILE=$THIS_FILE"_temp.txt"
GENERATED_FILE=$THIS_FILE"_menu_generated.lib"
#
# +----------------------------------------+
# |            Brief Description           |
# +----------------------------------------+
#
#@ Brief Description
#@
#@ This script synchronizes two directories using rsync.
#@ Choose and select the directories to synchronize using either
#@ the Dialog or Whiptail GUI or a text interface.
#@
#@ Usage: bash server_rsync.sh
#@        (not sh server_rsync.sh)
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
#     Rev: 2020-04-28
#  Inputs: $1=Argument
#             [--help] [ -h ] [ -? ]
#             [--about]
#             [--version] [ -ver ] [ -v ] [--about ]
#             [--history] [--hist ]
#             [] [ text ] [ dialog ] [ whiptail ]
#    Uses: None.
# Outputs: GUI, ERROR.
#
f_arguments () {
      #
      # If there is more than one argument, display help USAGE message, because only one argument is allowed.
      if [ $# -ge 2 ] ; then
         f_help_message text
         exit 0  # This cleanly closes the process generated by #!bin/bash. 
                 # Otherwise every time this script is run, another instance of
                 # process /bin/bash is created using up resources.
      fi
      #
      case $1 in
           --help | "-?")
              # If the one argument is "--help" display help USAGE message.
              f_help_message text
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           --about | --version | --ver | -v)
              f_about text
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           --history | --hist)
              f_code_history text
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           -*)
              # If the one argument is "-<unrecognized>" display help USAGE message.
              f_help_message text
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           "" | "text" | "dialog" | "whiptail")
              GUI=$1
           ;;
           *)
              # Display help USAGE message.
              f_help_message text
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
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
#     Rev: 2020-04-20
#  Inputs: $BASH_VERSION (System variable).
#    Uses: None.
# Outputs: None.
#
f_test_environment () {
      #
      # What shell is used? DASH or BASH?
      f_test_dash
      #
      # Test for X-Windows environment. Cannot run in CLI for LibreOffice.
      #if [ x$DISPLAY = x ] ; then
      #   f_message $1 "OK" "Cannot run LibreOffice" "Cannot run LibreOffice without an X-Windows environment.\ni.e. LibreOffice must run in a terminal emulator in an X-Window."
      #   f_abort
      #fi
      #
} # End of function f_test_environment.
#
# +----------------------------------------+
# |          Function f_test_dash          |
# +----------------------------------------+
#
# Test the environment. Are you in the BASH environment?
# Some scripts will have errors in the DASH environment that is the
# default command-line interface shell in Ubuntu.
#
#     Rev: 2020-04-20
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $BASH_VERSION (System variable), GUI.
#    Uses: None.
# Outputs: exit 1.
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
         f_abort text
      fi
      #
} # End of function f_test_dash
#
# +----------------------------------------+
# |        Function f_test_connection      |
# +----------------------------------------+
#
#     Rev: 2020-04-20
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
         f_message $1 "NOK" "Ping Test Internet Connection" " \n\Z1\Zb  No Internet connection, cannot get list of upgradable packages.\Zn"
      else
         f_message $1 "NOK" "Ping Test Internet Connection" "Internet connnection to $2 is good."
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
#     Rev: 2020-04-20
#  Inputs: None.
#    Uses: None.
# Outputs: None.
#
f_exit_script() {
      #
      f_message $1 "NOK" "End of script" " \nExiting script."
      #
      # Blank the screen. Nicer ending especially if you chose custom colors for this script.
      clear 
      #
      exit 0
      #
} # End of function f_exit_script
#
# +----------------------------------------+
# |              Function f_abort          |
# +----------------------------------------+
#
#     Rev: 2020-04-28
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
} # End of function f_abort.
#
# +------------------------------------+
# |          Function f_about          |
# +------------------------------------+
#
#     Rev: 2020-04-28
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
f_about () {
      #
      # Specify $THIS_FILE name of any file containing the text to be displayed.
      THIS_FILE="server_rsync.sh"
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      #
      # Set $VERSION according as it is set in the beginning of $THIS_FILE.
      X=$(grep --max-count=1 "VERSION" $THIS_FILE)
      # X="VERSION=YYYY-MM-DD HH:MM"
      # Use command "eval" to set $VERSION.
      eval $X
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed substitutes null for "#@" at the beginning of each line
      # so it is not printed.
      sed -n 's/^#@//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      f_message $1 "OK" "About (use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
      #
} # End of f_about.
#
# +------------------------------------+
# |      Function f_code_history       |
# +------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
f_code_history () {
      #
      # Specify $THIS_FILE name of any file containing the text to be displayed.
      THIS_FILE="server_rsync.sh"
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      #
      # Set $VERSION according as it is set in the beginning of $THIS_FILE.
      X=$(grep --max-count=1 "VERSION" $THIS_FILE)
      # X="VERSION=YYYY-MM-DD HH:MM"
      # Use command "eval" to set $VERSION.
      eval $X
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#@" but do not print "#@").
      # sed substitutes null for "#@" at the beginning of each line
      # so it is not printed.
      sed -n 's/^##//'p $THIS_DIR/$THIS_FILE >>$TEMP_FILE
      #
      f_message $1 "OK" "Code History (use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
      #
} # End of function f_code_history.
#
# +------------------------------------+
# |      Function f_help_message       |
# +------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
f_help_message () {
      #
      # Specify $THIS_FILE name of any file containing the text to be displayed.
      THIS_FILE="server_rsync.sh"
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      #
      # Set $VERSION according as it is set in the beginning of $THIS_FILE.
      X=$(grep --max-count=1 "VERSION" $THIS_FILE)
      # X="VERSION=YYYY-MM-DD HH:MM"
      # Use command "eval" to set $VERSION.
      eval $X
      #
      echo "Script: $THIS_FILE. Version: $VERSION" >$TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning with "#?" but do not print "#?").
      # sed substitutes null for "#?" at the beginning of each line
      # so it is not printed.
      sed -n 's/^#?//'p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      f_message $1 "OK" "Usage (use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
      #
} # End of f_help_message.
#
# **************************************
# ***     Start of Main Program      ***
# **************************************
#
#
# If an error occurs, the f_abort() function will be called.
# f_abort depends on f_message which must be in this script.
# (especially if library file *.lib is missing).
#
# trap 'f_abort' 0
# set -e
#
# Set THIS_DIR, SCRIPT_PATH to directory path of script.
f_script_path
#
LIB_FILE="server_rsync.lib"
#
if [ -r /$THIS_DIR/$LIB_FILE ] ; then
   # Invoke library file.
   . /$THIS_DIR/$LIB_FILE
else
   echo
   echo "Required module file \"$LIB_FILE\" is missing."
   echo
   echo "Cannot continue, exiting program script."
   echo
   echo "Exiting script"
   echo
   echo "An error occurred, cannot continue. Exiting script."
   exit 1
fi
#
# Test for Optional Arguments.
f_arguments $1  # Also sets variable GUI.
#
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
# **************************************
# ***           Main Menu            ***
# **************************************
f_main_menu
#
#clear   # Blank the screen.
#
# df -hT  # Display hard disk drive statistics mount status.
exit 0  # This cleanly closes the process generated by #!bin/bash. 
        # Otherwise every time this script is run, another instance of
        # process /bin/bash is created using up resources.
        #
# all dun dun noodles.
