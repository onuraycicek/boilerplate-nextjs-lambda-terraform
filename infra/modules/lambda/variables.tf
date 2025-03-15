variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "source_dir" {
  type        = string
  description = "Directory containing Lambda function code"
}

variable "handler" {
  type        = string
  description = "Lambda function handler"
  default     = "lambda_function.lambda_handler"
}

variable "runtime" {
  type        = string
  description = "Lambda function runtime"
  default     = "python3.9"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for Lambda function"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags to be added to resources"
  default     = {}
} 