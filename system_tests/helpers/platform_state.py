from clients import (
    get_keystone_client,
    get_neutron_client,
    get_nova_client,
)


def get_platform_entities(tester_conf):
    no = get_nova_client(tester_conf)
    ne = get_neutron_client(tester_conf)
    ks = get_keystone_client(tester_conf)

    result = {}

    servers = no.servers.list()
    result['servers'] = {
        server.name: server.id
        for server in servers
    }
    volumes = no.volumes.list()
    result['volumes'] = {
        volume.display_name: volume.id
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
    ]

    assert entity_type in supports_prefix, \
           'Entity {} does not support prefix searches.'.format(entity_type)
