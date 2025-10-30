# batocera_utils
some helpful things for batocera

sleep_monitor is a service file to detect lid close on laptop

lid-switch.sh for lid close triggered by multimedia_keys.conf

osd-controls.sh fixes brightness controls. the osd doesn't function as intended. the volume control functions are not needed, just there as i wanted a global osd, but that doesn't work

multimedia_keys.conf is to trigger the brightness keys and lid switch and whatever else. volume not configured since osd doesn't work


# Motion Controls scripts https://github.com/git-developer/batocera-extra     
fixes for AttributeError: module 'configparser' has no attribute 'SafeConfigParser'.     

Got this error when trying to use the Sony controller driver.

```
Traceback (most recent call last):
  File "/usr/bin/dsdrv-cemuhook", line 3, in <module>
    from dsdrv.__main__ import main
  File "/usr/lib/python3.12/site-packages/dsdrv/__main__.py", line 7, in <module>
    from .actions import ActionRegistry
  File "/usr/lib/python3.12/site-packages/dsdrv/actions/__init__.py", line 1, in <module>
    from ..action import ActionRegistry
  File "/usr/lib/python3.12/site-packages/dsdrv/action.py", line 1, in <module>
    from .config import add_controller_option
  File "/usr/lib/python3.12/site-packages/dsdrv/config.py", line 82, in <module>
    class Config(configparser.SafeConfigParser):
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
AttributeError: module 'configparser' has no attribute 'SafeConfigParser'. Did you mean: 'RawConfigParser'?
```

so i developed this fix which i placed in **safeconfig_alias.py**
```
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

```

I added another file **sitecustomize.py** to ensure the fix is always triggered
```
# Fix motion controls for the batocera_extra library
# https://github.com/git-developer/batocera-extra
#
# place in /usr/lib/python3.12/site-packages

import safeconfig_alias
import builtins
import configparser

builtins.SafeConfigParser = safeconfig_alias.SafeConfigParser
configparser.SafeConfigParser = safeconfig_alias.SafeConfigParser

```

