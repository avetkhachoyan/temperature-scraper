    #!/bin/bash

    kubectl run ts-kafka-client --restart='Never' --image docker.io/bitnami/kafka:3.6.1-debian-11-r1 --namespace temperature-scraper --command -- sleep infinity
    
    kubectl cp --namespace temperature-scraper ./kafka_client.properties ts-kafka-client:/tmp/client.properties
    
    kubectl exec ts-kafka-client --namespace temperature-scraper -- bash -c kafka-topics.sh \
            --command-config /tmp/client.properties \
            --bootstrap-server ts-kafka.temperature-scraper.svc.cluster.local:9092 --create --topic ts-messages
    
    kubectl exec ts-kafka-client --namespace temperature-scraper -- bash -c cp connect-standalone.properties ~
    kubectl exec ts-kafka-client --namespace temperature-scraper -- bash -c cp connect-file-source.properties ~
    kubectl exec ts-kafka-client --namespace temperature-scraper -- bash -c cp connect-file-sink.properties ~
    kubectl exec ts-kafka-client --namespace temperature-scraper -- bash -c cp JDBC-sinc.connector ~

    kubectl exec ts-kafka-client --namespace temperature-scraper -- bash -c connect-standalone.sh \
            ~/connect-standalone.properties ~/connect-file-source.properties ~/connect-file-sink.properties

    kubectl exec ts-kafka-client --namespace temperature-scraper -- bash -c kafka-console-producer.sh \
            --producer.config /tmp/client.properties \
            --broker-list   ts-kafka-controller-0.ts-kafka-controller-headless.temperature-scraper.svc.cluster.local:9092, \
                            ts-kafka-controller-1.ts-kafka-controller-headless.temperature-scraper.svc.cluster.local:9092, \
                            ts-kafka-controller-2.ts-kafka-controller-headless.temperature-scraper.svc.cluster.local:9092 \
            --topic ts-messages
    
    kubectl exec ts-kafka-client --namespace temperature-scraper -- bash -c kafka-console-consumer.sh \
            --consumer.config /tmp/client.properties \
            --bootstrap-server ts-kafka.temperature-scraper.svc.cluster.local:9092 --topic ts-messages --from-beginning

    exit $?