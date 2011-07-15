<script src="include/jquery.htmlstream.js"></script>
<script>
	/* ajax updater */
	function updateEnd(data){
		//$("#updatepopup .panel_text").html(data);
		$("#remoteupdate_form").find("input").removeAttr('disabled');
		$(".panel_action_close").fadeIn()	
	}
	function updateOn(data){
		
		var patt=/§([^§]*)§/g; 
		var matches = data.match(patt);
		$(matches).each(function(id,data){
			data = data.replace(/§/g,"");
			d = data.split("@");
			console.log(d);
			elm = $("#updatepopup .panel_text #"+d[0]);
			html = "<div id='"+d[0]+"' class='progress'>"+d[1]+"<span>"+d[2]+"</span></div>";
			if (elm.length==0){
				$("#updatepopup .panel_text").append(html);
			} else {
				$(elm).replaceWith(html);
			}
		});
		
		
	}
	
	$(function(){
		$("#remoteupdate_form").submit(function(){
			var data={};
			$(this).find("input").each(function(i, e){
				name = $(e).attr('name');
				value = $(e).val();
				e.disabled = true;
				data[name]=value;
			});

			$("#updatepopup .panel_text").html("");
			$("#updatepopup").show();
			$("#updatepopup .panel").hide().slideDown(500);
			$(".panel_action_close").hide().click(function(){
				$("#updatepopup .panel").slideUp(500, function(){
					$("#updatepopup").hide();
				});				
			});

			$.post(
				$(this).attr('action'), 
				data, 
				updateEnd,
				'text',
				updateOn
			);

			
			return false;
		})
	});
</script>
<div id="updatepopup" class="popup">
	<div class="background"></div>
	<div class="panel">
		<div class="panel_in">
			<h1>Friendika Update</h1>
			<div class="panel_text"></div>
			<div class="panel_actions">
				<input type="button" value="$close" class="panel_action_close">
			</div>
		</div>
	</div>
</div>
<div id="adminpage">
	<dl> <dt>Your version:</dt><dd>$localversion</dd> </dl>
{{ if $needupdate }}
	<dl> <dt>New version:</dt><dd>$remoteversion</dd> </dl>

	<form id="remoteupdate_form" method="POST" action="$baseurl/admin/update">
	<input type="hidden" name="$remotefile.0" value="$remotefile.2">

	{{ if $canwrite }}
		<div class="submit"><input type="submit" name="remoteupdate" value="$submit" /></div>
	{{ else }}
		<h3>Your friendika installation is not writable by web server.</h3>
		{{ if $canftp }}
			<p>You can try to update via FTP</p>
			{{ inc field_input.tpl with $field=$ftphost }}{{ endinc }}
			{{ inc field_input.tpl with $field=$ftppath }}{{ endinc }}
			{{ inc field_input.tpl with $field=$ftpuser }}{{ endinc }}
			{{ inc field_password.tpl with $field=$ftppwd }}{{ endinc }}
			<div class="submit"><input type="submit" name="remoteupdate" value="$submit" /></div>
		{{ endif }}
	{{ endif }}
	</form>
{{ else }}
<h4>No updates</h4>
{{ endif }}
</div>
