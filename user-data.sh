#!/bin/bash
cat > index.html <<EOF
<!DOCTYPE html>
<html>
<body style="text-align:center">
	<script>
		var xhttp = new XMLHttpRequest();
		xhttp.onload = (res)=>{
			if(res.target.status == 200){
				var jj = JSON.parse(res.target.responseText);
				var ran_key = jj.message[Math.floor(Math.random() *jj.message.length)];
				document.body.innerHTML += '<img src="' + ran_key + '">'
			}
			else{
				document.body.innerHTML = "Cannot get info from dog api.";
			}
		}
		xhttp.open("GET", "https://dog.ceo/api/breed/sheepdog/shetland/images", true);
		xhttp.send();
	</script>
</body>
</html>
EOF

nohup busybox httpd -f -p 8080 &
