FROM registry.access.redhat.com/ubi8-minimal:8.2-301

ENV APP_ROOT=/usr/src/app \
    PYTHON_PKG=python38 \
    PYTHON_EXE=python3.8 \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

RUN microdnf install -y ${PYTHON_PKG}{,-devel,-setuptools,-pip} && \
    microdnf clean all

RUN ${PYTHON_EXE} -m venv ${APP_ROOT} && \
    ${APP_ROOT}/bin/pip install pipenv && \
    chown -R 1001:0 ${APP_ROOT}
    
ENV PATH=${APP_ROOT}/bin:$PATH
WORKDIR ${APP_ROOT}

USER 1001
