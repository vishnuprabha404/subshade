# Colors for output
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[1;33m'
blue='\033[0;34m'
cyan='\033[0;36m'
reset='\033[0m'

# Error function
error() {
    echo -e "${red}Error: Please provide a valid domain${reset}"
    echo "Usage: $0 <domain>"
    exit 1
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check and install requirements
check_requirements() {
    local missing_tools=()
    
    if ! command_exists assetfinder; then
        missing_tools+=("assetfinder")
    fi
    
    if ! command_exists httprobe; then
        missing_tools+=("httprobe")
    fi
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo -e "${red}Missing required tools: ${missing_tools[*]}${reset}"
        echo -e "${yellow}SubShade requires these tools to function properly.${reset}"
        
        if [ -f "requirements.sh" ]; then
            echo -e "${blue}Found requirements.sh installer script.${reset}"
            read -p "Would you like to install the missing tools automatically? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "${yellow}Running requirements installation...${reset}"
                chmod +x requirements.sh
                ./requirements.sh
                
                # Check if installation was successful
                local still_missing=()
                for tool in "${missing_tools[@]}"; do
                    if ! command_exists "$tool"; then
                        still_missing+=("$tool")
                    fi
                done
                
                if [ ${#still_missing[@]} -gt 0 ]; then
                    echo -e "${red}Installation failed for: ${still_missing[*]}${reset}"
                    echo -e "${yellow}Please install these tools manually and try again.${reset}"
                    exit 1
                else
                    echo -e "${green}All tools installed successfully! Continuing with SubShade...${reset}"
                    echo
                fi
            else
                echo -e "${yellow}Please install the missing tools manually:${reset}"
                for tool in "${missing_tools[@]}"; do
                    echo -e "  - $tool"
                done
                echo -e "${blue}Or run: ./requirements.sh${reset}"
                exit 1
            fi
        else
            echo -e "${yellow}Please install the missing tools manually or download requirements.sh${reset}"
            echo -e "${blue}You can find installation instructions in README.md${reset}"
            exit 1
        fi
    fi
}

#starting
check_requirements                                                #check if required tools are installed
dom=$1                                                            #reading domain using command line argument
# Display banner
echo -e "${cyan}"
cat << "EOF"
   _____ __  ______  _____ __  _____    ____  ______
  / ___// / / / __ )/ ___// / / /   |  / __ \/ ____/
  \__ \/ / / / __  |\__ \/ /_/ / /| | / / / / __/   
 ___/ / /_/ / /_/ /___/ / __  / ___ |/ /_/ / /___   
/____/\____/_____//____/_/ /_/_/  |_/_____/_____/   
                                                    
EOF
echo -e "${reset}"
echo -e "${blue}═══════════════════════════════════════════════════════════${reset}"
echo -e "${yellow}            Subdomain Enumeration & Discovery Tool${reset}"
echo -e "${blue}═══════════════════════════════════════════════════════════${reset}"
echo -e "${green} Welcome ${red}$USER${reset} | ${blue}Date: ${cyan}$(date +"%Y-%m-%d %H:%M:%S")${reset}" #greetings
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