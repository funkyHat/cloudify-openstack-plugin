# Stdlib imports

# Third party imports
from fabric.api import sudo, env

# Cloudify imports
from cloudify import ctx
from cloudify.exceptions import NonRecoverableError

# This package imports


def configure():
    # In case of connection related retries, see if we need to scan+mkfs
    # This will still fail in some circumstances
    # (e.g. conn failure after rescan)
    ctx.instance.runtime_properties['test_succeeded'] = False
    ctx.logger.info('Seeing if we need to initialise the disk..')
    mounted = sudo('mount').splitlines()
    mounted_paths = [mount.split()[0] for mount in mounted]
    if '/mnt' in mounted_paths:
        ctx.logger.info('Device already initialised and mounted')
    else:
        target_device = env['device_name']
        ctx.logger.info('Formatting device as ext4...')
        sudo('mkfs.ext4 -F {device}'.format(device=target_device))
        sudo('mount {device} /mnt'.format(device=target_device))
        ctx.logger.info('Device formatted and mounted on /mnt')

    ctx.logger.info('Attempting to create file on device...')
    sudo('touch /mnt/testfile')
    ctx.instance.runtime_properties['test_succeeded'] = True
    ctx.logger.info('Successfully created test file on device')
