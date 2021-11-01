service {
  name = "nginx"
  port = 80
  check {
    name = "Nginx health check"
    http = "http://localhost/health"
    interval = "3s"
    timeout = "1s"
  }
}
