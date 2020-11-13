create table address_scopes
(
    id         varchar(36)  not null
        primary key,
    name       varchar(255) not null,
    project_id varchar(255) null,
    shared     tinyint(1)   not null,
    ip_version int          not null
)
    engine = InnoDB;

create index ix_address_scopes_project_id
    on address_scopes (project_id);

create table agents
(
    id                  varchar(36)            not null
        primary key,
    agent_type          varchar(255)           not null,
    `binary`            varchar(255)           not null,
    topic               varchar(255)           not null,
    host                varchar(255)           not null,
    admin_state_up      tinyint(1) default '1' not null,
    created_at          datetime               not null,
    started_at          datetime               not null,
    heartbeat_timestamp datetime               not null,
    description         varchar(255)           null,
    configurations      varchar(4095)          not null,
    `load`              int        default '0' not null,
    availability_zone   varchar(255)           null,
    resource_versions   varchar(8191)          null,
    constraint uniq_agents0agent_type0host
        unique (agent_type, host)
)
    engine = InnoDB;

create table alembic_version
(
    version_num varchar(32) not null
        primary key
)
    engine = InnoDB;

create table arista_provisioned_nets
(
    tenant_id       varchar(255) null,
    id              varchar(36)  not null
        primary key,
    network_id      varchar(36)  null,
    segmentation_id int          null
)
    engine = InnoDB;

create index ix_arista_provisioned_nets_tenant_id
    on arista_provisioned_nets (tenant_id);

create table arista_provisioned_tenants
(
    tenant_id varchar(255) null,
    id        varchar(36)  not null
        primary key
)
    engine = InnoDB;

create index ix_arista_provisioned_tenants_tenant_id
    on arista_provisioned_tenants (tenant_id);

create table arista_provisioned_vms
(
    tenant_id  varchar(255) null,
    id         varchar(36)  not null
        primary key,
    vm_id      varchar(255) null,
    host_id    varchar(255) null,
    port_id    varchar(36)  null,
    network_id varchar(36)  null
)
    engine = InnoDB;

create index ix_arista_provisioned_vms_tenant_id
    on arista_provisioned_vms (tenant_id);

create table bgp_peers
(
    id        varchar(36)  not null
        primary key,
    name      varchar(255) not null,
    auth_type varchar(16)  not null,
    password  varchar(255) null,
    peer_ip   varchar(64)  not null,
    remote_as int          not null,
    tenant_id varchar(255) null
)
    engine = InnoDB;

create index ix_bgp_peers_tenant_id
    on bgp_peers (tenant_id);

create table bgp_speakers
(
    id                                varchar(36)  not null
        primary key,
    name                              varchar(255) not null,
    local_as                          int          not null,
    ip_version                        int          not null,
    tenant_id                         varchar(255) null,
    advertise_floating_ip_host_routes tinyint(1)   not null,
    advertise_tenant_networks         tinyint(1)   not null
)
    engine = InnoDB;

create table bgp_speaker_dragent_bindings
(
    agent_id       varchar(36) not null
        primary key,
    bgp_speaker_id varchar(36) not null,
    constraint bgp_speaker_dragent_bindings_ibfk_1
        foreign key (agent_id) references agents (id)
            on delete cascade,
    constraint bgp_speaker_dragent_bindings_ibfk_2
        foreign key (bgp_speaker_id) references bgp_speakers (id)
            on delete cascade
)
    engine = InnoDB;

create index bgp_speaker_id
    on bgp_speaker_dragent_bindings (bgp_speaker_id);

create table bgp_speaker_peer_bindings
(
    bgp_speaker_id varchar(36) not null,
    bgp_peer_id    varchar(36) not null,
    primary key (bgp_speaker_id, bgp_peer_id),
    constraint bgp_speaker_peer_bindings_ibfk_1
        foreign key (bgp_speaker_id) references bgp_speakers (id)
            on delete cascade,
    constraint bgp_speaker_peer_bindings_ibfk_2
        foreign key (bgp_peer_id) references bgp_peers (id)
            on delete cascade
)
    engine = InnoDB;

create index bgp_peer_id
    on bgp_speaker_peer_bindings (bgp_peer_id);

create index ix_bgp_speakers_tenant_id
    on bgp_speakers (tenant_id);

create table brocadenetworks
(
    id   varchar(36) not null
        primary key,
    vlan varchar(10) null
)
    engine = InnoDB;

create table brocadeports
(
    port_id            varchar(36) default '' not null
        primary key,
    network_id         varchar(36)            not null,
    admin_state_up     tinyint(1)             not null,
    physical_interface varchar(36)            null,
    vlan_id            varchar(36)            null,
    tenant_id          varchar(36)            null,
    constraint brocadeports_ibfk_1
        foreign key (network_id) references brocadenetworks (id)
)
    engine = InnoDB;

create index network_id
    on brocadeports (network_id);

create table cisco_ml2_apic_host_links
(
    host   varchar(255) not null,
    ifname varchar(64)  not null,
    ifmac  varchar(32)  null,
    swid   varchar(32)  not null,
    module varchar(32)  not null,
    port   varchar(32)  not null,
    primary key (host, ifname)
)
    engine = InnoDB;

create table cisco_ml2_apic_names
(
    neutron_id   varchar(36)  not null,
    neutron_type varchar(32)  not null,
    apic_name    varchar(255) not null,
    primary key (neutron_id, neutron_type)
)
    engine = InnoDB;

create table cisco_ml2_n1kv_network_profiles
(
    id                 varchar(36)            not null
        primary key,
    name               varchar(255)           not null,
    segment_type       enum ('vlan', 'vxlan') not null,
    segment_range      varchar(255)           null,
    multicast_ip_index int                    null,
    multicast_ip_range varchar(255)           null,
    sub_type           varchar(255)           null,
    physical_network   varchar(255)           null
)
    engine = InnoDB;

create table cisco_ml2_n1kv_policy_profiles
(
    id     varchar(36)  not null,
    name   varchar(255) not null,
    vsm_ip varchar(16)  not null,
    primary key (id, vsm_ip)
)
    engine = InnoDB;

create table cisco_ml2_n1kv_profile_bindings
(
    profile_type enum ('network', 'policy')              null,
    tenant_id    varchar(36) default 'tenant_id_not_set' not null,
    profile_id   varchar(36)                             not null,
    primary key (tenant_id, profile_id)
)
    engine = InnoDB;

create table cisco_ml2_n1kv_vlan_allocations
(
    physical_network   varchar(64) not null,
    vlan_id            int         not null,
    allocated          tinyint(1)  not null,
    network_profile_id varchar(36) not null,
    primary key (physical_network, vlan_id),
    constraint cisco_ml2_n1kv_vlan_allocations_ibfk_1
        foreign key (network_profile_id) references cisco_ml2_n1kv_network_profiles (id)
            on delete cascade
)
    engine = InnoDB;

create index network_profile_id
    on cisco_ml2_n1kv_vlan_allocations (network_profile_id);

create table cisco_ml2_n1kv_vxlan_allocations
(
    vxlan_id           int         not null
        primary key,
    allocated          tinyint(1)  not null,
    network_profile_id varchar(36) not null,
    constraint cisco_ml2_n1kv_vxlan_allocations_ibfk_1
        foreign key (network_profile_id) references cisco_ml2_n1kv_network_profiles (id)
            on delete cascade
)
    engine = InnoDB;

create index network_profile_id
    on cisco_ml2_n1kv_vxlan_allocations (network_profile_id);

create table cisco_ml2_nexus_nve
(
    vni         int auto_increment,
    switch_ip   varchar(255) not null,
    device_id   varchar(255) not null,
    mcast_group varchar(255) null,
    primary key (vni, switch_ip, device_id)
)
    engine = InnoDB;

create table cisco_ml2_nexusport_bindings
(
    binding_id       int auto_increment
        primary key,
    port_id          varchar(255)           null,
    vlan_id          int                    not null,
    switch_ip        varchar(255)           null,
    instance_id      varchar(255)           null,
    vni              int                    null,
    is_provider_vlan tinyint(1) default '0' not null
)
    engine = InnoDB;

create table consistencyhashes
(
    hash_id varchar(255) not null
        primary key,
    hash    varchar(255) not null
)
    engine = InnoDB;

create table dvr_host_macs
(
    host        varchar(255) not null
        primary key,
    mac_address varchar(32)  not null,
    constraint mac_address
        unique (mac_address)
)
    engine = InnoDB;

create table firewall_policies
(
    tenant_id   varchar(255)  null,
    id          varchar(36)   not null
        primary key,
    name        varchar(255)  null,
    description varchar(1024) null,
    shared      tinyint(1)    null,
    audited     tinyint(1)    null
)
    engine = InnoDB;

