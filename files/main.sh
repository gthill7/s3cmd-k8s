#!/bin/sh -e

#
# main entry point to run s3cmd
#
S3CMD_PATH=/opt/s3cmd/s3cmd
S3CMD_CONFIG=/root/.s3cfg

#
# Check for required parameters

if [ -z "${access_key}" ]; then
    echo "WARNING: The environment variable key is not set. Hopefully your node has access or you have kube2iam configured..."
else
    #
    # Set user provided key and secret in .s3cfg file
    #
    echo "" >> "$S3CMD_CONFIG"
    echo "access_key=${access_key}" >> "$S3CMD_CONFIG"
fi

if [ -z "${secret_key}" ]; then
    echo "WARNING: The environment variable secret is not set. Hopefully your node has access or you have kube2iam configured..."
else
    echo "secret_key=${secret_key}" >> "$S3CMD_CONFIG"
fi

ITER=true
if [ -z "${interval}" ]; then
    echo "INFO: No interval was defined. If you would like to run this as a loop please specify --env interval={SECONDS}"
    ITER=false
fi

#
# Add region base host if it exist in the env vars
#
if [ "${s3_host_base}" != "" ]; then
  echo "host_base = ${s3_host_base}" >> "$S3CMD_CONFIG"
fi

if [ "${s3_host_bucket_template}" != "" ]; then
  echo "host_bucket = ${s3_host_bucket_template}" >> "$S3CMD_CONFIG"
fi

actions() {
# Check whether to run a pre-defined command
if [ -n "${cmd}" ]; then
  #
  # sync-s3-to-local - copy from s3 to local
  #
  if [ "${cmd}" = "sync-s3-to-local" ]; then
      echo ${SRC_S3}
      ${S3CMD_PATH} sync $* ${SRC_S3} /opt/dest/
  fi

  #
  # sync-local-to-s3 - copy from local to s3
  #
  if [ "${cmd}" = "sync-local-to-s3" ]; then
      cd /opt/src
      FILE=$(ls)
      ${S3CMD_PATH} put $* /opt/src/$FILE ${DEST_S3}
  fi
else
  ${S3CMD_PATH} $*
fi

}

# Perform action at least once before while loop.
actions
# Loops forever at the user defined interval.
while $ITER
do
    actions
    sleep ${interval}
done

#
# Finished operations
#
echo "Finished s3cmd operations"
