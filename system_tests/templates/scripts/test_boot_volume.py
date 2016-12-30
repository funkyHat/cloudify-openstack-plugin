# Stdlib imports

# Third party imports
from fabric.api import run

# Cloudify imports
from cloudify import ctx
from cloudify.exceptions import NonRecoverableError


def check():
    ctx.logger.info('Checking Server info')
    ctx.instance.runtime_properties['os_distro'] = run(
            'uname -a | cut -f1,2 -d" "')
