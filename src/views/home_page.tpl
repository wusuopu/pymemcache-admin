<html>
<head>
%include header title='memcache admin'
</head>

<body>
	<br />
	<br />
		<form class="form-horizontal" action="" method="post">
		<div clss="control-group error">
			<label class="control-label" for="server">Server:</label>
			<div class="controls">
				<input name="server_info" id="server_info" type="text" placeholder="ip1:port1,ip2:port2" /> 
				% if defined('error'):
				<span class="help-inline">请输入服务器地址，格式为ip:port，多个地址用逗号','隔开。</span>
				% end
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
				<input class="btn" type="submit" value="OK" />
			</div>
		</div>
		</form>
</body>
</html>