create table firewall_rules
(
    tenant_id                  varchar(255)           null,
    id                         varchar(36)            not null
        primary key,
    name                       varchar(255)           null,
    description                varchar(1024)          null,
    firewall_policy_id         varchar(36)            null,
    shared                     tinyint(1)             null,
    protocol                   varchar(40)            null,
    ip_version                 int                    not null,
    source_ip_address          varchar(46)            null,
    destination_ip_address     varchar(46)            null,
    source_port_range_min      int                    null,
    source_port_range_max      int                    null,
    destination_port_range_min int                    null,
    destination_port_range_max int                    null,
    action                     enum ('allow', 'deny') null,
    enabled                    tinyint(1)             null,
    position                   int                    null,
    constraint firewall_rules_ibfk_1
        foreign key (firewall_policy_id) references firewall_policies (id)
)
    engine = InnoDB;

create table firewalls
(
    tenant_id          varchar(255)  null,
    id                 varchar(36)   not null
        primary key,
    name               varchar(255)  null,
    description        varchar(1024) null,
    shared             tinyint(1)    null,
    admin_state_up     tinyint(1)    null,
    status             varchar(16)   null,
    firewall_policy_id varchar(36)   null,
    constraint firewalls_ibfk_1
        foreign key (firewall_policy_id) references firewall_policies (id)
)
    engine = InnoDB;

create table flavors
(
    id           varchar(36)            not null
        primary key,
    name         varchar(255)           null,
    description  varchar(1024)          null,
    enabled      tinyint(1) default '1' not null,
    service_type varchar(36)            null
)
    engine = InnoDB;

create table healthmonitors
(
    tenant_id      varchar(255)                          null,
    id             varchar(36)                           not null
        primary key,
    type           enum ('PING', 'TCP', 'HTTP', 'HTTPS') not null,
    delay          int                                   not null,
    timeout        int                                   not null,
    max_retries    int                                   not null,
    http_method    varchar(16)                           null,
    url_path       varchar(255)                          null,
    expected_codes varchar(64)                           null,
    admin_state_up tinyint(1)                            not null
)
    engine = InnoDB;

create table ikepolicies
(
    tenant_id               varchar(255)                                   null,
    id                      varchar(36)                                    not null
        primary key,
    name                    varchar(255)                                   null,
    description             varchar(255)                                   null,
    auth_algorithm          enum ('sha1')                                  not null,
    encryption_algorithm    enum ('3des', 'aes-128', 'aes-256', 'aes-192') not null,
    phase1_negotiation_mode enum ('main')                                  not null,
    lifetime_units          enum ('seconds', 'kilobytes')                  not null,
    lifetime_value          int                                            not null,
    ike_version             enum ('v1', 'v2')                              not null,
    pfs                     enum ('group2', 'group5', 'group14')           not null
)
    engine = InnoDB;

create table ipamsubnets
(
    id                varchar(36) not null
        primary key,
    neutron_subnet_id varchar(36) null
)
    engine = InnoDB;

create table ipamallocationpools
(
    id             varchar(36) not null
        primary key,
    ipam_subnet_id varchar(36) not null,
    first_ip       varchar(64) not null,
    last_ip        varchar(64) not null,
    constraint ipamallocationpools_ibfk_1
        foreign key (ipam_subnet_id) references ipamsubnets (id)
            on delete cascade
)
    engine = InnoDB;

create index ipam_subnet_id
    on ipamallocationpools (ipam_subnet_id);

create table ipamallocations
(
    ip_address     varchar(64) not null,
    status         varchar(36) null,
    ipam_subnet_id varchar(36) not null,
    primary key (ip_address, ipam_subnet_id),
    constraint ipamallocations_ibfk_1
        foreign key (ipam_subnet_id) references ipamsubnets (id)
            on delete cascade
)
    engine = InnoDB;

create index ipam_subnet_id
    on ipamallocations (ipam_subnet_id);

create table ipsecpolicies
(
    tenant_id            varchar(255)                                   null,
    id                   varchar(36)                                    not null
        primary key,
    name                 varchar(255)                                   null,
    description          varchar(255)                                   null,
    transform_protocol   enum ('esp', 'ah', 'ah-esp')                   not null,
    auth_algorithm       enum ('sha1')                                  not null,
    encryption_algorithm enum ('3des', 'aes-128', 'aes-256', 'aes-192') not null,
    encapsulation_mode   enum ('tunnel', 'transport')                   not null,
    lifetime_units       enum ('seconds', 'kilobytes')                  not null,
    lifetime_value       int                                            not null,
    pfs                  enum ('group2', 'group5', 'group14')           not null
)
    engine = InnoDB;

create table lsn
(
    net_id varchar(36) not null,
    lsn_id varchar(36) not null
        primary key
)
    engine = InnoDB;

create table lsn_port
(
    lsn_port_id varchar(36) not null
        primary key,
    lsn_id      varchar(36) not null,
    sub_id      varchar(36) not null,
    mac_addr    varchar(32) not null,
    constraint mac_addr
        unique (mac_addr),
    constraint sub_id
        unique (sub_id),
    constraint lsn_port_ibfk_1
        foreign key (lsn_id) references lsn (lsn_id)
            on delete cascade
)
    engine = InnoDB;

create index lsn_id
    on lsn_port (lsn_id);

create table meteringlabels
(
    project_id  varchar(255)           null,
    id          varchar(36)            not null
        primary key,
    name        varchar(255)           null,
    description varchar(1024)          null,
    shared      tinyint(1) default '0' null
)
    engine = InnoDB;

create table meteringlabelrules
(
    id                varchar(36)                not null
        primary key,
    direction         enum ('ingress', 'egress') null,
    remote_ip_prefix  varchar(64)                null,
    metering_label_id varchar(36)                not null,
    excluded          tinyint(1) default '0'     null,
    constraint meteringlabelrules_ibfk_1
        foreign key (metering_label_id) references meteringlabels (id)
            on delete cascade
)
    engine = InnoDB;

create index metering_label_id
    on meteringlabelrules (metering_label_id);

create index ix_meteringlabels_project_id
    on meteringlabels (project_id);

create table ml2_brocadenetworks
(
    id           varchar(36)  not null
        primary key,
    vlan         varchar(10)  null,
    segment_id   varchar(36)  null,
    network_type varchar(10)  null,
    tenant_id    varchar(255) null
)
    engine = InnoDB;

create index ix_ml2_brocadenetworks_tenant_id
    on ml2_brocadenetworks (tenant_id);

create table ml2_brocadeports
(
    id                 varchar(36)  not null
        primary key,
    network_id         varchar(36)  not null,
    admin_state_up     tinyint(1)   not null,
    physical_interface varchar(36)  null,
    vlan_id            varchar(36)  null,
    tenant_id          varchar(255) null,
    constraint ml2_brocadeports_ibfk_1
        foreign key (network_id) references ml2_brocadenetworks (id)
)
    engine = InnoDB;

create index ix_ml2_brocadeports_tenant_id
    on ml2_brocadeports (tenant_id);

create index network_id
    on ml2_brocadeports (network_id);

create table ml2_flat_allocations
(
    physical_network varchar(64) not null
        primary key
)
    engine = InnoDB;

create table ml2_geneve_allocations
(
    geneve_vni int                    not null
        primary key,
    allocated  tinyint(1) default '0' not null
)
    engine = InnoDB;

create index ix_ml2_geneve_allocations_allocated
    on ml2_geneve_allocations (allocated);

create table ml2_geneve_endpoints
(
    ip_address varchar(64)  not null
        primary key,
    host       varchar(255) null,
    constraint unique_ml2_geneve_endpoints0host
        unique (host)
)
    engine = InnoDB;

create table ml2_gre_allocations
(
    gre_id    int                    not null
        primary key,
    allocated tinyint(1) default '0' not null
)
    engine = InnoDB;

create index ix_ml2_gre_allocations_allocated
    on ml2_gre_allocations (allocated);

create table ml2_gre_endpoints
(
    ip_address varchar(64)  not null
        primary key,
    host       varchar(255) null,
    constraint unique_ml2_gre_endpoints0host
        unique (host)
)
    engine = InnoDB;

create table ml2_nexus_vxlan_allocations
(
    vxlan_vni int                    not null
        primary key,
    allocated tinyint(1) default '0' not null
)
    engine = InnoDB;

create table ml2_nexus_vxlan_mcast_groups
(
    id             varchar(36) not null
        primary key,
    mcast_group    varchar(64) not null,
    associated_vni int         not null,
    constraint ml2_nexus_vxlan_mcast_groups_ibfk_1
        foreign key (associated_vni) references ml2_nexus_vxlan_allocations (vxlan_vni)
            on delete cascade
)
    engine = InnoDB;

