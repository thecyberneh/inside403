<h1 align="center">
  <br>
  <a href="https://twitter.com/thecyberneho"><img src="images/inside403logoNoBg.png" alt="INSIDE403"></a>
</h1>
<h4 align="center">Scanner for directory/path which has status code 403 and test for possible 403 Bypass</h4>


<p align="center">
<a><img title="Made in INDIA" src="https://img.shields.io/badge/MADE%20IN-INDIA-SCRIPT?colorA=%23ff8100&colorB=%23017e40&colorC=%23ff0000&style=for-the-badge"></a>
</p>
<p align="center">
<a><img title="Version" src="https://img.shields.io/badge/Version-v1.0.0_dev-blue.svg"></a>
<a href="https://twitter.com/thecyberneh"><img src="https://img.shields.io/twitter/follow/thecyberneh?style=social"></a>
</p>

<p align="center">
  <a href="#install-inside403">Instllation</a> •
  <a href="#usage">Usage</a>
</p>

## Install INSIDE403
INSIDE403 requires <a href="https://github.com/ffuf/ffuf">**FFUF**<a>.<br>
Also this tool will consider following wordlist as default wordlist.
```
Default Worslist at :- /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
```
<br>
<br>
  
For complete installation, run following command
```sh
  git clone https://github.com/thecyberneh/inside403.git
  cd inside403
  bash installer.sh
```
<br>
<br>
  
## USAGE


```sh
inside403 -h
```
This will display help for the tool. Here are all the switches it supports.
  
```console
[ABOUT]
   INSIDE403 is a Scanner for directory/path which has status code 403 and test for possible 403 Bypass
   and try to bypass it.


[Usage:]
   inside403 [flags]


[FLAGS:]
    [TARGET:]
       -l, --list       target URLs/hosts to scan
       -u, --url        Target URL+Directory to Scan, Single URL


    [WORDLIST:]
       -w, --wordlist    path of your wordlist


[Examples:]
   Try to bypass 403 on directory:- 403here
       inside403 -u https://sub.domain.tld/403here 


   Try to find directories with 403 from URL list
   with wordlist located at:- /path/to/wordlist.txt
       inside403 -l httpxResults.txt -w /path/to/wordlist.txt 
   You can use results from HTTPX tool as URL list


   Run tool with default wordlist
       Default wordlist at:- /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
       inside403 -l httpxResults.txt 
    [HELP:]
       -h, --help    to get help menu 
```

