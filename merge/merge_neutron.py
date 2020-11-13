# -*- coding: utf-8 -*-

'''
Auth:__XsY__
CreateDate: 2019-12-23
Talk Is Cheap,Show Me The Code.
'''

from utils import *

SRC_ENGINE = get_engine('neutron', 'neutron123', '100.69.6.88', 'neutron')
DEST_ENGINE = get_engine('neutron', 'neutron123', '100.69.6.94', 'neutron')

NEUTRON_TABLES = [
    {"table": "subnetpoolprefixes", 'clear_id': False, 'change_time': False},
    {"table": "nsxv_rule_mappings", 'clear_id': False, 'change_time': False},
    {"table": "floatingipdnses", 'clear_id': False, 'change_time': False},
    {"table": "neutron_nsx_security_group_mappings",
        'clear_id': False, 'change_time': False},
    {"table": "nsxv_security_group_section_mappings",
        'clear_id': False, 'change_time': False},
    {"table": "segmenthostmappings", 'clear_id': False, 'change_time': False},
    {"table": "cisco_ml2_n1kv_network_profiles",
        'clear_id': False, 'change_time': False},
    {"table": "cisco_ml2_n1kv_vlan_allocations",
        'clear_id': False, 'change_time': False},
    {"table": "cisco_ml2_n1kv_vxlan_allocations",
        'clear_id': False, 'change_time': False},
    {"table": "qospolicyrbacs", 'clear_id': False, 'change_time': False},
    {"table": "qos_minimum_bandwidth_rules",
        'clear_id': False, 'change_time': False},
    {"table": "qos_dscp_marking_rules", 'clear_id': False, 'change_time': False},
    {"table": "qos_bandwidth_limit_rules", 'clear_id': False, 'change_time': False},
    {"table": "qos_network_policy_bindings",
        'clear_id': False, 'change_time': False},
    {"table": "qos_port_policy_bindings", 'clear_id': False, 'change_time': False},
    {"table": "ipallocationpools", 'clear_id': False, 'change_time': False},
    {"table": "ipallocations", 'clear_id': False, 'change_time': False},
    {"table": "subnet_service_types", 'clear_id': False, 'change_time': False},
    {"table": "dnsnameservers", 'clear_id': False, 'change_time': False},
    {"table": "subnetroutes", 'clear_id': False, 'change_time': False},
    {"table": "nuage_net_partitions", 'clear_id': False, 'change_time': False},
    {"table": "nuage_subnet_l2dom_mapping",
        'clear_id': False, 'change_time': False},
    {"table": "nuage_net_partition_router_mapping",
        'clear_id': False, 'change_time': False},
    {"table": "vpnservices", 'clear_id': False, 'change_time': False},
    {"table": "auto_allocated_topologies", 'clear_id': False, 'change_time': False},
    {"table": "ha_router_agent_port_bindings",
        'clear_id': False, 'change_time': False},
    {"table": "routerports", 'clear_id': False, 'change_time': False},
    {"table": "cisco_ml2_apic_contracts", 'clear_id': False, 'change_time': False},
    {"table": "router_extra_attributes", 'clear_id': False, 'change_time': False},
    {"table": "routerl3agentbindings", 'clear_id': False, 'change_time': False},
    {"table": "routerroutes", 'clear_id': False, 'change_time': False},
    {"table": "neutron_nsx_router_mappings",
        'clear_id': False, 'change_time': False},
    {"table": "nsxv_router_ext_attributes",
        'clear_id': False, 'change_time': False},
    {"table": "cisco_port_mappings", 'clear_id': False, 'change_time': False},
    {"table": "routerrules", 'clear_id': True, 'change_time': False, 'child': [
        {"table": "nexthops", 'clear_id': False, 'change_time': False,
            "s_column": "rule_id", "p_column": "id"},
    ]},
    {"table": "cisco_ml2_n1kv_network_bindings",
        'clear_id': False, 'change_time': False},
    {"table": "bgp_peers", 'clear_id': False, 'change_time': False},
    {"table": "bgp_speakers", 'clear_id': False, 'change_time': False},
    {"table": "bgp_speaker_peer_bindings", 'clear_id': False, 'change_time': False},
    {"table": "bgp_speaker_network_bindings",
        'clear_id': False, 'change_time': False},
    {"table": "networkgateways", 'clear_id': False, 'change_time': False},
    {"table": "networkgatewaydevicereferences",
        'clear_id': False, 'change_time': False},
    {"table": "networkconnections", 'clear_id': False, 'change_time': False},
    {"table": "networksecuritybindings", 'clear_id': False, 'change_time': False},
    {"table": "ha_router_networks", 'clear_id': False, 'change_time': False},
    {"table": "qosqueues", 'clear_id': False, 'change_time': False},
    {"table": "networkqueuemappings", 'clear_id': False, 'change_time': False},
    {"table": "portqueuemappings", 'clear_id': False, 'change_time': False},
    {"table": "nsxv_tz_network_bindings", 'clear_id': False, 'change_time': False},
    {"table": "tz_network_bindings", 'clear_id': False, 'change_time': False},
    {"table": "ha_router_vrid_allocations",
        'clear_id': False, 'change_time': False},
    {"table": "multi_provider_networks", 'clear_id': False, 'change_time': False},
    {"table": "networkdnsdomains", 'clear_id': False, 'change_time': False},
    {"table": "networkrbacs", 'clear_id': False, 'change_time': False},
    {"table": "nsxv_internal_networks", 'clear_id': False, 'change_time': False},
    {"table": "externalnetworks", 'clear_id': False, 'change_time': False},
    {"table": "neutron_nsx_network_mappings",
        'clear_id': False, 'change_time': False},
    {"table": "nuage_provider_net_bindings",
        'clear_id': False, 'change_time': False},
    {"table": "nsxv_spoofguard_policy_network_mappings",
        'clear_id': False, 'change_time': False},
    {"table": "ml2_port_binding_levels", 'clear_id': False, 'change_time': False},
    {"table": "maclearningstates", 'clear_id': False, 'change_time': False},
    {"table": "vips", 'clear_id': False, 'change_time': False},
    {"table": "pools", 'clear_id': False, 'change_time': False},
    {"table": "healthmonitors", 'clear_id': False, 'change_time': False},
    {"table": "poolmonitorassociations", 'clear_id': False, 'change_time': False},
    {"table": "poolloadbalanceragentbindings",
        'clear_id': False, 'change_time': False},
    {"table": "members", 'clear_id': False, 'change_time': False},
    {"table": "poolstatisticss", 'clear_id': False, 'change_time': False},
    {"table": "ml2_port_bindings", 'clear_id': False, 'change_time': False},
    {"table": "ml2_distributed_port_bindings",
        'clear_id': False, 'change_time': False},
    {"table": "allowedaddresspairs", 'clear_id': False, 'change_time': False},
    {"table": "nsxv_port_vnic_mappings", 'clear_id': False, 'change_time': False},
    {"table": "neutron_nsx_port_mappings", 'clear_id': False, 'change_time': False},
    {"table": "portdnses", 'clear_id': False, 'change_time': False},
    {"table": "extradhcpopts", 'clear_id': False, 'change_time': False},
    {"table": "cisco_ml2_n1kv_port_bindings",
        'clear_id': False, 'change_time': False},
    {"table": "portbindingports", 'clear_id': False, 'change_time': False},
    {"table": "nsxv_port_index_mappings", 'clear_id': False, 'change_time': False},
    {"table": "subports", 'clear_id': False, 'change_time': False},
    {"table": "cisco_router_mappings", 'clear_id': False, 'change_time': False},
    {"table": "portsecuritybindings", 'clear_id': False, 'change_time': False},
    # {"table": "agents", 'clear_id': False, 'change_time': False}, # 自动上报
    {"table": "bgp_speaker_dragent_bindings",
        'clear_id': False, 'change_time': False},
    {"table": "cisco_hosting_devices", 'clear_id': False, 'change_time': False},
    {"table": "flavors", 'clear_id': False, 'change_time': False},
    {"table": "serviceprofiles", 'clear_id': False, 'change_time': False},
    {"table": "flavorserviceprofilebindings",
        'clear_id': False, 'change_time': False},
    {"table": "ikepolicies", 'clear_id': False, 'change_time': False},
    {"table": "ipsecpolicies", 'clear_id': False, 'change_time': False},
    {"table": "ipsec_site_connections", 'clear_id': False, 'change_time': False},
    {"table": "cisco_csr_identifier_map", 'clear_id': False, 'change_time': False},
    {"table": "ipsecpeercidrs", 'clear_id': False, 'change_time': False},
    {"table": "firewall_policies", 'clear_id': False, 'change_time': False},
    {"table": "firewalls", 'clear_id': False, 'change_time': False},
    {"table": "firewall_rules", 'clear_id': False, 'change_time': False},
    {"table": "brocadenetworks", 'clear_id': False, 'change_time': False},
    {"table": "brocadeports", 'clear_id': False, 'change_time': False},
    {"table": "ml2_brocadenetworks", 'clear_id': False, 'change_time': False},
    {"table": "ml2_brocadeports", 'clear_id': False, 'change_time': False},
    {"table": "meteringlabels", 'clear_id': False, 'change_time': False},
    {"table": "meteringlabelrules", 'clear_id': False, 'change_time': False},
    {"table": "ipamsubnets", 'clear_id': False, 'change_time': False},
    {"table": "ipamallocationpools", 'clear_id': False, 'change_time': False},
    {"table": "ipamallocations", 'clear_id': False, 'change_time': False},
    {"table": "reservations", 'clear_id': False, 'change_time': False},
    {"table": "resourcedeltas", 'clear_id': False, 'change_time': False},
    {"table": "lsn", 'clear_id': False, 'change_time': False},
    {"table": "lsn_port", 'clear_id': False, 'change_time': False},
    {"table": "ml2_nexus_vxlan_allocations", 'change_time': False, 'primary_key': 'vxlan_vni',
     'child': [
         {"table": "ml2_nexus_vxlan_mcast_groups", 'change_time': False,
          'clear_id': False, "s_column": "associated_vni", "p_column": "vxlan_vni"},
     ]},
    {"table": "nsxv_router_bindings", 'clear_id': False, 'change_time': False},
    {"table": "cisco_ml2_nexusport_bindings", 'clear_id': True,
     'primary_key': 'binding_id', 'change_time': False},
    {"table": "networkgatewaydevices", 'clear_id': False, 'change_time': False},
    {"table": "cisco_ml2_apic_host_links", 'clear_id': False, 'change_time': False},
    {"table": "arista_provisioned_vms", 'clear_id': False, 'change_time': False},
    {"table": "vcns_router_bindings", 'clear_id': False, 'change_time': False},
    {"table": "address_scopes", 'clear_id': False, 'change_time': False},
    {"table": "cisco_ml2_nexus_nve", 'clear_id': False, 'change_time': False},
    {"table": "quotas", 'clear_id': False, 'change_time': False},
    {"table": "nsxv_edge_vnic_bindings", 'clear_id': False, 'change_time': False},
    {"table": "nsxv_firewall_rule_bindings",
        'clear_id': False, 'change_time': False},
    {"table": "nsxv_internal_edges", 'clear_id': False, 'change_time': False},
    {"table": "nsxv_edge_dhcp_static_bindings",
        'clear_id': False, 'change_time': False},
    {"table": "arista_provisioned_nets", 'clear_id': False, 'change_time': False},
    {"table": "cisco_ml2_n1kv_profile_bindings",
        'clear_id': False, 'change_time': False},
    {"table": "cisco_ml2_n1kv_policy_profiles",
        'clear_id': False, 'change_time': False},
    {"table": "nsxv_vdr_dhcp_bindings", 'clear_id': False, 'change_time': False},
    {"table": "cisco_ml2_apic_names", 'clear_id': False, 'change_time': False},
    {"table": "ml2_ucsm_port_profiles", 'clear_id': True,
     'primary_key': 'vlan_id', 'change_time': False},
    {"table": "ml2_vxlan_endpoints", 'clear_id': False, 'change_time': False},
    {"table": "arista_provisioned_tenants",
        'clear_id': False, 'change_time': False},
    {"table": "ml2_geneve_allocations", 'clear_id': True,
        'change_time': False, 'primary_key': 'geneve_vni'},
    {"table": "dvr_host_macs", 'clear_id': False, 'change_time': False},
    {"table": "ml2_geneve_endpoints", 'clear_id': False, 'change_time': False},
    {"table": "ml2_gre_endpoints", 'clear_id': False, 'change_time': False},
    {"table": "ml2_gre_allocations", 'clear_id': True,
        'change_time': False, 'primary_key': 'gre_id'},
    {"table": "providerresourceassociations",
        'clear_id': False, 'change_time': False},
    {"table": "consistencyhashes", 'clear_id': False, 'change_time': False},
    {"table": "securitygroupportbindings", 'clear_id': False, 'change_time': False},
]


