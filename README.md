# Kubernetes Python Client

Kubernetes python(based on Python 2.7.12) client supports by Alpine in a docker container.

[![](https://img.shields.io/badge/Github-thxcode/kubernetes_python_client-orange.svg)](https://github.com/thxcode/kubernetes-python-client)&nbsp;[![](https://img.shields.io/badge/Docker_Hub-maiwj/kubernetes_python_client-orange.svg)](https://hub.docker.com/r/maiwj/kubernetes-python-client)&nbsp;[![](https://img.shields.io/docker/build/maiwj/kubernetes-python-client.svg)](https://hub.docker.com/r/maiwj/kubernetes-python-client)&nbsp;[![](https://img.shields.io/docker/pulls/maiwj/kubernetes-python-client.svg)](https://store.docker.com/community/images/maiwj/kubernetes-python-client)&nbsp;[![](https://img.shields.io/github/license/thxcode/kubernetes-python-client.svg)](https://github.com/thxcode/kubernetes-python-client)

[![](https://images.microbadger.com/badges/image/maiwj/kubernetes-python-client.svg)](https://microbadger.com/images/maiwj/kubernetes-python-client)&nbsp;[![](https://images.microbadger.com/badges/version/maiwj/kubernetes-python-client.svg)](http://microbadger.com/images/maiwj/kubernetes-python-client)&nbsp;[![](https://images.microbadger.com/badges/commit/maiwj/kubernetes-python-client.svg)](http://microbadger.com/images/maiwj/kubernetes-python-client.svg)

## References

- [Kubernetes python client](https://github.com/kubernetes-incubator/client-python/blob/master/kubernetes/README.md)
- [Access from Pod demo](https://github.com/kubernetes-incubator/client-python/blob/master/examples/in_cluster_config.py) via `kubernetes.config.load_incluster_config()`

## How to use this image

### Start an instance

To start a container, use the following:

``` bash
$ docker run -it --name test-kubernetes-python-client \
           maiwj/kubernetes-python-client

```

### Watching resources from Kubernetes Pod

``` python
#!/usr/bin/python
# -*- coding: UTF-8 -*-

import sys
import os
from kubernetes import client
from kubernetes.client.rest import ApiException

def main():
    SERVICE_TOKEN_FILENAME = "/var/run/secrets/kubernetes.io/serviceaccount/token"
    SERVICE_CERT_FILENAME = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
    KUBERNETES_HOST = "https://%s:%s" % (os.getenv("KUBERNETES_SERVICE_HOST"), os.getenv("KUBERNETES_SERVICE_PORT"))

    ## configure 
    configuration = client.Configuration()
    configuration.host = KUBERNETES_HOST
    if not os.path.isfile(SERVICE_TOKEN_FILENAME):
        raise ApiException("Service token file does not exists.")
    with open(SERVICE_TOKEN_FILENAME) as f:
        token = f.read()
        if not token:
            raise ApiException("Token file exists but empty.")
        configuration.api_key['authorization'] = "bearer " + token.strip('\n')
    if not os.path.isfile(SERVICE_CERT_FILENAME):
        raise ApiException("Service certification file does not exists.")
    with open(SERVICE_CERT_FILENAME) as f:
        if not f.read():
            raise ApiException("Cert file exists but empty.")
        configuration.ssl_ca_cert = SERVICE_CERT_FILENAME
    client.Configuration.set_default(configuration)

    try:
        ret = client.CoreV1Api().list_namespaced_config_map(namespace=os.getenv("CHART_NAMESPACE"), field_selector=("metadata.name=%s" % os.getenv("CHART_FULLNAME")), watch=False)
        print ret
    except ApiException as e:
        print("Exception when calling CoreV1Api->list_namespaced_config_map: %s\n" % e)

if __name__ == '__main__':
    main()

```

## License

- Kuberentes python client is released under the [Apache2 License](https://github.com/kubernetes-incubator/client-python/blob/master/LICENSE)
- This image is released under the [MIT License](LICENSE)
