<html>
%include header title='memcache admin'
<body>
<a name="top"></a>
<div class="container-fluid">
	<div class="row-fluid">
		<div id="left" class="span2" style="position:absolute;">
		<ul class="nav nav-list">
			<li class="active"><a id="server_info" href='#'>服务器信息</a></li>
			<li><a id="cache_list" href='#'>缓存信息</a></li>
			<li><a id="server_list" href='#'>服务器列表</a></li>
			<li><a href='#top'>返回顶部</a></li>
		</ul>
		<div id="log"></div>
		</div>
		<div id="right" class="span7" style="position:absolute; left:230px;">
		%include ajax_server_info clients=clients
		</div>


	</div>
</div>
</body>
<script language="javascript">
	$(document).ready(function(){
		var menuYloc = $(".span2").offset().top;
		$(window).scroll(function (){
			var offsetTop = menuYloc + $(window).scrollTop() +"px";
			$(".span2").animate({top : offsetTop },{ duration:300 , queue:false });
		});
	});

	$("a#server_info").click(function() {
		$('div#right').load('/server_info'); 
		$('div#left>ul>li.active').removeClass('active');
		$("a#server_info").parent().addClass('active');
	});
	$("a#server_list").click(function() {
		$('div#right').load('/server_list'); 
		$('div#left>ul>li.active').removeClass('active');
		$("a#server_list").parent().addClass('active');
	});
	$("a#cache_list").click(function() {
		$('div#right').load('/cache_list'); 
		$('div#left>ul>li.active').removeClass('active');
		$("a#cache_list").parent().addClass('active');
	});
</script> 
</html>
