;;; resources/ollama-copilot/ollama-copilot.el -*- lexical-binding: t; -*-

(require 'json)
(require 'cl-lib)
(require 'url)

(defgroup ollama nil
  "Ollama client for Emacs."
  :group 'ollama)

(defcustom ollama:endpoint "http://localhost:11434/api/generate"
  "Ollama http service endpoint."
  :group 'ollama
  :type 'string)

(defcustom ollama:model "codellama"
  "Ollama model."
  :group 'ollama
  :type 'string)

(defun ollama-fetch (url prompt model)
  (let* ((url-request-method "POST")
         (url-request-extra-headers
          '(("Content-Type" . "application/json")))
         (url-request-data
          (encode-coding-string
           (json-encode `((model . ,model) (prompt . ,prompt)))
           'utf-8)))
    (with-current-buffer (url-retrieve-synchronously url)
      (goto-char url-http-end-of-headers)
      (decode-coding-string
       (buffer-substring-no-properties
        (point)
        (point-max))
       'utf-8))))

(defun ollama-get-response-from-line (line)
  (cdr
   (assoc 'response
          (json-read-from-string line))))

(defun ollama-prompt (url prompt model)
  (mapconcat 'ollama-get-response-from-line
             (cl-remove-if #'(lambda (str) (string= str ""))
                           (split-string (ollama-fetch url prompt model) "\n")) ""))

;;;###autoload
(defun ollama-prompt-line ()
  "Prompt with current word."
  (interactive)
  (with-output-to-temp-buffer "*ollama*"
    (princ
     (ollama-prompt ollama:endpoint (thing-at-point 'line) ollama:model))))

;;;###autoload
(defun ollama-define-word ()
  "Find definition of current word."
  (interactive)
  (with-output-to-temp-buffer "*ollama*"
    (princ
     (ollama-prompt ollama:endpoint (format "define %s" (thing-at-point 'word)) ollama:model))))

;;;###autoload
(defun ollama-summarize-region ()
  "Summarize marked text."
  (interactive)
  (with-output-to-temp-buffer "*ollama*"
    (princ
     (ollama-prompt ollama:endpoint (format "summarize \"\"\"%s\"\"\"" (buffer-substring (region-beginning) (region-end))) ollama:model))))

;;;###autoload
(defun ollama-write-code ()
  "Generate a code snippet."
  (interactive)
  (with-output-to-temp-buffer "*ollama*"
    (princ
     (ollama-lazy-prompt ollama:endpoint (format "program \"\"\"%s\"\"\"" (buffer-substring (region-beginning) (region-end))) ollama:model))))

;;;###autoload
(defun ollama-dev-clean-sync ()
  "Delete old package and run `doom sync`."
  (interactive)
  (delete-directory "~/.config/doom/straight/build/my-package" t)
  (doom/sync))

(provide 'ollama)

;; Emacs lisp, factorial function
