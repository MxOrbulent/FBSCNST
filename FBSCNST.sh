#!/bin/bash
echo "Fix Black Screen After Level Load For Crash N Sane Trilogy - FBSCNST Loaded"
echo "Select if you want the script to search for the install folder (1) or if you want to enter it manually (2)"
echo "Or if you want to restore the path to as originally set by the devs (3)"
echo "Choose now (enter either a 1 or a 2 and press ENTER)"
#set -x
read -p 'Time to choose: ' decision
if [ $decision == "1" ]
then

#Check if steam is running
  exitwhileloop="0"
  processlistofsteam=$(ps -C steam)
  while [ $exitwhileloop == "0" ]
  do
  	processlistofsteam=$(ps -C steam)
  	if [[ $processlistofsteam == *"steam"* ]]; then
  		echo "You need to close down steam now."
	echo "Waiting 3 seconds before doing another scan..."
	sleep 3
  
else
	
	exitwhileloop="1"
fi
done

echo "Steam appears to be closed."
groupnameofloggedinuser=$(id -gn)


echo "Searching for the Crash Bandicoot install folder... (Be Patient)"
#result=$(find / -path "*common/crash/CrashBandicootNSaneTrilogy.exe")
#result=$(locate CrashBandicootNSaneTrilogy.exe)
#find / -type d ! -perm -g+r,u+r,o+r -prune -o -type f -name 'netcdf' -print
#Not really good practice in my opinion. But the solution is far to abstract for me to understand
#so this will have to do for now.
path=$(find / -name "CrashBandicootNSaneTrilogy.exe" -group $groupnameofloggedinuser -print -quit 2>/dev/null)
echo "$path"

if [[ $path == *"common/cr4sh/"* ]]; then
  echo "You have already applied the fix on your install"
  echo "If you want to restore everything to default, please run"
  echo "the file UFBSCNST.sh !"
  echo "Exiting..."
  exit 0
fi

