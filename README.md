# foundryvtt
Docker container for FoundryVTT

# Usage
1. Download install.sh ```curl -fsSl https://raw.githubusercontent.com/rheuvel89/foundryvtt/main/install.sh -o install.sh```
2. Download default.env ```curl -fsSl https://raw.githubusercontent.com/rheuvel89/foundryvtt/main/default.env -o default.env```
3. Modify install.sh to run ```sudo chmod +x install.sh```
4. Modify fill out variables in default.env
5. Run install.sh with the a list of subdomains:
e.g.: ```sudo ./install.sh "foo;bar;mrep"```
for three servers named foo, bar and mrep