{application, perv, [
    {description, "HTTP content sniffer"},
        {vsn, "0.01"},
        {modules, [
            perv,
            pervon,
            perv_sup,
            perv_app,
            peep
                ]},
        {registered, [perv]},
        {applications, [
            kernel,
            stdlib
                ]},
        {mod, {perv_app, []}},
        {env, []}
    ]}.