create table backups
(
    created_at            datetime     null,
    updated_at            datetime     null,
    deleted_at            datetime     null,
    deleted               tinyint(1)   null,
    id                    varchar(36)  not null
        primary key,
    volume_id             varchar(36)  not null,
    user_id               varchar(255) null,
    project_id            varchar(255) null,
    host                  varchar(255) null,
    availability_zone     varchar(255) null,
    display_name          varchar(255) null,
    display_description   varchar(255) null,
    container             varchar(255) null,
    status                varchar(255) null,
    fail_reason           varchar(255) null,
    service_metadata      varchar(255) null,
    service               varchar(255) null,
    size                  int          null,
    object_count          int          null,
    parent_id             varchar(36)  null,
    temp_volume_id        varchar(36)  null,
    temp_snapshot_id      varchar(36)  null,
    num_dependent_backups int          null,
    snapshot_id           varchar(36)  null,
    data_timestamp        datetime     null,
    restore_volume_id     varchar(36)  null
);

create table clusters
(
    created_at      datetime     null,
    updated_at      datetime     null,
    deleted_at      datetime     null,
    deleted         tinyint(1)   null,
    id              int auto_increment
        primary key,
    name            varchar(255) not null,
    `binary`        varchar(255) not null,
    disabled        tinyint(1)   null,
    disabled_reason varchar(255) null,
    race_preventer  int          not null,
    constraint name
        unique (name, `binary`, race_preventer)
);

create table consistencygroups
(
    created_at        datetime     null,
    updated_at        datetime     null,
    deleted_at        datetime     null,
    deleted           tinyint(1)   null,
    id                varchar(36)  not null
        primary key,
    user_id           varchar(255) null,
    project_id        varchar(255) null,
    host              varchar(255) null,
    availability_zone varchar(255) null,
    name              varchar(255) null,
    description       varchar(255) null,
    volume_type_id    varchar(255) null,
    status            varchar(255) null,
    cgsnapshot_id     varchar(36)  null,
    source_cgid       varchar(36)  null,
    cluster_name      varchar(255) null
);

create table cgsnapshots
(
    created_at          datetime     null,
    updated_at          datetime     null,
    deleted_at          datetime     null,
    deleted             tinyint(1)   null,
    id                  varchar(36)  not null
        primary key,
    consistencygroup_id varchar(36)  not null,
    user_id             varchar(255) null,
    project_id          varchar(255) null,
    name                varchar(255) null,
    description         varchar(255) null,
    status              varchar(255) null,
    constraint cgsnapshots_ibfk_1
        foreign key (consistencygroup_id) references consistencygroups (id)
);

create index consistencygroup_id
    on cgsnapshots (consistencygroup_id);

create table driver_initiator_data
(
    created_at datetime     null,
    updated_at datetime     null,
    id         int auto_increment
        primary key,
    initiator  varchar(255) not null,
    namespace  varchar(255) not null,
    `key`      varchar(255) not null,
    value      varchar(255) null,
    constraint initiator
        unique (initiator, namespace, `key`)
);

create index ix_driver_initiator_data_initiator
    on driver_initiator_data (initiator);

create table encryption
(
    created_at       datetime     null,
    updated_at       datetime     null,
    deleted_at       datetime     null,
    deleted          tinyint(1)   null,
    cipher           varchar(255) null,
    control_location varchar(255) not null,
    key_size         int          null,
    provider         varchar(255) not null,
    volume_type_id   varchar(36)  not null,
    encryption_id    varchar(36)  not null
        primary key
);

create table group_types
(
    id          varchar(36)  not null
        primary key,
    name        varchar(255) not null,
    description varchar(255) null,
    created_at  datetime     null,
    updated_at  datetime     null,
    deleted_at  datetime     null,
    deleted     tinyint(1)   null,
    is_public   tinyint(1)   null
);

create table group_type_projects
(
    id            int auto_increment
        primary key,
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    group_type_id varchar(36)  null,
    project_id    varchar(255) null,
    deleted       tinyint(1)   null,
    constraint group_type_id
        unique (group_type_id, project_id, deleted),
    constraint group_type_projects_ibfk_1
        foreign key (group_type_id) references group_types (id)
);

create table group_type_specs
(
    id            int auto_increment
        primary key,
    `key`         varchar(255) null,
    value         varchar(255) null,
    group_type_id varchar(36)  not null,
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    deleted       tinyint(1)   null,
    constraint group_type_specs_ibfk_1
        foreign key (group_type_id) references group_types (id)
);

