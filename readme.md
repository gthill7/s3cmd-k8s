## Credits
This repo is essentially a copy of [hochzehn/s3cmd-docker](https://github.com/hochzehn/s3cmd-docker) and [sekka1/docker-s3cmd](https://github.com/sekka1/docker-s3cmd), but allows you to specify a host other than the default AWS host (e.g DigitalOcean Spaces which is S3 compatible).

## Description
Docker container with s3cmd support. Pull and run this image in order to upload/download between S3 host and local machine.

## Upload from Local to S3
```
docker run --rm \
  --env access_key=${ACCESS_KEY} \
  --env secret_key=${SECRET_KEY} \
  --env s3_host_base=${HOST} \
  --env s3_host_bucket_template=${HOST_BUCKET_TEMPLATE} \
  --env cmd=sync-local-to-s3 \
  --env DEST_S3=${BUCKET} \
  -v ${LOCAL_FILE}:/opt/src \
  gthill77/s3cmd-docker
```

## Download from S3 to Local
```
docker run --rm \
  --env access_key=${ACCESS_KEY} \
  --env secret_key=${SECRET_KEY} \
  --env s3_host_base=${HOST} \
  --env s3_host_bucket_template=${HOST_BUCKET_TEMPLATE} \
  --env cmd=sync-s3-to-local \
  --env SRC_S3=${BUCKET} \
  -v ${LOCAL_PATH}:/opt/dest \
  gthill77/s3cmd-docker
```

## Optional args
* If you want this to run periodically at a specified interval, you can do so by adding to env vars:

    * _NOTE_: If no interval is given then it will only execute once and exit.
```bash
--env interval=${SECONDS}
```

## Examples of env vars
* AWS
```bash
HOST = s3.amazonaws.com
HOST_BUCKET_TEMPLATE = "%(bucket)s.s3.amazonaws.com"
```
* DigitalOcean
```bash
HOST = nyc3.digitaloceanspaces.com
HOST_BUCKET_TEMPLATE = "%(bucket)s.nyc3.digitaloceanspaces.com"
```
