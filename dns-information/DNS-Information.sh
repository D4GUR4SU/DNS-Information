#!/bin/bash

#############################################################
#
#  ▪ Title: DnsInformation
#  ▪ Version: 1.0
#  ▪ Date: 08/06/2022
#  ▪ Tested on: Ubuntu
#  ▪ Owner: Dagurasu56
#
#############################################################


#############################################################
# ▶ Colors
#############################################################
BLACK='\033[30;01;1m'
RED='\033[31;01;1m'
RED_BLINK='\033[31;01;05;1m'
GREEN='\032[36;01;1m'
CIANO='\033[36;01;1m'
CIANO_BLINK='\033[36;01;05;1m'
BLUE='\033[34;01;1m'
END='\033[m'

#############################################################
# ▶ Arguments
#############################################################
op=$1			# op = option

#Direct Search
domain_direct=$2	# domain_direct = target domain
wd_direct=$4		# wd_direct = wordlist to use

#Search Lookup
ip=$2			# ip = target ip
network=$4			# network = target network

#Zone Transfer
domain_zone=$3		# domain_zone = target domain

#TakeOver
domain_take=$3		# domain_take = target domain
wd_take=$5		# wd_take = wordlist to use
#############################################################

#############################################################
# ▶ Version
#############################################################
Version='1.0'

#############################################################
# ▶ Ctrl+C
#############################################################
trap Ctrl_C INT
Ctrl_C(){
	echo -e "${RED_BLINK}\n[!] Aborted Action [!]${END}"
	exit 1
}
#############################################################
# ▶ Clear
#############################################################

Clear(){
	clear
}

#############################################################
# ▶ Banner
#############################################################
Banner(){
	Clear
	echo
	echo -e "${BLACK} ██████╗ ███╗   ██╗███████╗    ██╗███╗   ██╗███████╗ ██████╗ ██████╗ ███╗   ███╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗ ${END}";
	echo -e "${BLACK} ██╔══██╗████╗  ██║██╔════╝    ██║████╗  ██║██╔════╝██╔═══██╗██╔══██╗████╗ ████║██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║ ${END}";
	echo -e "${BLACK} ██║  ██║██╔██╗ ██║███████╗    ██║██╔██╗ ██║█████╗  ██║   ██║██████╔╝██╔████╔██║███████║   ██║   ██║██║   ██║██╔██╗ ██║ ${END}";
	echo -e "${RED} ██║  ██║██║╚██╗██║╚════██║    ██║██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║██╔══██║   ██║   ██║██║   ██║██║╚██╗██║ ${END}";
	echo -e "${RED} ██████╔╝██║ ╚████║███████║    ██║██║ ╚████║██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║ ${END}";
	echo -e "${RED} ╚═════╝ ╚═╝  ╚═══╝╚══════╝    ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ${END}";
	echo -e "                                                                                                                       ${END}";
	echo -e "${RED}\t\t\t\t\t\t.:Coded By Dagurasu56:.${END}"
	echo
	echo -e "${RED} Welcome user, Have a nice experience${END}"
	echo -e "${RED} $0 -h ▶ How to use the Dns Information${END}"
	echo
}

#############################################################
# ▶ Help
#############################################################
Help(){
	echo
	echo -e "${CIANO}\t\t[SOS] Help Panel [SOS]\n${END}"
	echo -e "${BLUE} -v, --version    	Show the program version${END}"
	echo -e "${BLUE} -h, --help       	Show the help menu${END}"
	echo -e "${BLUE} -z, --zonetransfer     Defines that a zone transfer will be made${END}"
	echo -e "${BLUE} -t, --takeover		Define that a scan will be made for subdomains that are vulnerable to subdomain takeover${END}"
	echo -e "${BLUE} -d, --domain     	Set target domain(example.com)${END}"
	echo -e "${BLUE} -w, --wordlist   	Defines the wordlist to be used in bruteforce${END}"
	echo -e "${BLUE} -i, --ip         	Set target ip (Reverse Lookup)${END}"
	echo -e "${BLUE} -n, --network       	Define the target network${END}"
	echo
	echo -e "${CIANO}\t\t[?] EXAMPLES [?]${END}"
	echo -e "${BLACK} ▶ Direct Search${END}"
	echo -e "${BLUE} $0 ${CIANO}-d${END}${BLUE} example.com -w subdomains-20000.txt${END}"

	echo -e "${BLACK} ▶ Reverse Search${END}"
	echo -e "${BLUE} $0 ${CIANO}-i${END}${BLUE} 192.168.8.1 -n 192.168.8${END}"

	echo -e "${BLACK} ▶ Zone Transfer${END}"
	echo -e "${BLUE} $0 ${CIANO}-z${END}${BLUE} -d example.com${END}"

	echo -e "${BLACK} ▶ SubDomain - Take Over${END}"
	echo -e "${BLUE} $0 ${CIANO}-t${END}${BLUE} -d example.com -w subdomains-20000.txt${END}"
	echo
	echo -e "${RED} [-] If nothing is returned and the script closes -> Nothing Found${END}"
	echo -e "${RED} [-] If nothing is being returned but the script is still in progress -> Program in progress, wait!${END}"
	echo
}

