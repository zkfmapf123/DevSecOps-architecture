#################################### S3 ####################################
resource "aws_s3_bucket" "cloud_trail_bucket" {
  bucket = "aws-cloudtrail-logs-182024812696-16c90fb2"
  tags = {
    Name     = "cloud-trail-bucket"
    Resource = "s3"
  }
}

#################################### Cloud-Trail ####################################
resource "aws_cloudtrail" "cloud_trail" {

  name                          = "tracking-secure"
  s3_bucket_name                = aws_s3_bucket.cloud_trail_bucket.id
  include_global_service_events = false
  is_multi_region_trail         = false

  tags = {
    Name     = "tracking-secure"
    Resource = "cloud-trail"
  }

  insight_selector {
    insight_type = "ApiErrorRateInsight"
  }

  advanced_event_selector {
    name = "관리 이벤트 선택기"

    field_selector {
      ends_with = null
      equals = [
        "Management",
      ]
      field           = "eventCategory"
      not_ends_with   = null
      not_equals      = null
      not_starts_with = null
      starts_with     = null
    }

    field_selector {
      ends_with     = null
      equals        = null
      field         = "eventSource"
      not_ends_with = null
      not_equals = [
        "kms.amazonaws.com",
        "rdsdata.amazonaws.com",
      ]
      not_starts_with = null
      starts_with     = null
    }
  }
}

#################################### SNS ####################################
resource "aws_sns_topic" "subject_root_login" {
  name = "subnet-root-login"
}

#################################### Event-Bridge ####################################
resource "aws_cloudwatch_event_rule" "tracking-account" {
  name = "tracking-account"

  event_pattern = jsonencode({
    "source" : ["aws.signin"],
    "detail-type" : ["AWS Console Sign In via CloudTrail"]
  })

  depends_on = [aws_sns_topic.subject_root_login, aws_cloudtrail.cloud_trail]
}


/*
    [ ] EventBridge + SNS Target
    [ ] Chatbot
*/