create index group_type_id
    on group_type_specs (group_type_id);

create table `groups`
(
    created_at        datetime     null,
    updated_at        datetime     null,
    deleted_at        datetime     null,
    deleted           tinyint(1)   null,
    id                varchar(36)  not null
        primary key,
    user_id           varchar(255) null,
    project_id        varchar(255) null,
    cluster_name      varchar(255) null,
    host              varchar(255) null,
    availability_zone varchar(255) null,
    name              varchar(255) null,
    description       varchar(255) null,
    group_type_id     varchar(36)  null,
    status            varchar(255) null,
    group_snapshot_id varchar(36)  null,
    source_group_id   varchar(36)  null
);

create table group_snapshots
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    deleted       tinyint(1)   null,
    id            varchar(36)  not null
        primary key,
    group_id      varchar(36)  not null,
    user_id       varchar(255) null,
    project_id    varchar(255) null,
    name          varchar(255) null,
    description   varchar(255) null,
    status        varchar(255) null,
    group_type_id varchar(36)  null,
    constraint group_snapshots_ibfk_1
        foreign key (group_id) references `groups` (id)
);

create index group_id
    on group_snapshots (group_id);

create table image_volume_cache_entries
(
    image_updated_at datetime     null,
    id               int auto_increment
        primary key,
    host             varchar(255) not null,
    image_id         varchar(36)  not null,
    volume_id        varchar(36)  not null,
    size             int          not null,
    last_used        datetime     not null
);

create index ix_image_volume_cache_entries_host
    on image_volume_cache_entries (host);

create index ix_image_volume_cache_entries_image_id
    on image_volume_cache_entries (image_id);

create table messages
(
    id            varchar(36)  not null
        primary key,
    project_id    varchar(36)  not null,
    request_id    varchar(255) not null,
    resource_type varchar(36)  null,
    resource_uuid varchar(255) null,
    event_id      varchar(255) not null,
    message_level varchar(255) not null,
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    deleted       tinyint(1)   null,
    expires_at    datetime     null
);

create table migrate_version
(
    repository_id   varchar(250) not null
        primary key,
    repository_path text         null,
    version         int          null
);

create table quality_of_service_specs
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    tinyint(1)   null,
    id         varchar(36)  not null
        primary key,
    specs_id   varchar(36)  null,
    `key`      varchar(255) null,
    value      varchar(255) null,
    constraint quality_of_service_specs_ibfk_1
        foreign key (specs_id) references quality_of_service_specs (id)
);

create index specs_id
    on quality_of_service_specs (specs_id);

create table quota_classes
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    tinyint(1)   null,
    id         int auto_increment
        primary key,
    class_name varchar(255) null,
    resource   varchar(255) null,
    hard_limit int          null
);

create index ix_quota_classes_class_name
    on quota_classes (class_name);

create table quota_usages
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    deleted       tinyint(1)   null,
    id            int auto_increment
        primary key,
    project_id    varchar(255) null,
    resource      varchar(255) null,
    in_use        int          not null,
    reserved      int          not null,
    until_refresh int          null
);

create index ix_quota_usages_project_id
    on quota_usages (project_id);

create table quotas
(
    id         int auto_increment
        primary key,
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    tinyint(1)   null,
    project_id varchar(255) null,
    resource   varchar(255) not null,
    hard_limit int          null,
    allocated  int          null
);

create table reservations
(
    created_at   datetime     null,
    updated_at   datetime     null,
    deleted_at   datetime     null,
    deleted      tinyint(1)   null,
    id           int auto_increment
        primary key,
    uuid         varchar(36)  not null,
    usage_id     int          null,
    project_id   varchar(255) null,
    resource     varchar(255) null,
    delta        int          not null,
    expire       datetime     null,
    allocated_id int          null,
    constraint reservations_ibfk_1
        foreign key (usage_id) references quota_usages (id),
    constraint reservations_ibfk_2
        foreign key (allocated_id) references quotas (id)
);

create index allocated_id
    on reservations (allocated_id);

create index ix_reservations_project_id
    on reservations (project_id);

create index reservations_deleted_expire_idx
    on reservations (deleted, expire);

create index usage_id
    on reservations (usage_id);

