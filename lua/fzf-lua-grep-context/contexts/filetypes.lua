-- Predefined filetype-based context group for fzf-lua-grep-context

---@type ContextGroup
local filetypes = {
  title = "Filetypes",
  entries = {
    html = {
      label = "HTML",
      filetype = "html",
      commands = {
        rg = { flags = { "--type", "html" } },
        git_grep = { globs = { "*.htm", "*.html", "*.shtml" } },
      },
    },
    css = {
      label = "CSS",
      filetype = "css",
      commands = {
        rg = { flags = { "--type", "css" } },
        git_grep = { globs = { "*.css" } },
      },
    },
    javascript = {
      label = "Javascript",
      filetype = "javascript",
      commands = {
        rg = { flags = { "--type", "javascript" } },
        git_grep = { globs = { "*.js", "*.mjs", "*.cjs" } },
      },
    },
    json = {
      label = "JSON",
      filetype = "json",
      commands = {
        rg = { flags = { "--type", "json" } },
        git_grep = { globs = { "*.json" } },
      },
    },
    markdown = {
      label = "Markdown",
      filetype = "markdown",
      commands = {
        rg = { flags = { "--type", "markdown" } },
        git_grep = {
          globs = { "*.markdown", "*.mdown", "*.mdwn", "*.md", "*.mkd", "*.mkdn", "*.mdtxt", "*.mdtext" },
        },
      },
    },
    python = {
      label = "Python",
      filetype = "python",
      commands = {
        rg = { flags = { "--type", "python" } },
        git_grep = { globs = { "*.py" } },
      },
    },
    ruby = {
      label = "Ruby",
      filetype = "ruby",
      commands = {
        rg = { flags = { "--type", "ruby" } },
        git_grep = { globs = { "*.rb", "*.rake", "*.gemspec", "*.ru", "*.erb" } },
      },
    },
    rust = {
      label = "Rust",
      filetype = "rust",
      commands = {
        rg = { flags = { "--type", "rust" } },
        git_grep = { globs = { "*.rs" } },
      },
    },
    lua = {
      label = "Lua",
      filetype = "lua",
      commands = {
        rg = { flags = { "--type", "lua" } },
        git_grep = { globs = { "*.lua" } },
      },
    },
    sh = {
      label = "Shell script",
      filetype = "sh",
      commands = {
        rg = { flags = { "--type", "sh" } },
        git_grep = { globs = { "*.sh", "*.bash", "*.zsh" } },
      },
    },
    toml = {
      label = "TOML",
      filetype = "toml",
      commands = {
        rg = { flags = { "--type", "toml" } },
        git_grep = { globs = { "*.toml" } },
      },
    },
    typescript = {
      label = "Typescript",
      filetype = "typescript",
      commands = {
        rg = { flags = { "--type", "typescript" } },
        git_grep = { globs = { "*.ts", "*.tsx" } },
      },
    },
    yaml = {
      label = "YAML",
      filetype = "yaml",
      commands = {
        rg = { flags = { "--type", "yaml" } },
        git_grep = { globs = { "*.yaml", "*.yml" } },
      },
    },
    c = {
      label = "C",
      filetype = "c",
      commands = {
        rg = { flags = { "--type", "c" } },
        git_grep = { globs = { "*.c", "*.h" } },
      },
    },
    cpp = {
      label = "C++/Cpp",
      filetype = "cpp",
      commands = {
        rg = { flags = { "--type", "cpp" } },
        git_grep = { globs = { "*.[ch]pp", "*.cc", "*.hh", "*.[ch]xx", "*.inl", "*.h" } },
      },
    },
    cs = {
      label = "C#",
      filetype = "cs",
      commands = {
        rg = { flags = { "--type", "cs" } },
        git_grep = { globs = { "*.cs" } },
      },
    },
    go = {
      label = "Go",
      filetype = "go",
      commands = {
        rg = { flags = { "--type", "go" } },
        git_grep = { globs = { "*.go" } },
      },
    },
    java = {
      label = "Java",
      filetype = "java",
      commands = {
        rg = { flags = { "--type", "java" } },
        git_grep = { globs = { "*.java", "*.class", "*.jar" } },
      },
    },
    php = {
      label = "PHP",
      filetype = "php",
      commands = {
        rg = { flags = { "--type", "php" } },
        git_grep = { globs = { "*.php", "*.php3", "*.php4", "*.php5", "*.phtml" } },
      },
    },
    kotlin = {
      label = "Kotlin",
      filetype = "kotlin",
      commands = {
        rg = { flags = { "--type", "kotlin" } },
        git_grep = { globs = { "*.kt", "*.kts" } },
      },
    },
    swift = {
      label = "Swift",
      filetype = "swift",
      commands = {
        rg = { flags = { "--type", "swift" } },
        git_grep = { globs = { "*.swift" } },
      },
    },
    scala = {
      label = "Scala",
      filetype = "scala",
      commands = {
        rg = { flags = { "--type", "scala" } },
        git_grep = { globs = { "*.scala", "*.sc" } },
      },
    },
    dart = {
      label = "Dart",
      filetype = "dart",
      commands = {
        rg = { flags = { "--type", "dart" } },
        git_grep = { globs = { "*.dart" } },
      },
    },
    r = {
      label = "R",
      filetype = "r",
      commands = {
        rg = { flags = { "--type", "r" } },
        git_grep = { globs = { "*.r", "*.R" } },
      },
    },
    text = {
      label = "Plain Text",
      filetype = "text",
      commands = {
        rg = { flags = { "--type", "text" } },
        git_grep = { globs = { "*.txt" } },
      },
    },
    scss = {
      label = "SCSS",
      filetype = "scss",
      commands = {
        rg = { flags = { "--type", "scss" } },
        git_grep = { globs = { "*.scss", "*.sass" } },
      },
    },
    xml = {
      label = "XML",
      filetype = "xml",
      commands = {
        rg = { flags = { "--type", "xml" } },
        git_grep = { globs = { "*.xml" } },
      },
    },
    haskell = {
      label = "Haskell",
      filetype = "haskell",
      commands = {
        rg = { flags = { "--type", "haskell" } },
        git_grep = { globs = { "*.hs", "*.lhs" } },
      },
    },
    elixir = {
      label = "Elixir",
      filetype = "elixir",
      commands = {
        rg = { flags = { "--type", "elixir" } },
        git_grep = { globs = { "*.ex", "*.exs" } },
      },
    },
    erlang = {
      label = "Erlang",
      filetype = "erlang",
      commands = {
        rg = { flags = { "--type", "erlang" } },
        git_grep = { globs = { "*.erl", "*.hrl" } },
      },
    },
    perl = {
      label = "Perl",
      filetype = "perl",
      commands = {
        rg = { flags = { "--type", "perl" } },
        git_grep = { globs = { "*.pl", "*.pm", "*.t" } },
      },
    },
    groovy = {
      label = "Groovy",
      filetype = "groovy",
      commands = {
        rg = { flags = { "--type", "groovy" } },
        git_grep = { globs = { "*.groovy", "*.gvy", "*.gy", "*.gsh" } },
      },
    },
    proto = {
      label = "Protocol Buffers",
      filetype = "proto",
      commands = {
        rg = { flags = { "--type", "proto" } },
        git_grep = { globs = { "*.proto" } },
      },
    },
  },
}

return filetypes
