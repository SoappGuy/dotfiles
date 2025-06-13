return {
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
            },
            checkOnSave = {
                allFeatures = true,
                command = 'clippy',
                extraArgs = {
                    '--',
                    '--no-deps',             -- run only on the given crate
                    '-Wclippy::correctness', -- code that is outright wrong or useless
                    '-Wclippy::complexity',  -- code that does something simple but in a complex way
                    '-Wclippy::suspicious',  -- code that is most likely wrong or useless
                    '-Wclippy::style',       -- code that should be written in a more idiomatic way
                    '-Wclippy::perf',        -- code that can be written to run faster
                    '-Wclippy::pedantic',    -- lints which are rather strict or have occasional false positives
                    '-Wclippy::nursery',     -- new lints that are still under development
                    '-Wclippy::cargo',       -- lints for the cargo manifest
                    -- '-Aclippy::restriction',    -- lints which prevent the use of language and library features
                    -- '-Aclippy::must_use_candidate', -- must_use is rather annoying
                },
            },
            procMacro = {
                enable = true,
                ignored = {
                    ['async-trait'] = { 'async_trait' },
                    ['napi-derive'] = { 'napi' },
                    ['async-recursion'] = { 'async_recursion' },
                },
            },
        },
    }
}
