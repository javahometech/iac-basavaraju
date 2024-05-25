module "vpc" {
  source = "./modules/vpc"
}

module "lambda" {
  source          = "./modules/lambda"
  lambda_handler  = "hello-python.lambda_handler"
  lambda_runtime  = "python3.8"
  lambda_filename = "hello-python.zip"
  function_name   = "JHCFunction"
}