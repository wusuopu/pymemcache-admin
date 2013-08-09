<h3>服务器列表</h3>

		<table class="table table-bordered table-striped table-hover">
			<thead>
				<th>主机</th>
				<th>端口</th>
				<th>操作</th>
			</thead>
			<tbody>
%i = 0
%for client in clients:
	% if client.servers:
		% server = client.servers[0]
			<tr id="table_tr{{ i }}">
				<td><input id="server{{ i }}" type="text" value="{{ server.ip }}" readonly=true /></td>
				<td><input id="port{{ i }}" type="text" value="{{ server.port }}" readonly=true /></td>
				<td>
					<a class="btn btn-primary" onclick="ChangeServerInfo(this, {{ i }})"; >修改</a>
					<a class="btn btn-danger" onclick="DeleteServerInfo({{ i }})"; >删除</a>
					<a class="btn btn-primary" style="display:none;" onclick="ConfirmChangeServerInfo({{ i }})"; >确定</a>
					<a class="btn btn-info" style="display:none;" onclick="CancelChangeServerInfo(this, {{ i }})"; >取消</a>
				</td>
			</tr>
		%i += 1
	%end
%end
			</tbody>
		</table>
		<table class="table table-striped table-hover">
			<tr>
				<td><input id="new_host" type="text" /></td>
				<td><input id="new_port" type="text" /></td>
				<td><a class="btn btn-success" onclick="AddServerInfo()";>添加</a> </td>
			</tr>
		</table>

<script type="text/javascript">
	$('#new_host').keypress(function(event) { if(event.keyCode==13) {$('table>tbody>tr>td>a.btn-success').click();} });
	$('#new_port').keypress(function(event) { if(event.keyCode==13) {$('table>tbody>tr>td>a.btn-success').click();} });
	var ajax_operation_id_num;
	// 修改服务器列表
	function ChangeServerInfo(obj, id_num) {
		ChangeButtonDisplay(obj);
		ChangeInputReadOnly(id_num, false);
		SaveInputValue(id_num);
	}
	// 删除服务器列表
	function DeleteServerInfo(id_num) {
		var res = confirm("是否确定要删除该条信息？");
		if ( res ) {
			var num = $('tr#table_tr' + id_num).index();
			ajax_operation_id_num = id_num;
			$.ajax({
				url: '/del_server?num=' + num,
				success: ajax_del_server_success,
				dataType: 'json',
			});
		}
	}
	function ajax_del_server_success(data, textStatus, jqXHR) {
		if (textStatus == "success") {
			if (data.status) {
				$('tr#table_tr' + ajax_operation_id_num).remove();
			} else {
				alert("错误："+ data.msg);
			}
		}
	}
	// 确定修改
	function ConfirmChangeServerInfo(id_num) {
		ajax_operation_id_num = id_num;
		var ip = $('input#server' + id_num)[0].value;
		var port = $('input#port' + id_num)[0].value;
		if (!ip) {
			alert("请输入正确的主机名！");
			return;
		}
		if (! /^\d{1,5}$/.test(port)) {
			alert("请输入正确的端口号！");
			return;
		}
		$.ajax({
			type: 'POST',
			url: '/set_server',
			data: {
				'ip': ip,
				'port': port,
				'num': $('tr#table_tr' + id_num).index(),
				},
			success: ajax_set_server_success,
			dataType: 'json',
		});
	}
	function ajax_set_server_success(data, textStatus, jqXHR) {
		if (textStatus == "success") {
			if (data.status) {
				ChangeButtonDisplay($('tr#table_tr' + ajax_operation_id_num + '>td>a')[2]);
				ChangeInputReadOnly(ajax_operation_id_num, true);
			} else {
				alert("错误："+ data.msg);
			}
		}
	}
	// 取消修改
	function CancelChangeServerInfo(obj, id_num) {
		ChangeButtonDisplay(obj);
		ChangeInputReadOnly(id_num, true);
		RestoreInputValue(id_num);
	}

	// 保存旧的值
	function SaveInputValue(id_num) {
		$('input#server' + id_num).data('value', $('input#server' + id_num).val());
		$('input#port' + id_num).data('value', $('input#port' + id_num).val());
	}
	// 恢复之前的值
	function RestoreInputValue(id_num) {
		$('input#server' + id_num)[0].value = $('input#server' + id_num).data('value');
		$('input#port' + id_num)[0].value = $('input#port' + id_num).data('value');
	}

	// 修改输入框只读属性
	function ChangeInputReadOnly(id_num, readOnly) {
		$('input#server' + id_num)[0].readOnly=readOnly;
		$('input#port' + id_num)[0].readOnly=readOnly;
	}
	// 修改按钮可见状态
	function ChangeButtonDisplay(obj) {
		var bts = obj.parentNode.children;
		var i = 0;
		while (i < bts.length) {
			if ( bts[i].style.display == "none" ) {
				bts[i].style.display = "";
			} else {
				bts[i].style.display = "none";
			}
			i++;
		}
	}
	// 添加新的服务器信息
	function AddServerInfo() {
		var ip = document.getElementById('new_host').value;
		var port = document.getElementById('new_port').value;
		if (!ip) {
			alert("请输入正确的主机名！");
			return;
		}
		if (! /^\d{1,5}$/.test(port)) {
			alert("请输入正确的端口号！");
			return;
		}
		$.ajax({
			type: 'POST',
			url: '/add_server',
			data: {
				'ip': ip,
				'port': port,
				},
			success: ajax_add_server_success,
			dataType: 'json',
		});
	}
	function ajax_add_server_success(data, textStatus, jqXHR) {
		console.log(data);
		console.log(data.msg.ip);
		console.log(data.msg.port);
		document.getElementById('new_host').value = '';
		document.getElementById('new_port').value = '';
		if (textStatus == "success" && data.status) {
			var tr = $('table.table-bordered>tbody>tr').last();
			if (tr.length) {
				var num = parseInt(/\d+$/.exec(tr[0].id)[0]);
				num++;
				var new_tr = $("<tr id='table_tr" + num + "'>/tr>").insertAfter(tr)[0];
				new_tr.innerHTML = "<td><input id='server" + num + "' type='text' value='" + data.msg.ip + "' readonly=true /></td> <td><input id='port" + num + "' type='text' value='" + data.msg.port + "' readonly=true /></td> <td> <a class='btn btn-primary' onclick='ChangeServerInfo(this, " + num + ")'; >修改</a> <a class='btn btn-danger' onclick='DeleteServerInfo(" + num + ")'; >删除</a> <a class='btn btn-primary' style='display:none;' onclick='ConfirmChangeServerInfo(" + num + ")'; >确定</a> <a class='btn btn-info' style='display:none;' onclick='CancelChangeServerInfo(this, " + num + ")'; >取消</a> </td>"
			} else {
				var num = 0;
				var tbody = $('table.table-bordered>tbody');
				tbody[0].innerHTML = "<tr id='table_tr" + num + "'><td><input id='server" + num + "' type='text' value='" + data.msg.ip + "' readonly=true /></td> <td><input id='port" + num + "' type='text' value='" + data.msg.port + "' readonly=true /></td> <td> <a class='btn btn-primary' onclick='ChangeServerInfo(this, " + num + ")'; >修改</a> <a class='btn btn-danger' onclick='DeleteServerInfo(" + num + ")'; >删除</a> <a class='btn btn-primary' style='display:none;' onclick='ConfirmChangeServerInfo(" + num + ")'; >确定</a> <a class='btn btn-info' style='display:none;' onclick='CancelChangeServerInfo(this, " + num + ")'; >取消</a> </td></tr>"
			}
		}
	}
</script>
