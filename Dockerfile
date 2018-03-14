FROM python:2.7-slim

# Run updates, install basics and cleanup
# - build-essential: Compile specific dependencies
# - git-core: Checkout git repos
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends build-essential git-core openssl libssl-dev libffi6 libffi-dev curl  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# use bash always
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# workdir
WORKDIR /app
COPY . /app

# rasa stack
## rasa nlu
RUN pip install -r requirements/requirements_docker.txt
## mitie models
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends wget \
    && wget -P mitie/ https://s3-eu-west-1.amazonaws.com/mitie/total_word_feature_extractor.dat \
    && apt-get remove -y wget \
    && apt-get autoremove -y
## rasa core
RUN pip install rasa_core

# volumes
VOLUME ["/app/logs", "/app/data", "/app/config"]


EXPOSE 5000

ENTRYPOINT ["./entrypoint.sh"]
