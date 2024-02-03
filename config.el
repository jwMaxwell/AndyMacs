;; [[file:config.org::*Identity][Identity:1]]
(setq user-full-name "Andrew Maxwell"
      user-mail-address "whatever@you.want")
;; Identity:1 ends here

;; [[file:config.org::*Theme][Theme:1]]
(setq doom-theme 'doom-one)
;; Theme:1 ends here

;; [[file:config.org::*Welcome Screen][Welcome Screen:1]]
(setq +doom-dashboard-banner-file "~/.config/doom/resources/emacs-e.png")
;; Welcome Screen:1 ends here

;; [[file:config.org::*Enable Line Numbers][Enable Line Numbers:1]]
(setq display-line-numbers-type t)
;; Enable Line Numbers:1 ends here

;; [[file:config.org::*Maximize Emacs on Launch][Maximize Emacs on Launch:1]]
(setq-default frame-resize-pixelwise t)
(add-hook 'window-setup-hook #'toggle-frame-maximized t)
;; Maximize Emacs on Launch:1 ends here

;; [[file:config.org::*Trim Code on Save][Trim Code on Save:1]]
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; Trim Code on Save:1 ends here

;; [[file:config.org::*Tab Size][Tab Size:1]]
(setq-default tab-width 2)
;; Tab Size:1 ends here

;; [[file:config.org::*Apps on Startup][Apps on Startup:1]]
;; (add-hook 'doom-init-ui-hook #'treemacs)
(add-hook 'doom-init-ui-hook #'minimap-mode)
(add-hook 'doom-init-ui-hook #'ergoemacs-mode) ;; Standard-ish keymap
;; Apps on Startup:1 ends here

;; [[file:config.org::*Code Completion][Code Completion:1]]
(setq company-idle-delay 0.2
      company-minimum-prefix-length 2)
;; Code Completion:1 ends here

;; [[file:config.org::*Keybindings][Keybindings:1]]
(defun my-search-replace ()
  "Search and replace in current file (cmd h)"
  (interactive)
  (let ((start-pos (point)))
    (goto-char (point-min))
    (call-interactively 'replace-string)
    (goto-char start-pos)))

;; FIXME
(defun my-open-term ()
  "Toggle a horizontal split containing a terminal."
  (interactive)
  (if (eq (current-buffer) (get-buffer "*terminal*"))
      (delete-window)
    (if (get-buffer-window "*terminal*")
        (delete-window (get-buffer-window "*terminal*"))
      (progn
        (split-window-below)
        (other-window 1)
        (term "/bin/bash")))))

(defun my-mark-next-token ()
  "Select the next instance of a given token in the current file"
  (interactive)
  (if (region-active-p)
      (mc/mark-next-word-like-this 1)
    (progn
      (forward-word)
      (backward-word)
      (set-mark (point))
      (forward-word))))

(defun my-search-across-files ()
  (interactive)
  (if (eq (buffer-substring (region-beginning) (region-end)) "")
      (counsel-rg)
    (counsel-rg (buffer-substring (region-beginning) (region-end)))))

(with-eval-after-load 'ergoemacs-mode
  (define-key ergoemacs-user-keymap (kbd "C-S-p") 'counsel-M-x)
  (define-key ergoemacs-user-keymap (kbd "C-h") 'my-search-replace)
  (define-key ergoemacs-user-keymap (kbd "C-`") 'my-open-term)
  (define-key ergoemacs-user-keymap (kbd "C-b") 'treemacs)
  (define-key ergoemacs-user-keymap (kbd "C-/") 'comment-line)
  (define-key ergoemacs-user-keymap (kbd "C-p") 'find-file)
  (define-key ergoemacs-user-keymap (kbd "C-d") 'my-mark-next-token)
  (define-key ergoemacs-user-keymap (kbd "C-u") 'mc/unmark-next-like-this)
  (define-key ergoemacs-user-keymap (kbd "C-S-f") 'my-search-across-files)
  (define-key ergoemacs-user-keymap (kbd "C-g") 'goto-line)
  (define-key ergoemacs-user-keymap (kbd "<f2>") 'js2r-rename-var)
  )
;; Keybindings:1 ends here
