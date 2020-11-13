create table artifacts
(
    id                  varchar(36)  not null
        primary key,
    name                varchar(255) not null,
    type_name           varchar(255) not null,
    type_version_prefix bigint       not null,
    type_version_suffix varchar(255) null,
    type_version_meta   varchar(255) null,
    version_prefix      bigint       not null,
    version_suffix      varchar(255) null,
    version_meta        varchar(255) null,
    description         text         null,
    visibility          varchar(32)  not null,
    state               varchar(32)  not null,
    owner               varchar(255) not null,
    created_at          datetime     not null,
    updated_at          datetime     not null,
    deleted_at          datetime     null,
    published_at        datetime     null
);

create table artifact_blobs
(
    id          varchar(36)  not null
        primary key,
    artifact_id varchar(36)  not null,
    size        bigint       not null,
    checksum    varchar(32)  null,
    name        varchar(255) not null,
    item_key    varchar(329) null,
    position    int          null,
    created_at  datetime     not null,
    updated_at  datetime     not null,
    constraint artifact_blobs_ibfk_1
        foreign key (artifact_id) references artifacts (id)
);

create table artifact_blob_locations
(
    id         varchar(36) not null
        primary key,
    blob_id    varchar(36) not null,
    value      text        not null,
    created_at datetime    not null,
    updated_at datetime    not null,
    position   int         null,
    status     varchar(36) null,
    constraint artifact_blob_locations_ibfk_1
        foreign key (blob_id) references artifact_blobs (id)
);

create index ix_artifact_blob_locations_blob_id
    on artifact_blob_locations (blob_id);

create index ix_artifact_blobs_artifact_id
    on artifact_blobs (artifact_id);

create index ix_artifact_blobs_name
    on artifact_blobs (name);

create table artifact_dependencies
(
    id              varchar(36) not null
        primary key,
    artifact_source varchar(36) not null,
    artifact_dest   varchar(36) not null,
    artifact_origin varchar(36) not null,
    is_direct       tinyint(1)  not null,
    position        int         null,
    name            varchar(36) null,
    created_at      datetime    not null,
    updated_at      datetime    not null,
    constraint artifact_dependencies_ibfk_1
        foreign key (artifact_source) references artifacts (id),
    constraint artifact_dependencies_ibfk_2
        foreign key (artifact_dest) references artifacts (id),
    constraint artifact_dependencies_ibfk_3
        foreign key (artifact_origin) references artifacts (id)
);

create index ix_artifact_dependencies_dest_id
    on artifact_dependencies (artifact_dest);

create index ix_artifact_dependencies_direct_dependencies
    on artifact_dependencies (artifact_source, is_direct);

create index ix_artifact_dependencies_origin_id
    on artifact_dependencies (artifact_origin);

create index ix_artifact_dependencies_source_id
    on artifact_dependencies (artifact_source);

create table artifact_properties
(
    id            varchar(36)  not null
        primary key,
    artifact_id   varchar(36)  not null,
    name          varchar(255) not null,
    string_value  varchar(255) null,
    int_value     int          null,
    numeric_value decimal      null,
    bool_value    tinyint(1)   null,
    text_value    text         null,
    created_at    datetime     not null,
    updated_at    datetime     not null,
    position      int          null,
    constraint artifact_properties_ibfk_1
        foreign key (artifact_id) references artifacts (id)
);

create index ix_artifact_properties_artifact_id
    on artifact_properties (artifact_id);

create index ix_artifact_properties_name
    on artifact_properties (name);

create table artifact_tags
(
    id          varchar(36)  not null
        primary key,
    artifact_id varchar(36)  not null,
    value       varchar(255) not null,
    created_at  datetime     not null,
    updated_at  datetime     not null,
    constraint artifact_tags_ibfk_1
        foreign key (artifact_id) references artifacts (id)
);

create index ix_artifact_tags_artifact_id
    on artifact_tags (artifact_id);

create index ix_artifact_tags_artifact_id_tag_value
    on artifact_tags (artifact_id, value);

create index ix_artifact_name_and_version
    on artifacts (name, version_prefix, version_suffix);

create index ix_artifact_owner
    on artifacts (owner);

create index ix_artifact_state
    on artifacts (state);

create index ix_artifact_type
    on artifacts (type_name, type_version_prefix, type_version_suffix);

create index ix_artifact_visibility
    on artifacts (visibility);

create table images
(
    id               varchar(36)          not null
        primary key,
    name             varchar(255)         null,
    size             bigint               null,
    status           varchar(30)          not null,
    is_public        tinyint(1)           not null,
    created_at       datetime             not null,
    updated_at       datetime             null,
    deleted_at       datetime             null,
    deleted          tinyint(1)           not null,
    disk_format      varchar(20)          null,
    container_format varchar(20)          null,
    checksum         varchar(32)          null,
    owner            varchar(255)         null,
    min_disk         int                  not null,
    min_ram          int                  not null,
    protected        tinyint(1) default 0 not null,
    virtual_size     bigint               null
);

create table image_locations
(
    id         int auto_increment
        primary key,
    image_id   varchar(36)                  not null,
    value      text                         not null,
    created_at datetime                     not null,
    updated_at datetime                     null,
    deleted_at datetime                     null,
    deleted    tinyint(1)                   not null,
    meta_data  text                         null,
    status     varchar(30) default 'active' not null,
    constraint image_locations_ibfk_1
        foreign key (image_id) references images (id)
);

create index ix_image_locations_deleted
    on image_locations (deleted);

create index ix_image_locations_image_id
    on image_locations (image_id);

