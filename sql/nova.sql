create table agent_builds
(
    created_at   datetime     null,
    updated_at   datetime     null,
    deleted_at   datetime     null,
    id           int auto_increment
        primary key,
    hypervisor   varchar(255) null,
    os           varchar(255) null,
    architecture varchar(255) null,
    version      varchar(255) null,
    url          varchar(255) null,
    md5hash      varchar(255) null,
    deleted      int          null,
    constraint uniq_agent_builds0hypervisor0os0architecture0deleted
        unique (hypervisor, os, architecture, deleted)
);

create index agent_builds_hypervisor_os_arch_idx
    on agent_builds (hypervisor, os, architecture);

create table aggregates
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    id         int auto_increment
        primary key,
    name       varchar(255) null,
    deleted    int          null,
    uuid       varchar(36)  null
);

create table aggregate_hosts
(
    created_at   datetime     null,
    updated_at   datetime     null,
    deleted_at   datetime     null,
    id           int auto_increment
        primary key,
    host         varchar(255) null,
    aggregate_id int          not null,
    deleted      int          null,
    constraint uniq_aggregate_hosts0host0aggregate_id0deleted
        unique (host, aggregate_id, deleted),
    constraint aggregate_hosts_ibfk_1
        foreign key (aggregate_id) references aggregates (id)
);

create index aggregate_id
    on aggregate_hosts (aggregate_id);

create table aggregate_metadata
(
    created_at   datetime     null,
    updated_at   datetime     null,
    deleted_at   datetime     null,
    id           int auto_increment
        primary key,
    aggregate_id int          not null,
    `key`        varchar(255) not null,
    value        varchar(255) not null,
    deleted      int          null,
    constraint uniq_aggregate_metadata0aggregate_id0key0deleted
        unique (aggregate_id, `key`, deleted),
    constraint aggregate_metadata_ibfk_1
        foreign key (aggregate_id) references aggregates (id)
);

create index aggregate_metadata_key_idx
    on aggregate_metadata (`key`);

create index aggregate_uuid_idx
    on aggregates (uuid);

create table allocations
(
    id                   int auto_increment
        primary key,
    resource_provider_id int         not null,
    consumer_id          varchar(36) not null,
    resource_class_id    int         not null,
    used                 int         not null
)
    charset = latin1;

create index allocations_consumer_id_idx
    on allocations (consumer_id);

create index allocations_resource_class_id_idx
    on allocations (resource_class_id);

create index allocations_resource_provider_class_used_idx
    on allocations (resource_provider_id, resource_class_id, used);

create table bw_usage_cache
(
    created_at     datetime     null,
    updated_at     datetime     null,
    deleted_at     datetime     null,
    id             int auto_increment
        primary key,
    start_period   datetime     not null,
    last_refreshed datetime     null,
    bw_in          bigint       null,
    bw_out         bigint       null,
    mac            varchar(255) null,
    uuid           varchar(36)  null,
    last_ctr_in    bigint       null,
    last_ctr_out   bigint       null,
    deleted        int          null
);

create index bw_usage_cache_uuid_start_period_idx
    on bw_usage_cache (uuid, start_period);

create table cells
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    api_url       varchar(255) null,
    weight_offset float        null,
    weight_scale  float        null,
    name          varchar(255) null,
    is_parent     tinyint(1)   null,
    deleted       int          null,
    transport_url varchar(255) not null,
    constraint uniq_cells0name0deleted
        unique (name, deleted)
);

create table certificates
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    id         int auto_increment
        primary key,
    user_id    varchar(255) null,
    project_id varchar(255) null,
    file_name  varchar(255) null,
    deleted    int          null
);

create index certificates_project_id_deleted_idx
    on certificates (project_id, deleted);

create index certificates_user_id_deleted_idx
    on certificates (user_id, deleted);

create table compute_nodes
(
    created_at            datetime     null,
    updated_at            datetime     null,
    deleted_at            datetime     null,
    id                    int auto_increment
        primary key,
    service_id            int          null,
    vcpus                 int          not null,
    memory_mb             int          not null,
    local_gb              int          not null,
    vcpus_used            int          not null,
    memory_mb_used        int          not null,
    local_gb_used         int          not null,
    hypervisor_type       mediumtext   not null,
    hypervisor_version    int          not null,
    cpu_info              mediumtext   not null,
    disk_available_least  int          null,
    free_ram_mb           int          null,
    free_disk_gb          int          null,
    current_workload      int          null,
    running_vms           int          null,
    hypervisor_hostname   varchar(255) null,
    deleted               int          null,
    host_ip               varchar(39)  null,
    supported_instances   text         null,
    pci_stats             text         null,
    metrics               text         null,
    extra_resources       text         null,
    stats                 text         null,
    numa_topology         text         null,
    host                  varchar(255) null,
    ram_allocation_ratio  float        null,
    cpu_allocation_ratio  float        null,
    uuid                  varchar(36)  null,
    disk_allocation_ratio float        null,
    constraint uniq_compute_nodes0host0hypervisor_hostname0deleted
        unique (host, hypervisor_hostname, deleted)
);

create table console_auth_tokens
(
    created_at           datetime     null,
    updated_at           datetime     null,
    id                   int auto_increment
        primary key,
    token_hash           varchar(255) not null,
    console_type         varchar(255) not null,
    host                 varchar(255) not null,
    port                 int          not null,
    internal_access_path varchar(255) null,
    instance_uuid        varchar(36)  not null,
    expires              int          not null,
    constraint uniq_console_auth_tokens0token_hash
        unique (token_hash)
);

create index console_auth_tokens_host_expires_idx
    on console_auth_tokens (host, expires);

create index console_auth_tokens_instance_uuid_idx
    on console_auth_tokens (instance_uuid);

create index console_auth_tokens_token_hash_idx
    on console_auth_tokens (token_hash);

create table console_pools
(
    created_at      datetime     null,
    updated_at      datetime     null,
    deleted_at      datetime     null,
    id              int auto_increment
        primary key,
    address         varchar(39)  null,
    username        varchar(255) null,
    password        varchar(255) null,
    console_type    varchar(255) null,
    public_hostname varchar(255) null,
    host            varchar(255) null,
    compute_host    varchar(255) null,
    deleted         int          null,
    constraint uniq_console_pools0host0console_type0compute_host0deleted
        unique (host, console_type, compute_host, deleted)
);

create table dns_domains
(
    created_at        datetime     null,
    updated_at        datetime     null,
    deleted_at        datetime     null,
    deleted           tinyint(1)   null,
    domain            varchar(255) not null
        primary key,
    scope             varchar(255) null,
    availability_zone varchar(255) null,
    project_id        varchar(255) null
);

create index dns_domains_domain_deleted_idx
    on dns_domains (domain, deleted);

create index dns_domains_project_id_idx
    on dns_domains (project_id);

create table floating_ips
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    address       varchar(39)  null,
    fixed_ip_id   int          null,
    project_id    varchar(255) null,
    host          varchar(255) null,
    auto_assigned tinyint(1)   null,
    pool          varchar(255) null,
    interface     varchar(255) null,
    deleted       int          null,
    constraint uniq_floating_ips0address0deleted
        unique (address, deleted)
);

