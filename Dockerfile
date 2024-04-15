FROM nvcr.io/nvidia/pytorch:23.12-py3

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Berlin

RUN apt-get update \
    && apt-get install -y sudo \
    && apt-get install -y --no-install-recommends \
    # Git-LFS for files larger than 100 MB
    git-lfs \
    # .NET SDK for devcontainers
    aspnetcore-runtime-8.0 \
    # HDF5
    hdf5-tools \
    # Fish shell
    zsh \ 
    tmux \
    tree

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Silence pip's warnings
ENV PIP_ROOT_USER_ACTION=ignore \
    PIP_DISABLE_PIP_VERSION_CHECK=true

# Install Python packages
RUN python3 -m pip install \
    'altair' \
    'scanpy' \
    'muon' \
    'tqdm' \
    'altair' \
    'vega' \
    # For large tables in altair
    'vegafusion[embed]>=1.4.0' \
    'cytoolz'
    

# Install dev packages (optional)
RUN python3 -m pip install \
    'ipykernel' \ 
    'ipython'

# ---------------------------------------------------------------------------- #
# Autoreload in Python
RUN echo "c.InteractiveShellApp.exec_lines = ['%load_ext autoreload', \
    '%autoreload 2']" > "$(ipython locate)/profile_default/ipython_config.py"

ENV DEBIAN_FRONTEND=dialog


RUN git clone --depth 1 https://github.com/Ruth-Seven/InitLinux.git /root/tools && \
	echo "----------------PLEASH ADD SSH KEY IN GITHUB---------------" && \
	echo "----------------Then run ./initLinux.sh"

# Setup fish zsh 
RUN chsh -s $(which zsh)
COPY ./config.fish /root/.config/fish/config.fish

WORKDIR /root
RUN ["/bin/zsh"]