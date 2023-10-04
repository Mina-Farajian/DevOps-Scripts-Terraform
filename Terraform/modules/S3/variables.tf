variable "config" {
  type = object({
    bucket = string
    tags   = map(string)
  })
}