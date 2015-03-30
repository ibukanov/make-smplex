FROM ubuntu

RUN apt-get update

RUN apt-get install -y gcc make tar curl

RUN apt-get clean

# Drop suid|sguid
RUN find / -xdev -perm /6000 -type f -print0 | xargs -0r chmod -6000

RUN groupadd -g 3015 user && \
    useradd -m -d /home/user -u 3015 -g 3015 user && \
    mkdir -p 755 /vol

WORKDIR /home/user

ENTRYPOINT ["/opt/build-statics"]

COPY build-statics /opt/

RUN chmod a+rX -R /opt
