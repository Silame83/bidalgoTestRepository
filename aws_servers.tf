//---------------------------Jenkins server-------------------------------------

data "aws_ami" "linux_jenkins" {

  filter {
    name = "image-id"
    values = ["ami-0be2609ba883822ec"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners = ["amazon"]
}

resource "aws_key_pair" "virginia_kp" {
  key_name = "virginia-qa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQsiQzUYBjED7WvyqK6rMUSI2DDz8Xuhjb+KjW1GVQBazLpK9ynj/YRK2bsFkDMmUEjg1hcfPlbzx+oOpShnzUPRxY/iEFguFdnxEw9NN02dBdMnPEpQPylljnC1xtPSFko60RivpeCpvngkTZtc+crqF8CDwYGm+hYo6Y8YRtFvcDQ/re1zEld7CTxueoMHIqCno6mPw+kMcYtWiHV8GjwCl5Fl+u+yX5y1mbHhJPopg3yeYX0ZZppxPRa8AQYoHSZ0OPjIiAOj5e4lL0NB6bdDwY+yw8T3IosD3AZwl4FzuBKiPlStPBeE+tAimZZl0sZI97cr58aDHdsVThEx7j qa"
}

resource "aws_instance" "jenkins" {
  ami = data.aws_ami.linux_jenkins.id
  instance_type = "t2.medium"
  subnet_id = aws_subnet.bidalgo_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_bidalgo.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.virginia_kp.id
  user_data = <<EOF
          #! /bin/bash
          sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
          sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
          sudo yum -y upgrade
          sudo yum install -y jenkins java-1.8.0-openjdk-devel
          sudo systemctl daemon-reload
          sudo systemctl start jenkins
  EOF
  tags = {
    Name = "Jenkins"
  }
}

//----------------------------------LAMP server-------------------------------------

resource "aws_instance" "lamp" {
  ami = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.bidalgo_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_bidalgo.id]
  associate_public_ip_address = true
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
  }
  key_name = aws_key_pair.virginia_kp.id
  user_data = file("userdata.sh")
  tags = {
    Name = "code server"
  }
}