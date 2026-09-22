#!/usr/bin/env bash
# Emit O0 LLVM IR, then run mem2reg + loop-vectorize.
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

SRC=loop.c
O0_LL=loop.ll
UNROLLED_LL=unrolled.ll

echo "==> [${CLANG}] O0 emit-llvm -> ${O0_LL}"
# -disable-O0-optnone: otherwise every function gets 'optnone' and opt
# refuses to transform the IR (vectorize would be a no-op).
"${CLANG}" -O0 -Xclang -disable-O0-optnone -emit-llvm -S "${SRC}" -o "${O0_LL}"

echo "==> [${OPT}] mem2reg,loop-vectorize -> ${UNROLLED_LL}"
# mem2reg promotes allocas to SSA; loop-vectorize is the auto-vectorizer
# (it can also interleave / "unroll" iterations into SIMD lanes).
"${OPT}" -passes='mem2reg,loop-vectorize' -S "${O0_LL}" -o "${UNROLLED_LL}"

echo "Done."
echo "  O0 IR:          ${O0_LL}"
echo "  vectorized IR:  ${UNROLLED_LL}"
echo
echo "Tip: compare the first loop in both files, e.g.:"
echo "  grep -n 'vector\|<4 x i32>\|<8 x i32>\|load\|store' ${O0_LL} ${UNROLLED_LL}"
