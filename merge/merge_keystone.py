# -*- coding: utf-8 -*-

'''
Auth:__XsY__
CreateDate: 2019-12-31
Talk Is Cheap,Show Me The Code.
'''

from utils import *

SRC_ENGINE = get_engine('keystone', 'keystone123', '100.69.6.88', 'keystone')
DEST_ENGINE = get_engine('keystone', 'keystone123', '100.69.6.94', 'keystone')

KEYSTONE_TABLES = [
    {"table": "project", 'clear_id': False, 'change_time': False},
    # {"table": "credential", 'clear_id': False, 'change_time': False},
    # {"table": "user", 'clear_id': False, 'change_time': False},
    # {"table": "local_user", 'clear_id': False, 'change_time': False},
    # {"table": "password", 'clear_id': False, 'change_time': False},
    # {"table": "nonlocal_user", 'clear_id': False, 'change_time': False},
    # {"table": "role", 'clear_id': False, 'change_time': False},
    # {"table": "consumer", 'clear_id': False, 'change_time': False},
    # {"table": "request_token", 'clear_id': False, 'change_time': False},
    # {"table": "access_token", 'clear_id': False, 'change_time': False},
    # {"table": "identity_provider", 'clear_id': False, 'change_time': False},
    # {"table": "federation_protocol", 'clear_id': False, 'change_time': False},
    # {"table": "idp_remote_ids", 'clear_id': False, 'change_time': False},
    # {"table": "service_provider", 'clear_id': False, 'change_time': False},
    # {"table": "mapping", 'clear_id': False, 'change_time': False},
    # {"table": "group", 'clear_id': False, 'change_time': False},
    # {"table": "user_group_membership", 'clear_id': False, 'change_time': False},
    # {"table": "trust", 'clear_id': False, 'change_time': False},
    # {"table": "trust_role", 'clear_id': False, 'change_time': False},
    # {"table": "implied_role", 'clear_id': False, 'change_time': False},
    # {"table": "token", 'clear_id': False, 'change_time': False},
    # {"table": "trust", 'clear_id': False, 'change_time': False},
    # {"table": "service", 'clear_id': False, 'change_time': False},
    # {"table": "region", 'clear_id': False, 'change_time': False},
    # {"table": "policy", 'clear_id': False, 'change_time': False},
    # {"table": "policy_association", 'clear_id': False, 'change_time': False},
    # {"table": "endpoint", 'clear_id': False, 'change_time': False}, 
    # {"table": "project_endpoint", 'clear_id': False, 'change_time': False}, 
    # {"table": "endpoint_group", 'clear_id': False, 'change_time': False},
    # {"table": "project_endpoint_group", 'clear_id': False, 'change_time': False},
    # {"table": "whitelisted_config", 'clear_id': False, 'change_time': False},
    # {"table": "sensitive_config", 'clear_id': False, 'change_time': False},
    # {"table": "config_register", 'clear_id': False, 'change_time': False},
    # {"table": "id_mapping", 'clear_id': False, 'change_time': False},
    # {"table": "assignment", 'clear_id': False, 'change_time': False},
    # {"table": "federated_user", 'clear_id': True, 'change_time': False},
    # {"table": "revocation_event", 'clear_id': True, 'change_time': False},
]


def merge_keystone(tables):
    for table in tables:
        old_data = pd.read_sql_table(table['table'], SRC_ENGINE)
        new_data = pd.read_sql_table(table['table'], DEST_ENGINE)
        data = pd.concat([new_data, old_data], ignore_index=True)
        data.drop_duplicates(subset=['id',], inplace=True)
        if data.empty:
            print("%s is empty..." % table['table'])
        else:
            data.to_sql(table['table'], DEST_ENGINE, index=False, if_exists='replace')
            print("write data to %s success" % table['table'])


if __name__ == "__main__":
    check_data_exist(SRC_ENGINE)
    merge_keystone(KEYSTONE_TABLES)
    print("Finish merge!")
