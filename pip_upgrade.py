import pip
import sys
from subprocess import call

if sys.version_info.major == 2:
    pip_str = 'pip2'
elif sys.version_info.major == 3:
    pip_str = 'pip3'
else:
    exit(-1)

for dist in pip.get_installed_distributions():
    call(pip_str + ' install --upgrade ' + dist.project_name, shell=True)