create table services
(
    created_at             datetime     null,
    updated_at             datetime     null,
    deleted_at             datetime     null,
    deleted                tinyint(1)   null,
    id                     int auto_increment
        primary key,
    host                   varchar(255) null,
    `binary`               varchar(255) null,
    topic                  varchar(255) null,
    report_count           int          not null,
    disabled               tinyint(1)   null,
    availability_zone      varchar(255) null,
    disabled_reason        varchar(255) null,
    modified_at            datetime     null,
    rpc_current_version    varchar(36)  null,
    object_current_version varchar(36)  null,
    replication_status     varchar(36)  null,
    frozen                 tinyint(1)   null,
    active_backend_id      varchar(255) null,
    cluster_name           varchar(255) null
);

create table volume_types
(
    created_at   datetime     null,
    updated_at   datetime     null,
    deleted_at   datetime     null,
    deleted      tinyint(1)   null,
    id           varchar(36)  not null
        primary key,
    name         varchar(255) null,
    qos_specs_id varchar(36)  null,
    is_public    tinyint(1)   null,
    description  varchar(255) null,
    constraint volume_types_ibfk_1
        foreign key (qos_specs_id) references quality_of_service_specs (id)
);

create table group_volume_type_mapping
(
    created_at     datetime    null,
    updated_at     datetime    null,
    deleted_at     datetime    null,
    deleted        tinyint(1)  null,
    id             int auto_increment
        primary key,
    volume_type_id varchar(36) not null,
    group_id       varchar(36) not null,
    constraint group_volume_type_mapping_ibfk_1
        foreign key (volume_type_id) references volume_types (id),
    constraint group_volume_type_mapping_ibfk_2
        foreign key (group_id) references `groups` (id)
);

create index group_id
    on group_volume_type_mapping (group_id);

create index volume_type_id
    on group_volume_type_mapping (volume_type_id);

create table volume_type_extra_specs
(
    created_at     datetime     null,
    updated_at     datetime     null,
    deleted_at     datetime     null,
    deleted        tinyint(1)   null,
    id             int auto_increment
        primary key,
    volume_type_id varchar(36)  not null,
    `key`          varchar(255) null,
    value          varchar(255) null,
    constraint volume_type_extra_specs_ibfk_1
        foreign key (volume_type_id) references volume_types (id)
);

create table volume_type_projects
(
    id             int auto_increment
        primary key,
    created_at     datetime     null,
    updated_at     datetime     null,
    deleted_at     datetime     null,
    volume_type_id varchar(36)  null,
    project_id     varchar(255) null,
    deleted        int          null,
    constraint volume_type_id
        unique (volume_type_id, project_id, deleted),
    constraint volume_type_projects_ibfk_1
        foreign key (volume_type_id) references volume_types (id)
);

create index qos_specs_id
    on volume_types (qos_specs_id);

create table volumes
(
    created_at                  datetime     null,
    updated_at                  datetime     null,
    deleted_at                  datetime     null,
    deleted                     tinyint(1)   null,
    id                          varchar(36)  not null
        primary key,
    ec2_id                      varchar(255) null,
    user_id                     varchar(255) null,
    project_id                  varchar(255) null,
    host                        varchar(255) null,
    size                        int          null,
    availability_zone           varchar(255) null,
    status                      varchar(255) null,
    attach_status               varchar(255) null,
    scheduled_at                datetime     null,
    launched_at                 datetime     null,
    terminated_at               datetime     null,
    display_name                varchar(255) null,
    display_description         varchar(255) null,
    provider_location           varchar(256) null,
    provider_auth               varchar(256) null,
    snapshot_id                 varchar(36)  null,
    volume_type_id              varchar(36)  null,
    source_volid                varchar(36)  null,
    bootable                    tinyint(1)   null,
    provider_geometry           varchar(255) null,
    _name_id                    varchar(36)  null,
    encryption_key_id           varchar(36)  null,
    migration_status            varchar(255) null,
    replication_status          varchar(255) null,
    replication_extended_status varchar(255) null,
    replication_driver_data     varchar(255) null,
    consistencygroup_id         varchar(36)  null,
    provider_id                 varchar(255) null,
    multiattach                 tinyint(1)   null,
    previous_status             varchar(255) null,
    cluster_name                varchar(255) null,
    group_id                    varchar(36)  null,
    constraint volumes_ibfk_1
        foreign key (consistencygroup_id) references consistencygroups (id),
    constraint volumes_ibfk_2
        foreign key (group_id) references `groups` (id)
);

