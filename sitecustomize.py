# Fix motion controls for the batocera_extra library
# https://github.com/git-developer/batocera-extra
#
# place in /usr/lib/python3.12/site-packages

import safeconfig_alias
import builtins
import configparser

builtins.SafeConfigParser = safeconfig_alias.SafeConfigParser
configparser.SafeConfigParser = safeconfig_alias.SafeConfigParser
