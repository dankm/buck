#!/usr/bin/env bash

# Extract the "--num-jobs <n>" value from the args. This value is the number of
# jobs this script should expect to be sent to it from buck.
num_jobs=$(echo "$@" | sed 's/--num-jobs \([0-9]*\)/\1/')

# Read in the handshake JSON.
read -d "}" handshake_json
# Extract the id value.
handshake_id=$(echo "$handshake_json" | sed 's/.*"id":\([0-9]*\).*/\1/')
# Send the handshake reply.
printf "[{\"id\":%s, \"type\":\"handshake\", \"protocol_version\":\"0\", \"capabilities\": []}" "$handshake_id"

for ((i=1; i <= num_jobs ; i++))
do
  # Read in the job JSON.
  read -d "}" job_json
  # Extract the id value.
  message_id=$(echo "$job_json" | sed 's/.*"id":\([0-9]*\).*/\1/')
  # Extract the path to the file containing the job args.
  args_path=$(echo "$job_json" | sed 's/.*"args_path":"\([^"]*\)",.*/\1/')
  # Read the job args from the args file. This assumes the args file only
  # contains the path for the output file.
  output_path=$(cat "$args_path")
  # Write to the output file.
  echo "the startup arguments were: $@" > $output_path
  # Send the job result reply.
  printf ",{\"id\":%s, \"type\":\"result\", \"exit_code\":0}" "$message_id"
done

# Read in the end of the JSON array and reply with a corresponding closing bracket.
read -d "]"
echo ]