create index fixed_ip_id
    on floating_ips (fixed_ip_id);

create index floating_ips_host_idx
    on floating_ips (host);

create index floating_ips_pool_deleted_fixed_ip_id_project_id_idx
    on floating_ips (pool, deleted, fixed_ip_id, project_id);

create index floating_ips_project_id_idx
    on floating_ips (project_id);

create table instance_groups
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    int          null,
    id         int auto_increment
        primary key,
    user_id    varchar(255) null,
    project_id varchar(255) null,
    uuid       varchar(36)  not null,
    name       varchar(255) null,
    constraint uniq_instance_groups0uuid0deleted
        unique (uuid, deleted)
);

create table instance_group_member
(
    created_at  datetime     null,
    updated_at  datetime     null,
    deleted_at  datetime     null,
    deleted     int          null,
    id          int auto_increment
        primary key,
    instance_id varchar(255) null,
    group_id    int          not null,
    constraint instance_group_member_ibfk_1
        foreign key (group_id) references instance_groups (id)
);

create index group_id
    on instance_group_member (group_id);

create index instance_group_member_instance_idx
    on instance_group_member (instance_id);

create table instance_group_policy
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    int          null,
    id         int auto_increment
        primary key,
    policy     varchar(255) null,
    group_id   int          not null,
    constraint instance_group_policy_ibfk_1
        foreign key (group_id) references instance_groups (id)
);

create index group_id
    on instance_group_policy (group_id);

create index instance_group_policy_policy_idx
    on instance_group_policy (policy);

create table instance_id_mappings
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    id         int auto_increment
        primary key,
    uuid       varchar(36) not null,
    deleted    int         null
);

create index ix_instance_id_mappings_uuid
    on instance_id_mappings (uuid);

create table instance_types
(
    created_at   datetime     null,
    updated_at   datetime     null,
    deleted_at   datetime     null,
    name         varchar(255) null,
    id           int auto_increment
        primary key,
    memory_mb    int          not null,
    vcpus        int          not null,
    swap         int          not null,
    vcpu_weight  int          null,
    flavorid     varchar(255) null,
    rxtx_factor  float        null,
    root_gb      int          null,
    ephemeral_gb int          null,
    disabled     tinyint(1)   null,
    is_public    tinyint(1)   null,
    deleted      int          null,
    constraint uniq_instance_types0flavorid0deleted
        unique (flavorid, deleted),
    constraint uniq_instance_types0name0deleted
        unique (name, deleted)
);

create table instance_type_extra_specs
(
    created_at       datetime     null,
    updated_at       datetime     null,
    deleted_at       datetime     null,
    id               int auto_increment
        primary key,
    instance_type_id int          not null,
    `key`            varchar(255) null,
    value            varchar(255) null,
    deleted          int          null,
    constraint uniq_instance_type_extra_specs0instance_type_id0key0deleted
        unique (instance_type_id, `key`, deleted),
    constraint instance_type_extra_specs_ibfk_1
        foreign key (instance_type_id) references instance_types (id)
)
    collate = utf8_bin;

create index instance_type_extra_specs_instance_type_id_key_idx
    on instance_type_extra_specs (instance_type_id, `key`);

create table instance_type_projects
(
    created_at       datetime     null,
    updated_at       datetime     null,
    deleted_at       datetime     null,
    id               int auto_increment
        primary key,
    instance_type_id int          not null,
    project_id       varchar(255) null,
    deleted          int          null,
    constraint uniq_instance_type_projects0instance_type_id0project_id0deleted
        unique (instance_type_id, project_id, deleted),
    constraint instance_type_projects_ibfk_1
        foreign key (instance_type_id) references instance_types (id)
);

create index instance_type_id
    on instance_type_projects (instance_type_id);

create table instances
(
    created_at               datetime                null,
    updated_at               datetime                null,
    deleted_at               datetime                null,
    id                       int auto_increment
        primary key,
    internal_id              int                     null,
    user_id                  varchar(255)            null,
    project_id               varchar(255)            null,
    image_ref                varchar(255)            null,
    kernel_id                varchar(255)            null,
    ramdisk_id               varchar(255)            null,
    launch_index             int                     null,
    key_name                 varchar(255)            null,
    key_data                 mediumtext              null,
    power_state              int                     null,
    vm_state                 varchar(255)            null,
    memory_mb                int                     null,
    vcpus                    int                     null,
    hostname                 varchar(255)            null,
    host                     varchar(255)            null,
    user_data                mediumtext              null,
    reservation_id           varchar(255)            null,
    scheduled_at             datetime                null,
    launched_at              datetime                null,
    terminated_at            datetime                null,
    display_name             varchar(255)            null,
    display_description      varchar(255)            null,
    availability_zone        varchar(255)            null,
    locked                   tinyint(1)              null,
    os_type                  varchar(255)            null,
    launched_on              mediumtext              null,
    instance_type_id         int                     null,
    vm_mode                  varchar(255)            null,
    uuid                     varchar(36)             not null,
    architecture             varchar(255)            null,
    root_device_name         varchar(255)            null,
    access_ip_v4             varchar(39)             null,
    access_ip_v6             varchar(39)             null,
    config_drive             varchar(255)            null,
    task_state               varchar(255)            null,
    default_ephemeral_device varchar(255)            null,
    default_swap_device      varchar(255)            null,
    progress                 int                     null,
    auto_disk_config         tinyint(1)              null,
    shutdown_terminate       tinyint(1)              null,
    disable_terminate        tinyint(1)              null,
    root_gb                  int                     null,
    ephemeral_gb             int                     null,
    cell_name                varchar(255)            null,
    node                     varchar(255)            null,
    deleted                  int                     null,
    locked_by                enum ('owner', 'admin') null,
    cleaned                  int                     null,
    ephemeral_key_uuid       varchar(36)             null,
    constraint uniq_instances0uuid
        unique (uuid),
    constraint uuid
        unique (uuid)
);

create table block_device_mapping
(
    created_at            datetime     null,
    updated_at            datetime     null,
    deleted_at            datetime     null,
    id                    int auto_increment
        primary key,
    device_name           varchar(255) null,
    delete_on_termination tinyint(1)   null,
    snapshot_id           varchar(36)  null,
    volume_id             varchar(36)  null,
    volume_size           int          null,
    no_device             tinyint(1)   null,
    connection_info       mediumtext   null,
    instance_uuid         varchar(36)  null,
    deleted               int          null,
    source_type           varchar(255) null,
    destination_type      varchar(255) null,
    guest_format          varchar(255) null,
    device_type           varchar(255) null,
    disk_bus              varchar(255) null,
    boot_index            int          null,
    image_id              varchar(36)  null,
    tag                   varchar(255) null,
    constraint block_device_mapping_instance_uuid_fkey
        foreign key (instance_uuid) references instances (uuid)
);

create index block_device_mapping_instance_uuid_device_name_idx
    on block_device_mapping (instance_uuid, device_name);

