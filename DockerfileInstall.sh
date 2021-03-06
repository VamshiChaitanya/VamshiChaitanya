do_with_root() {
    # already root? "Just do it" (tm).
    if [[ `whoami` = 'root' ]]; then
        $*
    elif [[ -x /bin/sudo || -x /usr/bin/sudo ]]; then
        echo "sudo $*"
        sudo $*
    else
        echo "Glances requires root privileges to install."
        echo "Please run this script as root."
        exit 1
    fi
}

echo "Install dependancies"


# Glances issue #922: Do not install PySensors (SENSORS)

DEPS="setuptools glances[action,batinfo,browser,cpuinfo,chart,docker,export,folders,gpu,ip,raid,snmp,web,wifi]"



# Install libs
do_with_root pip install --upgrade pip

do_with_root pip install $DEPS


# Install or ugrade Glances from the Pipy repository
if [[ -x /usr/local/bin/glances || -x /usr/bin/glances ]]; then
    echo "Upgrade Glances and dependancies"
    # Upgrade libs
    do_with_root pip install --upgrade $DEPS
    do_with_root pip install --upgrade glances
else
    echo "Install DhanushGlances"
    # Install Glances
    do_with_root pip install glances
fi
