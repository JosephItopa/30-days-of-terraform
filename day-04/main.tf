provider "aws" {
    region = "us-east-2"
}

variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default     = 8080
}

resource "aws_instance" "web_server_example" {
        ami                     = "ami-00eb69d236edcfaf8"
        instance_type           = "t2.micro"
        vpc_security_group_ids  = [aws_security_group.instance.id]
        user_data = <<-EOF
                    #!/bin/bash
                    yum install busybox -y
                    echo "Hello, World" > index.html
                    nohup busybox httpd -f -p ${var.server_port} &
                    EOF

        tags = {
                Name = "web_server_example"
        } 
}

resource "aws_security_group" "instance" {
        name = "security_group_instance"

        ingress {
            from_port   = var.server_port
            to_port     = var.server_port
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

output "public_ip" {
    value           = aws_instance.web_server_example.public_ip
    description     = "The public IP address of the web server"
}