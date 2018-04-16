#!/usr/bin/env bash

_system()
{
    local cur script coms opts com
    COMPREPLY=()
    _get_comp_words_by_ref -n : cur words

    # for an alias, get the real script behind it
    if [[ $(type -t ${words[0]}) == "alias" ]]; then
        script=$(alias ${words[0]} | sed -E "s/alias ${words[0]}='(.*)'/\1/")
    else
        script=${words[0]}
    fi

    # lookup for command
    for word in ${words[@]:1}; do
        if [[ $word != -* ]]; then
            com=$word
            break
        fi
    done

    # completing for an option
    if [[ ${cur} == --* ]] ; then
        opts="--help --quiet --verbose --version --ansi --no-ansi --no-interaction --env --no-debug"

        case "$com" in
            about)
            opts="${opts} "
            ;;
            help)
            opts="${opts} --format --raw"
            ;;
            list)
            opts="${opts} --raw --format"
            ;;
            assets:install)
            opts="${opts} --symlink --relative"
            ;;
            cache:clear)
            opts="${opts} --no-warmup --no-optional-warmers"
            ;;
            cache:pool:clear)
            opts="${opts} "
            ;;
            cache:pool:prune)
            opts="${opts} "
            ;;
            cache:warmup)
            opts="${opts} --no-optional-warmers"
            ;;
            config:dump-reference)
            opts="${opts} --format"
            ;;
            debug:autowiring)
            opts="${opts} "
            ;;
            debug:config)
            opts="${opts} "
            ;;
            debug:container)
            opts="${opts} --show-private --show-arguments --tag --tags --parameter --parameters --types --format --raw"
            ;;
            debug:event-dispatcher)
            opts="${opts} --format --raw"
            ;;
            debug:router)
            opts="${opts} --show-controllers --format --raw"
            ;;
            debug:translation)
            opts="${opts} --domain --only-missing --only-unused --all"
            ;;
            debug:twig)
            opts="${opts} --format"
            ;;
            lint:twig)
            opts="${opts} --format"
            ;;
            lint:xliff)
            opts="${opts} --format"
            ;;
            lint:yaml)
            opts="${opts} --format --parse-tags"
            ;;
            mjrone:add:database)
            opts="${opts} --operation"
            ;;
            mjrone:add:docker:file)
            opts="${opts} --net_name --net_mode --remove"
            ;;
            mjrone:add:docker:service)
            opts="${opts} --remove --command --environment --buildContext --buildDockerFile --image --networks --ports --restart --volumes --depends --links --memoryLimit"
            ;;
            mjrone:add:phpfpm)
            opts="${opts} --maxChildren --maxSpare --minSpare --maxRam --start --pm --xdebug --port --processIdleTimeout --maxRequests --disableDisplayError --disableLogErrors --flags --values --listen --remove"
            ;;
            mjrone:add:web)
            opts="${opts} --type --description --to --fpm --https --http --charSet --fcgiParams --zRay --clientMaxBodySize --proxyApp --fcgiBufferSize --fcgiConnectionTimeOut --fcgiBuffer --fcgiSendTimeOut --fcgiReadTimeOut --fcgiBusyBufferSize --category --remove"
            ;;
            mjrone:configure:mastermaster)
            opts="${opts} --prefix"
            ;;
            mjrone:configure:masterslave)
            opts="${opts} --prefix"
            ;;
            mjrone:docker:list)
            opts="${opts} "
            ;;
            mjrone:dockerCompose)
            opts="${opts} --build --bundle --down --kill --pull --restart --rm --stop --start --ps --up"
            ;;
            mjrone:generate:docker)
            opts="${opts} "
            ;;
            mjrone:generate:phpfpm)
            opts="${opts} --remove"
            ;;
            mjrone:generate:web)
            opts="${opts} --ignoreApache --ignoreNginx"
            ;;
            mjrone:install)
            opts="${opts} "
            ;;
            mjrone:ngrok)
            opts="${opts} --remove"
            ;;
            mjrone:package:ant)
            opts="${opts} --remove"
            ;;
            mjrone:package:apache2)
            opts="${opts} --remove"
            ;;
            mjrone:package:autocompleter)
            opts="${opts} --remove"
            ;;
            mjrone:package:beanstalkd)
            opts="${opts} --remove"
            ;;
            mjrone:package:beanstalkdAdmin)
            opts="${opts} --remove"
            ;;
            mjrone:package:blackfire)
            opts="${opts} --remove --reconfigure"
            ;;
            mjrone:package:cockpit)
            opts="${opts} --remove"
            ;;
            mjrone:package:composer)
            opts="${opts} --remove --update"
            ;;
            mjrone:package:couchdb)
            opts="${opts} --remove"
            ;;
            mjrone:package:darkstat)
            opts="${opts} --remove"
            ;;
            mjrone:package:docker)
            opts="${opts} --remove"
            ;;
            mjrone:package:dockerCompose)
            opts="${opts} --remove"
            ;;
            mjrone:package:dockerui)
            opts="${opts} --remove"
            ;;
            mjrone:package:elastic)
            opts="${opts} --elasticVersion --remove"
            ;;
            mjrone:package:errbit)
            opts="${opts} --remove"
            ;;
            mjrone:package:flyway)
            opts="${opts} --remove"
            ;;
            mjrone:package:hhvm)
            opts="${opts} --remove"
            ;;
            mjrone:package:java)
            opts="${opts} --remove"
            ;;
            mjrone:package:jenkins)
            opts="${opts} --remove"
            ;;
            mjrone:package:kibana)
            opts="${opts} --remove"
            ;;
            mjrone:package:logstash)
            opts="${opts} --remove"
            ;;
            mjrone:package:mailhog)
            opts="${opts} --remove"
            ;;
            mjrone:package:maria)
            opts="${opts} --remove"
            ;;
            mjrone:package:memcached)
            opts="${opts} --remove"
            ;;
            mjrone:package:mongo)
            opts="${opts} --remove"
            ;;
            mjrone:package:mongodbadmin)
            opts="${opts} --remove"
            ;;
            mjrone:package:mongodbphp)
            opts="${opts} --remove"
            ;;
            mjrone:package:munin)
            opts="${opts} --remove"
            ;;
            mjrone:package:mysql)
            opts="${opts} --mysql --remove"
            ;;
            mjrone:package:netdata)
            opts="${opts} --remove"
            ;;
            mjrone:package:nginx)
            opts="${opts} --remove"
            ;;
            mjrone:package:ngrok)
            opts="${opts} --remove"
            ;;
            mjrone:package:nodejs)
            opts="${opts} --remove"
            ;;
            mjrone:package:ohmyzsh)
            opts="${opts} --remove"
            ;;
            mjrone:package:pgsql)
            opts="${opts} --remove"
            ;;
            mjrone:package:php56)
            opts="${opts} --remove"
            ;;
            mjrone:package:php70)
            opts="${opts} --remove"
            ;;
            mjrone:package:php71)
            opts="${opts} --remove"
            ;;
            mjrone:package:php72)
            opts="${opts} --remove"
            ;;
            mjrone:package:phpmysql)
            opts="${opts} --remove"
            ;;
            mjrone:package:phppma)
            opts="${opts} --remove"
            ;;
            mjrone:package:python)
            opts="${opts} --remove"
            ;;
            mjrone:package:qatools)
            opts="${opts} --remove --include"
            ;;
            mjrone:package:rabbitmq)
            opts="${opts} --remove"
            ;;
            mjrone:package:redis)
            opts="${opts} --remove"
            ;;
            mjrone:package:roachdb)
            opts="${opts} --remove"
            ;;
            mjrone:package:ruby)
            opts="${opts} --remove"
            ;;
            mjrone:package:sqlite)
            opts="${opts} --remove"
            ;;
            mjrone:package:statsd)
            opts="${opts} --remove"
            ;;
            mjrone:package:supervisor)
            opts="${opts} --remove"
            ;;
            mjrone:package:tideways)
            opts="${opts} --remove"
            ;;
            mjrone:package:webdriver)
            opts="${opts} --remove"
            ;;
            mjrone:package:wpcli)
            opts="${opts} --remove --update"
            ;;
            mjrone:package:xdebug)
            opts="${opts} --remove"
            ;;
            mjrone:package:xhgui)
            opts="${opts} --remove"
            ;;
            mjrone:package:yarn)
            opts="${opts} --remove"
            ;;
            mjrone:package:zray)
            opts="${opts} --remove"
            ;;
            mjrone:packages:list)
            opts="${opts} "
            ;;
            mjrone:packages:requirements)
            opts="${opts} "
            ;;
            mjrone:service:cache)
            opts="${opts} "
            ;;
            mjrone:service:database)
            opts="${opts} "
            ;;
            mjrone:service:docker)
            opts="${opts} --ui"
            ;;
            mjrone:service:elasticStack)
            opts="${opts} "
            ;;
            mjrone:service:errbit)
            opts="${opts} "
            ;;
            mjrone:service:mail)
            opts="${opts} "
            ;;
            mjrone:service:monitoring)
            opts="${opts} "
            ;;
            mjrone:service:nosql)
            opts="${opts} "
            ;;
            mjrone:service:php)
            opts="${opts} "
            ;;
            mjrone:service:queue)
            opts="${opts} "
            ;;
            mjrone:service:supervisor)
            opts="${opts} "
            ;;
            mjrone:service:web)
            opts="${opts} "
            ;;
            router:match)
            opts="${opts} --method --scheme --host"
            ;;
            security:encode-password)
            opts="${opts} --empty-salt"
            ;;
            translation:update)
            opts="${opts} --prefix --output-format --dump-messages --force --no-backup --clean --domain"
            ;;

        esac

        COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
        __ltrim_colon_completions "$cur"

        return 0;
    fi

    # completing for a command
    if [[ $cur == $com ]]; then
        coms="about help list assets:install cache:clear cache:pool:clear cache:pool:prune cache:warmup config:dump-reference debug:autowiring debug:config debug:container debug:event-dispatcher debug:router debug:translation debug:twig lint:twig lint:xliff lint:yaml mjrone:add:database mjrone:add:docker:file mjrone:add:docker:service mjrone:add:phpfpm mjrone:add:web mjrone:configure:mastermaster mjrone:configure:masterslave mjrone:docker:list mjrone:dockerCompose mjrone:generate:docker mjrone:generate:phpfpm mjrone:generate:web mjrone:install mjrone:ngrok mjrone:package:ant mjrone:package:apache2 mjrone:package:autocompleter mjrone:package:beanstalkd mjrone:package:beanstalkdAdmin mjrone:package:blackfire mjrone:package:cockpit mjrone:package:composer mjrone:package:couchdb mjrone:package:darkstat mjrone:package:docker mjrone:package:dockerCompose mjrone:package:dockerui mjrone:package:elastic mjrone:package:errbit mjrone:package:flyway mjrone:package:hhvm mjrone:package:java mjrone:package:jenkins mjrone:package:kibana mjrone:package:logstash mjrone:package:mailhog mjrone:package:maria mjrone:package:memcached mjrone:package:mongo mjrone:package:mongodbadmin mjrone:package:mongodbphp mjrone:package:munin mjrone:package:mysql mjrone:package:netdata mjrone:package:nginx mjrone:package:ngrok mjrone:package:nodejs mjrone:package:ohmyzsh mjrone:package:pgsql mjrone:package:php56 mjrone:package:php70 mjrone:package:php71 mjrone:package:php72 mjrone:package:phpmysql mjrone:package:phppma mjrone:package:python mjrone:package:qatools mjrone:package:rabbitmq mjrone:package:redis mjrone:package:roachdb mjrone:package:ruby mjrone:package:sqlite mjrone:package:statsd mjrone:package:supervisor mjrone:package:tideways mjrone:package:webdriver mjrone:package:wpcli mjrone:package:xdebug mjrone:package:xhgui mjrone:package:yarn mjrone:package:zray mjrone:packages:list mjrone:packages:requirements mjrone:service:cache mjrone:service:database mjrone:service:docker mjrone:service:elasticStack mjrone:service:errbit mjrone:service:mail mjrone:service:monitoring mjrone:service:nosql mjrone:service:php mjrone:service:queue mjrone:service:supervisor mjrone:service:web router:match security:encode-password translation:update"

        COMPREPLY=($(compgen -W "${coms}" -- ${cur}))
        __ltrim_colon_completions "$cur"

        return 0
    fi
}

complete -o default -F _system system
