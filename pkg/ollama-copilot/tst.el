;;; pkg/ollama-copilot/tst.el -*- lexical-binding: t; -*-

(defun write-res (status)
  (message (format "Stat: \"%s\"" status)))

(defun ollama-lzy (url prompt model)
  (let* ((url-request-method "POST")
         (url-request-extra-headers
          '(("Content-Type" . "application/json")))
         (url-request-data
          (encode-coding-string
           (json-encode `((model . ,model) (prompt . ,prompt)))
           'utf-8)))
    (with-current-buffer (url-retrieve url #'write-res)
      (goto-char url-http-end-of-headers)
      (decode-coding-string
       (buffer-substring-no-properties
        (point)
        (point-max))
       'utf-8))))

(ollama-lzy "http://localhost:11434/api/generate" "Why is the sky blue?" "codellama")
