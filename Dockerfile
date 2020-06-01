FROM python:3.7.7-slim-buster

RUN apt-get update && \
  apt-get -y install \
  --no-install-recommends \
  --allow-remove-essential \
  --allow-change-held-packages \
  --autoremove \
  build-essential \
  python-dev
#  curl

RUN pip install uwsgi

# Add web files
COPY --chown=www-data:www-data PROJECT_DIR/ /var/src/PROJECT_DIR/

RUN pip install /var/src/PROJECT_DIR

EXPOSE 80
EXPOSE 9191

#ENV BENJI_LEVINE_DB_HOST
#ENV BENJI_LEVINE_DB_PASSWORD
#ENV BENJI_LEVINE_DB_PORT
#ENV BENJI_LEVINE_DB_USERNAME
#ENV BENJI_LEVINE_SMTP_HOST
#ENV BENJI_LEVINE_SMTP_PASSWORD
#ENV BENJI_LEVINE_SMTP_PORT
#ENV BENJI_LEVINE_SMTP_USERNAME
#ENV FLASK_SECRET_KEY
#ENV BL_RECAPTCHA_SITE_KEY
#ENV BL_RECAPTCHA_SECRET_KEY

CMD uwsgi --http 0.0.0.0:80 --wsgi-file \
  "/var/src/APPLICATION_FILE" --callable app \
  --processes 1 --threads 1 --stats 0.0.0.0:9191

HEALTHCHECK --interval=10s CMD curl --fail localhost:80 || exit 1