create index associated_vni
    on ml2_nexus_vxlan_mcast_groups (associated_vni);

create table ml2_ucsm_port_profiles
(
    vlan_id        int auto_increment
        primary key,
    profile_id     varchar(64) not null,
    created_on_ucs tinyint(1)  not null
)
    engine = InnoDB;

create table ml2_vlan_allocations
(
    physical_network varchar(64) not null,
    vlan_id          int         not null,
    allocated        tinyint(1)  not null,
    primary key (physical_network, vlan_id)
)
    engine = InnoDB;

create index ix_ml2_vlan_allocations_physical_network_allocated
    on ml2_vlan_allocations (physical_network, allocated);

create table ml2_vxlan_allocations
(
    vxlan_vni int                    not null
        primary key,
    allocated tinyint(1) default '0' not null
)
    engine = InnoDB;

create index ix_ml2_vxlan_allocations_allocated
    on ml2_vxlan_allocations (allocated);

create table ml2_vxlan_endpoints
(
    ip_address varchar(64)  not null
        primary key,
    udp_port   int          not null,
    host       varchar(255) null,
    constraint unique_ml2_vxlan_endpoints0host
        unique (host)
)
    engine = InnoDB;

create table networkgatewaydevices
(
    tenant_id      varchar(255) null,
    id             varchar(36)  not null
        primary key,
    nsx_id         varchar(36)  null,
    name           varchar(255) null,
    connector_type varchar(10)  null,
    connector_ip   varchar(64)  null,
    status         varchar(16)  null
)
    engine = InnoDB;

create index ix_networkgatewaydevices_tenant_id
    on networkgatewaydevices (tenant_id);

create table networkgateways
(
    id        varchar(36)  not null
        primary key,
    name      varchar(255) null,
    tenant_id varchar(36)  null,
    `default` tinyint(1)   null
)
    engine = InnoDB;

create table networkgatewaydevicereferences
(
    id                 varchar(36) not null,
    network_gateway_id varchar(36) not null,
    interface_name     varchar(64) not null,
    primary key (id, network_gateway_id, interface_name),
    constraint networkgatewaydevicereferences_ibfk_1
        foreign key (network_gateway_id) references networkgateways (id)
            on delete cascade
)
    engine = InnoDB;

create index network_gateway_id
    on networkgatewaydevicereferences (network_gateway_id);

create table nsxv_edge_dhcp_static_bindings
(
    edge_id     varchar(36) not null,
    mac_address varchar(32) not null,
    binding_id  varchar(36) not null,
    primary key (edge_id, mac_address)
)
    engine = InnoDB;

create table nsxv_edge_vnic_bindings
(
    edge_id      varchar(36) not null,
    vnic_index   int auto_increment,
    tunnel_index int         not null,
    network_id   varchar(36) null,
    primary key (edge_id, vnic_index, tunnel_index)
)
    engine = InnoDB;

create index idx_autoinc_vnic_index
    on nsxv_edge_vnic_bindings (vnic_index);

create table nsxv_firewall_rule_bindings
(
    rule_id     varchar(36) not null,
    edge_id     varchar(36) not null,
    rule_vse_id varchar(36) null,
    primary key (rule_id, edge_id)
)
    engine = InnoDB;

create table nsxv_internal_edges
(
    ext_ip_address varchar(64)             not null
        primary key,
    router_id      varchar(36)             null,
    purpose        enum ('inter_edge_net') null
)
    engine = InnoDB;

create table nsxv_router_bindings
(
    status             varchar(16)                                      not null,
    status_description varchar(255)                                     null,
    router_id          varchar(36)                                      not null
        primary key,
    edge_id            varchar(36)                                      null,
    lswitch_id         varchar(36)                                      null,
    appliance_size     enum ('compact', 'large', 'xlarge', 'quadlarge') null,
    edge_type          enum ('service', 'vdr')                          null
)
    engine = InnoDB;

create table nsxv_vdr_dhcp_bindings
(
    vdr_router_id  varchar(36) not null
        primary key,
    dhcp_router_id varchar(36) not null,
    dhcp_edge_id   varchar(36) not null,
    constraint unique_nsxv_vdr_dhcp_bindings0dhcp_edge_id
        unique (dhcp_edge_id),
    constraint unique_nsxv_vdr_dhcp_bindings0dhcp_router_id
        unique (dhcp_router_id)
)
    engine = InnoDB;

create table nuage_net_partitions
(
    id             varchar(36) not null
        primary key,
    name           varchar(64) null,
    l3dom_tmplt_id varchar(36) null,
    l2dom_tmplt_id varchar(36) null,
    isolated_zone  varchar(64) null,
    shared_zone    varchar(64) null
)
    engine = InnoDB;

create table providerresourceassociations
(
    provider_name varchar(255) not null,
    resource_id   varchar(36)  not null,
    primary key (provider_name, resource_id),
    constraint resource_id
        unique (resource_id)
)
    engine = InnoDB;

create table qosqueues
(
    tenant_id   varchar(255)                  null,
    id          varchar(36)                   not null
        primary key,
    name        varchar(255)                  null,
    `default`   tinyint(1) default '0'        null,
    min         int                           not null,
    max         int                           null,
    qos_marking enum ('untrusted', 'trusted') null,
    dscp        int                           null
)
    engine = InnoDB;

create index ix_qosqueues_tenant_id
    on qosqueues (tenant_id);

create table quotas
(
    id         varchar(36)  not null
        primary key,
    project_id varchar(255) null,
    resource   varchar(255) null,
    `limit`    int          null
)
    engine = InnoDB;

create index ix_quotas_project_id
    on quotas (project_id);

create table quotausages
(
    project_id varchar(255)           not null,
    resource   varchar(255)           not null,
    dirty      tinyint(1) default '0' not null,
    in_use     int        default '0' not null,
    reserved   int        default '0' not null,
    primary key (project_id, resource)
)
    engine = InnoDB;

create index ix_quotausages_project_id
    on quotausages (project_id);

create index ix_quotausages_resource
    on quotausages (resource);

create table reservations
(
    id         varchar(36)  not null
        primary key,
    project_id varchar(255) null,
    expiration datetime     null
)
    engine = InnoDB;

create table resourcedeltas
(
    resource       varchar(255) not null,
    reservation_id varchar(36)  not null,
    amount         int          null,
    primary key (resource, reservation_id),
    constraint resourcedeltas_ibfk_1
        foreign key (reservation_id) references reservations (id)
            on delete cascade
)
    engine = InnoDB;

create index reservation_id
    on resourcedeltas (reservation_id);

create table serviceprofiles
(
    id          varchar(36)            not null
        primary key,
    description varchar(1024)          null,
    driver      varchar(1024)          not null,
    enabled     tinyint(1) default '1' not null,
    metainfo    varchar(4096)          null
)
    engine = InnoDB;

create table flavorserviceprofilebindings
(
    service_profile_id varchar(36) not null,
    flavor_id          varchar(36) not null,
    primary key (service_profile_id, flavor_id),
    constraint flavorserviceprofilebindings_ibfk_1
        foreign key (service_profile_id) references serviceprofiles (id)
            on delete cascade,
    constraint flavorserviceprofilebindings_ibfk_2
        foreign key (flavor_id) references flavors (id)
            on delete cascade
)
    engine = InnoDB;

create table standardattributes
(
    id              bigint auto_increment
        primary key,
    resource_type   varchar(255)       not null,
    created_at      datetime           null,
    updated_at      datetime           null,
    description     varchar(255)       null,
    revision_number bigint default '0' not null
)
    engine = InnoDB;

