BROKER_IDS=(1001 1002 1003 1004 1005)
NUMBER_OF_PARTITIONS=50
NUMBER_OF_REPLICAS=3
TOPIC_NAME=topic

output_file="increase-replication-factor.json"

# Beginning of the file
echo '{"version":1,' > $output_file
echo '  "partitions":[' >> $output_file

current_broker_id_index=0

# Responsible for the circular aray of the partition IDs
set_next_broker(){
    current_broker_id_index=$1
    current_broker_id_index=$(($current_broker_id_index + 1))
    current_broker_id_index=$(($current_broker_id_index % ${#BROKER_IDS[@]}))
    return $current_broker_id_index
}

# Forges the string containing the replicas brokers of a partition
get_brokers_string(){
    current_broker_id_index=$1
    brokers_string="${BROKER_IDS[$current_broker_id_index]}"
    set_next_broker $current_broker_id_index
    current_broker_id_index=$?
    brokers_string="$brokers_string,${BROKER_IDS[$current_broker_id_index]}"
    set_next_broker $current_broker_id_index
    current_broker_id_index=$?
    brokers_string="$brokers_string,${BROKER_IDS[$current_broker_id_index]}"
    set_next_broker $current_broker_id_index
    current_broker_id_index=$?
    echo $brokers_string
    return $current_broker_id_index
}

# Create all the lines
partition_number=0
while (("$partition_number" < "$NUMBER_OF_PARTITIONS-1")); do
    brokers_string=$(get_brokers_string $current_broker_id_index)
    current_broker_id_index=$?
    echo "    {\"topic\":\"$TOPIC_NAME\",\"partition\":$partition_number,\"replicas\":[$brokers_string]}," >> $output_file
    partition_number=$(($partition_number + 1))
done

# Last line without trailing coma
brokers_string=$(get_brokers_string $current_broker_id_index)
echo "    {\"topic\":\"$TOPIC_NAME\",\"partition\":$partition_number,\"replicas\":[$brokers_string]}" >> $output_file

# End of the file
echo ']}' >> $output_file

exit 0