create index block_device_mapping_instance_uuid_idx
    on block_device_mapping (instance_uuid);

create index block_device_mapping_instance_uuid_volume_id_idx
    on block_device_mapping (instance_uuid, volume_id);

create index snapshot_id
    on block_device_mapping (snapshot_id);

create index volume_id
    on block_device_mapping (volume_id);

create table consoles
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    instance_name varchar(255) null,
    password      varchar(255) null,
    port          int          null,
    pool_id       int          null,
    instance_uuid varchar(36)  null,
    deleted       int          null,
    constraint consoles_ibfk_1
        foreign key (pool_id) references console_pools (id),
    constraint consoles_instance_uuid_fkey
        foreign key (instance_uuid) references instances (uuid)
);

create index consoles_instance_uuid_idx
    on consoles (instance_uuid);

create index pool_id
    on consoles (pool_id);

create table fixed_ips
(
    created_at           datetime     null,
    updated_at           datetime     null,
    deleted_at           datetime     null,
    id                   int auto_increment
        primary key,
    address              varchar(39)  null,
    network_id           int          null,
    allocated            tinyint(1)   null,
    leased               tinyint(1)   null,
    reserved             tinyint(1)   null,
    virtual_interface_id int          null,
    host                 varchar(255) null,
    instance_uuid        varchar(36)  null,
    deleted              int          null,
    constraint uniq_fixed_ips0address0deleted
        unique (address, deleted),
    constraint fixed_ips_instance_uuid_fkey
        foreign key (instance_uuid) references instances (uuid)
);

create index address
    on fixed_ips (address);

create index fixed_ips_address_reserved_network_id_deleted_idx
    on fixed_ips (address, reserved, network_id, deleted);

create index fixed_ips_deleted_allocated_idx
    on fixed_ips (address, deleted, allocated);

create index fixed_ips_deleted_allocated_updated_at_idx
    on fixed_ips (deleted, allocated, updated_at);

create index fixed_ips_host_idx
    on fixed_ips (host);

create index fixed_ips_network_id_host_deleted_idx
    on fixed_ips (network_id, host, deleted);

create index fixed_ips_virtual_interface_id_fkey
    on fixed_ips (virtual_interface_id);

create index network_id
    on fixed_ips (network_id);

create table instance_actions
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    action        varchar(255) null,
    instance_uuid varchar(36)  null,
    request_id    varchar(255) null,
    user_id       varchar(255) null,
    project_id    varchar(255) null,
    start_time    datetime     null,
    finish_time   datetime     null,
    message       varchar(255) null,
    deleted       int          null,
    constraint fk_instance_actions_instance_uuid
        foreign key (instance_uuid) references instances (uuid)
);

create index instance_uuid_idx
    on instance_actions (instance_uuid);

create index request_id_idx
    on instance_actions (request_id);

create table instance_actions_events
(
    created_at  datetime     null,
    updated_at  datetime     null,
    deleted_at  datetime     null,
    id          int auto_increment
        primary key,
    event       varchar(255) null,
    action_id   int          null,
    start_time  datetime     null,
    finish_time datetime     null,
    result      varchar(255) null,
    traceback   text         null,
    deleted     int          null,
    host        varchar(255) null,
    details     text         null,
    constraint instance_actions_events_ibfk_1
        foreign key (action_id) references instance_actions (id)
);

create index action_id
    on instance_actions_events (action_id);

create table instance_extra
(
    created_at        datetime    null,
    updated_at        datetime    null,
    deleted_at        datetime    null,
    deleted           int         null,
    id                int auto_increment
        primary key,
    instance_uuid     varchar(36) not null,
    numa_topology     text        null,
    pci_requests      text        null,
    flavor            text        null,
    vcpu_model        text        null,
    migration_context text        null,
    keypairs          text        null,
    device_metadata   text        null,
    constraint instance_extra_instance_uuid_fkey
        foreign key (instance_uuid) references instances (uuid)
);

create index instance_extra_idx
    on instance_extra (instance_uuid);

create table instance_faults
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    instance_uuid varchar(36)  null,
    code          int          not null,
    message       varchar(255) null,
    details       mediumtext   null,
    host          varchar(255) null,
    deleted       int          null,
    constraint fk_instance_faults_instance_uuid
        foreign key (instance_uuid) references instances (uuid)
);

create index instance_faults_host_idx
    on instance_faults (host);

create index instance_faults_instance_uuid_deleted_created_at_idx
    on instance_faults (instance_uuid, deleted, created_at);

create table instance_info_caches
(
    created_at    datetime    null,
    updated_at    datetime    null,
    deleted_at    datetime    null,
    id            int auto_increment
        primary key,
    network_info  mediumtext  null,
    instance_uuid varchar(36) not null,
    deleted       int         null,
    constraint uniq_instance_info_caches0instance_uuid
        unique (instance_uuid),
    constraint instance_info_caches_instance_uuid_fkey
        foreign key (instance_uuid) references instances (uuid)
);

create table instance_metadata
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    `key`         varchar(255) null,
    value         varchar(255) null,
    instance_uuid varchar(36)  null,
    deleted       int          null,
    constraint instance_metadata_instance_uuid_fkey
        foreign key (instance_uuid) references instances (uuid)
);

create index instance_metadata_instance_uuid_idx
    on instance_metadata (instance_uuid);

create table instance_system_metadata
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    instance_uuid varchar(36)  not null,
    `key`         varchar(255) not null,
    value         varchar(255) null,
    deleted       int          null,
    constraint instance_system_metadata_ibfk_1
        foreign key (instance_uuid) references instances (uuid)
);

create index instance_uuid
    on instance_system_metadata (instance_uuid);

create index instances_deleted_created_at_idx
    on instances (deleted, created_at);

create index instances_host_deleted_cleaned_idx
    on instances (host, deleted, cleaned);

create index instances_host_node_deleted_idx
    on instances (host, node, deleted);

create index instances_project_id_deleted_idx
    on instances (project_id, deleted);

create index instances_reservation_id_idx
    on instances (reservation_id);

create index instances_task_state_updated_at_idx
    on instances (task_state, updated_at);

create index instances_terminated_at_launched_at_idx
    on instances (terminated_at, launched_at);

create index instances_uuid_deleted_idx
    on instances (uuid, deleted);

create table inventories
(
    id                   int auto_increment
        primary key,
    resource_provider_id int   not null,
    resource_class_id    int   not null,
    total                int   not null,
    reserved             int   not null,
    min_unit             int   not null,
    max_unit             int   not null,
    step_size            int   not null,
    allocation_ratio     float not null,
    constraint uniq_inventories0resource_provider_resource_class
        unique (resource_provider_id, resource_class_id)
)
    charset = latin1;

create index inventories_resource_class_id_idx
    on inventories (resource_class_id);

create index inventories_resource_provider_id_idx
    on inventories (resource_provider_id);

create index inventories_resource_provider_resource_class_idx
    on inventories (resource_provider_id, resource_class_id);

