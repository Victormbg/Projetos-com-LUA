# Define a imagem base como Ubuntu 23.04
FROM ubuntu:23.04

# Define o timezone padrão
ENV TZ=America/Sao_Paulo

# Define a variável de ambiente DEBIAN_FRONTEND como noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
        sudo \
        unzip \
        libreadline-dev \
        libreadline8 \
        wget \
        tree \
        liblua5.4-0 \
        liblua5.4-dev \
        liblua5.4-0-dbg \
        libtool-bin \
        pkg-config \
        libc6 \
        libc6-dev \
        dh-lua \
        git \
        neofetch \
    && rm -rf /var/lib/apt/lists/*

# Define a variável PATH incluindo o caminho para o git
ENV PATH="${PATH}:$(which git)"

# Instala bibliotecas gráficas necessárias para a execução do Love2D - AINDA NÃO FUNCIONANDO
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install \
        libdevil-dev \
        libxcursor-dev \
        libxi-dev \
        libxinerama-dev \
        libxrandr-dev \
        libxxf86vm-dev \
        libopenal-dev \
        libalut-dev \
        libvorbis-dev \
        libphysfs-dev \
    && rm -rf /var/lib/apt/lists/*

# Instalação do Lua 5.4.4
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        wget \
    && cd /tmp \
    && wget https://www.lua.org/ftp/lua-5.4.4.tar.gz \
    && tar -xzf lua-5.4.4.tar.gz \
    && rm lua-5.4.4.tar.gz \
    && cd lua-5.4.4 \
    && make linux \
    && make install \
    && cd .. \
    && rm -rf lua-5.4.4 \
    && apt-get autoremove -y \
    && apt-get clean

# Adiciona as variáveis de ambiente LUA_PATH e LUA_CPATH
ENV LUA_PATH="/usr/local/share/lua/5.4/?.lua;/usr/local/share/lua/5.4/?/init.lua;;"
ENV LUA_CPATH="/usr/local/lib/lua/5.4/?.so;/usr/local/lib/lua/5.4/loadall.so;;"

# Instalação do LuaRocks 3.9.2
RUN apt-get update \
    && apt-get install -y \
        wget \
        libreadline-dev \
        libncurses-dev \
        libssl-dev \
        perl \
        make \
    && cd /tmp \
    && wget https://luarocks.org/releases/luarocks-3.9.2.tar.gz \
    && tar zxpf luarocks-3.9.2.tar.gz \
    && cd luarocks-3.9.2 \
    && ./configure --with-lua-include=/usr/local/include \
    && make \
    && make install \
    && cd .. \
    && rm -rf luarocks-3.9.2.tar.gz luarocks-3.9.2 \
    && apt-get autoremove -y \
    && apt-get clean

RUN apt-get update && apt-get install -y \
# LuaJIT
luajit libpcre3-dev \
# OpenSSL, M4 (para pacote cqueues), e libyaml-dev (para pacote lyaml)
libssl-dev m4 libyaml-dev libssl3 libssl-doc \
# Dependências necessárias para compilar o LuaGL
build-essential libgl1-mesa-dev freeglut3-dev libgirepository1.0-dev software-properties-common gobject-introspection \
# Outras bibliotecas essenciais
curl lsb-release \
# Dependências de compilação em geral
perl make \
# Depuração de pacotes de rede
lsof \
&& rm -rf /var/lib/apt/lists/*

# Variáveis de ambiente para a instalação da biblioteca "luacrypto" (que depende do OpenSSL)
ENV CRYPTO_DIR=/usr/lib/
ENV CRYPTO_INCDIR=/usr/include/

# Variáveis de ambiente para a instalação do OpenSSL (necessário para a biblioteca "luacrypto")
ENV OPENSSL_DIR=/usr/lib/x86_64-linux-gnu/
ENV OPENSSL_INCDIR=/usr/include/

# Instala o openresty e o nginx
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget gnupg ca-certificates \
    && wget -O - https://openresty.org/package/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/openresty.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/openresty.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends openresty nginx \
    && rm -rf /var/lib/apt/lists/*

# Instala dependencias para IA
RUN apt-get update && apt-get -y upgrade \
    && apt-get -y install cmake \
    && rm -rf /var/lib/apt/lists/*

# Instala o cwrap do torch
RUN git clone https://github.com/torch/cwrap.git \
    && cd cwrap \
    && luarocks make rocks/cwrap-scm-1.rockspec

# Instala o Love2D
RUN set -e \
    && apt-get clean \
    && apt-get autoclean \
    && apt-get autoremove \
    && dpkg --configure -a \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y love || { echo "Erro ao instalar o Love2D" >> /var/log/love-install.log; true; }

# Instala pacotes via luarocks com log de erro e pulo em caso de falha
RUN luarocks install luaossl || true
RUN luarocks install opengl > /dev/null || true
RUN luarocks install lua-gl > /dev/null || true
RUN luarocks install lgi > /dev/null || true 
RUN luarocks install http > /dev/null || true
RUN luarocks install lua-cjson > /dev/null || true 
RUN luarocks install lapis > /dev/null || true 
RUN luarocks install moonscript > /dev/null || true
RUN luarocks install bcrypt > /dev/null || true 
RUN luarocks install luasec > /dev/null || true
RUN luarocks install lua-term > /dev/null || true
RUN luarocks install dkjson > /dev/null || true 
RUN luarocks install loadkit > /dev/null || true
RUN luarocks install ansicolors > /dev/null || true
RUN luarocks install argparse > /dev/null || true
RUN luarocks install etlua > /dev/null || true
RUN luarocks install date > /dev/null || true
RUN luarocks install pgmoon > /dev/null || true
RUN luarocks install inspect > /dev/null || true
RUN luarocks install penlight > /dev/null || true
RUN luarocks install luasocket > /dev/null || true
RUN luarocks install async > /dev/null || true
RUN luarocks install lua_pack > /dev/null || true
RUN luarocks install lua-resty-session > /dev/null || true
RUN luarocks install lua-ffi-zlib > /dev/null || true 
RUN luarocks install lua-resty-openssl > /dev/null || true
RUN luarocks install lua-resty-jwt > /dev/null || true 
RUN luarocks install lua-resty-openidc > /dev/null || true
RUN luarocks install lua-resty-string > /dev/null || true 
RUN luarocks install luatz > /dev/null || true 
RUN luarocks install lua-cmsgpack > /dev/null || true 
RUN luarocks install lyaml > /dev/null || true 
RUN luarocks install promise-lua > /dev/null || true
RUN luarocks install lpeg > /dev/null || true 
RUN luarocks install --server=https://luarocks.org/dev paths || true 
RUN luarocks install --server=https://luarocks.org/dev torch || true

# Define a variável de ambiente LAPIS_OPENRESTY como o caminho do openresty
ENV LAPIS_OPENRESTY /usr/local/openresty/bin/openresty

# Remove arquivos desnecessários do sistema
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Define o diretório que será usado como volume
VOLUME ["/workspace"]
# Baixando e instalando o CD
# RUN curl -L https://sourceforge.net/projects/canvasdraw/files/5.14/Linux%20Libraries/cd-5.14_Linux50_64_lib.tar.gz -o cd-5.14_Linux50_64_lib.tar.gz \
#     && tar -xzvf cd-5.14_Linux50_64_lib.tar.gz --no-same-owner \
#     && ls \
#     && cd cd-5.14_Linux50_64_lib \
#     && sudo cp -r include/* /usr/local/include/ \
#     && sudo cp -r ftgl/lib/Linux50_64/* /usr/local/lib/ \
#     && cd ..

# Baixando e instalando o IUP
# RUN curl -L https://sourceforge.net/projects/iup/files/3.30/Linux%20Libraries/iup-3.30_Linux54_64_lib.tar.gz -o iup-3.30.tar.gz \
#     && tar -xzvf iup-3.30.tar.gz \
#     && cd iup-3.30_Linux54_64_lib \
#     && sudo cp -r include/* /usr/local/include/ \
#     && sudo cp -r lib/* /usr/local/lib/ \
#     && cd ..
