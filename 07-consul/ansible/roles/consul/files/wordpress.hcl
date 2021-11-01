service {
  name = "wordpress"
  port = 9000
  check {
    name = "Check fastcgi wordpress health (includes db connectivity check)"
    args = ["/usr/local/bin/check-wordpress.sh"],
    interval = "3s"
    timeout = "1s"
  }
}