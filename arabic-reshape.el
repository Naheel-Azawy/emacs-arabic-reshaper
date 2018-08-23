
(defun arabic-safe-save ()
  (remove-hook 'after-save-hook 'arabic-reshape-hook t)
  (save-buffer)
  (if arabic-reshape-mode
      (add-hook 'after-save-hook 'arabic-reshape-hook nil t)))

(defun arabic-reshape-priv ()
  (let ((loc (point)))
    (shell-command
     (concat "cat '" buffer-file-name "' | arabic-reshape")
     (current-buffer))
    (delete-trailing-whitespace)
    (goto-char loc)))

(defun arabic-unshape-priv ()
  (let ((loc (point)))
    (shell-command
     (concat "cat '" buffer-file-name "' | env ARRESHOPT='u' arabic-reshape")
     (current-buffer))
    (delete-trailing-whitespace)
    (goto-char loc)))

(defun arabic-unshape-reshape-priv ()
  (let ((loc (point)))
    (shell-command
     (concat "cat '" buffer-file-name "' | env ARRESHOPT='b' arabic-reshape")
     (current-buffer))
    (delete-trailing-whitespace)
    (goto-char loc)))

(defun arabic-reshape ()
  (interactive)
  (arabic-safe-save)
  (arabic-reshape-priv))

(defun arabic-unshape ()
  (interactive)
  (arabic-safe-save)
  (arabic-unshape-priv))

(defun arabic-unshape-reshape ()
  (interactive)
  (arabic-safe-save)
  (arabic-unshape-reshape-priv))

(defun arabic-reshape-hook ()
  (arabic-unshape-reshape-priv)
  (arabic-safe-save))

(define-minor-mode arabic-reshape-mode
  "Shape and unshape Arabic characters"
  :lighter " AP"
  (if arabic-reshape-mode
      (progn
        (arabic-reshape)
        (add-hook 'after-save-hook 'arabic-reshape-hook nil t))
    (remove-hook 'after-save-hook 'arabic-reshape-hook t)))