create table key_pairs
(
    created_at  datetime                           null,
    updated_at  datetime                           null,
    deleted_at  datetime                           null,
    id          int auto_increment
        primary key,
    name        varchar(255)                       not null,
    user_id     varchar(255)                       null,
    fingerprint varchar(255)                       null,
    public_key  mediumtext                         null,
    deleted     int                                null,
    type        enum ('ssh', 'x509') default 'ssh' not null,
    constraint uniq_key_pairs0user_id0name0deleted
        unique (user_id, name, deleted)
);

create table migrate_version
(
    repository_id   varchar(250) not null
        primary key,
    repository_path text         null,
    version         int          null
);

create table migrations
(
    created_at           datetime                                                     null,
    updated_at           datetime                                                     null,
    deleted_at           datetime                                                     null,
    id                   int auto_increment
        primary key,
    source_compute       varchar(255)                                                 null,
    dest_compute         varchar(255)                                                 null,
    dest_host            varchar(255)                                                 null,
    status               varchar(255)                                                 null,
    instance_uuid        varchar(36)                                                  null,
    old_instance_type_id int                                                          null,
    new_instance_type_id int                                                          null,
    source_node          varchar(255)                                                 null,
    dest_node            varchar(255)                                                 null,
    deleted              int                                                          null,
    migration_type       enum ('migration', 'resize', 'live-migration', 'evacuation') null,
    hidden               tinyint(1)                                                   null,
    memory_total         bigint                                                       null,
    memory_processed     bigint                                                       null,
    memory_remaining     bigint                                                       null,
    disk_total           bigint                                                       null,
    disk_processed       bigint                                                       null,
    disk_remaining       bigint                                                       null,
    constraint fk_migrations_instance_uuid
        foreign key (instance_uuid) references instances (uuid)
);

create index migrations_by_host_nodes_and_status_idx
    on migrations (deleted, source_compute, dest_compute, source_node, dest_node, status);

create index migrations_instance_uuid_and_status_idx
    on migrations (deleted, instance_uuid, status);

create table networks
(
    created_at          datetime     null,
    updated_at          datetime     null,
    deleted_at          datetime     null,
    id                  int auto_increment
        primary key,
    injected            tinyint(1)   null,
    cidr                varchar(43)  null,
    netmask             varchar(39)  null,
    bridge              varchar(255) null,
    gateway             varchar(39)  null,
    broadcast           varchar(39)  null,
    dns1                varchar(39)  null,
    vlan                int          null,
    vpn_public_address  varchar(39)  null,
    vpn_public_port     int          null,
    vpn_private_address varchar(39)  null,
    dhcp_start          varchar(39)  null,
    project_id          varchar(255) null,
    host                varchar(255) null,
    cidr_v6             varchar(43)  null,
    gateway_v6          varchar(39)  null,
    label               varchar(255) null,
    netmask_v6          varchar(39)  null,
    bridge_interface    varchar(255) null,
    multi_host          tinyint(1)   null,
    dns2                varchar(39)  null,
    uuid                varchar(36)  null,
    priority            int          null,
    rxtx_base           int          null,
    deleted             int          null,
    mtu                 int          null,
    dhcp_server         varchar(39)  null,
    enable_dhcp         tinyint(1)   null,
    share_address       tinyint(1)   null,
    constraint uniq_networks0vlan0deleted
        unique (vlan, deleted)
);

create index networks_bridge_deleted_idx
    on networks (bridge, deleted);

create index networks_cidr_v6_idx
    on networks (cidr_v6);

create index networks_host_idx
    on networks (host);

create index networks_project_id_deleted_idx
    on networks (project_id, deleted);

create index networks_uuid_project_id_deleted_idx
    on networks (uuid, project_id, deleted);

create index networks_vlan_deleted_idx
    on networks (vlan, deleted);

create table pci_devices
(
    created_at      datetime     null,
    updated_at      datetime     null,
    deleted_at      datetime     null,
    deleted         int          null,
    id              int auto_increment
        primary key,
    compute_node_id int          not null,
    address         varchar(12)  not null,
    product_id      varchar(4)   not null,
    vendor_id       varchar(4)   not null,
    dev_type        varchar(8)   not null,
    dev_id          varchar(255) null,
    label           varchar(255) not null,
    status          varchar(36)  not null,
    extra_info      text         null,
    instance_uuid   varchar(36)  null,
    request_id      varchar(36)  null,
    numa_node       int          null,
    parent_addr     varchar(12)  null,
    constraint uniq_pci_devices0compute_node_id0address0deleted
        unique (compute_node_id, address, deleted),
    constraint pci_devices_compute_node_id_fkey
        foreign key (compute_node_id) references compute_nodes (id)
);

create index ix_pci_devices_compute_node_id_deleted
    on pci_devices (compute_node_id, deleted);

create index ix_pci_devices_compute_node_id_parent_addr_deleted
    on pci_devices (compute_node_id, parent_addr, deleted);

create index ix_pci_devices_instance_uuid_deleted
    on pci_devices (instance_uuid, deleted);

create table project_user_quotas
(
    id         int auto_increment
        primary key,
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    int          null,
    user_id    varchar(255) not null,
    project_id varchar(255) not null,
    resource   varchar(255) not null,
    hard_limit int          null,
    constraint uniq_project_user_quotas0user_id0project_id0resource0deleted
        unique (user_id, project_id, resource, deleted)
);

create index project_user_quotas_project_id_deleted_idx
    on project_user_quotas (project_id, deleted);

create index project_user_quotas_user_id_deleted_idx
    on project_user_quotas (user_id, deleted);

create table provider_fw_rules
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    id         int auto_increment
        primary key,
    protocol   varchar(5)  null,
    from_port  int         null,
    to_port    int         null,
    cidr       varchar(43) null,
    deleted    int         null
);

create table quota_classes
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    id         int auto_increment
        primary key,
    class_name varchar(255) null,
    resource   varchar(255) null,
    hard_limit int          null,
    deleted    int          null
);

create index ix_quota_classes_class_name
    on quota_classes (class_name);

create table quota_usages
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    project_id    varchar(255) null,
    resource      varchar(255) not null,
    in_use        int          not null,
    reserved      int          not null,
    until_refresh int          null,
    deleted       int          null,
    user_id       varchar(255) null
);

create index ix_quota_usages_project_id
    on quota_usages (project_id);

create index ix_quota_usages_user_id_deleted
    on quota_usages (user_id, deleted);

create table quotas
(
    id         int auto_increment
        primary key,
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    project_id varchar(255) null,
    resource   varchar(255) not null,
    hard_limit int          null,
    deleted    int          null,
    constraint uniq_quotas0project_id0resource0deleted
        unique (project_id, resource, deleted)
);

create table reservations
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    id         int auto_increment
        primary key,
    uuid       varchar(36)  not null,
    usage_id   int          not null,
    project_id varchar(255) null,
    resource   varchar(255) null,
    delta      int          not null,
    expire     datetime     null,
    deleted    int          null,
    user_id    varchar(255) null,
    constraint reservations_ibfk_1
        foreign key (usage_id) references quota_usages (id)
);

