# Boot Dev Course — AWS via Floci

Zero AWS spend. No card on file, no bill possible.

Floci = local AWS emulator. Drop-in replacement for LocalStack (LocalStack
Community died March 2026, auth-walled now). Fakes S3, DynamoDB, SQS, IAM,
Lambda, and 40+ other services on `localhost:4566`. No AWS account, no auth
token, no card, ever.

## Setup

```
docker compose up -d
```

Starts Floci, binds port 4566, mounts a named volume for persistence.

## Point the AWS CLI at it

```
source floci-env.sh
```

Sets `AWS_ENDPOINT_URL`, region, and dummy creds (`test`/`test`). Every `aws`
command after this hits Floci, not real AWS.

Verify:
```
aws s3 mb s3://test-bucket
aws s3 ls
```

If that works with zero AWS account and zero card — you're set.

## Update Floci

```
./update.sh
```

Pulls latest image, recreates container, prunes old image. Data survives —
lives in a separate Docker volume, untouched by image updates.

## Files

| File             | What                                    |
| ----------------- | --------------------------------------- |
| `compose.yaml`    | Floci container + persistent volume     |
| `floci-env.sh`    | Env vars to point AWS CLI at Floci      |
| `update.sh`       | Pull + recreate on newer Floci release  |

## Persistence

Storage mode: `hybrid`. Flushes to the `floci_data` volume every 5s. Data
survives `docker compose down` and restarts. Delete the volume to reset:
```
docker compose down -v
```

## Limits — read before you rely on this for the whole course

- Not 100% AWS-faithful. Some services are in-process stubs, not real
  behavior (Textract, Transcribe, Bedrock Runtime are stub/dummy responses —
  check Floci's service table if the course touches these).
- Some services run as real Docker containers under the hood (Lambda, RDS,
  EKS, ElastiCache, etc.) — that's why `/var/run/docker.sock` is mounted in.
  If the course wants EKS/RDS-heavy work, expect heavier resource use than a
  pure API mock.
- No billing, no quotas, no real IAM enforcement — don't use this to learn
  cost management or account security, only API/service mechanics.
- If the course explicitly requires real AWS (console screenshots tied to an
  account, marketplace stuff, anything needing a real ARN across accounts),
  Floci won't get you there. Flag those modules early, don't discover it at
  the deadline.

## Never do this

Don't put real AWS credentials in `floci-env.sh` or export them alongside it.
Keep this fully disconnected from any real AWS account.
