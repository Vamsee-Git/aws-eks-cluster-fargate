# Output the URL of the existing patient-service repository
output "patient_service_repo_url" {
  value = data.aws_ecr_repository.patient_service.repository_url
}

# Output the URL of the existing appointment-service repository
output "appointment_service_repo_url" {
  value = data.aws_ecr_repository.appointment_service.repository_url
}