create index ix_reservations_project_id
    on reservations (project_id);

create index ix_reservations_user_id_deleted
    on reservations (user_id, deleted);

create index reservations_deleted_expire_idx
    on reservations (deleted, expire);

create index reservations_uuid_idx
    on reservations (uuid);

create index usage_id
    on reservations (usage_id);

create table resource_provider_aggregates
(
    resource_provider_id int auto_increment,
    aggregate_id         int not null,
    primary key (resource_provider_id, aggregate_id)
)
    charset = latin1;

create index resource_provider_aggregates_aggregate_id_idx
    on resource_provider_aggregates (aggregate_id);

create table resource_providers
(
    id         int auto_increment
        primary key,
    uuid       varchar(36)               not null,
    name       varchar(200) charset utf8 null,
    generation int                       null,
    can_host   int                       null,
    constraint uniq_resource_providers0name
        unique (name),
    constraint uniq_resource_providers0uuid
        unique (uuid)
)
    charset = latin1;

create index resource_providers_name_idx
    on resource_providers (name);

create index resource_providers_uuid_idx
    on resource_providers (uuid);

create table s3_images
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    id         int auto_increment
        primary key,
    uuid       varchar(36) not null,
    deleted    int         null
);

create table security_group_default_rules
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    deleted    int         null,
    id         int auto_increment
        primary key,
    protocol   varchar(5)  null,
    from_port  int         null,
    to_port    int         null,
    cidr       varchar(43) null
);

create table security_groups
(
    created_at  datetime     null,
    updated_at  datetime     null,
    deleted_at  datetime     null,
    id          int auto_increment
        primary key,
    name        varchar(255) null,
    description varchar(255) null,
    user_id     varchar(255) null,
    project_id  varchar(255) null,
    deleted     int          null,
    constraint uniq_security_groups0project_id0name0deleted
        unique (project_id, name, deleted)
);

create table security_group_instance_association
(
    created_at        datetime    null,
    updated_at        datetime    null,
    deleted_at        datetime    null,
    id                int auto_increment
        primary key,
    security_group_id int         null,
    instance_uuid     varchar(36) null,
    deleted           int         null,
    constraint security_group_instance_association_ibfk_1
        foreign key (security_group_id) references security_groups (id),
    constraint security_group_instance_association_instance_uuid_fkey
        foreign key (instance_uuid) references instances (uuid)
);

create index security_group_id
    on security_group_instance_association (security_group_id);

create index security_group_instance_association_instance_uuid_idx
    on security_group_instance_association (instance_uuid);

create table security_group_rules
(
    created_at      datetime     null,
    updated_at      datetime     null,
    deleted_at      datetime     null,
    id              int auto_increment
        primary key,
    parent_group_id int          null,
    protocol        varchar(255) null,
    from_port       int          null,
    to_port         int          null,
    cidr            varchar(43)  null,
    group_id        int          null,
    deleted         int          null,
    constraint security_group_rules_ibfk_1
        foreign key (parent_group_id) references security_groups (id),
    constraint security_group_rules_ibfk_2
        foreign key (group_id) references security_groups (id)
);

create index group_id
    on security_group_rules (group_id);

create index parent_group_id
    on security_group_rules (parent_group_id);

create table services
(
    created_at      datetime     null,
    updated_at      datetime     null,
    deleted_at      datetime     null,
    id              int auto_increment
        primary key,
    host            varchar(255) null,
    `binary`        varchar(255) null,
    topic           varchar(255) null,
    report_count    int          not null,
    disabled        tinyint(1)   null,
    deleted         int          null,
    disabled_reason varchar(255) null,
    last_seen_up    datetime     null,
    forced_down     tinyint(1)   null,
    version         int          null,
    constraint uniq_services0host0binary0deleted
        unique (host, `binary`, deleted),
    constraint uniq_services0host0topic0deleted
        unique (host, topic, deleted)
);

create table shadow_agent_builds
(
    created_at   datetime     null,
    updated_at   datetime     null,
    deleted_at   datetime     null,
    id           int auto_increment
        primary key,
    hypervisor   varchar(255) null,
    os           varchar(255) null,
    architecture varchar(255) null,
    version      varchar(255) null,
    url          varchar(255) null,
    md5hash      varchar(255) null,
    deleted      int          null
);

create table shadow_aggregate_hosts
(
    created_at   datetime     null,
    updated_at   datetime     null,
    deleted_at   datetime     null,
    id           int auto_increment
        primary key,
    host         varchar(255) null,
    aggregate_id int          not null,
    deleted      int          null
);

create table shadow_aggregate_metadata
(
    created_at   datetime     null,
    updated_at   datetime     null,
    deleted_at   datetime     null,
    id           int auto_increment
        primary key,
    aggregate_id int          not null,
    `key`        varchar(255) not null,
    value        varchar(255) not null,
    deleted      int          null
);

create table shadow_aggregates
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    id         int auto_increment
        primary key,
    name       varchar(255) null,
    deleted    int          null,
    uuid       varchar(36)  null
);

create table shadow_block_device_mapping
(
    created_at            datetime     null,
    updated_at            datetime     null,
    deleted_at            datetime     null,
    id                    int auto_increment
        primary key,
    device_name           varchar(255) null,
    delete_on_termination tinyint(1)   null,
    snapshot_id           varchar(36)  null,
    volume_id             varchar(36)  null,
    volume_size           int          null,
    no_device             tinyint(1)   null,
    connection_info       mediumtext   null,
    instance_uuid         varchar(36)  null,
    deleted               int          null,
    source_type           varchar(255) null,
    destination_type      varchar(255) null,
    guest_format          varchar(255) null,
    device_type           varchar(255) null,
    disk_bus              varchar(255) null,
    boot_index            int          null,
    image_id              varchar(36)  null,
    tag                   varchar(255) null
);

create table shadow_bw_usage_cache
(
    created_at     datetime     null,
    updated_at     datetime     null,
    deleted_at     datetime     null,
    id             int auto_increment
        primary key,
    start_period   datetime     not null,
    last_refreshed datetime     null,
    bw_in          bigint       null,
    bw_out         bigint       null,
    mac            varchar(255) null,
    uuid           varchar(36)  null,
    last_ctr_in    bigint       null,
    last_ctr_out   bigint       null,
    deleted        int          null
);

create table shadow_cells
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    api_url       varchar(255) null,
    weight_offset float        null,
    weight_scale  float        null,
    name          varchar(255) null,
    is_parent     tinyint(1)   null,
    deleted       int          null,
    transport_url varchar(255) not null
);

create table shadow_certificates
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    id         int auto_increment
        primary key,
    user_id    varchar(255) null,
    project_id varchar(255) null,
    file_name  varchar(255) null,
    deleted    int          null
);