create table image_members
(
    id         int auto_increment
        primary key,
    image_id   varchar(36)                   not null,
    member     varchar(255)                  not null,
    can_share  tinyint(1)                    not null,
    created_at datetime                      not null,
    updated_at datetime                      null,
    deleted_at datetime                      null,
    deleted    tinyint(1)                    not null,
    status     varchar(20) default 'pending' not null,
    constraint image_members_image_id_member_deleted_at_key
        unique (image_id, member, deleted_at),
    constraint image_members_ibfk_1
        foreign key (image_id) references images (id)
);

create index ix_image_members_deleted
    on image_members (deleted);

create index ix_image_members_image_id
    on image_members (image_id);

create index ix_image_members_image_id_member
    on image_members (image_id, member);

create table image_properties
(
    id         int auto_increment
        primary key,
    image_id   varchar(36)  not null,
    name       varchar(255) not null,
    value      text         null,
    created_at datetime     not null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    tinyint(1)   not null,
    constraint ix_image_properties_image_id_name
        unique (image_id, name),
    constraint image_properties_ibfk_1
        foreign key (image_id) references images (id)
);

create index ix_image_properties_deleted
    on image_properties (deleted);

create index ix_image_properties_image_id
    on image_properties (image_id);

create table image_tags
(
    id         int auto_increment
        primary key,
    image_id   varchar(36)  not null,
    value      varchar(255) not null,
    created_at datetime     not null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    tinyint(1)   not null,
    constraint image_tags_ibfk_1
        foreign key (image_id) references images (id)
);

create index ix_image_tags_image_id
    on image_tags (image_id);

create index ix_image_tags_image_id_tag_value
    on image_tags (image_id, value);

create index checksum_image_idx
    on images (checksum);

create index created_at_image_idx
    on images (created_at);

create index ix_images_deleted
    on images (deleted);

create index ix_images_is_public
    on images (is_public);

create index owner_image_idx
    on images (owner);

create index updated_at_image_idx
    on images (updated_at);

create table metadef_namespaces
(
    id           int auto_increment
        primary key,
    namespace    varchar(80)  not null,
    display_name varchar(80)  null,
    description  text         null,
    visibility   varchar(32)  null,
    protected    tinyint(1)   null,
    owner        varchar(255) not null,
    created_at   datetime     not null,
    updated_at   datetime     null,
    constraint uq_metadef_namespaces_namespace
        unique (namespace)
);

create index ix_metadef_namespaces_owner
    on metadef_namespaces (owner);

create table metadef_objects
(
    id           int auto_increment
        primary key,
    namespace_id int         not null,
    name         varchar(80) not null,
    description  text        null,
    required     text        null,
    json_schema  text        not null,
    created_at   datetime    not null,
    updated_at   datetime    null,
    constraint uq_metadef_objects_namespace_id_name
        unique (namespace_id, name),
    constraint metadef_objects_fk_1
        foreign key (namespace_id) references metadef_namespaces (id)
);

create index ix_metadef_objects_name
    on metadef_objects (name);

create table metadef_properties
(
    id           int auto_increment
        primary key,
    namespace_id int         not null,
    name         varchar(80) not null,
    json_schema  text        not null,
    created_at   datetime    not null,
    updated_at   datetime    null,
    constraint uq_metadef_properties_namespace_id_name
        unique (namespace_id, name),
    constraint metadef_properties_fk_1
        foreign key (namespace_id) references metadef_namespaces (id)
);

create index ix_metadef_properties_name
    on metadef_properties (name);

create table metadef_resource_types
(
    id         int auto_increment
        primary key,
    name       varchar(80) not null,
    protected  tinyint(1)  not null,
    created_at datetime    not null,
    updated_at datetime    null,
    constraint uq_metadef_resource_types_name
        unique (name)
);

create table metadef_namespace_resource_types
(
    resource_type_id  int         not null,
    namespace_id      int         not null,
    properties_target varchar(80) null,
    prefix            varchar(80) null,
    created_at        datetime    not null,
    updated_at        datetime    null,
    primary key (resource_type_id, namespace_id),
    constraint metadef_namespace_resource_types_ibfk_1
        foreign key (resource_type_id) references metadef_resource_types (id),
    constraint metadef_namespace_resource_types_ibfk_2
        foreign key (namespace_id) references metadef_namespaces (id)
);

create index ix_metadef_ns_res_types_namespace_id
    on metadef_namespace_resource_types (namespace_id);

create table metadef_tags
(
    id           int auto_increment
        primary key,
    namespace_id int         not null,
    name         varchar(80) not null,
    created_at   datetime    not null,
    updated_at   datetime    null,
    constraint uq_metadef_tags_namespace_id_name
        unique (namespace_id, name),
    constraint metadef_tags_fk_1
        foreign key (namespace_id) references metadef_namespaces (id)
);

create index ix_metadef_tags_name
    on metadef_tags (name);

create table tasks
(
    id         varchar(36)  not null
        primary key,
    type       varchar(30)  not null,
    status     varchar(30)  not null,
    owner      varchar(255) not null,
    expires_at datetime     null,
    created_at datetime     not null,
    updated_at datetime     null,
    deleted_at datetime     null,
    deleted    tinyint(1)   not null
);

create table task_info
(
    task_id varchar(36) not null
        primary key,
    input   text        null,
    result  text        null,
    message text        null,
    constraint task_info_ibfk_1
        foreign key (task_id) references tasks (id)
);

create index ix_tasks_deleted
    on tasks (deleted);

create index ix_tasks_owner
    on tasks (owner);

create index ix_tasks_status
    on tasks (status);

create index ix_tasks_type
    on tasks (type);

create index ix_tasks_updated_at
    on tasks (updated_at);