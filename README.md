# container-graphify

A container that takes a directory and delivers its
[graphify](https://github.com/Graphify-Labs/graphify) `graphify-out/`.

Built first to keep `graphify-out/` up to date in a GitLab fork, usable on any
repository.

## Contract

- The directory mounted on `/work` goes in, `/work/graphify-out/`
  (`graph.json`, `GRAPH_REPORT.md`, `graph.html`) comes out.
- It maps code only: no LLM, no API key, no network. It runs with
  `--network none`.
- The same code gives the same files, byte for byte. The extraction cache and
  the manifest, which hold local state, are removed.
- Any other command runs as is: `docker run ... graphify path A B`.
- It runs as `graphify` (uid 1000): the mounted directory must be writable by
  that uid.

## Run

```sh
docker run --rm --network none -v "$PWD:/work" ghcr.io/adsdworld/container-graphify:latest
```

| Variable | Default | |
| --- | --- | --- |
| `GRAPHIFY_TARGET` | `.` | directory to map, relative to `/work` |

`--build-arg GRAPHIFY_VERSION=<version>` pins graphify (latest by default).
