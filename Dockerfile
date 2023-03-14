FROM python:3.10-bullseye
LABEL maintainer="Gerben Tijdeman"

RUN apt update && \
    apt install -y --no-install-recommends \
    build-essential \
    python3-dev \
    libldap2-dev \ 
    libpq-dev \ 
    libsasl2-dev \
    && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb \
    && echo 'ea8277df4297afc507c61122f3c349af142f31e5 wkhtmltox.deb' | sha1sum -c - \
    && apt-get install -y --no-install-recommends ./wkhtmltox.deb \
    && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

COPY ./requirements.txt /usr/local/odoo/requirements.txt

RUN pip install --upgrade pip && \
    pip install -r /usr/local/odoo/requirements.txt

COPY . /usr/local/odoo
COPY ./config /etc/odoo

VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]
EXPOSE 8069 8071 8072

CMD ["python", "/usr/local/odoo/odoo-bin", "-c", "/etc/odoo/odoo.conf"]