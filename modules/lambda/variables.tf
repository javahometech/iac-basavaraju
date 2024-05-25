# Define input variables
variable "lambda_handler" {
  description = "Handler for the Lambda function"
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
}

variable "lambda_filename" {
  description = "Filename for the Lambda deployment package"
}

variable "function_name" {
  description = "Name of the Lambda function"
  default     = "JHCFunction"
}
