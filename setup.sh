if [ ! -f 19mil-7chars.txt ]; then
	echo -e '\n[*] Running: tar xvf 19mil-7chars.tar.gz'
	tar xvf 19mil-7chars.tar.gz
fi

# I haven't tested any of these except Kali
# libssl1.0-dev libxml2-dev zlib1g-dev are all required for Empire to install properly because its installer is broken on Kali
if lsb_release -d | grep -q "Fedora"; then
	echo -e '\n[*] Running: dnf install -y python36u-devel python-pip smbclient libssl1.0-devel libxml2-devel zlib1g-devel -y'
	dnf upgrade
	dnf install -y python3 python3-dev python-pip smbclient libssl1.0-devel libxml2-devel zlib1g-devel xterm

elif lsb_release -d | grep -q "CentoS"; then
	echo -e '\n[*] Running: yum update'
	yum update
	echo -e '\n[*] Running: yum install https://centos7.iuscommunity.org/ius-release.rpm'
	yum install https://centos7.iuscommunity.org/ius-release.rpm
	echo -e '\n[*] Running: yum install -y python36u-devel python36u python-pip smbclient libssl1.0-devel libxml2-devel zlib1g-devel xterm'
	yum install -y python36u-devel python36u python-pip smbclient libssl1.0-devel libxml2-devel zlib1g-devel xterm

elif lsb_release -d | grep -E "Debian|Kali|Ubuntu"; then
	echo -e '\n[*] Running: apt-get update'
	apt-get update 
	echo -e '\n[*] Running: apt-get install python3-dev python-pip smbclient libssl1.0-dev libxml2-dev zlib1g-dev -y'
	apt-get install python3-dev python-pip smbclient libssl1.0-dev libxml2-dev zlib1g-dev xterm -y
fi

# libssl1.0-dev libxml2-dev zlib1g-dev are all required for Empire to install properly because its installer is broken on Kali
echo -e '\n[*] Running: apt-get install python3-dev python-pip smbclient libssl1.0-dev libxml2-dev zlib1g-dev -y'
apt-get install python3-dev python-pip smbclient libssl1.0-dev libxml2-dev zlib1g-dev xterm -y

echo -e '\n[*] Running: pip2 install pipenv pexpect mitm6 ldap3'
pip2 install pipenv mitm6 pexpect ldap3
echo -e '\n[*] Running: pip2 install --upgrade pip2 pipenv pexpect mitm6 ldap3'
pip2 install --upgrade pip2 pipenv mitm6 pexpect ldap3

echo -e '\n[*] Running: git submodule init'
git submodule init

echo -e '\n[*] Running: git submodule update --recursive'
git submodule update

if [ ! -f submodules/JohnTheRipper/run/john ]; then
	echo -e '\n[*] Running: cd submodules/JohnTheRipper/src && ./configure && make'
	cd submodules/JohnTheRipper/src && ./configure && make
else
	cd submodules/JohnTheRipper/src
fi

echo -e '\n[*] Running: cd ../../impacket/'
cd ../../impacket/

echo -e '\n[*] Running: python2 setup.py install'
python2 setup.py install

echo -e '\n[*] Running: cd ../Empire/setup/'
cd ../Empire/setup/

echo -e '\n[*] Running: yes | ./install.sh'
yes | ./install.sh

echo -e '\n[*] Running: cd ../../../'
cd ../../../

echo -e '\n[*] Running: pipenv install --three'
pipenv install --three

#echo -e '\n[*] KALI USERS: run "apt-get remove python-impacket" before running icebreaker'
echo -e '[*] Run "pipenv shell" before running icebreaker'
echo -e '[*] Example usage: ./icebreaker.py -l targets.txt'