create table networks
(
    project_id              varchar(255) null,
    id                      varchar(36)  not null
        primary key,
    name                    varchar(255) null,
    status                  varchar(16)  null,
    admin_state_up          tinyint(1)   null,
    vlan_transparent        tinyint(1)   null,
    standard_attr_id        bigint       not null,
    availability_zone_hints varchar(255) null,
    constraint uniq_networks0standard_attr_id
        unique (standard_attr_id),
    constraint networks_ibfk_1
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create table bgp_speaker_network_bindings
(
    bgp_speaker_id varchar(36) not null,
    network_id     varchar(36) not null,
    ip_version     int         not null,
    primary key (network_id, bgp_speaker_id, ip_version),
    constraint bgp_speaker_network_bindings_ibfk_1
        foreign key (bgp_speaker_id) references bgp_speakers (id)
            on delete cascade,
    constraint bgp_speaker_network_bindings_ibfk_2
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create index bgp_speaker_id
    on bgp_speaker_network_bindings (bgp_speaker_id);

create table cisco_ml2_n1kv_network_bindings
(
    network_id      varchar(36) not null
        primary key,
    network_type    varchar(32) not null,
    segmentation_id int         null,
    profile_id      varchar(36) not null,
    constraint cisco_ml2_n1kv_network_bindings_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade,
    constraint cisco_ml2_n1kv_network_bindings_ibfk_2
        foreign key (profile_id) references cisco_ml2_n1kv_network_profiles (id)
)
    engine = InnoDB;

create index profile_id
    on cisco_ml2_n1kv_network_bindings (profile_id);

create table externalnetworks
(
    network_id varchar(36)            not null
        primary key,
    is_default tinyint(1) default '0' not null,
    constraint externalnetworks_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create table ha_router_networks
(
    project_id varchar(255) not null,
    network_id varchar(36)  not null,
    primary key (project_id, network_id),
    constraint ha_router_networks_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create index network_id
    on ha_router_networks (network_id);

create table ha_router_vrid_allocations
(
    network_id varchar(36) not null,
    vr_id      int auto_increment,
    primary key (network_id, vr_id),
    constraint ha_router_vrid_allocations_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create index idx_autoinc_vr_id
    on ha_router_vrid_allocations (vr_id);

create table multi_provider_networks
(
    network_id varchar(36) not null
        primary key,
    constraint multi_provider_networks_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create table networkdhcpagentbindings
(
    network_id    varchar(36) not null,
    dhcp_agent_id varchar(36) not null,
    primary key (network_id, dhcp_agent_id),
    constraint networkdhcpagentbindings_ibfk_1
        foreign key (dhcp_agent_id) references agents (id)
            on delete cascade,
    constraint networkdhcpagentbindings_ibfk_2
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create index dhcp_agent_id
    on networkdhcpagentbindings (dhcp_agent_id);

create table networkdnsdomains
(
    network_id varchar(36)  not null
        primary key,
    dns_domain varchar(255) not null,
    constraint networkdnsdomains_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create index ix_networkdnsdomains_network_id
    on networkdnsdomains (network_id);

create table networkqueuemappings
(
    network_id varchar(36) not null
        primary key,
    queue_id   varchar(36) null,
    constraint networkqueuemappings_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade,
    constraint networkqueuemappings_ibfk_2
        foreign key (queue_id) references qosqueues (id)
            on delete cascade
)
    engine = InnoDB;

create index queue_id
    on networkqueuemappings (queue_id);

create table networkrbacs
(
    id            varchar(36)  not null
        primary key,
    object_id     varchar(36)  not null,
    project_id    varchar(255) null,
    target_tenant varchar(255) not null,
    action        varchar(255) not null,
    constraint uniq_networkrbacs0tenant_target0object_id0action
        unique (action, object_id, target_tenant),
    constraint networkrbacs_ibfk_1
        foreign key (object_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create index ix_networkrbacs_project_id
    on networkrbacs (project_id);

create index object_id
    on networkrbacs (object_id);

create index ix_networks_project_id
    on networks (project_id);

create table networksecuritybindings
(
    network_id            varchar(36) not null
        primary key,
    port_security_enabled tinyint(1)  not null,
    constraint networksecuritybindings_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create table networksegments
(
    id               varchar(36)            not null
        primary key,
    network_id       varchar(36)            not null,
    network_type     varchar(32)            not null,
    physical_network varchar(64)            null,
    segmentation_id  int                    null,
    is_dynamic       tinyint(1) default '0' not null,
    segment_index    int        default '0' not null,
    standard_attr_id bigint                 not null,
    name             varchar(255)           null,
    constraint uniq_networksegments0standard_attr_id
        unique (standard_attr_id),
    constraint networksegments_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade,
    constraint networksegments_ibfk_2
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create index network_id
    on networksegments (network_id);

create table neutron_nsx_network_mappings
(
    neutron_id varchar(36) not null,
    nsx_id     varchar(36) not null,
    primary key (neutron_id, nsx_id),
    constraint neutron_nsx_network_mappings_ibfk_1
        foreign key (neutron_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create table nsxv_internal_networks
(
    network_purpose enum ('inter_edge_net') not null
        primary key,
    network_id      varchar(36)             null,
    constraint nsxv_internal_networks_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create index network_id
    on nsxv_internal_networks (network_id);

create table nsxv_spoofguard_policy_network_mappings
(
    network_id varchar(36) not null
        primary key,
    policy_id  varchar(36) not null,
    constraint nsxv_spoofguard_policy_network_mappings_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create table nsxv_tz_network_bindings
(
    network_id   varchar(36)                        not null,
    binding_type enum ('flat', 'vlan', 'portgroup') not null,
    phy_uuid     varchar(36)                        not null,
    vlan_id      int                                not null,
    primary key (network_id, binding_type, phy_uuid, vlan_id),
    constraint nsxv_tz_network_bindings_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create table nuage_provider_net_bindings
(
    network_id       varchar(36) not null
        primary key,
    network_type     varchar(32) not null,
    physical_network varchar(64) not null,
    vlan_id          int         not null,
    constraint nuage_provider_net_bindings_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create table ports
(
    project_id       varchar(255) null,
    id               varchar(36)  not null
        primary key,
    name             varchar(255) null,
    network_id       varchar(36)  not null,
    mac_address      varchar(32)  not null,
    admin_state_up   tinyint(1)   not null,
    status           varchar(16)  not null,
    device_id        varchar(255) not null,
    device_owner     varchar(255) not null,
    standard_attr_id bigint       not null,
    ip_allocation    varchar(16)  null,
    constraint uniq_ports0network_id0mac_address
        unique (network_id, mac_address),
    constraint uniq_ports0standard_attr_id
        unique (standard_attr_id),
    constraint ports_ibfk_1
        foreign key (network_id) references networks (id),
    constraint ports_ibfk_2
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create table allowedaddresspairs
(
    port_id     varchar(36) not null,
    mac_address varchar(32) not null,
    ip_address  varchar(64) not null,
    primary key (port_id, mac_address, ip_address),
    constraint allowedaddresspairs_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table cisco_hosting_devices
(
    tenant_id          varchar(255) null,
    id                 varchar(36)  not null
        primary key,
    complementary_id   varchar(36)  null,
    device_id          varchar(255) null,
    admin_state_up     tinyint(1)   not null,
    management_port_id varchar(36)  null,
    protocol_port      int          null,
    cfg_agent_id       varchar(36)  null,
    created_at         datetime     not null,
    status             varchar(16)  null,
    constraint cisco_hosting_devices_ibfk_1
        foreign key (cfg_agent_id) references agents (id),
    constraint cisco_hosting_devices_ibfk_2
        foreign key (management_port_id) references ports (id)
            on delete set null
)
    engine = InnoDB;

create index cfg_agent_id
    on cisco_hosting_devices (cfg_agent_id);

create index ix_cisco_hosting_devices_tenant_id
    on cisco_hosting_devices (tenant_id);

create index management_port_id
    on cisco_hosting_devices (management_port_id);

create table cisco_ml2_n1kv_port_bindings
(
    port_id    varchar(36) not null
        primary key,
    profile_id varchar(36) not null,
    constraint cisco_ml2_n1kv_port_bindings_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table cisco_port_mappings
(
    logical_resource_id varchar(36) not null,
    logical_port_id     varchar(36) not null,
    port_type           varchar(32) null,
    network_type        varchar(32) null,
    hosting_port_id     varchar(36) null,
    segmentation_id     int         null,
    primary key (logical_resource_id, logical_port_id),
    constraint cisco_port_mappings_ibfk_1
        foreign key (hosting_port_id) references ports (id)
            on delete cascade,
    constraint cisco_port_mappings_ibfk_2
        foreign key (logical_port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create index hosting_port_id
    on cisco_port_mappings (hosting_port_id);

create index logical_port_id
    on cisco_port_mappings (logical_port_id);

create table extradhcpopts
(
    id         varchar(36)     not null
        primary key,
    port_id    varchar(36)     not null,
    opt_name   varchar(64)     not null,
    opt_value  varchar(255)    not null,
    ip_version int default '4' not null,
    constraint uniq_extradhcpopts0portid0optname0ipversion
        unique (port_id, opt_name, ip_version),
    constraint extradhcpopts_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table maclearningstates
(
    port_id              varchar(36) not null
        primary key,
    mac_learning_enabled tinyint(1)  not null,
    constraint maclearningstates_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table ml2_distributed_port_bindings
(
    port_id     varchar(36)                    not null,
    host        varchar(255)                   not null,
    router_id   varchar(36)                    null,
    vif_type    varchar(64)                    not null,
    vif_details varchar(4095) default ''       not null,
    vnic_type   varchar(64)   default 'normal' not null,
    profile     varchar(4095) default ''       not null,
    status      varchar(16)                    not null,
    primary key (port_id, host),
    constraint ml2_distributed_port_bindings_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table ml2_port_binding_levels
(
    port_id    varchar(36)  not null,
    host       varchar(255) not null,
    level      int          not null,
    driver     varchar(64)  null,
    segment_id varchar(36)  null,
    primary key (port_id, host, level),
    constraint ml2_port_binding_levels_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade,
    constraint ml2_port_binding_levels_ibfk_2
        foreign key (segment_id) references networksegments (id)
            on delete set null
)
    engine = InnoDB;

create table ml2_port_bindings
(
    port_id     varchar(36)                    not null
        primary key,
    host        varchar(255)  default ''       not null,
    vif_type    varchar(64)                    not null,
    vnic_type   varchar(64)   default 'normal' not null,
    profile     varchar(4095) default ''       not null,
    vif_details varchar(4095) default ''       not null,
    constraint ml2_port_bindings_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table networkconnections
(
    tenant_id          varchar(255)          null,
    network_gateway_id varchar(36)           null,
    network_id         varchar(36)           null,
    segmentation_type  enum ('flat', 'vlan') null,
    segmentation_id    int                   null,
    port_id            varchar(36)           not null
        primary key,
    constraint network_gateway_id
        unique (network_gateway_id, segmentation_type, segmentation_id),
    constraint networkconnections_ibfk_1
        foreign key (network_gateway_id) references networkgateways (id)
            on delete cascade,
    constraint networkconnections_ibfk_2
        foreign key (network_id) references networks (id)
            on delete cascade,
    constraint networkconnections_ibfk_3
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create index ix_networkconnections_tenant_id
    on networkconnections (tenant_id);

create index network_id
    on networkconnections (network_id);

create table neutron_nsx_port_mappings
(
    neutron_id    varchar(36) not null
        primary key,
    nsx_port_id   varchar(36) not null,
    nsx_switch_id varchar(36) null,
    constraint neutron_nsx_port_mappings_ibfk_1
        foreign key (neutron_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table nsxv_port_index_mappings
(
    port_id   varchar(36)  not null
        primary key,
    device_id varchar(255) not null,
    `index`   int          not null,
    constraint device_id
        unique (device_id, `index`),
    constraint nsxv_port_index_mappings_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table nsxv_port_vnic_mappings
(
    neutron_id varchar(36) not null,
    nsx_id     varchar(42) not null,
    primary key (neutron_id, nsx_id),
    constraint nsxv_port_vnic_mappings_ibfk_1
        foreign key (neutron_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table portbindingports
(
    port_id varchar(36)  not null
        primary key,
    host    varchar(255) not null,
    constraint portbindingports_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table portdnses
(
    port_id             varchar(36)  not null
        primary key,
    current_dns_name    varchar(255) not null,
    current_dns_domain  varchar(255) not null,
    previous_dns_name   varchar(255) not null,
    previous_dns_domain varchar(255) not null,
    dns_name            varchar(255) not null,
    constraint portdnses_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create index ix_portdnses_port_id
    on portdnses (port_id);

create table portqueuemappings
(
    port_id  varchar(36) not null,
    queue_id varchar(36) not null,
    primary key (port_id, queue_id),
    constraint portqueuemappings_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade,
    constraint portqueuemappings_ibfk_2
        foreign key (queue_id) references qosqueues (id)
)
    engine = InnoDB;

create index queue_id
    on portqueuemappings (queue_id);

create index ix_ports_device_id
    on ports (device_id);

create index ix_ports_network_id_device_owner
    on ports (network_id, device_owner);

create index ix_ports_network_id_mac_address
    on ports (network_id, mac_address);

create index ix_ports_project_id
    on ports (project_id);

create table portsecuritybindings
(
    port_id               varchar(36) not null
        primary key,
    port_security_enabled tinyint(1)  not null,
    constraint portsecuritybindings_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table provisioningblocks
(
    standard_attr_id bigint       not null,
    entity           varchar(255) not null,
    primary key (standard_attr_id, entity),
    constraint provisioningblocks_ibfk_1
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create table qos_policies
(
    id               varchar(36)  not null
        primary key,
    name             varchar(255) null,
    project_id       varchar(255) null,
    standard_attr_id bigint       not null,
    constraint uniq_qos_policies0standard_attr_id
        unique (standard_attr_id),
    constraint qos_policies_ibfk_1
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create table qos_bandwidth_limit_rules
(
    id             varchar(36) not null
        primary key,
    qos_policy_id  varchar(36) not null,
    max_kbps       int         null,
    max_burst_kbps int         null,
    constraint qos_policy_id
        unique (qos_policy_id),
    constraint qos_bandwidth_limit_rules_ibfk_1
        foreign key (qos_policy_id) references qos_policies (id)
            on delete cascade
)
    engine = InnoDB;

create table qos_dscp_marking_rules
(
    id            varchar(36) not null
        primary key,
    qos_policy_id varchar(36) not null,
    dscp_mark     int         null,
    constraint qos_policy_id
        unique (qos_policy_id),
    constraint qos_dscp_marking_rules_ibfk_1
        foreign key (qos_policy_id) references qos_policies (id)
            on delete cascade
)
    engine = InnoDB;

create table qos_minimum_bandwidth_rules
(
    id            varchar(36)                                 not null
        primary key,
    qos_policy_id varchar(36)                                 not null,
    min_kbps      int                                         null,
    direction     enum ('egress', 'ingress') default 'egress' not null,
    constraint qos_minimum_bandwidth_rules0qos_policy_id0direction
        unique (qos_policy_id, direction),
    constraint qos_minimum_bandwidth_rules_ibfk_1
        foreign key (qos_policy_id) references qos_policies (id)
            on delete cascade
)
    engine = InnoDB;

create index ix_qos_minimum_bandwidth_rules_qos_policy_id
    on qos_minimum_bandwidth_rules (qos_policy_id);

create table qos_network_policy_bindings
(
    policy_id  varchar(36) not null,
    network_id varchar(36) not null,
    constraint network_id
        unique (network_id),
    constraint qos_network_policy_bindings_ibfk_1
        foreign key (policy_id) references qos_policies (id)
            on delete cascade,
    constraint qos_network_policy_bindings_ibfk_2
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create index policy_id
    on qos_network_policy_bindings (policy_id);

create index ix_qos_policies_project_id
    on qos_policies (project_id);

create table qos_port_policy_bindings
(
    policy_id varchar(36) not null,
    port_id   varchar(36) not null,
    constraint port_id
        unique (port_id),
    constraint qos_port_policy_bindings_ibfk_1
        foreign key (policy_id) references qos_policies (id)
            on delete cascade,
    constraint qos_port_policy_bindings_ibfk_2
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create index policy_id
    on qos_port_policy_bindings (policy_id);

create table qospolicyrbacs
(
    id            varchar(36)  not null
        primary key,
    project_id    varchar(255) null,
    target_tenant varchar(255) not null,
    action        varchar(255) not null,
    object_id     varchar(36)  not null,
    constraint target_tenant
        unique (target_tenant, object_id, action),
    constraint qospolicyrbacs_ibfk_1
        foreign key (object_id) references qos_policies (id)
            on delete cascade
)
    engine = InnoDB;

create index ix_qospolicyrbacs_project_id
    on qospolicyrbacs (project_id);

create index object_id
    on qospolicyrbacs (object_id);

create table routers
(
    project_id       varchar(255)           null,
    id               varchar(36)            not null
        primary key,
    name             varchar(255)           null,
    status           varchar(16)            null,
    admin_state_up   tinyint(1)             null,
    gw_port_id       varchar(36)            null,
    enable_snat      tinyint(1) default '1' not null,
    standard_attr_id bigint                 not null,
    flavor_id        varchar(36)            null,
    constraint uniq_routers0standard_attr_id
        unique (standard_attr_id),
    constraint routers_ibfk_1
        foreign key (gw_port_id) references ports (id),
    constraint routers_ibfk_2
        foreign key (flavor_id) references flavors (id),
    constraint routers_ibfk_3
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create table auto_allocated_topologies
(
    project_id varchar(255) not null
        primary key,
    network_id varchar(36)  not null,
    router_id  varchar(36)  null,
    constraint auto_allocated_topologies_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade,
    constraint auto_allocated_topologies_ibfk_2
        foreign key (router_id) references routers (id)
            on delete set null
)
    engine = InnoDB;

create index network_id
    on auto_allocated_topologies (network_id);

create index router_id
    on auto_allocated_topologies (router_id);

create table cisco_ml2_apic_contracts
(
    tenant_id varchar(255) null,
    router_id varchar(36)  not null
        primary key,
    constraint cisco_ml2_apic_contracts_ibfk_1
        foreign key (router_id) references routers (id)
)
    engine = InnoDB;

create index ix_cisco_ml2_apic_contracts_tenant_id
    on cisco_ml2_apic_contracts (tenant_id);

create table cisco_router_mappings
(
    router_id         varchar(36) not null
        primary key,
    auto_schedule     tinyint(1)  not null,
    hosting_device_id varchar(36) null,
    constraint cisco_router_mappings_ibfk_1
        foreign key (hosting_device_id) references cisco_hosting_devices (id)
            on delete set null,
    constraint cisco_router_mappings_ibfk_2
        foreign key (router_id) references routers (id)
            on delete cascade
)
    engine = InnoDB;

create index hosting_device_id
    on cisco_router_mappings (hosting_device_id);

create table floatingips
(
    project_id           varchar(255) null,
    id                   varchar(36)  not null
        primary key,
    floating_ip_address  varchar(64)  not null,
    floating_network_id  varchar(36)  not null,
    floating_port_id     varchar(36)  not null,
    fixed_port_id        varchar(36)  null,
    fixed_ip_address     varchar(64)  null,
    router_id            varchar(36)  null,
    last_known_router_id varchar(36)  null,
    status               varchar(16)  null,
    standard_attr_id     bigint       not null,
    constraint uniq_floatingips0floatingnetworkid0fixedportid0fixedipaddress
        unique (floating_network_id, fixed_port_id, fixed_ip_address),
    constraint uniq_floatingips0standard_attr_id
        unique (standard_attr_id),
    constraint floatingips_ibfk_1
        foreign key (fixed_port_id) references ports (id),
    constraint floatingips_ibfk_2
        foreign key (floating_port_id) references ports (id)
            on delete cascade,
    constraint floatingips_ibfk_3
        foreign key (router_id) references routers (id),
    constraint floatingips_ibfk_4
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create table floatingipdnses
(
    floatingip_id        varchar(36)  not null
        primary key,
    dns_name             varchar(255) not null,
    dns_domain           varchar(255) not null,
    published_dns_name   varchar(255) not null,
    published_dns_domain varchar(255) not null,
    constraint floatingipdnses_ibfk_1
        foreign key (floatingip_id) references floatingips (id)
            on delete cascade
)
    engine = InnoDB;

create index ix_floatingipdnses_floatingip_id
    on floatingipdnses (floatingip_id);

create index fixed_port_id
    on floatingips (fixed_port_id);

create index floating_port_id
    on floatingips (floating_port_id);

create index ix_floatingips_project_id
    on floatingips (project_id);

create index router_id
    on floatingips (router_id);

create table ha_router_agent_port_bindings
(
    port_id     varchar(36)                                  not null
        primary key,
    router_id   varchar(36)                                  not null,
    l3_agent_id varchar(36)                                  null,
    state       enum ('active', 'standby') default 'standby' null,
    constraint uniq_ha_router_agent_port_bindings0port_id0l3_agent_id
        unique (router_id, l3_agent_id),
    constraint ha_router_agent_port_bindings_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade,
    constraint ha_router_agent_port_bindings_ibfk_2
        foreign key (router_id) references routers (id)
            on delete cascade,
    constraint ha_router_agent_port_bindings_ibfk_3
        foreign key (l3_agent_id) references agents (id)
            on delete cascade
)
    engine = InnoDB;

create index l3_agent_id
    on ha_router_agent_port_bindings (l3_agent_id);

create table neutron_nsx_router_mappings
(
    neutron_id varchar(36) not null
        primary key,
    nsx_id     varchar(36) null,
    constraint neutron_nsx_router_mappings_ibfk_1
        foreign key (neutron_id) references routers (id)
            on delete cascade
)
    engine = InnoDB;

create table nsxv_router_ext_attributes
(
    router_id      varchar(36)                  not null
        primary key,
    distributed    tinyint(1)                   not null,
    router_type    enum ('shared', 'exclusive') not null,
    service_router tinyint(1)                   not null,
    constraint nsxv_router_ext_attributes_ibfk_1
        foreign key (router_id) references routers (id)
            on delete cascade
)
    engine = InnoDB;

create table nuage_net_partition_router_mapping
(
    net_partition_id varchar(36) not null,
    router_id        varchar(36) not null,
    nuage_router_id  varchar(36) null,
    nuage_rtr_rd     varchar(36) null,
    nuage_rtr_rt     varchar(36) null,
    primary key (net_partition_id, router_id),
    constraint nuage_router_id
        unique (nuage_router_id),
    constraint nuage_net_partition_router_mapping_ibfk_1
        foreign key (net_partition_id) references nuage_net_partitions (id)
            on delete cascade,
    constraint nuage_net_partition_router_mapping_ibfk_2
        foreign key (router_id) references routers (id)
            on delete cascade
)
    engine = InnoDB;

create index router_id
    on nuage_net_partition_router_mapping (router_id);

create table router_extra_attributes
(
    router_id               varchar(36)            not null
        primary key,
    distributed             tinyint(1) default '0' not null,
    service_router          tinyint(1) default '0' not null,
    ha                      tinyint(1) default '0' not null,
    ha_vr_id                int                    null,
    availability_zone_hints varchar(255)           null,
    constraint router_extra_attributes_ibfk_1
        foreign key (router_id) references routers (id)
            on delete cascade
)
    engine = InnoDB;

create table routerl3agentbindings
(
    router_id     varchar(36)     not null,
    l3_agent_id   varchar(36)     not null,
    binding_index int default '1' not null,
    primary key (router_id, l3_agent_id),
    constraint uniq_router_l3_agent_binding0router_id0binding_index0
        unique (router_id, binding_index),
    constraint routerl3agentbindings_ibfk_1
        foreign key (l3_agent_id) references agents (id)
            on delete cascade,
    constraint routerl3agentbindings_ibfk_2
        foreign key (router_id) references routers (id)
            on delete cascade
)
    engine = InnoDB;

create index l3_agent_id
    on routerl3agentbindings (l3_agent_id);

create table routerports
(
    router_id varchar(36)  not null,
    port_id   varchar(36)  not null,
    port_type varchar(255) null,
    primary key (router_id, port_id),
    constraint uniq_routerports0port_id
        unique (port_id),
    constraint routerports_ibfk_1
        foreign key (router_id) references routers (id)
            on delete cascade,
    constraint routerports_ibfk_2
        foreign key (port_id) references ports (id)
            on delete cascade
)
    engine = InnoDB;

create table routerroutes
(
    destination varchar(64) not null,
    nexthop     varchar(64) not null,
    router_id   varchar(36) not null,
    primary key (destination, nexthop, router_id),
    constraint routerroutes_ibfk_1
        foreign key (router_id) references routers (id)
            on delete cascade
)
    engine = InnoDB;

create index router_id
    on routerroutes (router_id);

create table routerrules
(
    id          int auto_increment
        primary key,
    source      varchar(64) not null,
    destination varchar(64) not null,
    action      varchar(10) not null,
    router_id   varchar(36) null,
    constraint routerrules_ibfk_1
        foreign key (router_id) references routers (id)
            on delete cascade
)
    engine = InnoDB;

create table nexthops
(
    rule_id int         not null,
    nexthop varchar(64) not null,
    primary key (rule_id, nexthop),
    constraint nexthops_ibfk_1
        foreign key (rule_id) references routerrules (id)
            on delete cascade
)
    engine = InnoDB;

create index router_id
    on routerrules (router_id);

create index flavor_id
    on routers (flavor_id);

create index gw_port_id
    on routers (gw_port_id);

create index ix_routers_project_id
    on routers (project_id);

create table securitygroups
(
    project_id       varchar(255) null,
    id               varchar(36)  not null
        primary key,
    name             varchar(255) null,
    standard_attr_id bigint       not null,
    constraint uniq_securitygroups0standard_attr_id
        unique (standard_attr_id),
    constraint securitygroups_ibfk_1
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create table default_security_group
(
    project_id        varchar(255) not null
        primary key,
    security_group_id varchar(36)  not null,
    constraint default_security_group_ibfk_1
        foreign key (security_group_id) references securitygroups (id)
            on delete cascade
)
    engine = InnoDB;

create index security_group_id
    on default_security_group (security_group_id);

create table neutron_nsx_security_group_mappings
(
    neutron_id varchar(36) not null,
    nsx_id     varchar(36) not null,
    primary key (neutron_id, nsx_id),
    constraint neutron_nsx_security_group_mappings_ibfk_1
        foreign key (neutron_id) references securitygroups (id)
            on delete cascade
)
    engine = InnoDB;

create table nsxv_security_group_section_mappings
(
    neutron_id    varchar(36)  not null
        primary key,
    ip_section_id varchar(100) null,
    constraint nsxv_security_group_section_mappings_ibfk_1
        foreign key (neutron_id) references securitygroups (id)
            on delete cascade
)
    engine = InnoDB;

create table securitygroupportbindings
(
    port_id           varchar(36) not null,
    security_group_id varchar(36) not null,
    primary key (port_id, security_group_id),
    constraint securitygroupportbindings_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade,
    constraint securitygroupportbindings_ibfk_2
        foreign key (security_group_id) references securitygroups (id)
)
    engine = InnoDB;

create index security_group_id
    on securitygroupportbindings (security_group_id);

create table securitygrouprules
(
    project_id        varchar(255)               null,
    id                varchar(36)                not null
        primary key,
    security_group_id varchar(36)                not null,
    remote_group_id   varchar(36)                null,
    direction         enum ('ingress', 'egress') null,
    ethertype         varchar(40)                null,
    protocol          varchar(40)                null,
    port_range_min    int                        null,
    port_range_max    int                        null,
    remote_ip_prefix  varchar(255)               null,
    standard_attr_id  bigint                     not null,
    constraint uniq_securitygrouprules0standard_attr_id
        unique (standard_attr_id),
    constraint securitygrouprules_ibfk_1
        foreign key (security_group_id) references securitygroups (id)
            on delete cascade,
    constraint securitygrouprules_ibfk_2
        foreign key (remote_group_id) references securitygroups (id)
            on delete cascade,
    constraint securitygrouprules_ibfk_3
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create table nsxv_rule_mappings
(
    neutron_id  varchar(36) not null,
    nsx_rule_id varchar(36) not null,
    primary key (neutron_id, nsx_rule_id),
    constraint nsxv_rule_mappings_ibfk_1
        foreign key (neutron_id) references securitygrouprules (id)
            on delete cascade
)
    engine = InnoDB;

create index ix_securitygrouprules_project_id
    on securitygrouprules (project_id);

create index remote_group_id
    on securitygrouprules (remote_group_id);

create index security_group_id
    on securitygrouprules (security_group_id);

create index ix_securitygroups_project_id
    on securitygroups (project_id);

create table segmenthostmappings
(
    segment_id varchar(36)  not null,
    host       varchar(255) not null,
    primary key (segment_id, host),
    constraint segmenthostmappings_ibfk_1
        foreign key (segment_id) references networksegments (id)
            on delete cascade
)
    engine = InnoDB;

create index ix_segmenthostmappings_host
    on segmenthostmappings (host);

create index ix_segmenthostmappings_segment_id
    on segmenthostmappings (segment_id);

create table subnetpools
(
    project_id        varchar(255)            null,
    id                varchar(36)             not null
        primary key,
    name              varchar(255)            null,
    ip_version        int                     not null,
    default_prefixlen int                     not null,
    min_prefixlen     int                     not null,
    max_prefixlen     int                     not null,
    shared            tinyint(1)              not null,
    default_quota     int                     null,
    hash              varchar(36) default ''  not null,
    address_scope_id  varchar(36)             null,
    is_default        tinyint(1)  default '0' not null,
    standard_attr_id  bigint                  not null,
    constraint uniq_subnetpools0standard_attr_id
        unique (standard_attr_id),
    constraint subnetpools_ibfk_1
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create table subnetpoolprefixes
(
    cidr          varchar(64) not null,
    subnetpool_id varchar(36) not null,
    primary key (cidr, subnetpool_id),
    constraint subnetpoolprefixes_ibfk_1
        foreign key (subnetpool_id) references subnetpools (id)
            on delete cascade
)
    engine = InnoDB;

create index subnetpool_id
    on subnetpoolprefixes (subnetpool_id);

create index ix_subnetpools_project_id
    on subnetpools (project_id);

create table subnets
(
    project_id        varchar(255)                                          null,
    id                varchar(36)                                           not null
        primary key,
    name              varchar(255)                                          null,
    network_id        varchar(36)                                           null,
    ip_version        int                                                   not null,
    cidr              varchar(64)                                           not null,
    gateway_ip        varchar(64)                                           null,
    enable_dhcp       tinyint(1)                                            null,
    ipv6_ra_mode      enum ('slaac', 'dhcpv6-stateful', 'dhcpv6-stateless') null,
    ipv6_address_mode enum ('slaac', 'dhcpv6-stateful', 'dhcpv6-stateless') null,
    subnetpool_id     varchar(36)                                           null,
    standard_attr_id  bigint                                                not null,
    segment_id        varchar(36)                                           null,
    constraint uniq_subnets0standard_attr_id
        unique (standard_attr_id),
    constraint subnets_ibfk_1
        foreign key (network_id) references networks (id),
    constraint subnets_ibfk_2
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade,
    constraint subnets_ibfk_3
        foreign key (segment_id) references networksegments (id)
)
    engine = InnoDB;

create table dnsnameservers
(
    address   varchar(128)    not null,
    subnet_id varchar(36)     not null,
    `order`   int default '0' not null,
    primary key (address, subnet_id),
    constraint dnsnameservers_ibfk_1
        foreign key (subnet_id) references subnets (id)
            on delete cascade
)
    engine = InnoDB;

create index subnet_id
    on dnsnameservers (subnet_id);

create table ipallocationpools
(
    id        varchar(36) not null
        primary key,
    subnet_id varchar(36) null,
    first_ip  varchar(64) not null,
    last_ip   varchar(64) not null,
    constraint ipallocationpools_ibfk_1
        foreign key (subnet_id) references subnets (id)
            on delete cascade
)
    engine = InnoDB;

create index subnet_id
    on ipallocationpools (subnet_id);

create table ipallocations
(
    port_id    varchar(36) null,
    ip_address varchar(64) not null,
    subnet_id  varchar(36) not null,
    network_id varchar(36) not null,
    primary key (ip_address, subnet_id, network_id),
    constraint ipallocations_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade,
    constraint ipallocations_ibfk_2
        foreign key (port_id) references ports (id)
            on delete cascade,
    constraint ipallocations_ibfk_3
        foreign key (subnet_id) references subnets (id)
            on delete cascade
)
    engine = InnoDB;

create index network_id
    on ipallocations (network_id);

create index port_id
    on ipallocations (port_id);

create index subnet_id
    on ipallocations (subnet_id);

create table nuage_subnet_l2dom_mapping
(
    subnet_id            varchar(36) not null
        primary key,
    net_partition_id     varchar(36) null,
    nuage_subnet_id      varchar(36) null,
    nuage_l2dom_tmplt_id varchar(36) null,
    nuage_user_id        varchar(36) null,
    nuage_group_id       varchar(36) null,
    nuage_managed_subnet tinyint(1)  null,
    constraint nuage_subnet_id
        unique (nuage_subnet_id),
    constraint nuage_subnet_l2dom_mapping_ibfk_1
        foreign key (subnet_id) references subnets (id)
            on delete cascade,
    constraint nuage_subnet_l2dom_mapping_ibfk_2
        foreign key (net_partition_id) references nuage_net_partitions (id)
            on delete cascade
)
    engine = InnoDB;

create index net_partition_id
    on nuage_subnet_l2dom_mapping (net_partition_id);

create table subnet_service_types
(
    subnet_id    varchar(36)  not null,
    service_type varchar(255) not null,
    primary key (subnet_id, service_type),
    constraint subnet_service_types_ibfk_1
        foreign key (subnet_id) references subnets (id)
            on delete cascade
)
    engine = InnoDB;

create table subnetroutes
(
    destination varchar(64) not null,
    nexthop     varchar(64) not null,
    subnet_id   varchar(36) not null,
    primary key (destination, nexthop, subnet_id),
    constraint subnetroutes_ibfk_1
        foreign key (subnet_id) references subnets (id)
            on delete cascade
)
    engine = InnoDB;

create index subnet_id
    on subnetroutes (subnet_id);

create index ix_subnets_project_id
    on subnets (project_id);

create index ix_subnets_subnetpool_id
    on subnets (subnetpool_id);

create index network_id
    on subnets (network_id);

create index segment_id
    on subnets (segment_id);

create table tags
(
    standard_attr_id bigint      not null,
    tag              varchar(60) not null,
    primary key (standard_attr_id, tag),
    constraint tags_ibfk_1
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create table trunks
(
    admin_state_up   tinyint(1)  default '1'      not null,
    project_id       varchar(255)                 null,
    id               varchar(36)                  not null
        primary key,
    name             varchar(255)                 null,
    port_id          varchar(36)                  not null,
    status           varchar(16) default 'ACTIVE' not null,
    standard_attr_id bigint                       not null,
    constraint port_id
        unique (port_id),
    constraint standard_attr_id
        unique (standard_attr_id),
    constraint trunks_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade,
    constraint trunks_ibfk_2
        foreign key (standard_attr_id) references standardattributes (id)
            on delete cascade
)
    engine = InnoDB;

create table subports
(
    port_id           varchar(36) not null
        primary key,
    trunk_id          varchar(36) not null,
    segmentation_type varchar(32) not null,
    segmentation_id   int         not null,
    constraint uniq_subport0trunk_id0segmentation_type0segmentation_id
        unique (trunk_id, segmentation_type, segmentation_id),
    constraint subports_ibfk_1
        foreign key (port_id) references ports (id)
            on delete cascade,
    constraint subports_ibfk_2
        foreign key (trunk_id) references trunks (id)
            on delete cascade
)
    engine = InnoDB;

create index ix_trunks_project_id
    on trunks (project_id);

create table tz_network_bindings
(
    network_id   varchar(36)                                   not null,
    binding_type enum ('flat', 'vlan', 'stt', 'gre', 'l3_ext') not null,
    phy_uuid     varchar(36)                                   not null,
    vlan_id      int                                           not null,
    primary key (network_id, binding_type, phy_uuid, vlan_id),
    constraint tz_network_bindings_ibfk_1
        foreign key (network_id) references networks (id)
            on delete cascade
)
    engine = InnoDB;

create table vcns_router_bindings
(
    status             varchar(16)  not null,
    status_description varchar(255) null,
    router_id          varchar(36)  not null
        primary key,
    edge_id            varchar(16)  null,
    lswitch_id         varchar(36)  not null
)
    engine = InnoDB;

create table vips
(
    tenant_id          varchar(255)                  null,
    id                 varchar(36)                   not null
        primary key,
    status             varchar(16)                   not null,
    status_description varchar(255)                  null,
    name               varchar(255)                  null,
    description        varchar(255)                  null,
    port_id            varchar(36)                   null,
    protocol_port      int                           not null,
    protocol           enum ('HTTP', 'HTTPS', 'TCP') not null,
    pool_id            varchar(36)                   not null,
    admin_state_up     tinyint(1)                    not null,
    connection_limit   int                           null,
    constraint pool_id
        unique (pool_id),
    constraint vips_ibfk_1
        foreign key (port_id) references ports (id)
)
    engine = InnoDB;

create table pools
(
    tenant_id          varchar(255)                                           null,
    id                 varchar(36)                                            not null
        primary key,
    status             varchar(16)                                            not null,
    status_description varchar(255)                                           null,
    vip_id             varchar(36)                                            null,
    name               varchar(255)                                           null,
    description        varchar(255)                                           null,
    subnet_id          varchar(36)                                            not null,
    protocol           enum ('HTTP', 'HTTPS', 'TCP')                          not null,
    lb_method          enum ('ROUND_ROBIN', 'LEAST_CONNECTIONS', 'SOURCE_IP') not null,
    admin_state_up     tinyint(1)                                             not null,
    constraint pools_ibfk_1
        foreign key (vip_id) references vips (id)
)
    engine = InnoDB;

create table members
(
    tenant_id          varchar(255) null,
    id                 varchar(36)  not null
        primary key,
    status             varchar(16)  not null,
    status_description varchar(255) null,
    pool_id            varchar(36)  not null,
    address            varchar(64)  not null,
    protocol_port      int          not null,
    weight             int          not null,
    admin_state_up     tinyint(1)   not null,
    constraint uniq_member0pool_id0address0port
        unique (pool_id, address, protocol_port),
    constraint members_ibfk_1
        foreign key (pool_id) references pools (id)
)
    engine = InnoDB;

create table poolloadbalanceragentbindings
(
    pool_id  varchar(36) not null
        primary key,
    agent_id varchar(36) not null,
    constraint poolloadbalanceragentbindings_ibfk_1
        foreign key (pool_id) references pools (id)
            on delete cascade,
    constraint poolloadbalanceragentbindings_ibfk_2
        foreign key (agent_id) references agents (id)
            on delete cascade
)
    engine = InnoDB;

create index agent_id
    on poolloadbalanceragentbindings (agent_id);

create table poolmonitorassociations
(
    status             varchar(16)  not null,
    status_description varchar(255) null,
    pool_id            varchar(36)  not null,
    monitor_id         varchar(36)  not null,
    primary key (pool_id, monitor_id),
    constraint poolmonitorassociations_ibfk_1
        foreign key (pool_id) references pools (id),
    constraint poolmonitorassociations_ibfk_2
        foreign key (monitor_id) references healthmonitors (id)
)
    engine = InnoDB;

create index monitor_id
    on poolmonitorassociations (monitor_id);

create index vip_id
    on pools (vip_id);

create table poolstatisticss
(
    pool_id            varchar(36) not null
        primary key,
    bytes_in           bigint      not null,
    bytes_out          bigint      not null,
    active_connections bigint      not null,
    total_connections  bigint      not null,
    constraint poolstatisticss_ibfk_1
        foreign key (pool_id) references pools (id)
)
    engine = InnoDB;

create table sessionpersistences
(
    vip_id      varchar(36)                                     not null
        primary key,
    type        enum ('SOURCE_IP', 'HTTP_COOKIE', 'APP_COOKIE') not null,
    cookie_name varchar(1024)                                   null,
    constraint sessionpersistences_ibfk_1
        foreign key (vip_id) references vips (id)
)
    engine = InnoDB;

create index port_id
    on vips (port_id);

create table vpnservices
(
    tenant_id      varchar(255) null,
    id             varchar(36)  not null
        primary key,
    name           varchar(255) null,
    description    varchar(255) null,
    status         varchar(16)  not null,
    admin_state_up tinyint(1)   not null,
    subnet_id      varchar(36)  not null,
    router_id      varchar(36)  not null,
    constraint vpnservices_ibfk_1
        foreign key (subnet_id) references subnets (id),
    constraint vpnservices_ibfk_2
        foreign key (router_id) references routers (id)
)
    engine = InnoDB;

create table ipsec_site_connections
(
    tenant_id      varchar(255)                                                     null,
    id             varchar(36)                                                      not null
        primary key,
    name           varchar(255)                                                     null,
    description    varchar(255)                                                     null,
    peer_address   varchar(255)                                                     not null,
    peer_id        varchar(255)                                                     not null,
    route_mode     varchar(8)                                                       not null,
    mtu            int                                                              not null,
    initiator      enum ('bi-directional', 'response-only')                         not null,
    auth_mode      varchar(16)                                                      not null,
    psk            varchar(255)                                                     not null,
    dpd_action     enum ('hold', 'clear', 'restart', 'disabled', 'restart-by-peer') not null,
    dpd_interval   int                                                              not null,
    dpd_timeout    int                                                              not null,
    status         varchar(16)                                                      not null,
    admin_state_up tinyint(1)                                                       not null,
    vpnservice_id  varchar(36)                                                      not null,
    ipsecpolicy_id varchar(36)                                                      not null,
    ikepolicy_id   varchar(36)                                                      not null,
    constraint ipsec_site_connections_ibfk_1
        foreign key (vpnservice_id) references vpnservices (id),
    constraint ipsec_site_connections_ibfk_2
        foreign key (ipsecpolicy_id) references ipsecpolicies (id),
    constraint ipsec_site_connections_ibfk_3
        foreign key (ikepolicy_id) references ikepolicies (id)
)
    engine = InnoDB;

create table cisco_csr_identifier_map
(
    tenant_id           varchar(255) null,
    ipsec_site_conn_id  varchar(36)  not null
        primary key,
    csr_tunnel_id       int          not null,
    csr_ike_policy_id   int          not null,
    csr_ipsec_policy_id int          not null,
    constraint cisco_csr_identifier_map_ibfk_1
        foreign key (ipsec_site_conn_id) references ipsec_site_connections (id)
            on delete cascade
)
    engine = InnoDB;

create index ikepolicy_id
    on ipsec_site_connections (ikepolicy_id);

create index ipsecpolicy_id
    on ipsec_site_connections (ipsecpolicy_id);

create index vpnservice_id
    on ipsec_site_connections (vpnservice_id);

create table ipsecpeercidrs
(
    cidr                     varchar(32) not null,
    ipsec_site_connection_id varchar(36) not null,
    primary key (cidr, ipsec_site_connection_id),
    constraint ipsecpeercidrs_ibfk_1
        foreign key (ipsec_site_connection_id) references ipsec_site_connections (id)
            on delete cascade
)
    engine = InnoDB;

create index ipsec_site_connection_id
    on ipsecpeercidrs (ipsec_site_connection_id);

create index router_id
    on vpnservices (router_id);

create index subnet_id
    on vpnservices (subnet_id);

