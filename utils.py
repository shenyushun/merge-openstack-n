# -*- coding: utf-8 -*-
'''
Auth:__XsY__
CreateDate: 2019-11-13
Talk Is Cheap,Show Me The Code.
'''

import sys
#! NOTE change this path!
sys.path.insert(1,'/root/merge/merge_openstack/env/lib64/python2.7/site-packages/')
sys.path.insert(1,'/root/merge/merge_openstack/env/lib/python2.7/site-packages/')

import pandas as pd
import sqlalchemy as sql
from datetime import datetime


def get_engine(name, pswd, host, database_name, port=3306):
    """[create database engine]

    Arguments:
        name {[str]} -- [database user name]
        pswd {[str]} -- [database user password]
        host {[str]} -- [database host]
        database_name {[str]} -- [database name]

    Returns:
        [pd.Engine] -- [engine]
    """
    return sql.create_engine('mysql://%s:%s@%s:%s/%s?charset=utf8mb4' % (name, pswd, host, port, database_name))


def create_in_condition_str(condition, condition_type='int'):
    """[create IN query condition]

    Arguments:
        condition {[pd.Series]} -- [condition]
        condition_type {[pd.Series]} -- [condition_type]

    Returns:
        [str] -- [condition str]
    """
    tmp = ','.join(['%s'] * condition.count())
    if condition_type != 'int':
        condition = condition.apply(lambda x: "'%s'" % x)
    return tmp % tuple(condition)


def create_in_query_sql(table_name, column, condition):
    """[create query segment of condition 'IN']
    Eg: select * from table_name where column in (condition)

    Arguments:
        table_name {[str]} -- [table name]
        column {[str]} -- [column name]
        condition {[str]} -- [conditions]

    Returns:
        [str] -- [sql segment]
    """
    select_str = "select * from %s where %s in (%s)" % (
        table_name, column, condition)
    return select_str


def write_data_to_table(table_name, data, time_flag, engine, clear_id=True, change_time=True, primary_key='id'):
    """[write data to table]

    Arguments:
        table_name {[str]} -- [table name]
        data {[pd.DataFrame]} -- [data]
        time_flag {datetime]} -- [datetime flag to distinguish merged data and original data]
        engine {[pd.Engine]} -- [destination database engine]
        clear_id {[bool]} -- [whether clear id, default is True]
        change_time {[bool]} -- [whether change update time, default is True]
        primary_key {[str]} -- [primary key name, default is id]
    """
    if data.empty:
        print("%s is empty..." % table_name)
    else:
        print("writing data to %s..." % table_name)
        if clear_id:
            data[primary_key] = None
        if change_time:
            data.updated_at = time_flag  # NOTE modify this for next time query
        # https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.to_sql.html
        # TODO here could be optimization by param chunksize and method
        data.to_sql(table_name, engine, index=False, if_exists='append')
        print("write data to %s success" % table_name)


def merge_parent_table(old_table, new_table):
    """[merge_table]

    Arguments:
        old_table {[pd.DataFrame]} -- [old_table]
        new_table {[pd.DataFrame]} -- [new_table]

    Returns:
        [pd.DataFrame] -- [merged table]
    """
    col = old_table.columns.to_list()
    col.remove('id')
    col.remove('updated_at')
    merged_table = pd.merge(old_table, new_table, how='left', on=col)
    return merged_table


def modify_table_relation_id(data, child_col, parent_col, merged_parent_table):
    """[modify child table column value for new parent column value]

    Arguments:
        data {[pd.DataFrame]} -- [child data]
        child_col {[str]} -- [child column name]
        parent_col {[str]} -- [parent column name]
        merged_parent_table {[pd.DataFrame]} -- [merged parent table]

    Returns:
        [pd.DataFrame] -- [modified child table data]
    """
    old_col = '%s_x' % parent_col
    new_col = '%s_y' % parent_col
    merged_parent_table.drop_duplicates(subset=[old_col, ], inplace=True)
    id_map = merged_parent_table[[old_col, new_col]]
    data = data.merge(id_map, left_on=child_col, right_on=old_col)
    data[child_col] = data[new_col]
    data.drop(columns=[old_col, new_col], inplace=True)
    return data


def check_duplicated(s1, s2):
    """[check data whether duplicated]

    Arguments:
        s1 {[pd.Series]} -- [data1]
        s2 {[pd.Series]} -- [data2]

    Returns:
        [bool] -- [return True if there is duplicated data else False]
    """
    tmp = set(s1).intersection(set(s2))
    return tmp


def write_root_table(table_map_list, src_engine, dest_engine, src_data_handly=None):
    for each in table_map_list:
        clear_id = each.get('clear_id', True)
        change_time = each.get('change_time', True)
        date_col = ['created_at', 'updated_at', 'deleted_at', 'start_time',
                    'modified_at', 'finish_time'] if change_time else []
        primary_key = each.get('primary_key', 'id')
        if src_data_handly is None:
            src_data = pd.read_sql_table(
                each['table'], src_engine, parse_dates=date_col)
        else:
            src_data = src_data_handly
        if src_data.empty:
            print("%s is empty..." % each['table'])
            continue
        time_flag = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        backup_src_data = src_data.copy()
        write_data_to_table(each['table'], src_data, time_flag,
                            dest_engine, clear_id=clear_id,
                            change_time=change_time, primary_key=primary_key)
        if each.get('child', []):
            new_data = pd.read_sql(
                "select * from %s where updated_at = '%s'" % (each['table'], time_flag), dest_engine, parse_dates=date_col)
            write_child_table(each['child'], backup_src_data,
                              new_data, clear_id, src_engine, dest_engine, src_data_handly)


def write_child_table(table_map_list, parent_old_data, parent_new_data, parent_id_chenged, src_engine, dest_engine, src_data_handly=None):
    # just depend on single parent table
    if parent_id_chenged:
        merged_parent_table = merge_parent_table(
            parent_old_data, parent_new_data)
    for each in table_map_list:
        time_flag = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        data = pd.read_sql_table(each['table'], src_engine)
        if data.empty:
            print("%s is empty..." % each['table'])
            continue
        if parent_id_chenged:
            data = modify_table_relation_id(
                data, each['s_column'], each['p_column'], merged_parent_table)
        if src_data_handly is not None:
            # 如果父表经过筛选，那么子表只要和筛选后的数据关联的数据。
            # 多用于父表中2个库有重复数据过滤的情况。
            data = data[data[each['s_column']].isin(
                src_data_handly[each['p_column']])]
        write_data_to_table(each['table'], data, time_flag,
                            dest_engine,
                            clear_id=each.get('clear_id', True),
                            change_time=each.get('change_time', True),
                            primary_key=each.get('primary_key', 'id'))


def check_data_exist(engine):
    tables = pd.read_sql_query("show tables", engine)
    for each in tables.values:
        data = pd.read_sql_query(
            'select count(*) as cnt from `%s`' % each[0], engine)
        if data.cnt[0] > 0:
            print(each[0])


def merge_data_not_duplicates(table, dup_colname, src_engine, dest_engine):
    old_data = pd.read_sql_table(table['table'], src_engine)
    new_data = pd.read_sql_table(table['table'], dest_engine)
    duplicate = check_duplicated(
        old_data[dup_colname], new_data[dup_colname])
    old_data = old_data[~old_data[dup_colname].isin(duplicate)]
    write_root_table([table, ], src_engine, dest_engine,
                     src_data_handly=old_data)

if __name__ == "__main__":
    pass
