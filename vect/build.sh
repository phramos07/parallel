#!/usr/bin/env bash
# Emit O0 LLVM IR, run mem2reg + loop-vectorize, and dump CFG PDFs for both.
set -euo pipefail

# Prefer Homebrew LLVM so clang and opt share the same IR version.
if [[ -x /opt/homebrew/opt/llvm/bin/clang ]]; then
  CLANG=/opt/homebrew/opt/llvm/bin/clang
  OPT=/opt/homebrew/opt/llvm/bin/opt
elif [[ -x /usr/local/opt/llvm/bin/clang ]]; then
  CLANG=/usr/local/opt/llvm/bin/clang
  OPT=/usr/local/opt/llvm/bin/opt
else
  CLANG="${CLANG:-clang}"
  OPT="${OPT:-opt}"
fi

DOT="${DOT:-dot}"

SRC=loop.c
O0_LL=loop.ll
UNROLLED_LL=unrolled.ll
O0_CFG_PDF=loop.cfg.pdf
UNROLLED_CFG_PDF=unrolled.cfg.pdf

emit_cfg_pdf() {
  local ll="$1"
  local prefix="$2"
  local pdf="$3"
  local dotfile="${prefix}.main.dot"

  echo "==> [${OPT}] dot-cfg (${ll}) -> ${dotfile}"
  "${OPT}" -passes=dot-cfg -cfg-dot-filename-prefix="${prefix}" -disable-output "${ll}"

  echo "==> [${DOT}] ${dotfile} -> ${pdf}"
  "${DOT}" -Tpdf "${dotfile}" -o "${pdf}"
  rm -f "${dotfile}"
}

echo "==> [${CLANG}] O0 emit-llvm -> ${O0_LL}"
# -disable-O0-optnone: otherwise every function gets 'optnone' and opt
# refuses to transform the IR (vectorize would be a no-op).
"${CLANG}" -O0 -Xclang -disable-O0-optnone -emit-llvm -S "${SRC}" -o "${O0_LL}"

echo "==> [${OPT}] mem2reg,loop-vectorize -> ${UNROLLED_LL}"
# mem2reg promotes allocas to SSA; loop-vectorize is the auto-vectorizer
# (it can also interleave / "unroll" iterations into SIMD lanes).
"${OPT}" -passes='mem2reg,loop-vectorize' -S "${O0_LL}" -o "${UNROLLED_LL}"

emit_cfg_pdf "${O0_LL}" "loop" "${O0_CFG_PDF}"
emit_cfg_pdf "${UNROLLED_LL}" "unrolled" "${UNROLLED_CFG_PDF}"

echo "Done."
echo "  O0 IR:             ${O0_LL}"
echo "  vectorized IR:     ${UNROLLED_LL}"
echo "  O0 CFG PDF:        ${O0_CFG_PDF}"
echo "  vectorized CFG PDF:${UNROLLED_CFG_PDF}"
