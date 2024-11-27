;; Match foldable blocks enclosed by '{{{' and '}}}'
(
  (source_file
    (foldable_block) @fold)
)

;; Foldable block definition
(foldable_block
  "*{{{"
  (_)*
  "*}}}"
)
