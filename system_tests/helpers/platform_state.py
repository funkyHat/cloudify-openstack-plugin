from clients import (
    get_cinder_client,
    get_keystone_client,
    get_neutron_client,
    get_nova_client,
)

from keystoneauth1.exceptions.catalog import EndpointNotFound
from keystoneauth1.exceptions.http import Forbidden


def get_platform_entities(tester_conf):
    ci = get_cinder_client(tester_conf)
    no = get_nova_client(tester_conf)
    ne = get_neutron_client(tester_conf)
    ks = get_keystone_client(tester_conf)

    ks_version = 3 if 'v3' in tester_conf['openstack.keystone_url'] else 2

    result = {}

    servers = no.servers.list()
    result['servers'] = {
        server.name: server.id
        for server in servers
    }
    volumes = ci.volumes.list()
    result['volumes'] = {
        volume.name: volume.id
        for volume in volumes
    }
    keypairs = no.keypairs.list()
    result['keypairs'] = {
        keypair.name: keypair.id
        for keypair in keypairs
    }
    floating_ips = no.floating_ips.list()
    result['floating_ips'] = {
        floating_ip.ip: floating_ip.id
        for floating_ip in floating_ips
    }
    images = no.images.list()
    result['images'] = {
        image.name: image.id
        for image in images
    }
    security_groups = no.security_groups.list()
    result['security_groups'] = {
        security_group.name: security_group.id
        for security_group in security_groups
    }

    routers = ne.list_routers().get('routers', [])
    result['routers'] = {
        router['name']: router['id']
        for router in routers
    }
    ports = ne.list_ports().get('ports', [])
    result['ports'] = {}
    for port in ports:
        unknown_name_structure = '{type} device {dev} on network {net}'
        name_structures = {
            'compute:Production': 'Server {dev} on network {net}',
            'network:router_interface': 'Router {dev} on network {net}',
            'network:dhcp': 'DHCP {dev} on network {net}',
        }
        name = name_structures.get(port['device_owner'],
                                   unknown_name_structure)
        name = name.format(
            type=port['device_owner'],
            dev=port['device_id'],
            net=port['network_id'],
        )
        result['ports'][name] = port['id']
    subnets = ne.list_subnets().get('subnets', [])
    result['subnets'] = {
        '{name} ({cidr}) on network {net}'.format(
            name=subnet['name'],
            cidr=subnet['cidr'],
            net=subnet['network_id'],
        ): subnet['id']
        for subnet in subnets
    }
    networks = ne.list_networks().get('networks', [])
    result['networks'] = {
        network['name']: network['id']
        for network in networks
    }

    try:
        tenants = getattr(
            ks, 'projects' if ks_version == 3 else 'tenants').list()
        tenants = {
            tenant.name: tenant.id
            for tenant in tenants
        }
    except (EndpointNotFound, Forbidden):
        # Used as a canary in checks of changes
        tenants = {None: None}
    result['tenants'] = tenants

    return result


def compare_state(old_state, new_state):
    created_entities = {}
    for entity in old_state.keys():
        created_entities[entity] = dict(
            set(new_state[entity].items()) - set(old_state[entity].items())
        )

    deleted_entities = {}
    for entity in old_state.keys():
        deleted_entities[entity] = dict(
            set(old_state[entity].items()) - set(new_state[entity].items())
        )

    return {
        'current': new_state,
        'created': created_entities,
        'deleted': deleted_entities,
    }


def validate_entity_type(entity_type):
    valid_types = [
        'server',
        'volume',
        'keypair',
        'floating_ip',
        'image',
        'security_group',
        'router',
        'port',
        'subnet',
        'network',
        'tenant',
    ]

    assert entity_type in valid_types, \
        '{} is not a valid type of openstack entity.'.format(entity_type)


def supports_prefix_search(entity_type):
    supports_prefix = [
        'server',
        'volume',
        'keypair',
        'image',
        'security_group',
        'router',
        'subnet',
        'network',
        'tenant',
        'port',
    ]

    assert entity_type in supports_prefix, \
        'Entity {} does not support prefix searches.'.format(entity_type)
