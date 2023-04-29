FROM gitpod/workspace-full

USER gitpod

RUN sudo apt-get -q update \
    && sudo apt-get install -yq \
    lua5.4 \
    && sudo apt-get install -yq \
    luarocks \
    && sudo luarocks install http \
    && sudo luarocks install lua-cjson \
    && sudo rm -rf /var/lib/apt/lists/*
