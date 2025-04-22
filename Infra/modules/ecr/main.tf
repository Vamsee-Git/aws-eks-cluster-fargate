# Reference the existing patient-service repository
data "aws_ecr_repository" "patient_service" {
  name = var.patient_service_repo_name
}

# Reference the existing appointment-service repository
data "aws_ecr_repository" "appointment_service" {
  name = var.appointment_service_repo_name
}
