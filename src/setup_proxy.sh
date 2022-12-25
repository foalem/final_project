sudo apt update -y
sudo apt install python3-pip -y
sudo apt install python3-venv -y
python3.6 -m venv venv
source venv/bin/activate
pip3.6 install wheel
pip3.6 install PyMySQL
pip3.6 install --upgrade pip
pip3.6 install setuptools-rust
pip3.6 install paramiko
pip3.6 install pandas
pip3.6 install sshtunnel
pip3.6 install pythonping