resource "aws_key_pair" "webserver-key" {
  key_name   = "${var.prefix}-webserver-key"
  public_key = "ssh-rsa <key>"
}