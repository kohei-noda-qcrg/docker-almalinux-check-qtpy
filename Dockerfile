FROM almalinux:8
RUN yum update -y && yum install -y git sudo

# Create docker user
ENV UNAME=docker GID=1000 UID=1000
RUN groupadd -g $GID -o $UNAME && useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME && \
    echo "$UNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$UNAME && \
    chmod 0440 /etc/sudoers.d/$UNAME

# Install dependencies for pyenv
RUN yum install -y gcc make patch zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel

# Switch to docker user
USER ${UNAME}
WORKDIR /home/${UNAME}

# Pyenv
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
${HOME}/.pyenv/bin/pyenv install 3.11.5 && ${HOME}/.pyenv/bin/pyenv global 3.11.5

# Install dirac_caspt2_input_generator
RUN pip install -U dcaspt2_input_generator

# Install dependencies for dirac_caspt2_input_generator
RUN sudo yum install -y mesa-libGL.x86_64 mesa-libEGL.x86_64 libwayland-cursor.x86_64 libxkbcommon-x11.x86_64 xcb-util-image.x86_64 \
    xcb-util-keysyms.x86_64 xcb-util-renderutil.x86_64 xcb-util-wm.x86_64

# This rpm is not available in the default repository
# so we need to install it manually from the epel repository
RUN sudo yum install -y https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/x/xcb-util-cursor-0.1.3-9.el8.x86_64.rpm
