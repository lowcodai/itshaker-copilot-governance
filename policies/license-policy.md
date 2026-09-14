# License Policy — itshaker

## Default license

All itshaker repositories use the **MIT** license by default.

For proprietary or sensitive projects: an explicit proprietary license.

## Dependencies — allowed licenses

| Category | Allowed licenses |
|-----------|-------------------|
| Open source | MIT, Apache 2.0, BSD 2-Clause, BSD 3-Clause, ISC, CC0 |
| Documentation | CC BY 4.0, CC BY-SA 4.0 |
| Conditional | LGPL (review required — no static incorporation) |

## Forbidden licenses

- GPL v2/v3: contaminates proprietary code
- AGPL: network service restrictions
- Commons Clause: commercial restrictions
- Licenses without clear attribution

## Automatic verification

The `dependency-license-checker` hook checks licenses on every commit.

Configuration in the project's `.licensee.json` or `.license-checker.yml`.

## Exception procedure

1. Open an issue with the `policy: license-exception` label
2. Describe the dependency and justify the exception
3. Get approval from a maintainer
4. Document the exception in the project's `SECURITY.md`

## Awesome Copilot elements

Elements sourced from `github/awesome-copilot` are MIT licensed.
Check the license of each element before use.
