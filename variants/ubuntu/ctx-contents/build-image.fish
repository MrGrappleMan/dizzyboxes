#!/bin/fish

rm /etc/apt/apt.conf.d/docker-gzip-indexes /etc/apt/apt.conf.d/docker-no-languages
sed -Ei 's/^(hosts:.*)(\<files\>)\s*(.*)/\1\2 myhostname \3/' /etc/nsswitch.conf

# Packages
    apt update
    apt upgrade -y
    apt install -y \
            ubuntu-minimal ubuntu-standard libnss-myhostname flatpak-xdg-utils \
            apt-utils \
            bash-completion
            bc
            bzip2
            ca-certificates
            curl
            dbus-x11
            dialog
            diffutils
            direnv
            dirmngr
            fd-find
            findutils
            fish
            fzf
            git
            gnupg
            gnupg-l10n
            gnupg-utils
            gnupg2
            gpg
            gpg-agent
            gpg-wks-client
            gpg-wks-server
            gpgconf
            gpgsm
            hostname
            iproute2
            iputils-ping
            keyutils
            language-pack-en
            less
            libbsd0
            libcap2-bin
            libdrm-amdgpu1
            libdrm-common
            libdrm-nouveau2
            libdrm-radeon1
            libdrm2
            libedit2
            libegl-mesa0
            libegl1
            libelf1t64
            libexpat1
            libgbm1
            libgl1
            libgl1-mesa-dri
            libglib2.0-bin
            libglvnd0
            libglx-mesa0
            libglx0
            libkrb5-3
            libksba8
            libnpth0
            libnsl2
            libnss-mdns
            libnss-myhostname
            libpciaccess0
            libpython3-stdlib
            libsensors-config
            libsensors5
            libsqlite3-0
            libtirpc-common
            libtirpc3
            libvte-2.9*-common
            libvulkan1
            libwayland-client0
            libwayland-server0
            libx11-6
            libx11-data
            libx11-xcb1
            libxau6
            libxcb-dri2-0
            libxcb-dri3-0
            libxcb-glx0
            libxcb-present0
            libxcb-randr0
            libxcb-shm0
            libxcb-sync1
            libxcb-xfixes0
            libxcb1
            libxdmcp6
            libxext6
            libxfixes3
            libxml2-16
            locales
            lsof
            make
            man-db
            manpages
            media-types
            mesa-vulkan-drivers
            mtr
            ncurses-base
            openssh-client
            openssl
            passwd
            pigz
            pinentry-curses
            plocate
            procps
            progress
            rsync
            software-properties-common
            sudo
            tcpdump
            time
            traceroute
            tree
            tzdata
            unzip
            util-linux
            wget
            xauth
            xz-utils
            zip
            zsh \
            libasound2t64 \
            nala
    add-apt-repository ppa:apt-fast/stable
    apt install -y apt-fast


# Path to safely drop privileges and isolate processes
    mkdir /usr/share/empty

# Remove user ubuntu
    userdel --remove ubuntu

# Extranally fetch host-spawn
    curl -sLo /usr/bin/host-spawn https://github.com/1player/host-spawn/releases/download/1.5.0/host-spawn-x86_64
    chmod +x /usr/bin/host-spawn

# idk
rm /etc/apt/apt.conf.d/20apt-esm-hook.conf

# Symlinks
    ln -s /usr/libexec/flatpak-xdg-utils/flatpak-spawn /usr/bin/
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree

# Require no password for sudo
    echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# File attribution
apt-get install -y attr
dpkg-query -W -f='${Package}\n' | while read pkgname; do \
    echo "Setting file attributes for package: $pkgname (chunkah)"; \
    dpkg -L "$pkgname" | while read filepath; do \
        if [ -f "$filepath" ]; then \
            setfattr -n user.component -v "$pkgname" "$filepath" || true; \
        fi; \
    done; \
done
apt-get remove -y attr
