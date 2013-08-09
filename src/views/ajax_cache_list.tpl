<h3>缓存信息</h3>

%n = 0
%for client in clients:
	<ul class="nav nav-list">
	%i = 0
	%for server in client.servers:
		<li><a href="#" onclick="LoadCacheInfo({{ n }}, {{ i }})"; >{{ server.ip }}:{{ server.port }}&ensp;&gt;&gt;</a></li>
		%i += 1
	%end
	</ul>
	%n += 1
%end

<script type="text/javascript">
	function LoadCacheInfo(client_no, server_no) {
		$('div#right').load('/cache_info?client_no=' + client_no + '&server_no=' + server_no); 
	}
</script>