create table snapshots
(
    created_at          datetime     null,
    updated_at          datetime     null,
    deleted_at          datetime     null,
    deleted             tinyint(1)   null,
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
    provider_location   varchar(255) null,
    encryption_key_id   varchar(36)  null,
    volume_type_id      varchar(36)  null,
    cgsnapshot_id       varchar(36)  null,
    provider_id         varchar(255) null,
    provider_auth       varchar(255) null,
    group_snapshot_id   varchar(36)  null,
    constraint snapshots_ibfk_1
        foreign key (cgsnapshot_id) references cgsnapshots (id),
    constraint snapshots_ibfk_2
        foreign key (group_snapshot_id) references group_snapshots (id),
    constraint snapshots_volume_id_fkey
        foreign key (volume_id) references volumes (id)
);

create table snapshot_metadata
(
    created_at  datetime     null,
    updated_at  datetime     null,
    deleted_at  datetime     null,
    deleted     tinyint(1)   null,
    id          int auto_increment
        primary key,
    snapshot_id varchar(36)  not null,
    `key`       varchar(255) null,
    value       varchar(255) null,
    constraint snapshot_metadata_ibfk_1
        foreign key (snapshot_id) references snapshots (id)
);

create index snapshot_id
    on snapshot_metadata (snapshot_id);

create index cgsnapshot_id
    on snapshots (cgsnapshot_id);

create index group_snapshot_id
    on snapshots (group_snapshot_id);

create table transfers
(
    created_at   datetime     null,
    updated_at   datetime     null,
    deleted_at   datetime     null,
    deleted      tinyint(1)   null,
    id           varchar(36)  not null
        primary key,
    volume_id    varchar(36)  not null,
    display_name varchar(255) null,
    salt         varchar(255) null,
    crypt_hash   varchar(255) null,
    expires_at   datetime     null,
    constraint transfers_ibfk_1
        foreign key (volume_id) references volumes (id)
);

create index volume_id
    on transfers (volume_id);

create table volume_admin_metadata
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    tinyint(1)   null,
    id         int auto_increment
        primary key,
    volume_id  varchar(36)  not null,
    `key`      varchar(255) null,
    value      varchar(255) null,
    constraint volume_admin_metadata_ibfk_1
        foreign key (volume_id) references volumes (id)
);

create index volume_id
    on volume_admin_metadata (volume_id);

create table volume_attachment
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    deleted       tinyint(1)   null,
    id            varchar(36)  not null
        primary key,
    volume_id     varchar(36)  not null,
    attached_host varchar(255) null,
    instance_uuid varchar(36)  null,
    mountpoint    varchar(255) null,
    attach_time   datetime     null,
    detach_time   datetime     null,
    attach_mode   varchar(36)  null,
    attach_status varchar(255) null,
    constraint volume_attachment_ibfk_1
        foreign key (volume_id) references volumes (id)
);

create index volume_id
    on volume_attachment (volume_id);

create table volume_glance_metadata
(
    created_at  datetime     null,
    updated_at  datetime     null,
    deleted_at  datetime     null,
    deleted     tinyint(1)   null,
    id          int auto_increment
        primary key,
    volume_id   varchar(36)  null,
    snapshot_id varchar(36)  null,
    `key`       varchar(255) null,
    value       text         null,
    constraint volume_glance_metadata_ibfk_1
        foreign key (volume_id) references volumes (id),
    constraint volume_glance_metadata_ibfk_2
        foreign key (snapshot_id) references snapshots (id)
);

create index snapshot_id
    on volume_glance_metadata (snapshot_id);

create index volume_id
    on volume_glance_metadata (volume_id);

create table volume_metadata
(
    created_at datetime     null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    tinyint(1)   null,
    id         int auto_increment
        primary key,
    volume_id  varchar(36)  not null,
    `key`      varchar(255) null,
    value      varchar(255) null,
    constraint volume_metadata_ibfk_1
        foreign key (volume_id) references volumes (id)
);

create index volume_id
    on volume_metadata (volume_id);

create index consistencygroup_id
    on volumes (consistencygroup_id);

create index group_id
    on volumes (group_id);

create table workers
(
    created_at    datetime     null,
    updated_at    datetime     null,
    deleted_at    datetime     null,
    deleted       tinyint(1)   null,
    id            int auto_increment
        primary key,
    resource_type varchar(40)  not null,
    resource_id   varchar(36)  not null,
    status        varchar(255) not null,
    service_id    int          null,
    constraint resource_type
        unique (resource_type, resource_id),
    constraint workers_service_id_fkey
        foreign key (service_id) references services (id)
);

