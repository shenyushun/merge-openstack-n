create table aggregates
(
    created_at datetime     null,
    updated_at datetime     null,
    id         int auto_increment
        primary key,
    uuid       varchar(36)  null,
    name       varchar(255) null,
    constraint uniq_aggregate0name
        unique (name)
);

create table aggregate_hosts
(
    created_at   datetime     null,
    updated_at   datetime     null,
    id           int auto_increment
        primary key,
    host         varchar(255) null,
    aggregate_id int          not null,
    constraint uniq_aggregate_hosts0host0aggregate_id
        unique (host, aggregate_id),
    constraint aggregate_hosts_ibfk_1
        foreign key (aggregate_id) references aggregates (id)
);

create index aggregate_id
    on aggregate_hosts (aggregate_id);

create table aggregate_metadata
(
    created_at   datetime     null,
    updated_at   datetime     null,
    id           int auto_increment
        primary key,
    aggregate_id int          not null,
    `key`        varchar(255) not null,
    value        varchar(255) not null,
    constraint uniq_aggregate_metadata0aggregate_id0key
        unique (aggregate_id, `key`),
    constraint aggregate_metadata_ibfk_1
        foreign key (aggregate_id) references aggregates (id)
);

create index aggregate_metadata_key_idx
    on aggregate_metadata (`key`);

create index aggregate_uuid_idx
    on aggregates (uuid);

