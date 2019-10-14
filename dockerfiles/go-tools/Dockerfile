FROM cfcontainerization/base-ci:latest

ADD https://github.com/SUSE/kctl/releases/download/v0.0.12/kctl-linux-amd64 /usr/bin/k
RUN chmod +x /usr/bin/k

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH

RUN curl -fsL https://dl.google.com/go/go1.12.2.linux-amd64.tar.gz | tar -xz -C /opt && \
    update-alternatives --install "/usr/bin/go" "go" "/opt/go/bin/go" 1 && \
    update-alternatives --install "/usr/bin/gofmt" "gofmt" "/opt/go/bin/gofmt" 1

RUN go get -u golang.org/x/lint/golint
RUN go get github.com/onsi/ginkgo/ginkgo
RUN go get github.com/onsi/gomega/...
RUN go get github.com/rohitsakala/goveralls
RUN go get github.com/modocache/gover
RUN go get honnef.co/go/tools/cmd/staticcheck && cd $GOPATH/src/honnef.co/go/tools/cmd/staticcheck && git checkout 2019.2.2 && go get && go install
RUN gem install bosh-template
ENV HELM_VERSION="v2.13.1"
ENV HELM_URL https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz
RUN curl --progress-bar --location ${HELM_URL} | tar -xzf - -C /tmp linux-amd64/helm && \
    mv /tmp/linux-amd64/helm /usr/bin/helm && \
    rm -rf /tmp/linux-amd64/


RUN curl -Lo ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.5.1/kind-$(uname)-amd64
RUN chmod +x ./kind
RUN mv ./kind /usr/local/bin/kind
