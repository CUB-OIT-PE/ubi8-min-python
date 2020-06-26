# Python base image for PE

This includes:
 1. ubi8-minimal
 2. pipenv
 3. some structure from the [ubi8/python-38] container

It is intended to be used for running python workloads, and as a basis for
packaging and distributing python code à la [hello-python]

### Manually trigger jobs

Submit a POST to

    https://api.github.com/repos/CUB-OIT-PE/ubi8-min-python/dispatches

with a body of

    {
	"event_type": "bump",
	"client_payload": {}
    }

or
    {
	"event_type": "build",
	"client_payload": {}
    }

[ubi8/python-38]: https://catalog.redhat.com/software/containers/ubi8/python-38/5dde9cacbed8bd164a0af24a?container-tabs=dockerfile&tag=latest
[hello-python]: https://github.com/CUB-OIT-PE/hello-python

