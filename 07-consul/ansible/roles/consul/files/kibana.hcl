service {
  name = "kibana"
  port = 5601
  check {
    name = "Kibana health check"
    http = "http://localhost:5601/status"
    interval = "3s"
    timeout = "1s"
  }
}