create table shadow_compute_nodes
(
    created_at            datetime     null,
    updated_at            datetime     null,
    deleted_at            datetime     null,
    id                    int auto_increment
        primary key,
    service_id            int          null,
    vcpus                 int          not null,
    memory_mb             int          not null,
    local_gb              int          not null,
    vcpus_used            int          not null,
    memory_mb_used        int          not null,
    local_gb_used         int          not null,
    hypervisor_type       mediumtext   not null,
    hypervisor_version    int          not null,
    cpu_info              mediumtext   not null,
    disk_available_least  int          null,
    free_ram_mb           int          null,
    free_disk_gb          int          null,
    current_workload      int          null,
    running_vms           int          null,
    hypervisor_hostname   varchar(255) null,
    deleted               int          null,
    host_ip               varchar(39)  null,
    supported_instances   text         null,
    pci_stats             text         null,
    metrics               text         null,
    extra_resources       text         null,
    stats                 text         null,
    numa_topology         text         null,
    host                  varchar(255) null,
    ram_allocation_ratio  float        null,
    cpu_allocation_ratio  float        null,
    uuid                  varchar(36)  null,
    disk_allocation_ratio float        null
);

create table shadow_console_pools
(
    created_at      datetime     null,
    updated_at      datetime     null,
    deleted_at      datetime     null,
    id              int auto_increment
        primary key,
    address         varchar(39)  null,
    username        varchar(255) null,
    password        varchar(255) null,
    console_type    varchar(255) null,
    public_hostname varchar(255) null,
    host            varchar(255) null,
    compute_host    varchar(255) null,
    deleted         int          null
);

create table shadow_consoles
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    instance_name varchar(255) null,
    password      varchar(255) null,
    port          int          null,
    pool_id       int          null,
    instance_uuid varchar(36)  null,
    deleted       int          null
);

create table shadow_dns_domains
(
    created_at        datetime     null,
    updated_at        datetime     null,
    deleted_at        datetime     null,
    deleted           tinyint(1)   null,
    domain            varchar(255) not null
        primary key,
    scope             varchar(255) null,
    availability_zone varchar(255) null,
    project_id        varchar(255) null
);

create table shadow_fixed_ips
(
    created_at           datetime     null,
    updated_at           datetime     null,
    deleted_at           datetime     null,
    id                   int auto_increment
        primary key,
    address              varchar(39)  null,
    network_id           int          null,
    allocated            tinyint(1)   null,
    leased               tinyint(1)   null,
    reserved             tinyint(1)   null,
    virtual_interface_id int          null,
    host                 varchar(255) null,
    instance_uuid        varchar(36)  null,
    deleted              int          null
);

create table shadow_floating_ips
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    address       varchar(39)  null,
    fixed_ip_id   int          null,
    project_id    varchar(255) null,
    host          varchar(255) null,
    auto_assigned tinyint(1)   null,
    pool          varchar(255) null,
    interface     varchar(255) null,
    deleted       int          null
);

create table shadow_instance_actions
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    action        varchar(255) null,
    instance_uuid varchar(36)  null,
    request_id    varchar(255) null,
    user_id       varchar(255) null,
    project_id    varchar(255) null,
    start_time    datetime     null,
    finish_time   datetime     null,
    message       varchar(255) null,
    deleted       int          null
);

create table shadow_instance_actions_events
(
    created_at  datetime     null,
    updated_at  datetime     null,
    deleted_at  datetime     null,
    id          int auto_increment
        primary key,
    event       varchar(255) null,
    action_id   int          null,
    start_time  datetime     null,
    finish_time datetime     null,
    result      varchar(255) null,
    traceback   text         null,
    deleted     int          null,
    host        varchar(255) null,
    details     text         null
);

create table shadow_instance_extra
(
    created_at        datetime    null,
    updated_at        datetime    null,
    deleted_at        datetime    null,
    deleted           int         null,
    id                int auto_increment
        primary key,
    instance_uuid     varchar(36) not null,
    numa_topology     text        null,
    pci_requests      text        null,
    flavor            text        null,
    vcpu_model        text        null,
    migration_context text        null,
    keypairs          text        null,
    device_metadata   text        null
);

create index shadow_instance_extra_idx
    on shadow_instance_extra (instance_uuid);

create table shadow_instance_faults
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    instance_uuid varchar(36)  null,
    code          int          not null,
    message       varchar(255) null,
    details       mediumtext   null,
    host          varchar(255) null,
    deleted       int          null
);

create table shadow_instance_group_member
(
    created_at  datetime     null,
    updated_at  datetime     null,
    deleted_at  datetime     null,
    deleted     int          null,
    id          int auto_increment
        primary key,
    instance_id varchar(255) null,
    group_id    int          not null
);

create table shadow_instance_group_policy
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    int          null,
    id         int auto_increment
        primary key,
    policy     varchar(255) null,
    group_id   int          not null
);

create table shadow_instance_groups
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    int          null,
    id         int auto_increment
        primary key,
    user_id    varchar(255) null,
    project_id varchar(255) null,
    uuid       varchar(36)  not null,
    name       varchar(255) null
);

create table shadow_instance_id_mappings
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    id         int auto_increment
        primary key,
    uuid       varchar(36) not null,
    deleted    int         null
);

create table shadow_instance_info_caches
(
    created_at    datetime    null,
    updated_at    datetime    null,
    deleted_at    datetime    null,
    id            int auto_increment
        primary key,
    network_info  mediumtext  null,
    instance_uuid varchar(36) not null,
    deleted       int         null
);

create table shadow_instance_metadata
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    `key`         varchar(255) null,
    value         varchar(255) null,
    instance_uuid varchar(36)  null,
    deleted       int          null
);

create table shadow_instance_system_metadata
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    instance_uuid varchar(36)  not null,
    `key`         varchar(255) not null,
    value         varchar(255) null,
    deleted       int          null
);

create table shadow_instance_type_extra_specs
(
    created_at       datetime     null,
    updated_at       datetime     null,
    deleted_at       datetime     null,
    id               int auto_increment
        primary key,
    instance_type_id int          not null,
    `key`            varchar(255) null,
    value            varchar(255) null,
    deleted          int          null
);

create table shadow_instance_type_projects
(
    created_at       datetime     null,
    updated_at       datetime     null,
    deleted_at       datetime     null,
    id               int auto_increment
        primary key,
    instance_type_id int          not null,
    project_id       varchar(255) null,
    deleted          int          null
);

create table shadow_instance_types
(
    created_at   datetime     null,
    updated_at   datetime     null,
    deleted_at   datetime     null,
    name         varchar(255) null,
    id           int auto_increment
        primary key,
    memory_mb    int          not null,
    vcpus        int          not null,
    swap         int          not null,
    vcpu_weight  int          null,
    flavorid     varchar(255) null,
    rxtx_factor  float        null,
    root_gb      int          null,
    ephemeral_gb int          null,
    disabled     tinyint(1)   null,
    is_public    tinyint(1)   null,
    deleted      int          null
);

