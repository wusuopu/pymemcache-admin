<h3>服务器信息</h3>
		%n = 0
		%for client in clients:
			%stats = client.get_stats()
			%i = 0
			%while i < len(stats):
			<div class="accordion" id="accordion{{ n }}_{{ i }}">
				<div class="accordion-group">
					<div class="accordion-heading">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion{{ n }}_{{ i }}" href="#collapse{{ n }}_{{ i }}">{{ stats[i][0] }} &gt;&gt;&gt;</a>
					</div>
					<div id="collapse{{ n }}_{{ i }}" class="accordion-body collapse in">
						<div class="accordion-inner">
							<table class="table table-hover table-condensed">
							%for key, value in stats[i][1].items():
								<tr>
									<td>{{ key }}</td>
									<td>{{ value }}</td>
								</tr>
							%end
							</table>
						</div>
					</div>
				</div>
			</div>
				%i += 1
			%n += 1
		%end
