ARG PYTHON_VERSION=3.6
FROM godatadriven/miniconda:${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE 1

ARG BUILD_DATE
ARG MLFLOW_VERSION
ARG MLFLOW_EXTRAS=psycopg2

LABEL org.label-schema.name="MLflow ${MLFLOW_VERSION}" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.version=$MLFLOW_VERSION

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN set -x\
    && apt-get update \
    && apt-get install -y default-libmysqlclient-dev build-essential libpq-dev --no-install-recommends \
    && if [ -n "$MLFLOW_VERSION" ]; then\
           pip install --no-cache-dir mlflow==$MLFLOW_VERSION $MLFLOW_EXTRAS;\
       else\
           pip install --no-cache-dir mlflow $MLFLOW_EXTRAS;\
       fi\
    && apt-get remove -y --purge build-essential \
    && apt autoremove -y \
    && apt-get clean -y

ENTRYPOINT ["mlflow"]
CMD ["--help"]
