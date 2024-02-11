
variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}


provider "aws" {
  region     = "us-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}



# # 1. Create vpc

resource "aws_vpc" "test-cicd-dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "development"
  }
}

# # 2. Create Internet Gateway

resource "aws_internet_gateway" "test-cicd-gw" {
  vpc_id = aws_vpc.test-cicd-dev-vpc.id
}

# # 3. Create Custom Route Table

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.test-cicd-dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-cicd-gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.test-cicd-gw.id
  }

  tags = {
    Name = "Dev"
  }
}

# # 4. Create a Subnet 

resource "aws_subnet" "test-cicd-dev-subnet" {
  vpc_id            = aws_vpc.test-cicd-dev-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "test-cicd-dev-subnet"
  }
}

# # 5. Associate subnet with Route Table
resource "aws_route_table_association" "test-cicd-ta" {
  subnet_id      = aws_subnet.test-cicd-dev-subnet.id
  route_table_id = aws_route_table.prod-route-table.id
}
# # 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.test-cicd-dev-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# # 7. Create a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "test-cicd-dev-ni" {
  subnet_id       = aws_subnet.test-cicd-dev-subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}
# # 8. Assign an elastic IP to the network interface created in step 7

# resource "aws_eip" "one" {
#   vpc                       = true
#   network_interface         = aws_network_interface.web-server-nic.id
#   associate_with_private_ip = "10.0.1.50"
#   depends_on                = [aws_internet_gateway.gw]
# }

# output "server_public_ip" {
#   value = aws_eip.one.public_ip
# }

resource "aws_eip" "test-cicd-dev-eip" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.test-cicd-dev-ni.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.test-cicd-gw,aws_instance.web-server-instance]
  instance = aws_instance.web-server-instance.id
}

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.web-server-instance.id
#   allocation_id = aws_eip.test-cicd-dev-eip.id
# }


output "server_public_ip" {
  value = aws_eip.test-cicd-dev-eip.public_ip
}

# # 9. Create Ubuntu server and install/enable apache2

resource "aws_instance" "web-server-instance" {
  ami               = "ami-0c7217cdde317cfec"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "test-cicd-dev-keypair"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.test-cicd-dev-ni.id
  }

  user_data = <<-EOF
                #!/bin/bash
                curl -sSL https://get.docker.com/ | sh
                
                echo "$DOCKER_PASSWORD" | docker login --username jaenelleisidro --password-stdin

                docker pull jaenelleisidro/test_cicd_nodejs:main
                docker run -p 3000:3000 -d --name container_test_cicd_nodejs jaenelleisidro/test_cicd_nodejs:main
                
                EOF
  tags = {
    Name = "test-cicd-dev-web-server"
  }
}



output "server_private_ip" {
  value = aws_instance.web-server-instance.private_ip
}

output "server_id" {
  value = aws_instance.web-server-instance.id
}
