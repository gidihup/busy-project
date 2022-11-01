output "alb_dns_name" {
  description = "The DNS name of the application load balancer."
  value       = aws_lb.app-alb.dns_name
}