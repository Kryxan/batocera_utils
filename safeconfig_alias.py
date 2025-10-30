# Fix motion controls for the batocera_extra library
# https://github.com/git-developer/batocera-extra
#
# place in /usr/lib/python3.12/site-packages

try:
    from ConfigParser import SafeConfigParser  # Python 2
except ImportError:
    try:
        from configparser import SafeConfigParser  # Python <3.2
    except ImportError:
        from configparser import ConfigParser as SafeConfigParser
