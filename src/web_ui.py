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
# along with this program; If not, see <http://www.gnu.org/licenses/>.
# 
# 2013 - Long Changjin <admin@longchangjin.cn>

from bottle import (route, run, request, template,
                    static_file, error, redirect)
import os
from memcache_api import Client
import memcache
import json

ROOT_PATH = os.path.dirname(os.path.realpath(__file__))
MEMCACHE_CLIENT = []


@route('/')
@route('/', method="POST")
def home_page():
    context = {}
    if request.method == 'POST':
        server_info = request.POST.get('server_info')
        if not server_info:
            context['error'] = True
        else:
            try:
                servers = server_info.split(',')
                global MEMCACHE_CLIENT
                MEMCACHE_CLIENT = []
                for server in servers:
                    client = Client([server])
                    MEMCACHE_CLIENT.append(client)
            except Exception, e:
                print e
                context['error'] = True
        if 'error' in context:
            return template('home_page', **context)
        redirect('/main')
    return template('home_page', **context)


@route('/static/<filename:path>')
def server_static(filename):
    return static_file(filename, root="%s/static_files" % ROOT_PATH)


@route('/server_info')
@route('/server_list')
@route('/cache_list')
@route('/cache_info')
@route('/main')
def main_page():
    temp = {
        '/main': 'main_page',
        '/server_info': 'ajax_server_info',
        '/server_list': 'ajax_server_list',
        '/cache_list': 'ajax_cache_list',
        '/cache_info': 'ajax_cache_info',
    }
    extra_context = {}
    extra_context.update(request.GET)
    extra_context['clients'] = MEMCACHE_CLIENT
    return template(temp[request.path], **extra_context)


@route('/set_server', method="POST")
def set_server():
    ip = request.POST.get('ip')
    port = request.POST.get('port')
    num = int(request.POST.get("num", -1))
    result = {}
    if num < 0 or num >= len(MEMCACHE_CLIENT) or not ip or not port:
        result['status'] = False
        result['msg'] = "参数错误"
    else:
        try:
            host = memcache._Host("%s:%s" % (ip, port))
            i = 0
            while i < len(MEMCACHE_CLIENT[num].servers):
                MEMCACHE_CLIENT[num].servers.pop()
            MEMCACHE_CLIENT[num].servers.append(host)
            result['status'] = True
            result['msg'] = ''
        except (ValueError, TypeError):
            result['status'] = False
            result['msg'] = "参数错误"
        except Exception, e:
            result['status'] = False
            result['msg'] = str(e)
    return json.dumps(result)


@route('/del_server')
def del_server():
    num = int(request.GET.get("num", -1))
    result = {}
    if num < 0 or num >= len(MEMCACHE_CLIENT):
        result['status'] = False
        result['msg'] = "num参数错误"
    else:
        try:
            MEMCACHE_CLIENT[num].disconnect_all()
            del MEMCACHE_CLIENT[num]
            result['status'] = True
            result['msg'] = ''
        except Exception, e:
            result['status'] = False
            result['msg'] = str(e)
    return json.dumps(result)


@route('/add_server', method="POST")
def add_server():
    ip = request.POST.get('ip')
    port = request.POST.get('port')
    result = {}
    if not ip or not port:
        result['status'] = False
        result['msg'] = "参数错误"
    else:
        try:
            client = Client(["%s:%s" % (ip, port)])
            MEMCACHE_CLIENT.append(client)
            result['status'] = True
            result['msg'] = {'ip': ip, 'port': port}
        except (ValueError, TypeError):
            result['status'] = False
            result['msg'] = "参数错误"
        except Exception, e:
            result['status'] = False
            result['msg'] = str(e)
    return json.dumps(result)


@error(404)
def error404(error):
    return "Not Found!"

if __name__ == '__main__':
    run(host='localhost', port=8080, debug=True)
