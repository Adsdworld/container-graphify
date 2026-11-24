# container-graphify

A container that builds the [graphify](https://github.com/Graphify-Labs/graphify)
knowledge graph of the code mounted on `/work`, the same way each time.

Built first to keep `graphify-out/` up to date in a GitLab fork, usable on any
repository.

## Contract

- It maps the code of `/work` into `/work/graphify-out/` (`graph.json`,
  `GRAPH_REPORT.md`, `graph.html`), on code only: no LLM, no API key, no
  network. It runs with `--network none`.
- The same code gives the same files, byte for byte. The extraction cache and
  the manifest, which hold local state, are removed.
- Once the graph is built, the executables of `/etc/graphify/generators.d`
  run in name order. Each gets the target directory as `$1` and writes only
  inside its `graphify-out/`. This is how other generators are added.
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
| `GENERATORS_DIR` | `/etc/graphify/generators.d` | where the generators are |

## Add a generator

Mount executables on `/etc/graphify/generators.d`, see
[examples/generators.d](examples/generators.d):

```sh
docker run --rm --network none -v "$PWD:/work" \
  -v "$PWD/generators.d:/etc/graphify/generators.d:ro" \
  ghcr.io/adsdworld/container-graphify:latest
```

For a tool that needs to be installed, derive the image or build it with
`--build-arg EXTRA_PIP="<pip packages>"`. `GRAPHIFY_VERSION` pins graphify
(latest by default).

Generators must be reproducible too: the build is meant to be run again on
every push, and to change nothing when the code did not change.
