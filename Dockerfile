FROM elixir:latest AS build

RUN apt update
RUN apt install npm -y git -y python -y

#ENV SECRET_KEY_BASE=$SECRET_KEY_BASE
ARG SECRET_KEY_BASE=BRu4A20jdEH8IhrO9WCy3He42QNOJl4N32iim1Ey2pCfuVCuKVeYSkK6L2mBOPYU
# prepare build dir
WORKDIR /app
# export secret key
RUN export SECRET_KEY_BASE=BRu4A20jdEH8IhrO9WCy3He42QNOJl4N32iim1Ey2pCfuVCuKVeYSkK6L2mBOPYU
# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force
# set build ENV
ENV MIX_ENV=prod

# set build in development
#ENV MIX_ENV=dev

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.update --all, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
#RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
#RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM ubuntu:20.04 AS app

WORKDIR /app

RUN apt update
RUN apt install libssl-dev -y wget -y


COPY --from=build /app/_build/prod/rel/nrfa_elixir ./

ENV HOME=/app

CMD ["bin/probase", "start"]