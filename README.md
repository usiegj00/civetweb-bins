## Build All Binaries (Bullseye, Jammy, Noble)

This uses a multi-stage Docker build to compile binaries for Debian Bullseye, Ubuntu 22.04 (Jammy), and Ubuntu 24.04 (Noble).

1.  **Build the multi-stage Docker image:**
    ```bash
    docker build -t civetweb-multibuild .
    ```

2.  **Extract the binaries:**
    Use the `docker build --output` command to copy the binaries from the final build stage directly into your local `bins` directory.
    ```bash
    docker build --output ./bins --target final .
    ```

The `./bins` directory will now contain:
*   `civetweb-1.16-debian-bullseye-amd64`
*   `civetweb-1.16-ubuntu-jammy-amd64`
*   `civetweb-1.16-ubuntu-noble-amd64`
