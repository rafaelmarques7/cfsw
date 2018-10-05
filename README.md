# Goal
The goal of this module is to create a CloudFront distribution to the previously generated static website.

## References

The terraform cloudfront documentation can be consulted [here](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html). 


## Deployment
Deploy with the following command:
```bash
terraform apply \
--var AWS_PERSONAL_ACCESS_KEY=$AWS_PERSONAL_ACCESS_KEY \
--var AWS_PERSONAL_SECRET_KEY=$AWS_PERSONAL_SECRET_KEY
```

## Origin Access Identity

[Origin Access Identity](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html) (OAI) is a way of protecting your website origin s3 bucket from being exposed.
Instead of exposing your s3 bucket, you expose online the OAI, and it will retrieve the s3 content for you.

To see how to use Terraform the create the OIA, check [this](https://www.terraform.io/docs/providers/aws/r/cloudfront_origin_access_identity.html) page.


## IAM policies

see [this](https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html) page to use terraform to generate an IAM policy.


## Circular dependencies
circular dependencies can be solved using a variable to reference in both dependents, as showed in the last configuration [here](https://operator-error.com/2017/02/21/managing-iam-policy-documents-in-hcl-with-terraform/).

## Cloudfront Problems after deployment
* base url not pointing to index.html
* invalid pages not pointing to error.html

should work now
