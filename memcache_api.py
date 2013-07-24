#!/usr/bin/env python
#-*- coding:utf-8 -*-

# Copyright (C) 
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
# 2013 - Long Changjin <admin@longchangjin.cn>

import memcache


class Client(object):
    def __init__(self, servers, **kwargs):
        super(Client, self).__init__()
        self.servers = servers
        self.client = memcache.Client(servers, **kwargs)

    def get_slabs_list(self):
        slabs = self.client.get_slabs()
        slabs_list = []
        for dt in slabs:
            slabs_list += dt[1].keys()
        return set(slabs_list)

    def get_stats(self):
        return self.client.get_stats()

    def get_cachedump_stats(self, slabs_id, limit_num=0):
        '''
        获取缓存转储
        根据slab_id输出相同的slab_id中的item信息
        limit_num表示获取多少条记录，0为不限制。
        '''
        return self.client.get_stats('cachedump %d %d' % (slabs_id, limit_num))

    def set_value(self, key, value):
        return self.client.set(key, value)

    def get_value(self, key):
        return self.client.get(key)

if __name__ == '__main__':
    client = Client(['localhost:11211'])
    all_slabs = client.get_slabs_list()
    # 遍历所有的值
    for slabs in all_slabs:
        for cache in client.get_cachedump_stats(int(slabs)):
            print cache[0]
            for key in cache[1]:
                print '\t', key, client.get_value(key)
