{ lib
, emacs
, writeScript
}:
writeScript "indent-elisp" ''
  #!${lib.getExe emacs} --script
  (find-file (nth 0 argv))
  (indent-region (point-min) (point-max) nil)
  (save-buffer)
''