#############################################################
# ▶ Verification
#############################################################
Verify(){
	#Check the Dependencies
	if ! [[ -e /usr/bin/host ]];then
		echo -e "\n${BLUE}Dependency: host${END}"
		echo -e "${CIANO}sudo apt install host${END}\n"
		exit 1
	elif ! [[ -e /usr/bin/whois ]];then
		echo -e "\n${BLUE}Dependency: whois${END}"
		echo -e "${CIANO}sudo apt install whois${END}\n"
		exit 1
	fi

	#Check the arguments
	if [ -z "$op" ];then
		Banner
		exit 1
	fi
}
#############################################################
# ▶ Check Options
#############################################################
Check_Direct_Options(){
	if [ -z "$domain_direct" ];then Help;exit 1;fi
	if [ -z "$wd_direct" ];then Help;exit 1;fi
	if [ ! -s "$wd_direct" ];then echo -e "${BLACK}Wordlist Non-existent${END}";exit 1;fi
}
Check_Reverse_Options(){
	if [ -z "$ip" ];then Help;exit 1;fi
	if [ -z "$network" ];then Help;exit 1;fi
}
Check_Zone_Options(){
	if [ -z "$domain_zone" ];then Help;exit 1;fi
}
Check_Take_Options(){
	if [ -z "$domain_take" ];then Help;exit 1;fi
	if [ -z "$wd_take" ];then Help;exit 1;fi
	if [ ! -s "$wd_take" ];then echo -e "${BLACK}Wordlist Non-existent${END}";exit 1;fi
}

#############################################################
# ▶ Host verification
#############################################################
Check_Host_Direct(){
	Verify=$(host $domain_direct 2>/dev/null| cut -d "(" -f2 | sed 's/.$//')
	if [ "$Verify" == "NXDOMAIN" ] && [ "$Verify" == "SERVFAIL" ];then
		echo -e "${RED_BLINK}\n[-] HOST UNAVAILABLE [-]\n ${END}"
		exit 1

	fi
}
Check_Host_Zone(){
	Verify=$(host $domain_zone 2>/dev/null| cut -d "(" -f2 | sed 's/.$//')
	if [ "$Verify" == "NXDOMAIN" ] && [ "$Verify" == "SERVFAIL" ];then
		echo -e "${RED_BLINK}\n[-] HOST UNAVAILABLE [-]\n ${END}"
		exit 1
	fi
}
Check_Host_Take(){
	Verify=$(host $domain_take 2>/dev/null| cut -d "(" -f2 | sed 's/.$//')
	if [ "$Verify" == "NXDOMAIN" ] && [ "$Verify" == "SERVFAIL" ];then
		echo -e "${RED_BLINK}\n[-] HOST UNAVAILABLE\n [-]${END}"
		exit 1
	fi
}
Check_Host_IP(){
	Verify=$(host $ip 2>/dev/null| cut -d "(" -f2 | sed 's/.$//')
	if [ "$Verify" == "NXDOMAIN" ] && [ "$Verify" == "SERVFAIL" ];then
		echo -e "${RED_BLINK}\n[-] HOST UNAVAILABLE [-]\n ${END}"
		exit 1
	fi
}

#############################################################
# ▶ Get Range (Reverse Lookup)
#############################################################
Get_Range(){
        r1=$(whois $ip 2>/dev/null| grep "inetnum" | cut -d "." -f4 | cut -d " " -f1)
        r2=$(whois $ip 2>/dev/null| grep "inetnum" | cut -d "." -f7)
        for h in $(seq $r1 $r2);do echo -e "${BLACK}[+] Attacking: $network.$h${END}" | tr '\n' '\r';host $network.$h 2>/dev/null | egrep -v "SERVFAIL|NXDOMAIN" | grep -v "ip" | cut -d " " -f1,5 | cut -d "." -f1,2,3,4,6,7,8,9 | sed 's/arpa/ -> /';done; echo -e "\n${BLACK}--END--${END}"
}

