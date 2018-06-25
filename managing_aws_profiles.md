## Instructions along with an explanation on how to leverage aws-vault for setting up profiles on your dev workstation

### Follow these steps to setup your IAM user along with MFA device

1. Install [aws-vault](https://github.com/99designs/aws-vault#installing)

2. Add your Personal IAM user
Running this command adds a profile 'home' in ~/.aws/config, and adds  
your `aws_access_key_id` and `aws_secret_access_key` to a vault instead of
~/.aws/credentials

```console
$ aws-vault add home
Enter Access Key ID: abc123
Enter Secret Access Key: def456
Added credentials to profile "home" in vault

$ cat ~/.aws/config
[profile home]
```

3. Similarly add the user you want to assume role to by leaving the
access key fields blank (just hit Enter)
```console
$ aws-vault add assume_to_this_user
Enter Access Key ID:
Enter Secret Access Key:
Added credentials to profile "assume_to_this_user" in vault

$ cat ~/.aws/config
[profile home]

[profile assume_to_this_user]

```

4. In a text editor update `assume_to_this_user` profile in `~/.aws/config`
```console
[profile assume_to_this_user]
region=us-east-1
source_profile=home
role_arn=arn:aws:iam::01234:role/role
mfa_serial=arn:aws:iam::1111:mfa/name
```
`role_arn` is the ARN of the IAM user you want this profile to assume role of
`mfa_serial` is your 'home' user's multi factor device ARN

5. Load the profile you want to work with
```console
$ aws-vault exec assume_to_this_user --
```
Running this command will send your CLI into a new shell, which has these values
available as env variables:
```console
AWS_VAULT=assume_to_this_user
AWS_DEFAULT_REGION=us-east-1
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=10101010
AWS_SECRET_ACCESS_KEY=010101010
AWS_SESSION_TOKEN=111111111111
AWS_SECURITY_TOKEN=22222222222
```

6. So any command you run against AWS (via CLI or any aws sdk) will use these
values because credentials are loaded automatically in this order:
* ENV['AWS_ACCESS_KEY_ID'] and ENV['AWS_SECRET_ACCESS_KEY']
* Aws.config[:credentials]
* The shared credentials ini file at ~/.aws/credentials (more information)
* From an instance profile when running on EC2
