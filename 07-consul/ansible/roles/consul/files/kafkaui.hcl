service {
  name = "kafkaui"
  port = 8081
  check {
    name = "Kafka UI health check"
    http = "http://localhost:8081"
    interval = "3s"
    timeout = "1s"
  }
}
