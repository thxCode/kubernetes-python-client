FROM alpine:3.6

MAINTAINER Frank Mai <frank@rancher.com>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
	io.github.thxcode.build-date=$BUILD_DATE \
	io.github.thxcode.name="kubernetes python client" \
	io.github.thxcode.description="Kubernetes python client supports by Alpine in a docker container." \
	io.github.thxcode.url="https://github.com/thxcode/kubernetes-python-client" \
	io.github.thxcode.vcs-type="Git" \
	io.github.thxcode.vcs-ref=$VCS_REF \
	io.github.thxcode.vcs-url="https://github.com/thxcode/kubernetes-python-client.git" \
	io.github.thxcode.vendor="Rancher Labs, Inc" \
	io.github.thxcode.version=$VERSION \
	io.github.thxcode.schema-version="1.0" \
	io.github.thxcode.license="MIT" \
	io.github.thxcode.docker.dockerfile="/Dockerfile"

ENV KUBE_CLIENT_VERSION="4.0.0" \
	KUBE_WS_PATCH_VERSION="2.0.98"
	
RUN apk add --update --no-cache \
		dumb-init \
		bash \
		sudo \
		python \
	&& apk add --no-cache --virtual=build-dependencies \
		python-dev \
		py-pip \
	&& pip install --no-cache-dir -U \
		passlib \
		kubernetes==${KUBE_CLIENT_VERSION} \
		kubernetes-ws-patch==${KUBE_WS_PATCH_VERSION} \
	&& apk del --purge build-dependencies \
	&& rm -fr \
		/var/cache/apk/* \
		/root/.cache \
		/tmp/*

CMD ["/bin/bash"]
