terraform {
	required_version = ">= 1.0.0, < 2.0.0"

	required_providers {
	  aws = {
		source = "hashicorp/aws"
		version = "~> 4.0"
	  }
	}
}

provider "aws" {
	region = "us-east-2"
}

resource "aws_security_group" "instance" {
	name = "terraform-example-instance"

	ingress {
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
}

resource "aws_instance" "example"{
	ami = "ami-0fb653ca2d3203ac1"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.instance.id]

	user_data = <<-EOF
				#!/bin/bash
				printf "<html><body style=\"text-align:center\">	<script>var xhttp = new XMLHttpRequest();\n		xhttp.onload =(res)=>{\n			if(res.target.status == 200){\n				var jj = JSON.parse(res.target.responseText);\n	var random_dog = jj.message[Math.floor(Math.random() *jj.message.length)];\n	document.body.innerHTML += '<img height=\"600\" src=\"' + random_dog + '\">';\n}\nelse{\ndocument.body.innerHTML = \"Cannot get info from dog api.\";\n}\n}\nxhttp.open(\"GET\", \"https://dog.ceo/api/breed/sheepdog/shetland/images\", true);xhttp.send();</script></body></html>" >> index.html
				nohup busybox httpd -f -p 8080 &
				EOF

	user_data_replace_on_change = true

	tags = {
		Name = "First Terraform"
	}
}