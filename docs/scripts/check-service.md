# Check Service Script

## Purpose

The script validates the port argument and logs the service check steps.

## Usage

```bash
./scripts/check-service.sh <hostname> <port>
```

Example:

```bash
./scripts/check-service.sh example.com 443
```

## Validation

- Exactly two arguments are required.
- The port must contain only numeric characters.
- The port must be between 1 and 65535.

## Limitations

The script does not establish a network connection or verify whether the specified service is actually reachable.

## Static analysis

The script is checked using:

- `bash -n`
- `shellcheck`
