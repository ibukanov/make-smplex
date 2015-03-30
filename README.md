# make-smplex
docker container to build statically linked tmux and screen

This builds fully statically linked tmux and screen binaries inside a docker container using musl library. These terminal multiplexors are not available under CoreOS and using a privileged container with such binaries for manual administartion is inconvinient.

Installation
------------

Build the container:
```
docker build -t make-smplex directory
```
Run it with host volumes for storage and resulting binaries:
```
docker run -ti --rm -v /vol/smplex:/vol -v /opt/bin:/vol/bin make-smplex screen tmux
```
If successfull, this puts statically build `screen` and `tmux` under /opt/bin directory. If not, like when network connection to the servers with binaries is down, running the command again will resume from the point where it failed. If you need just one of multiplexers, drop other names from the command line.

Using under CoreOS
------------------

Running `screen` or `tmux` under CoreOS from a ssh shell will terminate the multiplexer daemon process when the ssh connection terminates defeating the purpose of a persistent multiplexer. To workaround this the container provides together with the binaries the helper commands `screen-resume` and `tmux-attach` that start the multiplexer as a systemd service before resuming the screen session or attaching to tmux manager. So to login into, say, a `tmux` session on a CoreOS VM, just invoke `ssh -t core@vm-name tmux-attach`.