#############################################################
# ▶ Get Subs (Direct Search)
#############################################################
Get_Sub(){
	for sub in $(cat $wd_direct);do
		echo -e "${BLACK}[+] Attacking: $domain_direct${END}" | tr '\n' '\r'
		host $sub.$domain_direct 2>/dev/null | egrep -v "NXDOMAIN|SERVFAIL" | cut -d " " -f1,4 | sed 's/ / -> /' | grep "$domain_direct" | grep -v "alias"
	done
	echo -e "\n${BLACK}--END--${END}"
}

#############################################################
# ▶ Get Subs Tk (Take Over)
#############################################################
Get_Tks(){
	for subs in $(cat $wd_take);do
		echo -e "${BLACK}[+] Attacking: $domain_take${END}\n" | tr '\n' '\r'
		sub_with_redirect=$(host -t cname $subs.$domain_take 2>/dev/null | egrep -v "NXDOMAIN|SERVFAIL" | grep "alias for" | awk -F " " '{print $1}')
        	check_the_subs=$(host $sub_with_redirect 2>/dev/null | awk -F " " '{print $5}' | cut -d "(" -f2 | cut -d ")" -f1)
 		if [ "$check_the_subs" == "NXDOMAIN" ];then
                        echo -e "${CIANO}[+] TakeOver: $check_the_subs  ${END}"
	        fi
	done
	echo -e "\n${BLACK}--END--${END}"
}

#############################################################
# ▶ Get Name Server (Zone Transfer)
#############################################################
Get_Ns(){
	for ns in $(host -t ns $domain_zone 2>/dev/null | awk -F " " '{print $4}');do echo -e "${BLACK}[+] Attacking: $domain_zone${END}" | tr '\n' '\r'; host -l -a $domain_zone $ns 2>/dev/null;done;echo -e "\n${BLACK}--END--${END}"
}

#############################################################
# ▶ Direct SubDomains Found
#############################################################
Find_Direct(){
	echo
	echo -e "${RED} ┏━╸┏━┓╻ ╻┏┓╻╺┳┓ ${END}";
	echo -e "${RED} ┣╸ ┃ ┃┃ ┃┃┗┫ ┃┃ ${END}";
	echo -e "${RED} ╹  ┗━┛┗━┛╹ ╹╺┻┛ ${END}";
	echo

	echo -e "${BLACK}########################################${END}"
	echo -e "${RED}#    SUB DOMAINS\t|\tIP     #${END}"
	echo -e "${BLACK}########################################${END}"
	echo
}

#############################################################
# ▶ TakeOver SubDomains Found
#############################################################
Find_Reverse(){
	echo
	echo -e "${RED} ┏━╸┏━┓╻ ╻┏┓╻╺┳┓ ${END}";
	echo -e "${RED} ┣╸ ┃ ┃┃ ┃┃┗┫ ┃┃ ${END}";
	echo -e "${RED} ╹  ┗━┛┗━┛╹ ╹╺┻┛ ${END}";
	echo

	echo -e "${BLACK}########################################${END}"
	echo -e "${RED}#    SUB DOMAINS\t|\tIP     #${END}"
	echo -e "${BLACK}########################################${END}"
	echo
}

#############################################################
# ▶ TakeOver SubDomains Found AND Zone Transfer Success
#############################################################
Find_TZ(){
	echo
	echo -e "${RED} ┏━╸┏━┓╻ ╻┏┓╻╺┳┓ ${END}";
	echo -e "${RED} ┣╸ ┃ ┃┃ ┃┃┗┫ ┃┃ ${END}";
	echo -e "${RED} ╹  ┗━┛┗━┛╹ ╹╺┻┛ ${END}";
	echo
}

#############################################################
# ▶ Main Function
#############################################################
Main(){
	Verify
	case $op in
		"-v"|"--version")
			echo -e "\n${CIANO}Version:${END}${BLACK} $Version${END}\n"
			exit 0
		;;
		"-h"|"--help")
			Help
			exit 0
		;;
		"-i"|"--ip")
			Check_Reverse_Options
			Check_Host_IP
			Find_Reverse
			Get_Range
			exit 0
		;;
		"-d"|"--domain")
			Check_Direct_Options
			Check_Host_Direct
			Find_Direct
			Get_Sub
			exit 0
		;;
		"-z"|"--zonetransfer")
			Check_Options_Zone
			Check_Host_Zone
			Find_TZ
			Get_Ns
			exit 0
		;;
		"-t"|"--takeover")
			Check_Take_Options
			Check_Host_Take
			Find_TZ
			Get_Tks
			exit 0
		;;
		*)
			Help
			exit 1
	esac
}

#############################################################
# ▶ Starting the Program
#############################################################
Main
