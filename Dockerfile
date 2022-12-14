# Release
FROM python:alpine
WORKDIR /app
COPY ./ /app/

ARG PORT \
    API_USER \
    API_PASS \
    CAPTCHA_SOLVER_URL \
    JAVDB_EMAIL \
    JAVDB_PASSWORD \
    CREATE_REDIS="false" \
    LOG_REQUEST="false" \
    REMEMBER_ME_TOKEN \
    JDB_SESSION \
    TIMEZONE="UTC" \
    IPINFO_TOKEN \
    INACTIVITY_TIMEOUT \
    REDIS_URL \
    RAILWAY_STATIC_URL \
    HEALTHCHECK_PROVIDER="None" \
    UPTIMEKUMA_PUSH_URL \
    HEALTHCHECKSIO_PING_URL \
    PLATFORM

ENV RUNTIME_DEPS="wget curl jq tmux ca-certificates alpine-conf bash"

ENV BASE_URL="${RAILWAY_STATIC_URL:-}" \
    PYTHONPATH="." \
    OVERMIND_NO_PORT=1

# Ref. https://github.com/iamrony777/JavInfo-api/tree/build
COPY --from=iamrony777/javinfo-api:build-layer /app/wheels /app/wheels
    
RUN apk add --no-cache $RUNTIME_DEPS && \
    chmod +x install.sh && bash /app/install.sh && \
    pip install --no-cache-dir -U pip setuptools wheel && \
    pip install --no-cache-dir /app/wheels/*

# MKDocs Static Site Generator
RUN mkdocs build -f /app/conf/mkdocs.yml && \
    pip uninstall mkdocs-material -y

RUN python -m compileall .

CMD ["bash", "start.sh"] 
