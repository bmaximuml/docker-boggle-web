FROM python:3.7.7-slim-buster

RUN apt-get update && \
  apt-get -y install \
  --no-install-recommends \
  --allow-remove-essential \
  --allow-change-held-packages \
  --autoremove \
  build-essential \
  python-dev \
  curl && \
  rm -rf /var/lib/apt/lists

RUN pip install uwsgi

# Add web files
COPY --chown=www-data:www-data boggle-web/ /var/src/boggle-web/

RUN pip install /var/src/boggle-web

EXPOSE 80
EXPOSE 9191

CMD uwsgi --http 0.0.0.0:80 --wsgi-file \
  "/var/src/boggle-web/boggle_web" --callable app \
  --processes 1 --threads 1 --stats 0.0.0.0:9191

HEALTHCHECK --interval=10s CMD curl --fail localhost:80 || exit 1