create table allocations
(
    created_at           datetime    null,
    updated_at           datetime    null,
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

create table build_requests
(
    created_at            datetime                null,
    updated_at            datetime                null,
    id                    int auto_increment
        primary key,
    request_spec_id       int                     null,
    project_id            varchar(255)            not null,
    user_id               varchar(255)            null,
    display_name          varchar(255)            null,
    instance_metadata     text                    null,
    progress              int                     null,
    vm_state              varchar(255)            null,
    task_state            varchar(255)            null,
    image_ref             varchar(255)            null,
    access_ip_v4          varchar(39)             null,
    access_ip_v6          varchar(39)             null,
    info_cache            text                    null,
    security_groups       text                    null,
    config_drive          tinyint(1)              null,
    key_name              varchar(255)            null,
    locked_by             enum ('owner', 'admin') null,
    instance_uuid         varchar(36)             null,
    instance              mediumtext              null,
    block_device_mappings mediumtext              null,
    constraint uniq_build_requests0instance_uuid
        unique (instance_uuid)
);

create index build_requests_instance_uuid_idx
    on build_requests (instance_uuid);

create index build_requests_project_id_idx
    on build_requests (project_id);

create table cell_mappings
(
    created_at          datetime     null,
    updated_at          datetime     null,
    id                  int auto_increment
        primary key,
    uuid                varchar(36)  not null,
    name                varchar(255) null,
    transport_url       text         null,
    database_connection text         null,
    constraint uniq_cell_mappings0uuid
        unique (uuid)
);

create index uuid_idx
    on cell_mappings (uuid);

create table flavors
(
    created_at   datetime     null,
    updated_at   datetime     null,
    name         varchar(255) not null,
    id           int auto_increment
        primary key,
    memory_mb    int          not null,
    vcpus        int          not null,
    swap         int          not null,
    vcpu_weight  int          null,
    flavorid     varchar(255) not null,
    rxtx_factor  float        null,
    root_gb      int          null,
    ephemeral_gb int          null,
    disabled     tinyint(1)   null,
    is_public    tinyint(1)   null,
    constraint uniq_flavors0flavorid
        unique (flavorid),
    constraint uniq_flavors0name
        unique (name)
);

create table flavor_extra_specs
(
    created_at datetime     null,
    updated_at datetime     null,
    id         int auto_increment
        primary key,
    flavor_id  int          not null,
    `key`      varchar(255) not null,
    value      varchar(255) null,
    constraint uniq_flavor_extra_specs0flavor_id0key
        unique (flavor_id, `key`),
    constraint flavor_extra_specs_ibfk_1
        foreign key (flavor_id) references flavors (id)
);

create index flavor_extra_specs_flavor_id_key_idx
    on flavor_extra_specs (flavor_id, `key`);

create table flavor_projects
(
    created_at datetime     null,
    updated_at datetime     null,
    id         int auto_increment
        primary key,
    flavor_id  int          not null,
    project_id varchar(255) not null,
    constraint uniq_flavor_projects0flavor_id0project_id
        unique (flavor_id, project_id),
    constraint flavor_projects_ibfk_1
        foreign key (flavor_id) references flavors (id)
);

create table host_mappings
(
    created_at datetime     null,
    updated_at datetime     null,
    id         int auto_increment
        primary key,
    cell_id    int          not null,
    host       varchar(255) not null,
    constraint uniq_host_mappings0host
        unique (host),
    constraint host_mappings_ibfk_1
        foreign key (cell_id) references cell_mappings (id)
);

create index cell_id
    on host_mappings (cell_id);

create index host_idx
    on host_mappings (host);

create table instance_groups
(
    created_at datetime     null,
    updated_at datetime     null,
    id         int auto_increment
        primary key,
    user_id    varchar(255) null,
    project_id varchar(255) null,
    uuid       varchar(36)  not null,
    name       varchar(255) null,
    constraint uniq_instance_groups0uuid
        unique (uuid)
);

create table instance_group_member
(
    created_at    datetime     null,
    updated_at    datetime     null,
    id            int auto_increment
        primary key,
    instance_uuid varchar(255) null,
    group_id      int          not null,
    constraint instance_group_member_ibfk_1
        foreign key (group_id) references instance_groups (id)
);

create index group_id
    on instance_group_member (group_id);

create index instance_group_member_instance_idx
    on instance_group_member (instance_uuid);

create table instance_group_policy
(
    created_at datetime     null,
    updated_at datetime     null,
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

create table instance_mappings
(
    created_at    datetime     null,
    updated_at    datetime     null,
    id            int auto_increment
        primary key,
    instance_uuid varchar(36)  not null,
    cell_id       int          null,
    project_id    varchar(255) not null,
    constraint uniq_instance_mappings0instance_uuid
        unique (instance_uuid),
    constraint instance_mappings_ibfk_1
        foreign key (cell_id) references cell_mappings (id)
);

create index cell_id
    on instance_mappings (cell_id);

create index instance_uuid_idx
    on instance_mappings (instance_uuid);

create index project_id_idx
    on instance_mappings (project_id);

create table inventories
(
    created_at           datetime null,
    updated_at           datetime null,
    id                   int auto_increment
        primary key,
    resource_provider_id int      not null,
    resource_class_id    int      not null,
    total                int      not null,
    reserved             int      not null,
    min_unit             int      not null,
    max_unit             int      not null,
    step_size            int      not null,
    allocation_ratio     float    not null,
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
    id          int auto_increment
        primary key,
    name        varchar(255)                       not null,
    user_id     varchar(255)                       not null,
    fingerprint varchar(255)                       null,
    public_key  text                               null,
    type        enum ('ssh', 'x509') default 'ssh' not null,
    constraint uniq_key_pairs0user_id0name
        unique (user_id, name)
);

create table migrate_version
(
    repository_id   varchar(250) not null
        primary key,
    repository_path text         null,
    version         int          null
);

create table request_specs
(
    created_at    datetime    null,
    updated_at    datetime    null,
    id            int auto_increment
        primary key,
    instance_uuid varchar(36) not null,
    spec          mediumtext  not null,
    constraint uniq_request_specs0instance_uuid
        unique (instance_uuid)
);

create index request_spec_instance_uuid_idx
    on request_specs (instance_uuid);

create table resource_provider_aggregates
(
    created_at           datetime null,
    updated_at           datetime null,
    resource_provider_id int auto_increment,
    aggregate_id         int      not null,
    primary key (resource_provider_id, aggregate_id)
)
    charset = latin1;

create index resource_provider_aggregates_aggregate_id_idx
    on resource_provider_aggregates (aggregate_id);

create table resource_providers
(
    created_at datetime                      null,
    updated_at datetime                      null,
    id         int auto_increment
        primary key,
    uuid       varchar(36)                   not null,
    name       varchar(200) collate utf8_bin null,
    generation int                           null,
    can_host   int                           null,
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