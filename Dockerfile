from ubuntu:trusty
maintainer doucol

RUN apt-get update
RUN apt-get install -y build-essential git software-properties-common \
  python python-dev python-software-properties python-setuptools sqlite3
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get install -y nginx supervisor

RUN apt-get update
#RUN apt-get upgrade -y

# install our code
add . /home/docker/code/

# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /home/docker/code/nginx-app.conf /etc/nginx/sites-enabled/
RUN ln -s /home/docker/code/supervisor-app.conf /etc/supervisor/conf.d/

# install python packages & all requirements for our python app
RUN easy_install pip
RUN pip install uwsgi
RUN pip install -r /home/docker/code/app/requirements.txt

expose 80
cmd ["supervisord", "-n"]
