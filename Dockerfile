FROM elixir:1.14.3

RUN apt-get update && apt-get -y install apt-file && apt-file update
RUN apt-get -y upgrade

RUN apt-get -y install bash git vim sudo curl inotify-tools imagemagick ffmpeg cmake

RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -

RUN apt-get -y install nodejs &&\
    npm install -g npm

RUN echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf

ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID devel
RUN useradd -u $UID -g devel -m devel
RUN echo "devel ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY --chown=devel:devel . /app

USER devel

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force
