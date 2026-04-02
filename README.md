# Infra

Bezum infrastructure is aimed at local development and k3s deployment.

## Bash Entrypoint

Main interface:

```bash
./infra/dev.sh up
./infra/dev.sh down
./infra/dev.sh restart
./infra/dev.sh rebuild
./infra/dev.sh logs
./infra/dev.sh flags
./infra/dev.sh refresh-flags
./infra/dev.sh reset
```

`up`:
- generates `infra/env/generated/runtime.env` if missing
- generates `infra/env/generated/flags.env` if missing
- starts all services through compose
- prints generated flags and hints

`reset`:
- stops the stack
- removes generated runtime env
- removes generated flags
- regenerates flags and secrets
- rebuilds and starts the stack again

`refresh-flags`:
- recreates only `infra/env/generated/flags.env`
- leaves `JWT_SECRET` and other runtime settings untouched
- backend begins accepting the new values without a full reset because it reads the flag file directly

## Compose

File: `infra/compose/docker-compose.yml`

Services:
- `frontend` listens on `8000` inside the container and `18000` on the host by default
- `backend` listens on `8001` inside the container and `18001` on the host by default for world websocket and API
- `auth` listens on `8002` inside the container and `18002` on the host by default
- `bank` listens on `8003` inside the container and `18003` on the host by default
- `notes` listens on `8004` inside the container and `18004` on the host by default
- `inmemory` listens on `8005` inside the container and `18005` on the host by default
- `games` listens on `8006` inside the container and `18006` on the host by default
- `chat` listens on `8007` inside the container and `18007` on the host by default

Inside compose, `frontend` reaches `auth`, `backend`, and `chat` through `FRONTEND_*_URL` using internal service names.

If frontend runs on the host, `runtime.env` already contains host-friendly `FRONTEND_AUTH_URL`, `FRONTEND_BACKEND_URL`, and `FRONTEND_CHAT_URL`.

## Generated Env

`infra/env/generated/runtime.env` contains:
- ports
- service URLs
- `FRONTEND_*_URL` for host-run frontend
- websocket public path/port overrides for local and ingress
- `JWT_SECRET`
- `FLAGS_FILE`
- the public `/flag` easter egg text
- hints

`infra/env/generated/flags.env` contains:
- all `FLAG_*`
- values that backend rotates after a successful submission

Do not commit generated values to a public repository.
