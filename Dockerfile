# Use the specified Ubuntu release as the base image
ARG UBUNTU_RELEASE=rolling
FROM ubuntu:${UBUNTU_RELEASE} as builder

#install systemd, snapd, flatpak+flathub
RUN <<-EOT
	  apt-get update -y
    apt-get install --no-install-recommends -y systemd systemd-sysv snapd flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    apt-get clean
    rm -rf /var/lib/apt/lists/* /var/log/alternatives.log /var/log/apt/history.log /var/log/apt/term.log /var/log/dpkg.log
    rm -rf  /etc/machine-id /var/lib/dbus/machine-id
EOT

FROM scratch
COPY --from=builder / /

ENTRYPOINT [ "/sbin/init" ]
CMD ["/bin/bash"]
