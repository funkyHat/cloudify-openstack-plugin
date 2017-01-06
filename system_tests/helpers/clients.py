import cinderclient.client as cinder_client
import keystoneclient.client as keystone_client
from keystoneauth1.identity import v2, v3
from keystoneauth1 import loading, session
import neutronclient.v2_0.client as neutron_client
import novaclient.client as nova_client


def _get_session(tester_conf):
    args = dict(
        auth_url=tester_conf['openstack.keystone_url'],
        username=tester_conf['openstack.username'],
        password=tester_conf['openstack.password'],
        project_name=tester_conf['openstack.tenant'],
        )
    if 'v3' in tester_conf['openstack.keystone_url']:
        version = v3
        args.update(dict(
            user_domain_name='default',
            project_domain_name='default',
            ))
    else:
        version = v2
        args['tenant_name'] = args.pop('project_name')
    auth = version.Password(**args)
    return session.Session(auth=auth)


def get_cinder_client(tester_conf):
    return cinder_client.Client('2', session=_get_session(tester_conf))


def get_nova_client(tester_conf):
    return nova_client.Client('2', session=_get_session(tester_conf))


def get_neutron_client(tester_conf):
    return neutron_client.Client(session=_get_session(tester_conf))


def get_keystone_client(tester_conf):
    version = '3' if 'v3' in tester_conf['openstack.keystone_url'] else '2'
    return keystone_client.Client(version, session=_get_session(tester_conf))
