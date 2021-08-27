FROM alpine:3.9

ARG KUBECTL_VERSION=v1.19.2
ARG HELM_VERSION=3.3.1

ENV KUBECTL_VERSION=$KUBECTL_VERSION
ENV HELM_VERSION=$HELM_VERSION
ENV HELM_HOME=/helm/
ENV YC_HOME=/yc

ENV PATH $HELM_HOME:$YC_HOME/bin:$PATH

RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

RUN curl -O https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64 $HELM_HOME && \
    rm helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mkdir $HELM_HOME/plugins && \
    helm plugin install https://github.com/futuresimple/helm-secrets

RUN curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | \
    bash -s -- -i ${YC_HOME} -n

VOLUME ["/root/.config"]
