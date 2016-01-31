FROM python:3.5

MAINTAINER Miha Cancula <miha@noughmad.eu>

RUN apt-get update && apt-get install -y \
		cmake \
		build-essential \
		pkg-config \
		libssl-dev \
		libz-dev \
		libhttp-parser-dev \
		libffi-dev \
        openssh-server \
        openssl \
        git \
	--no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV LIBGIT2_VERSION 0.23.4

ADD https://github.com/libgit2/libgit2/archive/v${LIBGIT2_VERSION}.tar.gz .
RUN tar -xzf v${LIBGIT2_VERSION}.tar.gz
RUN ls
RUN cd libgit2-${LIBGIT2_VERSION} && mkdir build && cd build && cmake .. && make && make install
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/local/lib/

ADD requirements.txt requirements.txt
RUN pip install -r requirements.txt

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/local/lib

# This is a volume now for faster development
# ADD src /src
WORKDIR /src/blobsource

EXPOSE 22
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd

ENV GIT_USER="git" GIT_PASSWORD="insecure"
RUN useradd -m -p $(openssl passwd -1 ${GIT_PASSWORD}) ${GIT_USER}
