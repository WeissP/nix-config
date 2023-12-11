(with-eval-after-load 'project
  (setq project-loaded-p t)
  (setq weiss-project-root-markers
        '("build.sbt" "pom.xml" "mix.exs" "Cargo.toml" "compile_commands.json" "compile_flags.txt"
          "project.clj" ".git" "deps.edn" "shadow-cljs.edn")
        )

  (defun project-root-p (path)
    "Check if the current PATH has any of the project root markers."
    (catch 'found
      (dolist (marker weiss-project-root-markers)
        (when (file-exists-p (concat path marker))
          (throw 'found marker)))))

  (defun project-find-root (path)
    "Search up the PATH for `project-root-markers'."
    (let ((path (expand-file-name path)))
      (catch 'found
        (while (not (equal "/" path))
          (if (not (project-root-p path))
              (setq path (file-name-directory (directory-file-name path)))
            (throw 'found (cons 'transient path)))))))
  (add-to-list 'project-find-functions #'project-find-root)
  )

(provide 'weiss_project_settings)
