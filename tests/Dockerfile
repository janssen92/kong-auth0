FROM kong:1.5.1-ubuntu

ENV LUA_PATH /usr/local/share/lua/5.1/?.lua;/usr/local/kong-auth0/?.lua
ENV LUA_CPATH /usr/local/lib/lua/5.1/?.so

# Install unzip for luarocks, gcc for lua-cjson
RUN apt-get update && apt-get install -y unzip gcc lua5.1
RUN luarocks install luacov
RUN luarocks install luaunit
RUN luarocks install lua-cjson
RUN luarocks install lua-resty-openidc 1.7.2

WORKDIR /usr/local/kong-auth0

COPY . .