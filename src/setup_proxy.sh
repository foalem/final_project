VENV="/home/ubuntu/server/venv/"
ACTIVATE="${VENV}bin/activate"

sudo apt update -y
sudo apt install python3-pip -y
sudo apt install python3-venv -y
python3.6 -m venv $VENV
source "$ACTIVATE"
pip3.6 install wheel
pip3.6 install PyMySQL

pip3.6 install --upgrade pip
pip3.6 install setuptools-rust
pip3.6 install paramiko
pip3.6 install pandas
pip3.6 install sshtunnel
pip3.6 install pythonping

sudo su <<HERE

VENV="/home/ubuntu/server/venv/"
ACTIVATE="${VENV}bin/activate"
python3.6 -m venv $VENV
source "$ACTIVATE"

python3.6 proxy.py -m $1 -n1 $2 -n2 $3  -n3 $4 -mode $5
HERE