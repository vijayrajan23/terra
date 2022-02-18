resource "aws_key_pair" "akp" {
  key_name   = "${var.PROJECT}-${var.ENVIRONMENT}-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqDiNi8Js4oq434zcqQT1IL5e9htVp9eMzYo66TzY8WIooJHmr+Hu6xhf9qQIioahxn9mH8OOAO3U1XI4chc8CYIgG5UabGJTVRVLqQJAjEG6dHzk7cPVwU2/V2anzx4Xf4gjYgETJc1pkU09ORJDXADD9+xU/zlanTMA/RHltYCH/sD8TxKtVno1gcz9FuMh5F2qYD+WtZcHVZZXvpIBqcQW0dKWkJ1pqBgLJT9ysvvaNFBNNO69T017eYi48hXS0wpsEvEZ26M4j7hM7Z47rnP90gA+6sH4+n2Ciq3tGT0Lhmnk7KyRElWofiHxcxKPFewB3KLySLfVNzoqyWUYWoc5GOWFvFb6gC535aJtrZrmVcBCHcdbxWv7JNS82zshEhO9y3IX/CFZ98Lscp2kCrBSUnZc+bUdPIO3Hqr3c9YSBl6idJ6Qeeezqb740dU5RJV0QdhI9m03iMqvrOFuvbeNB7c5gvKYWCQhzlN7vUuXY7em4L+fBeAUAMwfoTCU= ubuntu@RCMSLAP064"
}

resource "aws_security_group" "asg" {
  name        = "${var.PROJECT}-${var.ENVIRONMENT}-security-group"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.VPC_ID

  ingress {
    description = "TLS from VPC"
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
    Name = "${var.PROJECT}-security-group"
  }
}

resource "aws_instance" "ai" {
  ami                    = var.AMI
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.akp.key_name
  vpc_security_group_ids = [aws_security_group.asg.id]
  subnet_id              = var.SUBNET_ID
  tags = {
    Name = "${var.PROJECT}-${var.ENVIRONMENT}-instance"
  }
}
