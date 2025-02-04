FROM alpine:3.12.4

ENV WORKDIR /pre-commit
ENV PIP_NO_CACHE_DIR=1
ENV TF_VERSION 0.14.5
ENV TFDOCS_VERSION v0.14.1
ENV TFLINT_VERSION v0.29.0
ENV TFSEC_VERSION v0.39.21

COPY requirements.txt /

RUN apk add --update --no-cache perl=5.30.3-r0 python3=3.8.10-r0 bash=5.0.17-r0 git=2.26.3-r0 musl=1.1.24-r10 gawk=5.1.0-r0 curl=7.77.0-r0 unzip=6.0-r9 && \
    curl -sL https://github.com/terraform-docs/terraform-docs/releases/download/${TFDOCS_VERSION}/terraform-docs-${TFDOCS_VERSION}-linux-amd64.tar.gz  > terraform-docs.tgz && \
    curl -sL https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip > tflint.zip && \
    curl -sL https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip > terraform.zip && \
    curl -sL https://github.com/tfsec/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64 > /usr/bin/tfsec && \
    unzip terraform.zip && \
    rm terraform.zip && \
    mv terraform /usr/bin && \
    unzip tflint.zip && \
    rm tflint.zip && \
    mv tflint /usr/bin/ && \
    tar xzf terraform-docs.tgz && \
    rm terraform-docs.tgz && \
    chmod +x terraform-docs && \
    mv terraform-docs /usr/bin/ && \
    chmod +x /usr/bin/tfsec /usr/bin/terraform-docs /usr/bin/tflint /usr/bin/terraform && \
    python3 -m ensurepip && \
    python3 -m pip install -r requirements.txt && \
    mkdir ${WORKDIR} && \
    git init && \
    pre-commit install

WORKDIR ${WORKDIR}
RUN git init . && \
    pre-commit install

CMD ["pre-commit", "run", "--all-files"]
