output "elb_endpoint" {
  description = "Your website endpoint through Elastic Load Balancer (ELB)."
  value       = "http://${aws_elb.front.dns_name}"
}
