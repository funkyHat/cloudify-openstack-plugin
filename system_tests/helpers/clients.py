import keystoneclient.v2_0.client as keystone_client
from keystoneauth1 import loading, session
import neutronclient.v2_0.client as neutron_client
import novaclient.v2.client as nova_client


def get_nova_client(tester_conf):
    return nova_client.Client(
        auth_url=tester_conf['openstack.keystone_url'],
        username=tester_conf['openstack.username'],
        api_key=tester_conf['openstack.password'],
        project_id=tester_conf['openstack.tenant'],
        region=tester_conf['openstack.region'],
    )


def get_keystone_client(tester_conf):
    ks_args = dict(
        auth_url=tester_conf['openstack.keystone_url'],
        username=tester_conf['openstack.username'],
        password=tester_conf['openstack.password'],
        tenant_name=tester_conf['openstack.tenant'],
    )
    loader = loading.get_plugin_loader('password')
    auth = loader.load_from_options(**ks_args)
    sess = session.Session(auth=auth)
    ks_args['session'] = sess
    return keystone_client.Client(**ks_args)


def get_neutron_client(tester_conf):
    return neutron_client.Client(
        auth_url=tester_conf['openstack.keystone_url'],
        username=tester_conf['openstack.username'],
        password=tester_conf['openstack.password'],
        tenant_name=tester_conf['openstack.tenant'],
    )
