data "aws_autoscaling_groups" "all" {
  # Nessun filtro viene specificato, quindi recupera tutti gli Auto Scaling Groups
}

output "autoscaling_groups" {
  value = data.aws_autoscaling_groups.all.names
}

