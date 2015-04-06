# Designed to be run as 
# 
# docker build -t test/ubuntu .
# docker run -it -p 5080:80 -v /home/charts:/var/www test/ubuntu

FROM ubuntu

MAINTAINER Ivan A. Berezhko <i.berezhko@gmail.com>

RUN apt-get update
RUN apt-get install -y vim sudo mc nginx supervisor python-virtualenv python-pip\
            python-dev curl gfortran libatlas-base-dev liblapacke-dev liblapack-dev git
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y build-essential nodejs

RUN mkdir -p /var/www/charts/web.test
RUN mkdir -p /var/www/charts/log
RUN chown -R www-data:www-data /var/www/charts

COPY config/requirements.txt /var/www/charts/web.test/requirements.txt

RUN virtualenv /var/www/charts/env
RUN /var/www/charts/env/bin/pip install setproctitle
RUN /var/www/charts/env/bin/pip install -r /var/www/charts/web.test/requirements.txt

RUN npm install findup-sync resolve q mout bower-logger osenv bower grunt grunt-cli grunt-contrib-requirejs requirejs uglifyjs

COPY config/test.charts.conf /etc/supervisor/conf.d/test.charts.conf
COPY config/charts /etc/nginx/sites-available/charts

RUN rm /etc/nginx/sites-enabled/*
RUN ln -s /etc/nginx/sites-available/charts /etc/nginx/sites-enabled/charts

EXPOSE 81

#RUN useradd -m -s /bin/bash ivan
#RUN echo "ivan ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

#USER ivan
#ENV HOME /home/ivan
#ENV SHELL /bin/bash
#ENV USER ivan

#WORKDIR /home/ivan/

CMD /bin/bash
