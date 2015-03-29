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
docker run -ti --rm -v /vol/smplex:/vol /opt/bin:/vol/bin make-smplex screen tmux
```
If successfull, this puts statically build `screen` and `tmux` under /opt/bin directory. If not, like when network connection to the servers with binaries is down, running the command again will resume from the point where it failed.

Using under CoreOS
------------------

Just running `ssh -t host /opt/bin/tmux` under CoreOS will terminate tmux process when ssh connection terminates defeating the purpose of a persistent multiplexor. To workaround use a script like the following to connect into tmux session:
```
#!/bin/sh

host="$1"
shift
what='\
if ! /opt/bin/tmux list-sessions > /dev/null 2>&1; then
    systemctl is-active -q "tmux-$USER" 2>/dev/null || \
        sudo systemd-run --uid $UID --unit "tmux-$USER" --service-type=forking /opt/bin/tmux new-session -d
    i=0
    while ! /opt/bin/tmux list-sessions > /dev/null 2>&1 && test $i -lt 20; do
        sleep 0.05
        i=$(($i + 1))
    done
fi
exec /opt/bin/tmux attach'

exec ssh -t "$host" "$what"
```

This attaches the current terminal to a tmux run as a systemd service.
