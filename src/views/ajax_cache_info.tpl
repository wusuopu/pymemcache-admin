%if defined('client_no') and defined('server_no'):
	%client_no = int(client_no)
	%server_no = int(server_no)
	%if client_no < len(clients) and server_no < len(clients[client_no].servers):
		%client = clients[client_no]
		%server = client.servers[server_no]
		<div>
			<a href="#" onclick='LoadCacheInfo();' >缓存信息</a>&ensp;&gt;&gt;&gt;&ensp;{{ server.ip }}:{{ server.port }}
		 
		</div>
		%all_slabs = client.get_slabs_list()
		%print all_slabs
		%for slabs in all_slabs:
			%for cache in client.get_cachedump_stats(int(slabs)):
				<table class="table table-bordered table-striped table-hover">
					<thead>
						<th>key</th>
						<th>value</th>
						<th>value_type</th>
						<th>slabs</th>
					</thead>
					<tbody>
				%for key in cache[1]:
					<tr>
						<td>{{ key }}</td>
						%value = client.get_value(key)
						<td>{{ value }}</td>
						%value_type = type(value)
						<td>{{ value_type }}</td>
						<td>{{ slabs }}</td>
					</tr>
				%end
					</tbody>
				</table>
			%end
		%end
	%end
<script type="text/javascript">
	function LoadCacheInfo() {
		$('div#right').load('/cache_list'); 
	}
</script>
%end
