FROM ubuntu:latest

LABEL title="temperature-scraper" \
    authors="Avet_Khachoyan" \
    licenses="Apache-2.0" \
    version="v1.0"
ARG GIT_COMMIT=HEAD
LABEL revision "${GIT_COMMIT}"
ARG BUILD_DATE=now
LABEL created "${BUILD_DATE}"
ARG app_name='temperature-scraper'
RUN mkdir /app && mkdir /ts_data && touch /ts_data/ts-temperature.csv && mkdir /kafka_db_connection
RUN cd /app
RUN apt update && apt install -y curl wget tar tmux cron netcat sed gawk

RUN cd /app && wget -P /app/ https://dist.ipfs.tech/kubo/v0.24.0/kubo_v0.24.0_linux-amd64.tar.gz \ 
    && tar -xvzf kubo_v0.24.0_linux-amd64.tar.gz \
    && cd /app/kubo && bash install.sh \
    && cd /app && rm kubo_v0.24.0_linux-amd64.tar.gz
RUN ipfs init --profile server
COPY ../os_service_docker/ipfs.service /etc/systemd/system/
COPY ../os_service_docker/ipfs.initd /etc/init.d/
RUN chmod +x /etc/init.d/ipfs.initd && update-rc.d ipfs.initd defaults

COPY ../ts_app/temperature-scraper.sh /app
RUN chmod +x /app/temperature-scraper.sh

COPY ../ts_app/ts_CityList.txt /app

COPY ../kafka/kafka_client.properties /kafka_db_connection

COPY ../ts_env_bootstrap/ts-webserver.sh /app
RUN chmod +x /app/ts-webserver.sh

WORKDIR /app
ENTRYPOINT /bin/bash 
CMD while true; do bash -c /app/ts-webserver.sh; done;
