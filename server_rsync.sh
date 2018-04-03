#!/bin/bash
#
VERSION="2018-04-03 14:56"
THIS_FILE="server_rsync.sh"
#
#@ Brief Description
#@ This script synchronizes two directories using rsync.
#@ Choose and select the directories to synchronize using either
#@ the Dialog or Whiptail GUI or a text interface.
#@
#@ Code Change History
#@
#@ 2018-04-03 *f_rsync_gui, f_code_history_gui allow dynamic resize of
#@             dialog display to improve visibility.
#@
#@ 2017-11-20 *f_main_menu_gui improve visibility of menu choices.
#@
#@ 2017-04-04 *Updated Brief Description.
#@
#@ 2017-02-26 *f_any, f_any_source, f_any_target rewritten to allow
#@             cleaner return to Main Menu when "Cancel" button is pressed.
#@
#@ 2016-12-28 *Improved readability of case statements.
#@
#@ 2016-12-17 *Total rewrite of code eliminates some automation such as
#@             auto-mounting of share-points, but makes code much simpler.
#@            *Text menus no longer based on cliappmenu.sh menu code and
#@             have been rewritten for simplicity.
#@
#@ 2016-08-03 *Replace PC server "Peapod" with "Parsley". Peapod died.
#@
#@ 2016-05-04 *TO DO Fix bug false error message, "File has vanished"
#@             if file name contains ":" or "?".
#@
#@ 2016-04-18 *Changed dialog msgbox to infobox to simplify user messages.
#@
#@ 2016-03-31 *f_rsync changed from: 
#@             sudo rsync -rltvhi --progress --delete --force
#@             --exclude '.gvfs' --log-file=$LOG_FILE $SOURCE $TARGET
#@
#@                       changed to:
#@             sudo rsync -rltvhi --progress --delete --size-only
#@             --exclude '.gvfs' --log-file=$LOG_FILE $SOURCE $TARGET
#@
#@ 2015-11-27 *f_rsync_gui2 include the start and end times in the same window
#@             as the summary of actions.
#@
#@ 2015-10-10 *f_rsync_text, f_rsync_gui added check for existence of log file
#@             /var/log/rsync.
#@
#@ 2015-09-09 *rsync_gui call f_free_gui to display mount-points if a bad
#@             mount-point is specified.
#@
#@ 2015-09-07 *f_free, f_free_gui changed options of df command to display
#@             local plus networked mount-points and exclude virtual filesystems.
#@
#@ 2015-08-27 *f_free_txt, f_free_gui used "type" command for testing
#@             whether "df" command has advanced options.
#@
#@ 2015-08-21 *f_rsync_text2, f_display_log changed to use "more" application
#@             if "most" application is not installed (using "type" command).
#@
#@ 2015-08-19 *f_display_log, f_display_log_gui added.
#@
#@ 2015-08-17 *f_free_gui trapped error if version of df has no advanced
#@             options and if so use basic options instead.
#@             Also add ability to show mount-points in the largest screen
#@             size/window possible.
#@            *f_free use only the most basic options.
#@
#@ 2015-08-16 *f_show_log_file_gui, f_more_gui added ability to show
#@             log file in the largest screen size/window possible.
#@
#@ 2015-08-06 *f_free, f_free_gui rewrote to display free space only
#@             on mount-points.
#@
#@ 2015-06-27 *f_rsync_command changed from rsync -avhi to -rltvhi for
#@             linux partitions so permissions are not preserved.
#@             Permissions were causing needless rsync since same
#@             users had different UIDs across servers.
#@
#@ 2015-06-25 *f_test_connection added GUI dialog box.
#@ 2015-06-24 *f_go_nogo_rsync created a textbox for /etc/mtab.
#@
#@ 2015-06-22 *f_password_gui added to prompt for mount-point password.
#@            *f_code_history_gui added.
#@
#@ 2015-06-03 *f_main_menu_gui, prompt to use arrow keys or letters only.
#@
#@ 2015-02-17 *f_main_menu_text, f_main_menu_gui changed D1, D2 to X1, X2
#@             and changed "df" to "Free".
#@            *Change TIME_FILE from rsync_last_date.null* 
#@             to rsync_time_stamp*.
#@
#@ 2015-01-27_*f_pub2, f_pnb2 corrected spelling of log file.
#@
#@ 2015-01-26 *f_rsync_gui2 added a 4 second pause to read ping messages.
#@            *f_test_connection deleted a 5 second pause.
#@
#@ 2015-01-20 *f_test_connection added a 5 second pause.
#@
#@ 2015-01-16 *Added network connectivity test and finished creating GUI
#@             dialog boxes for all menus and menu choices.
#@
#@ 2015-01-15 *Fixed bug not detecting previously mounted mount-points.
#@
#@ 2015-01-14 *Changed menus to use "dialog" or "whiptail" if available.
#@
#@ 2015-01-10 *Main Menu change title.
#@
#@ 2015-01-08 *f_drop changed to skip if null source or target PC.
#@
#@ 2015-01-03 *f_drop changed to pattern matching case statements.
#@
#@ 2015-01-02 *f_drop fixed bug if PC Cabbage is target for Dropbox rsync.
#@
#@ 2014-12-28 *Made functional improvements, log and time file names.
#@
#@ 2014-12-26 *Created script using template cli-app-menu-template.sh.
#@
#@ After each edit made, update the "Code Change History" and
#@ version (date stamp string).
#
# +----------------------------------------+
# |         Function f_script_path         |
# +----------------------------------------+
#
#  Inputs: $BASH_SOURCE (System variable).
#    Uses: None.
# Outputs: SCRIPT_PATH.
#
f_script_path () {
      # BASH_SOURCE[0] gives the filename of the script.
      # dirname "{$BASH_SOURCE[0]}" gives the directory of the script
      # Execute commands: cd <script directory> and then pwd
      # to get the directory of the script.
      # NOTE: This code does not work with symlinks in directory path.
      #
      # !!!Non-BASH environments will give error message about line below!!!
      SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
      #
} # End of function f_script_path
#
# +----------------------------------------+
# |          Function f_detect_ui          |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: ERROR.
# Outputs: GUI (dialog, whiptail, text).
#
f_detect_ui () {
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
} # End of function f_detect_ui
#
# +----------------------------------------+
# |      Function f_test_environment       |
# +----------------------------------------+
#
#  Inputs: $BASH_VERSION (System variable).
#    Uses: None.
# Outputs: None.
#
f_test_environment () {
      # Set default colors in case configuration file is not readable
      # or does not exist.
      FCOLOR="Green" ; BCOLOR="Black" ; UCOLOR="" ; ECOLOR="Red"
      #
      # Test the environment. Are you in the BASH environment?
      # $BASH_VERSION is null if you are not in the BASH environment.
      # Typing "sh" at the CLI may invoke a different shell other than BASH.
      if [ "$BASH_VERSION" = '' ]; then
          echo $(tput setaf 1) # Set font to color red.
          echo "Restart this script by typing:"
          echo "\"bash $THIS_FILE\""
          echo "at the command line prompt (without the quotation marks)."
          echo
          echo "This script needs a BASH environment to run properly."
          echo -n $(tput sgr0) # Set font to normal color.
          f_press_enter_key_to_continue
          f_abort_txt
      fi
      #
} # End of function f_test_environment
#
# +----------------------------------------+
# |          Function f_abort_txt          |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: None.
# Outputs: None.
#
f_abort_txt() {
      echo $(tput setaf 1) # Set font to color red.
      echo >&2 "***************"
      echo >&2 "*** ABORTED ***"
      echo >&2 "***************"
      echo
      echo "An error occurred. Exiting..." >&2
      exit 1
      echo -n $(tput sgr0) # Set font to normal color.
} # End of function f_abort_txt
#
# +----------------------------------------+
# | Function f_press_enter_key_to_continue |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: X.
# Outputs: None.
#
f_press_enter_key_to_continue () { # Display message and wait for user input.
      echo
      echo -n "Press '"Enter"' key to continue."
      read X
      unset X  # Throw out this variable.
      #
} # End of function f_press_enter_key_to_continue
#
# +----------------------------------------+
# |         Function f_password_gui        |
# +----------------------------------------+
#
#  Inputs: $1 - "dialog" or "whiptail" The CLI GUI application in use.
#    Uses: ERROR.
# Outputs: temp.txt, PASSWORD.
#
f_password_gui() {
      PASSWORD=""
      $1 --title "Enter SMB Mount-Point Password" --clear --insecure --passwordbox "Enter SMB mount-point password:" 10 50 2>temp.txt
      ERROR=$?
      PASSWORD=$(cat temp.txt)
      rm temp.txt
      case $ERROR in
           1) PASSWORD="" ;;   # Cancel button pressed.
           255) PASSWORD="" ;; # <ESC> key pressed.
      esac
      unset ERROR
} # End of function f_password_gui
#
# +----------------------------------------+
# |           Function f_free_txt          |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: None.
# Outputs: APP_NAME.
#
f_free_txt () {
      clear  # Clear screen.
      # Test if this version of "df" has these OPTIONS found on newer versions of "df".
      #
      df -h --exclude devtmpfs --exclude tmpfs --output=source,fstype,avail,target >/dev/null 
      ERROR=$?
      if [ $ERROR = 1 ] ; then
         # Test "df" with minimal OPTIONS. Some older versions of "df" do not have the OPTION --output 
         #
         df -Th --exclude devtmpfs --exclude tmpfs >/dev/null
         ERROR=$?
         if [ $ERROR = 1 ] ; then
            echo
            echo "No mount-points are mounted or error reading mounted devices."
            echo
         else
            df -Th --exclude devtmpfs --exclude tmpfs
         fi
      else
         df -h --exclude devtmpfs --exclude tmpfs --output=source,fstype,avail,target
      fi 
      f_press_enter_key_to_continue
} # End of function f_free_txt
#
# +----------------------------------------+
# |          Function f_free_gui           |
# +----------------------------------------+
#
#  Inputs: $THIS_FILE, $1 - "dialog" or "whiptail" The CLI GUI application in use.
#    Uses: None.
# Outputs: temp.txt.
#
f_free_gui () {
      date>temp.txt ; echo "Program script: $THIS_FILE">>temp.txt
      echo >>temp.txt
      # Test if this version of df has these OPTIONS.
      df -h --exclude devtmpfs --exclude tmpfs --output=source,fstype,avail,target >/dev/null 2>&1
      ERROR=$?
      if [ $ERROR = 1 ] ; then
         # Older version of df or nothing mounted, so use df with minimal OPTIONS.
         df -Th --exclude devtmpfs --exclude tmpfs >/dev/null 2>&1
         ERROR=$?
         if [ $ERROR = 1 ] ; then
            # Write error message to temp.txt to display later.
            echo "No mount-points are mounted or error reading mounted devices." >>temp.txt
            echo >>temp.txt
            df -Th --exclude devtmpfs --exclude tmpfs >>temp.txt
         else
            df -Th --exclude devtmpfs --exclude tmpfs >>temp.txt
         fi 
      else
         df -h --exclude devtmpfs --exclude tmpfs --output=source,fstype,avail,target >>temp.txt
         ERROR=$?
      fi 
      #
      if [ $ERROR = 1 ] ; then
         $1 --title "Error from df command" --textbox temp.txt 60 70
      else
         # Get the screen resolution or X-window size.
         # Get rows (height).
         Y=$(stty size | awk '{ print $1 }')
         # Get columns (width).
         X=$(stty size | awk '{ print $2 }')
         #
         $1 --title "Show Mount-points (use arrow keys to scroll up/down/side-ways)" --textbox temp.txt $Y $X 
      fi
      rm temp.txt
      unset X Y  # Throw out this variable.
} # End of function f_free_gui
#
# +----------------------------------------+
# |              Function f_any            |
# +----------------------------------------+
#
#  Inputs: $1=GUI.
#    Uses: X, Y.
# Outputs: APP_NAME.
#
f_any () {
      f_any_source $1
      if [ -n "$SOURCE" ] ; then
         f_any_target $1
         case $TARGET in 
              "")
                 case $1 in
                      text)
                         echo -n $(tput setaf 1) # Set font to color red.
                         echo "Invalid TARGET directory, returning to MAIN menu."
                         echo $(tput sgr0) # Set font to normal color.
                         f_press_enter_key_to_continue
                         ;;
                      dialog | whiptail)
                         # $1 --title "Invalid TARGET directory" --msgbox "Invalid TARGET directory, returning to MAIN menu." 10 55
                         ;;
                 esac
                 ;;
              *)
                 # TARGET_FILESYSTEM is the filesystem of the backup media (i.e. linux, FAT, NTFS),
                 # used to determine best rsync options.
                 TARGET_FILESYSTEM="linux"
                 # TIME_FILE is the file containing time stamps in clear text.
                 TIME_FILE="rsync_time_stamp_from_PC $SNAME to_PC $TNAME.txt"
                 TIME_FILE=$(echo $TIME_FILE | sed 's/ /_/g')   # Substitute "<underscore>" for "<space>" to derive TIME_FILE name.
                 # LOG_FILE is the partial name of the file which contains rsync operation details from last run.
                 LOG_FILE="rsync_from_PC $SNAME to_PC $TNAME.log"
                 LOG_FILE=$(echo $LOG_FILE | sed 's/ /_/g')   # Substitute "<underscore>" for "<space>" to derive LOG_FILE name.
                 #
                 f_go_nogo_rsync $1
                 ;;
         esac
      else
         case $1 in
              text)
                 echo -n $(tput setaf 1) # Set font to color red.
                 echo "Invalid SOURCE directory, returning to MAIN menu."
                 echo $(tput sgr0) # Set font to normal color.
                 f_press_enter_key_to_continue
                 ;;
              dialog | whiptail)
                 # $1 --title "Invalid SOURCE directory" --msgbox "Invalid SOURCE directory, returning to MAIN menu." 10 55
                 ;;
         esac
      fi
} # End of function f_any
#
# +----------------------------------------+
# |          Function f_any_source         |
# +----------------------------------------+
#
#  Inputs: $1=GUI.
#    Uses: X, Y.
# Outputs: APP_NAME.
#
f_any_source () {
      clear  # Blank the screen.
      case $1 in
           text)
              # SOURCE of the data to be synchronized.
              echo "Rsync between any two servers/directories."
              echo
              echo -n "Enter SOURCE directory with trailing / slash: "
              read SOURCE
              echo
              echo "SOURCE directory is now: $SOURCE"
              echo
              if [ -n "$SOURCE" ] ; then
                 echo -n "Enter SOURCE server (leave blank if localhost): "
                 read SNAME
              fi   
              ;;
           dialog)
              # Get the screen resolution or X-window size.
              # Get rows (height).
              Y=$(stty size | awk '{ print $1 }')
              # Get columns (width).
              X=$(stty size | awk '{ print $2 }')
              let Y=Y-17
              let X=X-6
              #
              # GENERATED_FILE="xdir_menu_gui.lib"
              # f_update_menu_gui $GUI $GENERATED_FILE
              # . $GENERATED_FILE  # Invoke Generated file.
              # f_directory_menu_gui $GUI
              #
              SOURCE=$($1 --stdout --backtitle "Use <tab>, <up/down arrows>, <spacebar> and / (slash) to select SOURCE dir." --title "Please choose a SOURCE directory to synchronize." --cancel-label "Exit" --fselect ./ $Y $X)
              ERROR=$?
              if [ $ERROR -eq 0 ] ; then  # Was "Cancel" button pressed?
                 SNAME=$($1 --output-fd 1 --title "Specify SOURCE Server." --inputbox "Enter SOURCE server (leave blank if localhost):" 10 70)
              else
                 SNAME=""  # Cancel button pressed for directory question, don't ask any more questions.
              fi
              ;;
           whiptail)
              #
              # GENERATED_FILE="xdir_menu_gui.lib"
              # f_update_menu_gui $GUI $GENERATED_FILE
              # . $GENERATED_FILE  # Invoke Generated file.
              # f_directory_menu_gui $GUI
              #
              SOURCE=$($1 --title "Rsync between any two servers/directories." --inputbox "Enter SOURCE directory with trailing / slash ." 10 70 3>&1 1>&2 2>&3)
	      ERROR=$?
              if [ $ERROR -eq 0 ] ; then  # Was "Cancel" button pressed?
                 SNAME=$($1 --title "Specify SOURCE Server." --inputbox "Enter SOURCE server (leave blank if localhost):" 10 70 3>&1 1>&2 2>&3)
              else
    	         SNAME=""  # Cancel button pressed for directory question, don't ask any more questions.
              fi
              ;;
      esac
      #
      # Make the default SOURCE Server is localhost.
      if [ -z "$SNAME" ] ; then
         SNAME="localhost"
      fi
      #
} # End of function f_any_source
#
# +----------------------------------------+
# |          Function f_any_target         |
# +----------------------------------------+
#
#  Inputs: $1=GUI.
#    Uses: X, Y.
# Outputs: APP_NAME.
#
f_any_target () {
      case $1 in
           text)
              # TARGET where the data is synchronized.
              echo
              echo -n "Enter TARGET directory without trailing / slash: "
              read TARGET
              echo
              echo "TARGET directory is now: $TARGET"
              echo
              if [ -n "$TARGET" ] ; then
                 echo -n "Enter TARGET server (leave blank if localhost): "
                 read TNAME
                 echo
                 if [ -z "$TNAME" ] ; then
                    TNAME="localhost"
                 fi
              fi   
              ;;
           dialog)
              # Get the screen resolution or X-window size.
              # Get rows (height).
              Y=$(stty size | awk '{ print $1 }')
              # Get columns (width).
              X=$(stty size | awk '{ print $2 }')
              let Y=Y-17
              let X=X-6
              #
              TARGET=$($1 --stdout --backtitle "Use <tab>, <up/down arrows>, <spacebar> and / (slash) to select TARGET dir." --title "Please choose a TARGET directory to synchronize." --cancel-label "Exit" --fselect ./ $Y $X)
              ERROR=$?
              if [ $ERROR -eq 0 ] ; then  # Was "Cancel" button pressed?
                 TNAME=$($1 --output-fd 1 --title "Specify TARGET Server." --inputbox "Enter TARGET server (leave blank if localhost):" 10 70)
              else
                 TNAME=""  # Cancel button pressed for directory question, don't ask any more questions.
              fi
              ;;
           whiptail)
              TARGET=$($1 --title "Rsync between any two servers/directories." --inputbox "Enter TARGET directory without trailing / slash ." 10 70 3>&1 1>&2 2>&3)
              ERROR=$?
              if [ $ERROR -eq 0 ] ; then  # Was "Cancel" button pressed?
                 TNAME=$($1 --title "Specify TARGET Server." --inputbox "Enter TARGET server (leave blank if localhost):" 10 70 3>&1 1>&2 2>&3)
              else
                 TNAME=""  # Cancel button pressed for directory question, don't ask any more questions.
              fi
              ;;
      esac
      #
      # Make the default TARGET Server is localhost.
      if [ -z "$TNAME" ] ; then
         TNAME="localhost"
      fi
      #
      unset X Y
} # End of function f_any
#
# +----------------------------------------+
# |        Function f_go_nogo_rsync        |
# +----------------------------------------+
#
#  Inputs:  $1=GUI, ERROR.
#    Uses: ANS
# Outputs: None.
#
f_go_nogo_rsync () {
      #
      clear  # Clear the screen.
      case $GUI in
           text)
              if [ ! -d /var/log/rsync ] ; then
                 echo
                 echo -n $(tput setaf 1) # Set font to color red.
                 echo "!!!WARNING!!! Cannot continue, /var/log/rsync directory either does not exist"
                 echo "or you do not have WRITE permission to the log directory: /var/log/rsync."
                 f_abort_txt
              fi
              #
              f_free_txt
              echo
              echo
              echo "Are the SOURCE/TARGET Server filesystems mounted? If not, then abort rsync."
              f_press_enter_key_to_continue
              clear  # Clear the screen.
           ;;
           dialog | whiptail)
              if [ ! -d /var/log/rsync ] ; then
                 echo -n $(tput setaf 1) # Set font to color red.
                 $1 --title "!!!WARNING!!!" --msgbox "Cannot continue, /var/log/rsync directory either does not exist\nor you do not have WRITE permission\nto the  log directory below:\n\n /var/log/rsync" 9 70
                 f_abort_txt
              fi
              #
              f_free_gui $GUI
           ;;
      esac
      #      
      if [ $ERROR -eq 0 ] ; then
         case $GUI in
              whiptail | dialog) f_rsync_gui $GUI;;
              text) f_rsync_text ;;
         esac
      else
         case $GUI in
              whiptail | dialog)
                 $1 --title "Failed Mount" --msgbox "Cannot synchronize due to mounting problems\nso rsync is aborted." 7 70
              ;;
              text)
                 echo
                 echo -n $(tput setaf 1) # Set font to color red.
                 echo "Cannot synchronize due to mounting problems so rsync is aborted."
                 echo $(tput sgr0) # Set font to normal color.
                 echo "Press \"Enter\" key to continue."
                 read ANS
                clear  # Clear the screen.
              ;;
         esac
      fi
      unset ANS
} # End of function f_go_nogo_rsync
#
# +------------------------------------+
# |        Function f_rsync_text       |
# +------------------------------------+
#
#  Inputs: SOURCE, TARGET, LOG_FILE, TIME_FILE
#          THIS_FILE, VERSION.
#    Uses: X, TIME_FILE.
# Outputs: None.
#
f_rsync_text () {
      #
      # For any mount point to synchronize:
      #
      # Prerequisites: External device share available on TARGET and
      #                directory /var/log/rsync exists.
      # 
      # If you edit this shell script, use -n option or --dry-run for testing.
      #
      #  when SOURCE and/or TARGET mount-point does not exist. 
      #
      if [ ! -d $SOURCE ] || [ ! -d $TARGET ] ; then
         #
         if [ ! -d $SOURCE ] ; then
            echo -n $(tput setaf 1) # Set font to color red.
            echo "!!!WARNING!!! Cannot continue, SOURCE directory etther does not exist"
	        echo "              or you do not have WRITE permission to the SOURCE directory."
            echo "$SOURCE"
         else
            echo -n $(tput setaf 1) # Set font to color red.
            echo "!!!WARNING!!! Cannot continue, TARGET directory either does not exist"
	        echo "              or you do not have WRIGHT permission to the TARGET directory."
            echo "$TARGET"
         fi
         echo $(tput sgr0) # Set font to normal color.
         f_press_enter_key_to_continue
         echo
         echo "To help diagnose problem, here is a list of mounted drives/devices."
         echo
         f_free_txt
         echo 
         echo "---"
         echo "Re-start this script once the external device is mounted properly"
         echo "at the mount-point directory."
         echo "---"
         echo
         f_press_enter_key_to_continue
      else
         echo
         echo "Rsync from directory:"
         echo "$SOURCE"
         echo
         echo "        to directory:"
         echo "$TARGET"
         echo
         echo "       Log file: $LOG_FILE"
         echo "Date stamp file: $TIME_FILE"
         echo
         echo "To abort: press Ctrl-C now or press \"Enter\" key to continue."
         # Prompt to allow user to abort or continue.
         read X
         f_rsync_text2
      fi
      unset X
} # End of function f_rsync_text
#
# +------------------------------------+
# |        Function f_rsync_text2      |
# +------------------------------------+
#
#
#  Inputs: GUI, SOURCE, TARGET, TARGET_FILESYSTEM, LOG_FILE, TIME_FILE,
#          THIS_FILE, VERSION.
#    Uses: ERROR.
# Outputs: None.
#
f_rsync_text2 () {
      f_test_connection $GUI $SNAME
      if [ $ERROR -ne 0 ] ; then
         echo -n $(tput setaf 1) # Set font to color red.
         echo "Test of network connection failed... aborting rsync."
         echo $(tput sgr0) # Set font to normal color.
         f_press_enter_key_to_continue
      else
         f_test_connection $GUI $TNAME
         if [ $ERROR -ne 0 ] ; then
            echo -n $(tput setaf 1) # Set font to color red.
            echo "Test of network connection failed... aborting rsync."
            echo $(tput sgr0) # Set font to normal color.
            f_press_enter_key_to_continue
         else
            # Do the actual rsync.
            f_rsync_command
            # Real-time messages from rsync are now displayed on screen
            # and written to the log file.
            f_press_enter_key_to_continue
            #
            # Display free space on screen.
            f_free_txt
            f_press_enter_key_to_continue
            clear  # Blank the screen.
            #
            # Display start and end times on screen.
            cat $TIME_FILE
            echo
            echo "The rsync backup has completed."
            echo
            echo "Rsync from directory:"
            echo "$SOURCE"
            echo
            echo "        to directory:"
            echo "$TARGET"
            echo
            echo "Date stamp file:"
            echo "$TIME_FILE"
            echo
            echo "       Log file:"
            echo "$LOG_FILE"
            echo
            echo "Backup script \"$THIS_FILE\" ver. $VERSION"
            echo "has completed its run."
            echo "---"
            echo
            echo -n "Do you want to see the log file? (y/N) "
            read ANS
            case $ANS in
                 [Yy])
                    # Test if most command is available.
                    type most >/dev/null 2>&1
                    ERROR=$?
                    if [ $ERROR = 1 ] ; then
                       # Use more command.
                       more $LOG_FILE >/dev/null
                       ERROR=$?
                       if [ $ERROR = 1 ] ; then
                          echo
                          echo "Log file, $LOG_FILE is unavailable."
                          echo
                       else
                          more $LOG_FILE
                          f_press_enter_key_to_continue
                       fi 
                    else
                       most $LOG_FILE
                    fi 
                 ;;
                 [Nn] | *)
                 ;;
            esac
         fi
      fi
      unset ANS
} # End of function f_rsync_text2
#
# +------------------------------------+
# |         Function f_rsync_gui       |
# +------------------------------------+
#
#  Inputs: #  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          SOURCE, TARGET, TARGET_FILESYSTEM, LOG_FILE, THIS_FILE, VERSION.
#    Uses: X, TIME_FILE.
# Outputs: None.
#
f_rsync_gui () {
      #
      # For any mount point to synchronize:
      #
      # Prerequisites: External device share available on TARGET and
      #                directory /var/log/rsync exists.
      # 
      # If you edit this shell script, use -n option or --dry-run for testing.
      #
      #  when SOURCE and/or TARGET mount-point does not exist. 
      #
      # Get the screen resolution or X-window size.
      # Get rows (height).
      # Y=$(stty size | awk '{ print $1 }')
      # Get columns (width).
      X=$(stty size | awk '{ print $2 }')
      #let Y=Y-17
      let X=X-6
      #
      if [ ! -d $SOURCE ] || [ ! -d $TARGET ] ; then
         #
         if [ ! -d $SOURCE ] ; then
            echo -n $(tput setaf 1) # Set font to color red.
            $1 --title "!!!WARNING!!!" --msgbox "Cannot continue, SOURCE directory either does not exist\nor you do not have WRITE permission\nto the SOURCE directory below:\n\n $SOURCE" 9 60
         else
            echo -n $(tput setaf 1) # Set font to color red.
            $1 --title "!!!WARNING!!!" --msgbox "Cannot continue, TARGET directory either does not exist\nor you do not have WRITE permission\nto the TARGET directory below:\n\n $TARGET" 9 60
         fi
         echo $(tput sgr0) # Set font to normal color.
         echo
         $1 --msgbox "To help diagnose problem, here is a list of mounted drives/devices." 7 75 
         clear  # Blank the screen.
         f_free_gui $GUI
         clear  # Blank the screen.
         $1 --msgbox "Re-start this script once the external device is mounted properly\nat the mount-point directory." 7 70
      else
         if ($1 --title "Confirmation of SOURCE/TARGET" --yesno "Synchronization by rsync from SOURCE to TARGET. \n\n From SOURCE directory: \n\"$SOURCE\" \n\n   To TARGET directory: \n\"$TARGET\" \n\n       Log file:\n$LOG_FILE\n\nDate stamp file:\n$TIME_FILE\n\nIs this correct? Last chance to abort.\n                 < No > aborts rsync." 22 $X) then
            # Yes, use selected directories.
            f_rsync_gui2 $1
         else
            # No, bad selection. Null selections. Quit.
            $1 --title "!!! Abort rsync !!!" --msgbox "Aborting rsync operation." 8 30
         fi
      fi
      unset X Y
} # End of function f_rsync_gui
#
# +------------------------------------+
# |         Function f_rsync_gui2      |
# +------------------------------------+
#
#  Inputs: #  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          SOURCE, TARGET, TARGET_FILESYSTEM, LOG_FILE, THIS_FILE, VERSION.
#    Uses: TIME_FILE.
# Outputs: None.
#
f_rsync_gui2 () {
      clear  # Blank the screen.
      f_test_connection $GUI $SNAME
      if [ $ERROR -eq 0 ] ; then
         f_test_connection $GUI $TNAME
         sleep 4  # Pause to see messages for 5 seconds.
         if [ $ERROR -eq 0 ] ; then
            # Do the actual rsync.
            clear  # Blank the screen.
            f_rsync_command
            #
            # Display free space on screen.
            f_df_gui
            #
            # Write rsync parameters to file $TIME_FILE.
            echo "Synchronization by rsync from SOURCE to TARGET is complete." >>$TIME_FILE
            echo >>$TIME_FILE
            echo " from SOURCE directory:" >>$TIME_FILE
            echo "$SOURCE" >>$TIME_FILE
            echo >>$TIME_FILE
            echo "   to TARGET directory:" >>$TIME_FILE
            echo "$TARGET" >>$TIME_FILE
            echo  >>$TIME_FILE
            echo "Date Stamp File:" >>$TIME_FILE
            echo "$TIME_FILE" >>$TIME_FILE
            echo  >>$TIME_FILE
            echo "       Log file:" >>$TIME_FILE
            echo "$LOG_FILE" >>$TIME_FILE
            echo >>$TIME_FILE
            echo "Backup script $THIS_FILE ver. $VERSION" >>$TIME_FILE
            echo "has completed its run." >>$TIME_FILE
            #
            # Display rsync parameters with start and end times on screen.
            $1 --textbox $TIME_FILE 23 68
            #
            # Old code using GUI msgbox.
            # $1 --title "Rsync has completed" --msgbox "Synchronization by rsync from SOURCE to TARGET is complete. \n\n $TIME_FILE\n\n from SOURCE directory: \n\"$SOURCE\" \n\n   to TARGET directory: \n\"$TARGET\" \n\n       Log file: $LOG_FILE\n\nDate Stamp File: $TIME_FILE\n\nBackup script \"$THIS_FILE\" ver. $VERSION\nhas completed its run." 23 68
            #
            if ($1 --yesno "Do you want to see the log file?" 8 40) then
               # Yes, show log file.
               f_show_log_file_gui $1 $LOG_FILE               
            else
               # No, don't show me.
               :  # No-op command (does nothing but to prevent a syntax error).
            fi
         fi
      else  # Connection error, pause to read ping error message.
         sleep 4  # Pause to see messages for 5 seconds.
      fi
} # End of function f_rsync_gui2
#
# +----------------------------------------+
# |      Function f_show_log_file_gui      |
# +----------------------------------------+
#
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - $LOG_FILE.
#    Uses: X, Y.
# Outputs: None.
#
f_show_log_file_gui () {
      # Get the screen resolution or X-window size.
      # Get rows (height).
      Y=$(stty size | awk '{ print $1 }')
      # Get columns (width).
      X=$(stty size | awk '{ print $2 }')
      #
      $1 --title "/var/log/rsync/<LOG_FILE> (use arrow keys to scroll up/down/side-ways)" --textbox $2 $Y $X 
      #
      unset X Y  # Throw out this variable.
} # End of function f_show_log_file_gui
#
# +------------------------------------+
# |      Function f_rsync_command      |
# +------------------------------------+
#
#  Inputs: SOURCE, TARGET, TARGET_FILESYSTEM, LOG_FILE, THIS_FILE,
#          VERSION.
#    Uses: TIME_FILE.
# Outputs: None.
#
f_rsync_command () {
         # Record the start date/time of the backup.
         # Use printf to put everything on a single line for easy readability.
         # The echo command inserts <CR><LF> even if using -n switch so unused.
         #
         printf "$THIS_FILE  started at: ">$TIME_FILE;date>>$TIME_FILE
         # 
         if [ "$TARGET_FILESYSTEM" = linux ] ; then
            LOG_FILE="/var/log/rsync/$(date +%Y%m%d-%H%M)_$LOG_FILE"
            clear  # Blank the screen.
            # If backing up to ext2-ext4 partition, you can preserve permissions, owner, group. Therefore can use -a(rchive) option.
            # Use options -avhi (archive, verbose, human-readable, itemize changes).
            # Start actual backup command rsync
            # sudo rsync -avhi --progress --delete --force --exclude '.gvfs' --log-file=$LOG_FILE $SOURCE $TARGET
            # sudo rsync -rltvhi --progress --delete --force --exclude '.gvfs' --log-file=$LOG_FILE $SOURCE $TARGET
            # sudo rsync -rltvhi --progress --delete --size-only --exclude '.gvfs' --log-file=$LOG_FILE $SOURCE $TARGET
            #
            # Use options -rltvhi (recursive, symlinks, times, verbose, human-readable, itemize changes).
            #             (Note: DO NOT preserve permissions).
            sudo rsync -rltvhi --size-only --progress --delete --exclude '.gvfs' --log-file=$LOG_FILE $SOURCE $TARGET
            #
         else
            # If backing up to FAT32 partition, DO NOT preserve permissions, owner, group. Therefore cannot use -a(rchive) option.
            # Use options -rltDvhi (recursive, links (symlinks), times, Devices/specials, verbose, human-readable, itemize changes.
            # Start actual backup command rsync
            LOG_FILE="/var/log/rsync/$(date +%Y%m%d-%H%M)_$LOG_FILE"
            clear  # Blank the screen.
            sudo rsync -rltDvhi --size-only --progress --delete --exclude '.gvfs'  --log-file=$LOG_FILE $SOURCE $TARGET
         fi  
         # 
         # Record the end date/time of the backup.
         # Use printf to put everything on a single line for easy readability.
         # The echo command inserts <CR><LF> even if using -n switch so unused.
         #
         printf "$THIS_FILE finished at: ">>$TIME_FILE;date>>$TIME_FILE
         #
         # 2010-06-23 rdc change from cp $TIME_FILE . . . to sudo cp $TIME_FILE . . .
         touch $TIME_FILE
         sudo cp $TIME_FILE $TARGET
} # End of function f_rsync_command
#
# +----------------------------------------+
# |        Function f_test_connection      |
# +----------------------------------------+
#
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 Network name of server. 
#    Uses: None.
# Outputs: ERROR. 
#
f_test_connection () {
      # Check if there is an internet connection before doing a download.
      case $1 in
           whiptail | dialog)
              ping -c 1 -q $2  # Ping server address.
              ERROR=$?
              if [ $ERROR -ne 0 ] ; then
                 $1 --title "Ping Test Connection" --msgbox "Network connnection to $2 failed. Cannot rsync." 7 70
              fi
           ;;
           text)
              ping -c 1 -q $2  # Ping server address.
              ERROR=$?
              echo
              if [ $ERROR -ne 0 ] ; then
                 echo -n $(tput setaf 1) # Set font to color red.
                 echo -n $(tput bold)
                 echo "Network connnection to $2 failed. Cannot rsync."
                 echo -n $(tput sgr0)
              fi
           ;;
      esac
} # End of function f_test_connection
#
# +------------------------------------+
# |        Function f_about_txt        |
# +------------------------------------+
#
#  Inputs: None.
#    Uses: None.
# Outputs: None.
#
f_about_txt () {
      clear # Blank the screen.
      echo "Script $THIS_FILE"
      echo "Version: $VERSION"
      echo
      f_press_enter_key_to_continue
      #
} # End of f_about_txt
#
# +------------------------------------+
# |        Function f_about_gui        |
# +------------------------------------+
#
#  Inputs: THIS_FILE, VERSION, $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#    Uses: None.
# Outputs: None.
#
f_about_gui () {
      $1 --title "About this script" --msgbox "Script: $THIS_FILE. Version: $VERSION" 8 55
} # End of f_about_gui
#
# +----------------------------------------+
# |       Function f_code_history_txt      |
# +----------------------------------------+
#
#  Inputs: THIS_DIR, THIS_FILE.
#    Uses: None.
# Outputs: APP_NAME.
#
f_code_history_txt () {
      clear # Blank the screen.
      # Display Help (all lines beginning with "#@" but do not print "#@").
      # sed substitutes null for "#@" at the beginning of each line
      # so it is not printed.
      # less -P customizes prompt for
      # %f <FILENAME> page <num> of <pages> (Spacebar, PgUp/PgDn . . .)
      sed -n 's/^#@//'p $THIS_DIR/$THIS_FILE | less -P '(Spacebar, PgUp/PgDn, Up/Dn arrows, press q to quit)'
} # End of function f_code_history_txt
#
# +----------------------------------------+
# |       Function f_code_history_gui      |
# +----------------------------------------+
#
#  Inputs: THIS_DIR, THIS_FILE. $1 - "dialog" or "whiptail" The CLI GUI application in use.
#    Uses: X.
# Outputs: APP_NAME.
#
f_code_history_gui () {
      # Get the screen resolution or X-window size.
      # Get rows (height).
      Y=$(stty size | awk '{ print $1 }')
      # Get columns (width).
      X=$(stty size | awk '{ print $2 }')
      let Y=Y-4
      #
      clear # Blank the screen.
      # Display Help (all lines beginning with "#@" but do not print "#@").
      # sed substitutes null for "#@" at the beginning of each line
      # so it is not printed.
      # less -P customizes prompt for
      # %f <FILENAME> page <num> of <pages> (Spacebar, PgUp/PgDn . . .)
      date>temp.txt ; echo "Script: $THIS_FILE">>temp.txt
      sed -n 's/^#@//'p $THIS_DIR/$THIS_FILE >> temp.txt
      $1 --title "Code History (use arrow keys to scroll up/down/side-ways)" --textbox temp.txt $Y $X #24 80
      rm temp.txt
      unset X
      #
} # End of function f_code_history_gui
#
# +----------------------------------------+
# |       Function f_display_log_txt       |
# +----------------------------------------+
#
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - $LOG_FILE.
#    Uses: Y ERROR.
# Outputs: None.
#
f_display_log_txt () {
      # Listing current log file created on this run, never exited script after
      # running the rsync command.
      if [ -n "$1" ] ; then  # if $LOG_FILE variable is not null.
         # Test if most command is available.
         type most >/dev/null 2>&1
         ERROR=$?
         if [ $ERROR = 1 ] ; then
            # Use more command.
            more $1 >/dev/null
            ERROR=$?
            if [ $ERROR = 1 ] ; then
               echo
               echo "Log file, $1 is unavailable."
               echo
            else
               more $1
            fi 
         else
            most $1
         fi 
      else
         # Listing latest log file created on a previous run, rsync'ed,
         # then exited script, then ran script again.
         ls -tC /var/log/rsync | head -n 1 >temp.txt
         Y="/var/log/rsync/$(cat temp.txt)"
         #
         clear  # Blank the screen.
         echo "Display latest log file: $Y"
         f_press_enter_key_to_continue
         #
         clear  # Blank the screen.
         # Test if most command is available.
         type most >/dev/null 2>&1
         ERROR=$?
         if [ $ERROR = 1 ] ; then
            # Use more command.
            more $Y >/dev/null
            ERROR=$?
            if [ $ERROR = 1 ] ; then
               echo
               echo "Log file, $Y is unavailable."
               echo
            else
               more $Y
            fi 
         else
            most $Y
         fi 
         rm temp.txt
      fi
      unset Y ERROR
} # End of function f_display_log_txt
#
# +----------------------------------------+
# |       Function f_display_log_gui       |
# +----------------------------------------+
#
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - $LOG_FILE.
#    Uses: X, Y.
# Outputs: None.
#
f_display_log_gui () {
      if [ -n "$2" ] ; then  # if $LOG_FILE variable is not null.
         # Get the screen resolution or X-window size.
         # Get rows (height).
         Y=$(stty size | awk '{ print $1 }')
         # Get columns (width).
         X=$(stty size | awk '{ print $2 }')
         #
         $1 --title "/var/log/rsync/<LOG_FILE> (use arrow keys to scroll up/down/side-ways)" --textbox $2 $Y $X 
      else
         # Listing latest log file created by script, server_rsync.
         ls -tC /var/log/rsync | head -n 1 >temp.txt
         XX="Display latest log file: /var/log/rsync/$(cat temp.txt)"
         YY="/var/log/rsync/$(cat temp.txt)"
         echo $XX >temp.txt
         echo >>temp.txt
         cat $YY >>temp.txt
         # Get the screen resolution or X-window size.
         # Get rows (height).
         Y=$(stty size | awk '{ print $1 }')
         # Get columns (width).
         X=$(stty size | awk '{ print $2 }')
         #
         $1 --title "/var/log/rsync/<LOG_FILE> (use arrow keys to scroll up/down/side-ways)" --textbox temp.txt $Y $X 
      fi
      rm temp.txt
      unset X Y XX YY  # Throw out this variable.
} # End of function f_display_log_gui
#
# +----------------------------------------+
# |         Function f_main_menu_text      |
# +----------------------------------------+
#
#  Inputs: #  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#    Uses: CHOICE.
# Outputs: None.
#
f_main_menu_text () {
      CHOICE=-1
      #      
      until [ "$CHOICE" = "0" ]
      do    # Start of Main Menu until loop.
            clear  # Clear screen.
            echo "            Main Menu"
            echo
            echo "0 (Q/q) - Quit this script."
            echo "1 (S/s) - Synchronize two directories."
            echo "2 (L/l) - Log file display."
            echo "3 (M/m) - Mount-points of networked shares."
            echo "4 (A/a) - About this script."
            echo "5 (C/c) - Code history changes."
            echo
            echo -n $(tput bold)
            echo -n "Please select letter or 0-4 (0): " ; read CHOICE
            echo -n $(tput sgr0)
            #
            case $CHOICE in
                 0 | [Qq] | "") CHOICE=0 ;;
                 1 | [Ss]) f_any $1 ;;
                 2 | [Ll]) f_display_log_txt "" ;;
                 3 | [Mm]) f_free_txt ;;
                 4 | [Aa]) f_about_txt ;;
                 5 | [Cc]) f_code_history_txt ;;
            esac
      done  # End of Main Menu until loop.
            #
      unset CHOICE  # Throw out this variable.
} # End of function f_main_menu_text
#
# +----------------------------------------+
# |        Function f_main_menu_gui        |
# +----------------------------------------+
#
#  Inputs: #  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#    Uses: CHOICE, MENU_TITLE.
# Outputs: None.
#
f_main_menu_gui () {
      CHOICE=-1
      #      
      until [ "$CHOICE" = "0" ]
      do    # Start of Main Menu until loop.
            MENU_TITLE="Main Menu"
            CHOICE=$($1 --clear --title "$MENU_TITLE" --menu "\n\nUse (up/down arrow keys) or (1 to 5) or (letters):" 15 70 6 \
            Quit "Quit this script." \
            Synchronize "Synchronize two directories." \
            Log-file "Show latest log file." \
            Mount-points "Show mounted networked shares." \
            About "About this script." \
            Code "Code history changes." \
            2>&1 >/dev/tty)
            #
            case $CHOICE in
                 Quit) CHOICE=0 ;;
                 Synchronize) f_any $1 ;;
     	         Log-file) f_display_log_gui $1 "" ;;
                 Mount-points) f_free_gui $1 ;;
                 About) f_about_gui $1 ;;
                 Code) f_code_history_gui $1 ;;
            esac
      done  # End of Main Menu until loop.
            #
      unset CHOICE  # Throw out this variable.
} # End of function f_main_menu_gui
#
# **************************************
# ***     Start of Main Program      ***
# **************************************
#
# If an error occurs, the f_abort_txt() function will be called.
# trap 'f_abort_txt' 0
# set -e
#
clear  # Blank the screen.
#
# Set SCRIPT_PATH to directory path of script.
f_script_path
MAINMENU_DIR=$SCRIPT_PATH
THIS_DIR=$MAINMENU_DIR  # Set $THIS_DIR to location of Main Menu.

#
# Test for BASH environment.
f_test_environment
#
# Test for GUI-CLI environment.
f_detect_ui
#
# GUI="text"      # Diagnostic line. Force plain text w/o GUI for testing purposes.
# GUI="whiptail"  # Diagnostic line. Force whiptail GUI for testing purposes.
# GUI="dialog"    # Diagnostic line. Force dialog GUI for testing purposes.
#
# **************************************
# ***           Main Menu            ***
# **************************************
case $GUI in
     text)
        f_main_menu_text $GUI
     ;;
     dialog | whiptail)
        f_main_menu_gui $GUI
     ;;
esac
      clear   # Blank the screen.
      # df -hT  # Display hard disk drive statistics mount status.
      exit 0  # This cleanly closes the process generated by #!bin/bash. 
              # Otherwise every time this script is run, another instance of
              # process /bin/bash is created using up resources.
# all dun dun noodles.
