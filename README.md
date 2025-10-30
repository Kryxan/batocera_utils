# batocera_utils
some helpful things for batocera

sleep_monitor is a service file to detect lid close on laptop

lid-switch.sh for lid close triggered by multimedia_keys.conf

osd-controls.sh fixes brightness controls. the osd doesn't function as intended. the volume control functions are not needed, just there as i wanted a global osd, but that doesn't work

multimedia_keys.conf is to trigger the brightness keys and lid switch and whatever else. volume not configured since osd doesn't work


# Motion Controls scripts https://github.com/git-developer/batocera-extra     
fixes for AttributeError: module 'configparser' has no attribute 'SafeConfigParser'.     
safeconfig_alias.py fixes errors i got with the sony controller driver     
sitecustomize.py automatically calls fix     

