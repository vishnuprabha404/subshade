 #starting
dom=$1                                                            #reading domain using command line argument
echo -e "\n${blue} WELCOME ${red}$USER \n\n${blue} Today is ${cyan}$(date)" #greetings
echo -e "\n${yellow} Initializing ..."
echo -e "\n${yellow} Gathering subdomains of ${reset}$dom"
if [[ -z $dom ]]; then                                            #checking whether the domain is empty
	
	error                                                           #calling error function

else   

  #using assetfinder

rm -fr temp                                                       #removing temp folder if it already exist from the previous execution of the script
mkdir temp                                                        #creating temp folder to store temporary files which will be deleted after execution
assetfinder -subs-only $dom >> temp/asset.txt                     #using assetfinder to gather subdomains
total=$(cat temp/asset.txt | wc -l)                               #total variable is used to get the total number of subdomains

if [[ $total -le 0 ]]; then                                       #checking whether any subdomain are gathered

    error                                                         #calling error function

else

  #sorting duplicates and gathering live subdomains

sort -u temp/asset.txt >> temp/sort1.txt                          #sorting to reduce duplicates from original subdomains
echo -e "\n${yellow} Total number of subdomains found : ${reset} $total"
echo -e "${yellow}\n Checking for active subdomains, this might take a while ... \n \n"

cat temp/sort1.txt | httprobe >> temp/live.txt                    #checking for live subdomains


if [[ -s temp/live.txt ]]; then                                  #checking if there are no active subdomains

  #removing htpp and https

while read url; do                                            
	echo ${url#*//} >> temp/sub.txt                                 #removing 'http://' and 'https://' from subdomains
done < temp/live.txt                                              #live.txt is given as input to the while loop

   
  #final sorting

rm -fr $dom-subdomains.txt                                        #removing file if it already exist
sort -u temp/sub.txt >> $dom-subdomains.txt                       #final sorting of the subdomain and storing into a file
count=$(cat $dom-subdomains.txt | wc -l)                          #used to get the total number of active subdomains

  #printing the result

echo -e "${green}  SUBSHADE SUCCESSFULLY COMPLETED ! \n"
echo -e "${yellow} Total number of active subdomains after sorting is :  ${green} $count "
echo -e "\n${yellow} Check ${green}'$dom-subdomains.txt' ${yellow}for the list of active subdomains "


else

    rm -fr $dom-subdomains.txt                                    #removing subdomains folder if there are no active subdomains
    echo -e "${red} \n NO ACTIVE SUBDOMAINS "

fi

fi

fi

echo -e "\n${cyan} ================================================================================ ${reset}"
rm -fr temp                                                       #removing the temporary folder

#END OF THE SCRIPT