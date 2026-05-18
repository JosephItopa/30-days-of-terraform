provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "web_server_example" {
        ami                     = "ami-00eb69d236edcfaf8"
        instance_type           = "t2.micro"
        vpc_security_group_ids  = [aws_security_group.instance.id]
        user_data = <<-EOF
                    #!/bin/bash
                    yum install busybox -y
                    echo "Hello, World" > index.html
                    nohup busybox httpd -f -p 8080 &
                    EOF

        tags = {
                Name = "web_server_example"
        } 
}

resource "aws_security_group" "instance" {
        name = "security_group_instance"

        ingress {
            from_port   = 8080
            to_port     = 8080
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
        
        egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
}