create table shadow_instances
(
    created_at               datetime                null,
    updated_at               datetime                null,
    deleted_at               datetime                null,
    id                       int auto_increment
        primary key,
    internal_id              int                     null,
    user_id                  varchar(255)            null,
    project_id               varchar(255)            null,
    image_ref                varchar(255)            null,
    kernel_id                varchar(255)            null,
    ramdisk_id               varchar(255)            null,
    launch_index             int                     null,
    key_name                 varchar(255)            null,
    key_data                 mediumtext              null,
    power_state              int                     null,
    vm_state                 varchar(255)            null,
    memory_mb                int                     null,
    vcpus                    int                     null,
    hostname                 varchar(255)            null,
    host                     varchar(255)            null,
    user_data                mediumtext              null,
    reservation_id           varchar(255)            null,
    scheduled_at             datetime                null,
    launched_at              datetime                null,
    terminated_at            datetime                null,
    display_name             varchar(255)            null,
    display_description      varchar(255)            null,
    availability_zone        varchar(255)            null,
    locked                   tinyint(1)              null,
    os_type                  varchar(255)            null,
    launched_on              mediumtext              null,
    instance_type_id         int                     null,
    vm_mode                  varchar(255)            null,
    uuid                     varchar(36)             not null,
    architecture             varchar(255)            null,
    root_device_name         varchar(255)            null,
    access_ip_v4             varchar(39)             null,
    access_ip_v6             varchar(39)             null,
    config_drive             varchar(255)            null,
    task_state               varchar(255)            null,
    default_ephemeral_device varchar(255)            null,
    default_swap_device      varchar(255)            null,
    progress                 int                     null,
    auto_disk_config         tinyint(1)              null,
    shutdown_terminate       tinyint(1)              null,
    disable_terminate        tinyint(1)              null,
    root_gb                  int                     null,
    ephemeral_gb             int                     null,
    cell_name                varchar(255)            null,
    node                     varchar(255)            null,
    deleted                  int                     null,
    locked_by                enum ('owner', 'admin') null,
    cleaned                  int                     null,
    ephemeral_key_uuid       varchar(36)             null
);

create table shadow_key_pairs
(
    created_at  datetime                           null,
    updated_at  datetime                           null,
    deleted_at  datetime                           null,
    id          int auto_increment
        primary key,
    name        varchar(255)                       null,
    user_id     varchar(255)                       null,
    fingerprint varchar(255)                       null,
    public_key  mediumtext                         null,
    deleted     int                                null,
    type        enum ('ssh', 'x509') default 'ssh' not null
);

create table shadow_migrate_version
(
    repository_id   varchar(250) not null
        primary key,
    repository_path text         null,
    version         int          null
);

create table shadow_migrations
(
    created_at           datetime                                                     null,
    updated_at           datetime                                                     null,
    deleted_at           datetime                                                     null,
    id                   int auto_increment
        primary key,
    source_compute       varchar(255)                                                 null,
    dest_compute         varchar(255)                                                 null,
    dest_host            varchar(255)                                                 null,
    status               varchar(255)                                                 null,
    instance_uuid        varchar(36)                                                  null,
    old_instance_type_id int                                                          null,
    new_instance_type_id int                                                          null,
    source_node          varchar(255)                                                 null,
    dest_node            varchar(255)                                                 null,
    deleted              int                                                          null,
    migration_type       enum ('migration', 'resize', 'live-migration', 'evacuation') null,
    hidden               tinyint(1)                                                   null,
    memory_total         bigint                                                       null,
    memory_processed     bigint                                                       null,
    memory_remaining     bigint                                                       null,
    disk_total           bigint                                                       null,
    disk_processed       bigint                                                       null,
    disk_remaining       bigint                                                       null
);

create table shadow_networks
(
    created_at          datetime     null,
    updated_at          datetime     null,
    deleted_at          datetime     null,
    id                  int auto_increment
        primary key,
    injected            tinyint(1)   null,
    cidr                varchar(43)  null,
    netmask             varchar(39)  null,
    bridge              varchar(255) null,
    gateway             varchar(39)  null,
    broadcast           varchar(39)  null,
    dns1                varchar(39)  null,
    vlan                int          null,
    vpn_public_address  varchar(39)  null,
    vpn_public_port     int          null,
    vpn_private_address varchar(39)  null,
    dhcp_start          varchar(39)  null,
    project_id          varchar(255) null,
    host                varchar(255) null,
    cidr_v6             varchar(43)  null,
    gateway_v6          varchar(39)  null,
    label               varchar(255) null,
    netmask_v6          varchar(39)  null,
    bridge_interface    varchar(255) null,
    multi_host          tinyint(1)   null,
    dns2                varchar(39)  null,
    uuid                varchar(36)  null,
    priority            int          null,
    rxtx_base           int          null,
    deleted             int          null,
    mtu                 int          null,
    dhcp_server         varchar(39)  null,
    enable_dhcp         tinyint(1)   null,
    share_address       tinyint(1)   null
);

create table shadow_pci_devices
(
    created_at      datetime     null,
    updated_at      datetime     null,
    deleted_at      datetime     null,
    deleted         int          not null,
    id              int auto_increment
        primary key,
    compute_node_id int          not null,
    address         varchar(12)  not null,
    product_id      varchar(4)   null,
    vendor_id       varchar(4)   null,
    dev_type        varchar(8)   null,
    dev_id          varchar(255) null,
    label           varchar(255) not null,
    status          varchar(36)  not null,
    extra_info      text         null,
    instance_uuid   varchar(36)  null,
    request_id      varchar(36)  null,
    numa_node       int          null,
    parent_addr     varchar(12)  null
);

create table shadow_project_user_quotas
(
    id         int auto_increment
        primary key,
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    int          null,
    user_id    varchar(255) not null,
    project_id varchar(255) not null,
    resource   varchar(255) not null,
    hard_limit int          null
);

create table shadow_provider_fw_rules
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    id         int auto_increment
        primary key,
    protocol   varchar(5)  null,
    from_port  int         null,
    to_port    int         null,
    cidr       varchar(43) null,
    deleted    int         null
);

create table shadow_quota_classes
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    id         int auto_increment
        primary key,
    class_name varchar(255) null,
    resource   varchar(255) null,
    hard_limit int          null,
    deleted    int          null
);

create table shadow_quota_usages
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    project_id    varchar(255) null,
    resource      varchar(255) null,
    in_use        int          not null,
    reserved      int          not null,
    until_refresh int          null,
    deleted       int          null,
    user_id       varchar(255) null
);

create table shadow_quotas
(
    id         int auto_increment
        primary key,
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    project_id varchar(255) null,
    resource   varchar(255) not null,
    hard_limit int          null,
    deleted    int          null
);

create table shadow_reservations
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    id         int auto_increment
        primary key,
    uuid       varchar(36)  not null,
    usage_id   int          not null,
    project_id varchar(255) null,
    resource   varchar(255) null,
    delta      int          not null,
    expire     datetime     null,
    deleted    int          null,
    user_id    varchar(255) null
);

create table shadow_s3_images
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    id         int auto_increment
        primary key,
    uuid       varchar(36) not null,
    deleted    int         null
);

create table shadow_security_group_default_rules
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    deleted    int         null,
    id         int auto_increment
        primary key,
    protocol   varchar(5)  null,
    from_port  int         null,
    to_port    int         null,
    cidr       varchar(43) null
);

