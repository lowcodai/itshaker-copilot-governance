#!/usr/bin/env bash
# scripts/fetch-awesome-copilot.sh — Downloads the awesome-copilot elements into governance
# Usage: ./scripts/fetch-awesome-copilot.sh [--ref <sha>] [--dry-run]
#
# This script populates the itshaker-copilot-governance repo from github/awesome-copilot.
# Run it once at initialization, then again for updates.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GOVERNANCE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Load the libs from bootstrap if available
BOOTSTRAP_LIB="${GOVERNANCE_DIR}/../itshaker-bootstrap/scripts/lib"
if [[ -d "$BOOTSTRAP_LIB" ]]; then
  source "${BOOTSTRAP_LIB}/log.sh"
  source "${BOOTSTRAP_LIB}/fs.sh"
  source "${BOOTSTRAP_LIB}/gh.sh"
else
  # Minimal fallback logging if bootstrap is absent
  log_info()    { echo "[INFO] $*"; }
  log_success() { echo "[OK]   $*"; }
  log_warn()    { echo "[WARN] $*" >&2; }
  log_error()   { echo "[ERROR] $*" >&2; }
  log_skip()    { echo "[SKIP] $*"; }
  log_section() { echo "--- $* ---"; }
  log_dry()     { echo "[DRY-RUN] $*"; }
  DRY_RUN=false
  EXTEND_ONLY=false
fi

REF="dae77f24132c1d686c30fd5b29aee0d63668d1d2"

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --ref)          REF="$2"; shift 2 ;;
      --dry-run)      DRY_RUN=true; shift ;;
      --extend-only)  EXTEND_ONLY=true; shift ;;
      --verbose)      VERBOSE=true; shift ;;
      *) echo "[ERROR] Unknown argument: $1"; exit 1 ;;
    esac
  done
}

fetch_file() {
  local repo_path="$1" dest="$2"

  if [[ -f "$dest" ]] && [[ "${EXTEND_ONLY:-false}" == "true" ]]; then
    log_skip "$dest (extend-only)"
    return 0
  fi

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    log_dry "Download: github/awesome-copilot/$repo_path → $dest"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"
  local url="https://raw.githubusercontent.com/github/awesome-copilot/${REF}/${repo_path}"
  if curl --fail --silent --max-time 30 "$url" -o "$dest"; then
    log_success "Downloaded: $dest"
  else
    log_warn "Failed: $url — placeholder created"
    echo "# PLACEHOLDER — Source: $url" > "$dest"
    echo "# Download manually and replace this file." >> "$dest"
  fi
}

fetch_dir() {
  local repo_path="$1" dest_dir="$2"

  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    log_dry "Download directory: github/awesome-copilot/$repo_path → $dest_dir"
    return 0
  fi

  if ! command -v gh &>/dev/null; then
    log_warn "gh CLI required to download directories. Install: https://cli.github.com/"
    mkdir -p "$dest_dir"
    echo "# PLACEHOLDER — Source: github/awesome-copilot/$repo_path (ref: $REF)" > "$dest_dir/README.md"
    return 0
  fi

  mkdir -p "$dest_dir"
  local files
  files=$(gh api "repos/github/awesome-copilot/contents/${repo_path}?ref=${REF}" \
    --jq '.[].path' 2>/dev/null) || {
    log_warn "Directory not found: $repo_path"
    return 0
  }

  while IFS= read -r file_path; do
    [[ -z "$file_path" ]] && continue
    local filename
    filename=$(basename "$file_path")
    local dest="${dest_dir}/${filename}"

    if [[ -f "$dest" ]] && [[ "${EXTEND_ONLY:-false}" == "true" ]]; then
      log_skip "$dest"
      continue
    fi

    local content
    content=$(gh api "repos/github/awesome-copilot/contents/${file_path}?ref=${REF}" \
      --jq '.content' 2>/dev/null | base64 -d 2>/dev/null) || {
      log_warn "Unable to download: $file_path"
      continue
    }
    echo "$content" > "$dest"
    log_success "Downloaded: $dest"
  done <<< "$files"
}

main() {
  parse_args "$@"

  log_section "Fetch awesome-copilot (ref: $REF)"

  # ─── Instructions ─────────────────────────────────────────────────────────
  log_section "Instructions"
  local instructions=(
    "devops-core-principles.instructions.md"
    "github-actions-ci-cd-best-practices.instructions.md"
    "ansible.instructions.md"
    "containerization-docker-best-practices.instructions.md"
    "agent-safety.instructions.md"
    "agent-skills.instructions.md"
    "ai-prompt-engineering-safety-best-practices.instructions.md"
    "a11y.instructions.md"
  )
  for instr in "${instructions[@]}"; do
    fetch_file "instructions/${instr}" "${GOVERNANCE_DIR}/instructions/${instr}"
  done

  # ─── Hooks ────────────────────────────────────────────────────────────────
  log_section "Hooks"
  local hooks=(
    "tool-guardian"
    "secrets-scanner"
    "governance-audit"
    "dependency-license-checker"
    "fix-broken-links"
    "session-logger"
    "session-auto-commit"
    "attester-import-check"
  )
  for hook in "${hooks[@]}"; do
    fetch_dir "hooks/${hook}" "${GOVERNANCE_DIR}/hooks/${hook}"
  done

  # ─── Agents ───────────────────────────────────────────────────────────────
  log_section "Agents"
  local agents=(
    "adr-generator.agent.md"
    "ai-readiness-reporter.agent.md"
    "agent-governance-reviewer.agent.md"
    "ai-team-dev.agent.md"
    "accessibility.agent.md"
    "accessibility-runtime-tester.agent.md"
  )
  for agent in "${agents[@]}"; do
    fetch_file "agents/${agent}" "${GOVERNANCE_DIR}/agents/${agent}"
  done

  # ─── Skills ───────────────────────────────────────────────────────────────
  log_section "Skills"
  local skills=(
    "acquire-codebase-knowledge"
    "breakdown-plan"
    "breakdown-epic-arch"
    "breakdown-epic-pm"
    "breakdown-feature-prd"
    "breakdown-feature-implementation"
    "breakdown-test"
    "audit-integrity"
    "agent-supply-chain"
    "acreadiness-assess"
    "acreadiness-generate-instructions"
    "agent-governance"
    "agentic-eval"
    "ai-prompt-engineering-safety-review"
    "agent-owasp-compliance"
    "arize-instrumentation"
    "arize-dataset"
    "arize-evaluator"
    "arize-prompt-optimization"
  )
  for skill in "${skills[@]}"; do
    fetch_dir "skills/${skill}" "${GOVERNANCE_DIR}/skills/${skill}"
  done

  # ─── Plugins ──────────────────────────────────────────────────────────────
  log_section "Plugins"
  local plugins=("acreadiness-cockpit" "ai-team-orchestration" "arch" "arize-ax")
  for plugin in "${plugins[@]}"; do
    fetch_dir "plugins/${plugin}" "${GOVERNANCE_DIR}/plugins/${plugin}"
  done

  log_section "Fetch complete"
  log_info "Directory: $GOVERNANCE_DIR"
  log_info "Ref: $REF"
  log_warn "Check the placeholders created for elements that could not be downloaded"
}

main "$@"
