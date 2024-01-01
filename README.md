# DevSeOps Best Practice Architecture

## Todo

- [x] AWS VPC Endpoint
- [ ] CloudTrail Pipeline
- [ ] Automatino AccessKey, SecretKey

## VPC

## Cloud-Trail-Pipelin (계정 감사용)

![cloud-trail](./public/cloud-trail.png)


## Reference

- terraforming 설치 (only AWS)

```sh
    ## Install Terraforming
    gem install terraforming

    ## If Error )
    ## ERROR:  While executing gem ... (Gem::FilePermissionError)
    ## You don't have write permissions for the /Library/Ruby/Gems/2.6.0 directory.
    sudo gem install terraforming
```