echo "We need to trim off the exe file. Trimming the path string"
WORDTOREMOVE="CrashBandicootNSaneTrilogy.exe"
path=${path//$WORDTOREMOVE/}
echo "String trimmed!"


#Everything about decision 1 now.

echo "We will now begin the operations!"
  WORDTOREMOVE="common/Crash Bandicoot - N Sane Trilogy/"
  librarypath=${path//$WORDTOREMOVE/}
  echo "Backing up the original appmanifestfile"
  cp ""$librarypath"appmanifest_731490.acf" ""$librarypath"appmanifest_731490_BAK.acf"
  echo "Backup complete! Modifying the appmanifestfile"
  sed -i 's/Crash Bandicoot - N Sane Trilogy/cr4sh/g' ""$librarypath"appmanifest_731490.acf"
  echo "Done! Last step, renaming the installfolder itself. Commencing..."
  WORDTOREMOVE="Crash Bandicoot - N Sane Trilogy/"
  librarycommonpath=${path//$WORDTOREMOVE/}
  mv $librarycommonpath"Crash Bandicoot - N Sane Trilogy" $librarycommonpath"cr4sh"
  echo "Done. The original path was:"
  echo "$path"
  echo ""
  echo "It should now be:"
  echo ""$librarycommonpath"cr4sh/"
  echo "Please verify that it is so by launching steam, and following these instructions again"
  echo "You can get the path by being in Steam, rightclicking on Crash Bandicoot N Sane Trilogy in the library."
		echo "Then, click properties>Local Files>Browse Local Files..."

  echo "Your install folder on the disk should now read cr4sh instead."

  echo ""
  echo "Checking if we should save the old and new paths for future usage (ex: for restoration)..."

  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  DIR+="/cnsanetrilogypaths.txt"
if [ -f "$DIR" ]; then
    echo "We already have a file from a previous operation, I will not create a new one"
else 
    echo "We have never created a file containing the old and new paths before. Creating one now!"
    echo $path > $DIR
    echo ""$librarycommonpath"cr4sh/" >> $DIR
    echo "Finished entering the old and new paths"

    echo ""

fi

  echo "I can retrivie both line 7 from the appmanifest and also open the path in your file manager (Dolphin, thunar etc whatever it may be). (1)"
  echo "Or, you can exit this shellscript and go check yourself (2)"
  read -p 'Time to choose: ' decision2

  if [ $decision2 == "1" ]; then
      result=$(sed '7q;d' ""$librarypath"appmanifest_731490.acf")
      echo "This is what line 7 contains in the appmanifest"
      echo "It should read like this: "
      echo "Expected: \"installdir\"		\"cr4sh\""
      echo "Result  :""$result"
      echo "If it does, good. If not something went wrong."
      echo "I will now open the cr4sh folder for you."
      xdg-open ""$librarycommonpath"/cr4sh/"
      if [ ! $? == "0" ]; then
      	echo "ERROR! Could not open the Crash Bandicoot folder using it's new path."
      	echo "Exiting, please open steam and try browsing to it manually."
      	exit 1
      else
      	echo "#################################################################"
      	echo "#We are now completely done. Thank you for using this script!   #"
      	echo "#Donate to #teamtrees, and advocate for free speech. And I mean #"
      	echo "#full unyeilding free speech.                                   #" 
      	echo "#                  Exiting this shellscript...                  #"
      	echo "#################################################################"
      	exit 0
  fi
fi

  if [ $decision2 == "2" ]; then
  		echo "#################################################################"
      	echo "#We are now completely done. Thank you for using this script!   #"
      	echo "#Donate to #teamtrees, and advocate for free speech. And I mean #"
      	echo "#full unyeilding free speech.                                   #" 
      	echo "#                  Exiting this shellscript...                  #"
      	echo "#################################################################"
      	exit 0
  
      else
      	echo "At this stage it does not really matter if you picked something else than a 1 or a 2."
      	echo ""
      	echo "#################################################################"
      	echo "#We are now completely done. Thank you for using this script!   #"
      	echo "#Donate to #teamtrees, and advocate for free speech. And I mean #"
      	echo "#full unyeilding free speech.                                   #" 
      	echo "#                  Exiting this shellscript...                  #"
      	echo "#################################################################"
      	exit 0
  fi



#Everything about decision 2 below
elif [ $decision == "2" ]
	then
		echo "You have chosen to enter the path manually. Ensure that you enter the entire path, including any spaces and slashes"
		echo "You can get the path by being in Steam, rightclicking on Crash Bandicoot N Sane Trilogy in the library."
		echo "Then, click properties>Local Files>Browse Local Files..."
		echo ""
		echo "You will now be in the installation folder for Crash Bandicoot N Sane Trilogy."
		echo "Please copy it."
read -p 'When you see this text, paste the path into the terminal and press ENTER: ' path
		echo path aquired. Printing path:
		echo "$path"

    if [[ $path == *"common/cr4sh/"* ]]; then
  echo "You have already applied the fix on your install"
  echo "If you want to restore everything to default, please run"
  echo "this script again, but choose number 3 as your option in the beginning."
  echo "Exiting..."
  exit 0
fi
    #This checks if path is correct.
		if [[ $path == *"common/Crash Bandicoot - N Sane Trilogy/"* ]]; then
  echo "The path seems to be correct".

  #Check if steam is running
  exitwhileloop="0"
  processlistofsteam=$(ps -C steam)
  while [ $exitwhileloop == "0" ]
  do
  	processlistofsteam=$(ps -C steam)
  	if [[ $processlistofsteam == *"steam"* ]]; then
  		echo "You need to close down steam now."
	echo "Waiting 3 seconds before doing another scan..."
	sleep 3
  
else
	
	exitwhileloop="1"
fi
done


  echo "We will now begin the operations!"
  WORDTOREMOVE="common/Crash Bandicoot - N Sane Trilogy/"
  librarypath=${path//$WORDTOREMOVE/}
  echo "Backing up the original appmanifestfile"
  cp ""$librarypath"appmanifest_731490.acf" ""$librarypath"appmanifest_731490_BAK.acf"
  echo "Backup complete! Modifying the appmanifestfile"
  sed -i 's/Crash Bandicoot - N Sane Trilogy/cr4sh/g' ""$librarypath"appmanifest_731490.acf"
  echo "Done! Last step, renaming the installfolder itself. Commencing..."
  WORDTOREMOVE="Crash Bandicoot - N Sane Trilogy/"
  librarycommonpath=${path//$WORDTOREMOVE/}
  mv $librarycommonpath"Crash Bandicoot - N Sane Trilogy" $librarycommonpath"cr4sh"
  echo "Done. The original path was:"
  echo "$path"
  echo ""
  echo "It should now be:"
  echo ""$librarycommonpath"cr4sh/"
  echo "Please verify that it is so by launching steam, and following these instructions again"
  echo "You can get the path by being in Steam, rightclicking on Crash Bandicoot N Sane Trilogy in the library."
		echo "Then, click properties>Local Files>Browse Local Files..."

  echo "Your install folder on the disk should now read cr4sh instead."
  echo ""
  echo "Checking if we should save the old and new paths for future usage (ex: for restoration)..."

  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  DIR+="/cnsanetrilogypaths.txt"
if [ -f "$DIR" ]; then
    echo "We already have a file from a previous operation, I will not create a new one"
else 
    echo "We have never created a file containing the old and new paths before. Creating one now!"
    echo $path > $DIR
    echo ""$librarycommonpath"cr4sh/" >> $DIR
    echo "Finished entering the old and new paths"

    echo ""

fi




  




  echo "I can retrivie both line 7 from the appmanifest and also open the path in your file manager (Dolphin, thunar etc whatever it may be). (1)"
  echo "Or, you can exit this shellscript and go check yourself (2)"
  read -p 'Time to choose: ' decision3

  if [ $decision3 == "1" ]; then
      result=$(sed '7q;d' ""$librarypath"appmanifest_731490.acf")
      echo "This is what line 7 contains in the appmanifest"
      echo "It should read like this: "
      echo "Expected: \"installdir\"    \"cr4sh\""
      echo "Result  :""$result"
      echo "If it does, good. If not something went wrong."
      echo "I will now open the cr4sh folder for you."
      xdg-open ""$librarycommonpath"/cr4sh/"
      if [ ! $? == "0" ]; then
      	echo "ERROR! Could not open the Crash Bandicoot folder using it's new path."
      	echo "Exiting, please open steam and try browsing to it manually."
      	exit 1
      else
      	echo "#################################################################"
      	echo "#We are now completely done. Thank you for using this script!   #"
      	echo "#Donate to #teamtrees, and advocate for free speech. And I mean #"
      	echo "#full unyeilding free speech.                                   #" 
      	echo "#                  Exiting this shellscript...                  #"
      	echo "#################################################################"
      	exit 0
  fi
fi

  if [ $decision3 == "2" ]; then
  		echo "#################################################################"
      	echo "#We are now completely done. Thank you for using this script!   #"
      	echo "#Donate to #teamtrees, and advocate for free speech. And I mean #"
      	echo "#full unyeilding free speech.                                   #" 
      	echo "#                  Exiting this shellscript...                  #"
      	echo "#################################################################"
      	exit 0
  
      else
      	echo "At this stage it does not really matter if you picked something else than a 1 or a 2."
      	echo ""
      	echo "#################################################################"
      	echo "#We are now completely done. Thank you for using this script!   #"
      	echo "#Donate to #teamtrees, and advocate for free speech. And I mean #"
      	echo "#full unyeilding free speech.                                   #" 
      	echo "#                  Exiting this shellscript...                  #"
      	echo "#################################################################"
      	exit 0
  fi	



#Runs if path is not found, part of line 168.
else
	echo "Path was incorrect or you don't have Crash Bandicoot N Sane Trilogy installed. We will now exit. Start the script to try again."
	exit 1

fi


elif [[ $decision == "3" ]]; then

echo "You have chosen to restore everything back to normal."
echo "Looking to see if you have ran this tool atleast once before..."

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  DIR+="/cnsanetrilogypaths.txt"
if [ -f "$DIR" ]; then
    echo "You did run this script once before"
    echo "If you want to proceed with restoring everything to as it was, please type y "
    echo "and press ENTER to proceed, or type n to exit the script."

    read -p 'Restore (y/n)? ' dorestore

    if [ $dorestore == "y" ]; then
       
       #carefull... first line is old path, second line is new path.
       oldpath=$(sed '1q;d' "$DIR")
       newpath=$(sed '2q;d' "$DIR")

       if [ -d "$oldpath" ]; then
  echo "The game install folder is already the original"
  echo "Exiting..."
  exit 1
fi
fi

       if [[ $oldpath == *"common/Crash Bandicoot - N Sane Trilogy/"* ]]; then
          echo "Oldpath is correct"
         else
          echo "Aborting! Better safe than sorry, you will have to attempt restoration manually."
          exit 1
       fi
       if [[ $newpath == *"common/cr4sh/"* ]]; then
          echo "Newpath is correct"
         else
          echo "Aborting! Better safe than sorry, you will have to attempt restoration manually."
          exit 1
       fi

       echo "We have checked both paths, they seem correct."
       echo "Creating a new path variable so we can access the appmanifests"
       #Word to remove common/cr4sh/

       WORDTOREMOVE="common/cr4sh/"
      librarypath=${newpath//$WORDTOREMOVE/}

      echo "Done. Commencing restoration. You cannot back out now..."
      rm "$librarypath""appmanifest_731490.acf"
      echo "Removed appmanifest, restoring old one from backup now..."
      cp "$librarypath""appmanifest_731490_BAK.acf" "$librarypath""appmanifest_731490.acf"
      echo "Done! Renaming the installfolder of Crash Bandicoot back to it's original name!"
      mv "$newpath" "$oldpath" 
      echo "Done!"
      echo ""


      echo "I can retrivie both line 7 from the appmanifest and also open the path in your file manager (Dolphin, thunar etc whatever it may be). (1)"
  echo "Or, you can exit this shellscript and go check yourself (2)"
  read -p 'Time to choose: ' decision4

  if [[ $decision4 == "1" ]]; then
      result=$(sed '7q;d' ""$librarypath"appmanifest_731490.acf")
      echo "This is what line 7 contains in the appmanifest"
      echo "It should read like this: "
      echo "Expected: \"installdir\"    \"Crash Bandicoot™ N. Sane Trilogy\""
      echo "Result  :""$result"
      echo "If it does, good. If not something went wrong."
      echo "I will now open the cr4sh folder for you."
      xdg-open "$oldpath"
      if [ ! $? == "0" ]; then
        echo "ERROR! Could not open the Crash Bandicoot folder using it's restored path."
        echo "Exiting, please open steam and try browsing to it manually."
        exit 1
      else
        echo "#################################################################"
        echo "#We are now completely done. Thank you for using this script!   #"
        echo "#Donate to #teamtrees, and advocate for free speech. And I mean #"
        echo "#full unyeilding free speech.                                   #" 
        echo "#                  Exiting this shellscript...                  #"
        echo "#################################################################"
        exit 0
  fi
fi

  if [[ $decision4 == "2" ]]; then
      echo "#################################################################"
        echo "#We are now completely done. Thank you for using this script!   #"
        echo "#Donate to #teamtrees, and advocate for free speech. And I mean #"
        echo "#full unyeilding free speech.                                   #" 
        echo "#                  Exiting this shellscript...                  #"
        echo "#################################################################"
        exit 0
  
      else
        echo "At this stage it does not really matter if you picked something else than a 1 or a 2."
        echo ""
        echo "#################################################################"
        echo "#We are now completely done. Thank you for using this script!   #"
        echo "#Donate to #teamtrees, and advocate for free speech. And I mean #"
        echo "#full unyeilding free speech.                                   #" 
        echo "#                  Exiting this shellscript...                  #"
        echo "#################################################################"
        exit 0
  fi  


    else
     echo "You have chosen to not proceed with restoration!"
     echo "Exiting..."
     exit 0
    fi
      



else 
    echo "You have never run this script once before. Please do so by either selecting 1 or 2 at the start."
    echo "Start the script again."
    echo "Exiting..."
    exit 1

fi



else
	echo "You entered something that we do not want. Please only enter a 1 or a 2. Exiting, start the script again to try again"
	exit 1
fi
