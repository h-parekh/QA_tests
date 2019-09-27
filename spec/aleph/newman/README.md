# Testing Aleph Deployments with Newman

## Variables Needed

Variable Name | Variable Value
------------- | ---------------
AlephURL | The URL to test against. *ex*: **aleph.example.com**

## Testing Locally

The easiest way to run these tests is to leverage the official [Newman Docker Image](https://hub.docker.com/r/postman/newman) from Postman Labs.

Follow these steps:

Pull down the Docker container for Newman (*Note: this is only needed prior to the first run on local machine, and only speeds up Step 3*):

 ``` console
docker pull postman/newman
```

Clone the QA_tests Repository (*Note: this is only required if you do not have a copy of the repository on your machine.*):

 ``` console
git clone git@github.com:ndlib/QA_tests.git
```

Connect to the Notre Dame VPN [per University Instructions](https://oit.nd.edu/services/network/)

Run the Newman collection against the desired Aleph server:

 ``` console
docker run -v /full/path/to/QA_tests/spec/aleph/newman:/etc/newman -t postman/newman run Aleph.postman_collection.json --global-var "AlephURL=Value"
```