create table shadow_security_group_instance_association
(
    created_at        datetime    null,
    updated_at        datetime    null,
    deleted_at        datetime    null,
    id                int auto_increment
        primary key,
    security_group_id int         null,
    instance_uuid     varchar(36) null,
    deleted           int         null
);

create table shadow_security_group_rules
(
    created_at      datetime     null,
    updated_at      datetime     null,
    deleted_at      datetime     null,
    id              int auto_increment
        primary key,
    parent_group_id int          null,
    protocol        varchar(255) null,
    from_port       int          null,
    to_port         int          null,
    cidr            varchar(43)  null,
    group_id        int          null,
    deleted         int          null
);

create table shadow_security_groups
(
    created_at  datetime     null,
    updated_at  datetime     null,
    deleted_at  datetime     null,
    id          int auto_increment
        primary key,
    name        varchar(255) null,
    description varchar(255) null,
    user_id     varchar(255) null,
    project_id  varchar(255) null,
    deleted     int          null
);

create table shadow_services
(
    created_at      datetime     null,
    updated_at      datetime     null,
    deleted_at      datetime     null,
    id              int auto_increment
        primary key,
    host            varchar(255) null,
    `binary`        varchar(255) null,
    topic           varchar(255) null,
    report_count    int          not null,
    disabled        tinyint(1)   null,
    deleted         int          null,
    disabled_reason varchar(255) null,
    last_seen_up    datetime     null,
    forced_down     tinyint(1)   null,
    version         int          null
);

create table shadow_snapshot_id_mappings
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    id         int auto_increment
        primary key,
    uuid       varchar(36) not null,
    deleted    int         null
);

create table shadow_snapshots
(
    created_at          datetime     null,
    updated_at          datetime     null,
    deleted_at          datetime     null,
    id                  varchar(36)  not null
        primary key,
    volume_id           varchar(36)  not null,
    user_id             varchar(255) null,
    project_id          varchar(255) null,
    status              varchar(255) null,
    progress            varchar(255) null,
    volume_size         int          null,
    scheduled_at        datetime     null,
    display_name        varchar(255) null,
    display_description varchar(255) null,
    deleted             varchar(36)  null
);

create table shadow_task_log
(
    created_at       datetime     null,
    updated_at       datetime     null,
    deleted_at       datetime     null,
    id               int auto_increment
        primary key,
    task_name        varchar(255) not null,
    state            varchar(255) not null,
    host             varchar(255) not null,
    period_beginning datetime     not null,
    period_ending    datetime     not null,
    message          varchar(255) not null,
    task_items       int          null,
    errors           int          null,
    deleted          int          null
);

create table shadow_virtual_interfaces
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    address       varchar(255) null,
    network_id    int          null,
    uuid          varchar(36)  null,
    instance_uuid varchar(36)  null,
    deleted       int          null,
    tag           varchar(255) null
);

create table shadow_volume_id_mappings
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    id         int auto_increment
        primary key,
    uuid       varchar(36) not null,
    deleted    int         null
);

create table shadow_volume_usage_cache
(
    created_at          datetime     null,
    updated_at          datetime     null,
    deleted_at          datetime     null,
    id                  int auto_increment
        primary key,
    volume_id           varchar(36)  not null,
    tot_last_refreshed  datetime     null,
    tot_reads           bigint       null,
    tot_read_bytes      bigint       null,
    tot_writes          bigint       null,
    tot_write_bytes     bigint       null,
    curr_last_refreshed datetime     null,
    curr_reads          bigint       null,
    curr_read_bytes     bigint       null,
    curr_writes         bigint       null,
    curr_write_bytes    bigint       null,
    deleted             int          null,
    instance_uuid       varchar(36)  null,
    project_id          varchar(36)  null,
    user_id             varchar(36)  null,
    availability_zone   varchar(255) null
);

create table snapshot_id_mappings
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    id         int auto_increment
        primary key,
    uuid       varchar(36) not null,
    deleted    int         null
);

create table snapshots
(
    created_at          datetime     null,
    updated_at          datetime     null,
    deleted_at          datetime     null,
    id                  varchar(36)  not null
        primary key,
    volume_id           varchar(36)  not null,
    user_id             varchar(255) null,
    project_id          varchar(255) null,
    status              varchar(255) null,
    progress            varchar(255) null,
    volume_size         int          null,
    scheduled_at        datetime     null,
    display_name        varchar(255) null,
    display_description varchar(255) null,
    deleted             varchar(36)  null
);

create table tags
(
    resource_id varchar(36) not null,
    tag         varchar(80) not null,
    primary key (resource_id, tag)
);

create index tags_tag_idx
    on tags (tag);

create table task_log
(
    created_at       datetime     null,
    updated_at       datetime     null,
    deleted_at       datetime     null,
    id               int auto_increment
        primary key,
    task_name        varchar(255) not null,
    state            varchar(255) not null,
    host             varchar(255) not null,
    period_beginning datetime     not null,
    period_ending    datetime     not null,
    message          varchar(255) not null,
    task_items       int          null,
    errors           int          null,
    deleted          int          null,
    constraint uniq_task_log0task_name0host0period_beginning0period_ending
        unique (task_name, host, period_beginning, period_ending)
);

create index ix_task_log_host
    on task_log (host);

create index ix_task_log_period_beginning
    on task_log (period_beginning);

create index ix_task_log_period_ending
    on task_log (period_ending);

create table virtual_interfaces
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    id            int auto_increment
        primary key,
    address       varchar(255) null,
    network_id    int          null,
    uuid          varchar(36)  null,
    instance_uuid varchar(36)  null,
    deleted       int          null,
    tag           varchar(255) null,
    constraint uniq_virtual_interfaces0address0deleted
        unique (address, deleted),
    constraint virtual_interfaces_instance_uuid_fkey
        foreign key (instance_uuid) references instances (uuid)
);

create index virtual_interfaces_network_id_idx
    on virtual_interfaces (network_id);

create index virtual_interfaces_uuid_idx
    on virtual_interfaces (uuid);

create table volume_id_mappings
(
    created_at datetime    null,
    updated_at datetime    null,
    deleted_at datetime    null,
    id         int auto_increment
        primary key,
    uuid       varchar(36) not null,
    deleted    int         null
);

create table volume_usage_cache
(
    created_at          datetime     null,
    updated_at          datetime     null,
    deleted_at          datetime     null,
    id                  int auto_increment
        primary key,
    volume_id           varchar(36)  not null,
    tot_last_refreshed  datetime     null,
    tot_reads           bigint       null,
    tot_read_bytes      bigint       null,
    tot_writes          bigint       null,
    tot_write_bytes     bigint       null,
    curr_last_refreshed datetime     null,
    curr_reads          bigint       null,
    curr_read_bytes     bigint       null,
    curr_writes         bigint       null,
    curr_write_bytes    bigint       null,
    deleted             int          null,
    instance_uuid       varchar(36)  null,
    project_id          varchar(36)  null,
    user_id             varchar(64)  null,
    availability_zone   varchar(255) null
);