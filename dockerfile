FROM python:3.8-slim-buster AS base
WORKDIR /app

FROM base AS dependencies  
COPY requirements.txt ./
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

FROM dependencies AS build  
WORKDIR /app
COPY . /app

FROM python:3.6 AS release  
WORKDIR /app
COPY --from=dependencies /app/requirements.txt ./
COPY --from=dependencies /root/.cache /root/.cache
RUN groupadd -r uwsgi && useradd -r -g uwsgi uwsgi
RUN pip install -r requirements.txt && \
    pip install Flask uWSGI
COPY --from=build /app/ ./
EXPOSE 9000
COPY cmd.sh /
RUN chmod 777 cmd.sh
USER uwsgi
CMD ["/cmd.sh"]