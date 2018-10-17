#!/bin/sh
. ~/install_config.sh

echo "Updating OS"
sudo yum -y update
echo "Installing git"
sudo yum -y install git
echo "Configure git"
git config --global user.name "${USERNAME}"
git config --global user.email ${USEREMAIL}
echo "git: You should also make sure you have signed keys, etc...continuing on"

echo "Setting up .pypirc for Nexus"
cat > ~/.pypirc << EOFPP
[distutils]
index-servers = pypi
[pypi]
repository: ${NEXUS}/repository/${NEXUS_INTERNAL_REPO}/
username: ${NEXUS_USER}
password: ${NEXUS_PASSWORD}
EOFPP

echo "Setting up pip for Nexus"
mkdir -p ~/.config/pip/
cat > ~/.config/pip/pip.conf << EOFPIP
[freeze]
timeout = 10

[global]
timeout = 60
index = ${NEXUS}/repository/${NEXUS_GROUP_REPO}/pypi
index-url = ${NEXUS}/repository/${NEXUS_GROUP_REPO}/simple
trusted-host  = ${NEXUS_HOST}
EOFPIP

echo "Installing Python3"
sudo yum -y install python3

echo "Intalling virtualenv"
python3 -m pip install --user --upgrade virtualenv
echo "Installing pipsi"
curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python3

echo "Installing JDK"
sudo yum -y install ./Downloads/jdk*.rpm
echo "Installing sdkman"
curl -s "https://get.sdkman.io" | bash
mkdir -p ${HOME}/.sdkman/etc
cat > ${HOME}/.sdkman/etc/config << SDKMAN
# make sdkman non-interactive, preferred for CI environments
sdkman_auto_answer=true

# perform automatic selfupdates
sdkman_auto_selfupdate=true

# disables SSL certificate verification
# https://github.com/sdkman/sdkman-cli/issues/327
# HERE BE DRAGONS....
sdkman_insecure_ssl=false

# configure curl timeouts
sdkman_curl_connect_timeout=5
sdkman_curl_max_time=4

# subscribe to the beta channel
sdkman_beta_channel=false

SDKMAN
# sdk -y install lazybones	# if that's your thing
echo "Please start a new shell (log out and back in is best)