def merge_standardattributes():
    each = {"table": "standardattributes", 'clear_id': True, 'change_time': True, "change_desc": True, 'child': [
        {"table": "tags", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "qos_policies", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "networks", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "networksegments", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "subnets", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "provisioningblocks", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "routers", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "floatingips", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "ports", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "trunks", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "securitygroups", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "securitygrouprules", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
        {"table": "subnetpools", 'clear_id': False, 'change_time': False,
            "s_column": "standard_attr_id", "p_column": "id"},
    ]}
    date_col = ['created_at', 'updated_at']
    src_data = pd.read_sql_table(
        each['table'], SRC_ENGINE, parse_dates=date_col)
    src_data['description'] = src_data['id']
    time_flag = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    src_data['updated_at'] = time_flag
    src_data.id = None
    src_data.to_sql(each['table'], DEST_ENGINE,
                    index=False, if_exists='append')
    new_data = pd.read_sql(
        "select id as pid, description from %s where updated_at = '%s'" % (each['table'], time_flag), DEST_ENGINE, parse_dates=date_col)
    new_data['description'] = new_data['description'].astype(int)
    for e in each['child']:
        data = pd.read_sql_table(e['table'], SRC_ENGINE, parse_dates=date_col)
        if data.empty:
            print("%s is empty..." % e['table'])
            continue
        print("writing data to %s" % e['table'])
        data = data.merge(new_data, left_on='standard_attr_id',
                          right_on='description')
        data['standard_attr_id'] = new_data['pid']
        data.drop(columns=['pid', 'description'], inplace=True)
        data.to_sql(e['table'], DEST_ENGINE, index=False, if_exists='append')
        print("write data to %s success" % e['table'])


def merge_ml2allocations():
    tables = [
        {"table": "ml2_vxlan_allocations", 'clear_id': True,
            'change_time': False, 'primary_key': 'vxlan_vni'},
        {"table": "ml2_vlan_allocations", 'clear_id': False,
            'change_time': False, 'primary_key': 'vlan_id'},
        {"table": "ml2_flat_allocations", 'clear_id': False,
            'change_time': False, 'primary_key': 'physical_network'},
    ]
    for table in tables:
        merge_data_not_duplicates(
            table, table['primary_key'], SRC_ENGINE, DEST_ENGINE)


def merge_default_security_group():
    table = {"table": "default_security_group", 'clear_id': False,
             'change_time': False, 'primary_key': 'project_id'}
    merge_data_not_duplicates(table, 'project_id', SRC_ENGINE, DEST_ENGINE)


def merge_networkdhcpagentbindings():
    table = {"table": "networkdhcpagentbindings",
             'clear_id': False, 'change_time': False}
    old_data = pd.read_sql_table(table['table'], SRC_ENGINE)
    new_data = pd.read_sql_table(table['table'], DEST_ENGINE)
    data = pd.concat([new_data, old_data], ignore_index=True)
    data.drop_duplicates(subset=['network_id', 'dhcp_agent_id'], inplace=True)
    if data.empty:
        print("%s is empty..." % table['table'])
    else:
        data.to_sql(table['table'], DEST_ENGINE,
                    index=False, if_exists='replace')
        print("write data to %s success" % table['table'])


def merge_quotausages():
    table = {"table": "quotausages", 'clear_id': False, 'change_time': False}
    old_data = pd.read_sql_table(table['table'], SRC_ENGINE)
    new_data = pd.read_sql_table(table['table'], DEST_ENGINE)
    data = pd.concat([new_data, old_data], ignore_index=True)
    data.drop_duplicates(subset=['project_id', 'resource'], inplace=True)
    if data.empty:
        print("%s is empty..." % table['table'])
    else:
        data.to_sql(table['table'], DEST_ENGINE,
                    index=False, if_exists='replace')
        print("write data to %s success" % table['table'])


if __name__ == "__main__":
    # check_data_exist(SRC_ENGINE)
    merge_standardattributes()
    merge_ml2allocations()
    merge_default_security_group()
    merge_quotausages()
    merge_networkdhcpagentbindings()
    write_root_table(NEUTRON_TABLES, SRC_ENGINE, DEST_ENGINE)
    print("Finish merge!")
