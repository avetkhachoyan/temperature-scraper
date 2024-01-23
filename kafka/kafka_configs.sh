    #!/bin/bash

    kubectl run ts-kafka-client --restart='Never' --image docker.io/bitnami/kafka:3.6.1-debian-11-r1 --namespace temperature-scraper --command -- sleep infinity
    kubectl cp --namespace temperature-scraper ./kafka_client.properties ts-kafka-client:/tmp/client.properties
    kubectl exec --tty -i ts-kafka-client --namespace temperature-scraper -- bash -c kafka-topics.sh --command-config /tmp/client.properties --bootstrap-server ts-kafka.temperature-scraper.svc.cluster.local:9092 --create --topic ts-messages \
    && cp connect-standalone.properties . \
    && cp connect-file-source.properties . \
    && cp connect-file-sink.properties . \
    && cp JDBC-sinc.connector . \
    && connect-standalone.sh ./connect-standalone.properties ./connect-file-source.properties ./connect-file-sink.properties

    exit $?