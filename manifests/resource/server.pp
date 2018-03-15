# define: nginx::resource::server
#
# This definition creates a virtual host
#
# Parameters:
#   [*ensure*]                     - Enables or disables the specified server (present|absent)
#   [*listen_ip*]                  - Default IP Address for NGINX to listen with this server on. Defaults to all interfaces (*)
#   [*listen_port*]                - Default IP Port for NGINX to listen with this server on. Defaults to TCP 80
#   [*listen_options*]             - Extra options for listen directive like 'default_server' to catchall. Undef by default.
#   [*listen_unix_socket_enable*]  - BOOL value to enable/disable UNIX socket listening support (false|true).
#   [*listen_unix_socket*]         - Default unix socket for NGINX to listen with this server on. Defaults to UNIX /var/run/nginx.sock
#   [*listen_unix_socket_options*] - Extra options for listen directive like 'default' to catchall. Undef by default.
#   [*location_satisfy*]           - Allows access if all (all) or at least one (any) of the auth modules allow access.
#   [*location_allow*]             - Array: Locations to allow connections from.
#   [*location_deny*]              - Array: Locations to deny connections from.
#   [*ipv6_enable*]                - BOOL value to enable/disable IPv6 support (false|true). Module will check to see if IPv6 support
#     exists on your system before enabling.
#   [*ipv6_listen_ip*]             - Default IPv6 Address for NGINX to listen with this server on. Defaults to all interfaces (::)
#   [*ipv6_listen_port*]           - Default IPv6 Port for NGINX to listen with this server on. Defaults to TCP 80
#   [*ipv6_listen_options*]        - Extra options for listen directive like 'default' to catchall. Template will allways add ipv6only=on.
#     While issue jfryman/puppet-nginx#30 is discussed, default value is 'default'.
#   [*add_header*]                 - Hash: Adds headers to the HTTP response when response code is equal to 200, 204, 301, 302 or 304.
#   [*index_files*]                - Default index files for NGINX to read when traversing a directory
#   [*autoindex*]                  - Set it on 'on' or 'off 'to activate/deactivate autoindex directory listing. Undef by default.
#   [*proxy*]                      - Proxy server(s) for the root location to connect to.  Accepts a single value, can be used in
#     conjunction with nginx::resource::upstream
#   [*proxy_read_timeout*]         - Override the default proxy read timeout value of 90 seconds
#   [*proxy_send_timeout*]         - Override the default proxy send timeout value of 90 seconds
#   [*proxy_redirect*]             - Override the default proxy_redirect value of off.
#   [*proxy_buffering*]            - If defined, sets the proxy_buffering to the passed value.
#   [*resolver*]                   - Array: Configures name servers used to resolve names of upstream servers into addresses.
#   [*fastcgi*]                    - location of fastcgi (host:port)
#   [*fastcgi_param*]              - Set additional custom fastcgi_params
#   [*fastcgi_params*]             - optional alternative fastcgi_params file to use
#   [*fastcgi_index*]              - optional FastCGI index page
#   [*fastcgi_script*]             - optional SCRIPT_FILE parameter
#   [*uwsgi_read_timeout*]         - optional value for uwsgi_read_timeout
#   [*ssl*]                        - Indicates whether to setup SSL bindings for this server.
#   [*ssl_cert*]                   - Pre-generated SSL Certificate file to reference for SSL Support. This is not generated by this module.
#     Set to `false` to inherit from the http section, which improves performance by conserving memory.
#   [*ssl_client_cert*]            - Pre-generated SSL Certificate file to reference for client verify SSL Support. This is not generated by
#     this module.
#   [*ssl_verify_client*]          - Enables verification of client certificates.
#   [*ssl_crl*]                    - String: Specifies CRL path in file system
#   [*ssl_dhparam*]                - This directive specifies a file containing Diffie-Hellman key agreement protocol cryptographic
#     parameters, in PEM format, utilized for exchanging session keys between server and client. Defaults to nginx::ssl_dhparam
#   [*ssl_ecdh_curve*]             - This directive specifies a curve for ECDHE ciphers.
#   [*ssl_prefer_server_ciphers*]  - String: Specifies that server ciphers should be preferred over client ciphers when using the SSLv3 and
#     TLS protocols. Defaults to nginx::ssl_prefer_server_ciphers.
#   [*ssl_redirect*]               - Adds a server directive and return statement to force ssl redirect. Will honor ssl_port if it's set.
#   [*ssl_redirect_port*]          - Overrides $ssl_port in the SSL redirect set by ssl_redirect
#   [*ssl_key*]                    - Pre-generated SSL Key file to reference for SSL Support. This is not generated by this module. Set to
#     `false` to inherit from the http section, which improves performance by conserving memory.
#   [*ssl_port*]                   - Default IP Port for NGINX to listen with this SSL server on. Defaults to TCP 443
#   [*ssl_protocols*]              - SSL protocols enabled. Defaults to 'TLSv1 TLSv1.1 TLSv1.2'.
#   [*ssl_buffer_size*]            - Sets the size of the buffer used for sending data.
#   [*ssl_ciphers*]                - SSL ciphers enabled. Defaults to nginx::ssl_ciphers
#   [*ssl_stapling*]               - Bool: Enables or disables stapling of OCSP responses by the server. Defaults to false.
#   [*ssl_stapling_file*]          - String: When set, the stapled OCSP response will be taken from the specified file instead of querying
#     the OCSP responder specified in the server certificate.
#   [*ssl_stapling_responder*]     - String: Overrides the URL of the OCSP responder specified in the Authority Information Access
#     certificate extension.
#   [*ssl_stapling_verify*]        - Bool: Enables or disables verification of OCSP responses by the server. Defaults to false.
#   [*ssl_session_timeout*]        - String: Specifies a time during which a client may reuse the session parameters stored in a cache.
#     Defaults to 5m.
#   [*ssl_session_tickets*]        - String: Enables or disables session resumption through TLS session tickets.
#   [*ssl_session_ticket_key*]     - String: Sets a file with the secret key used to encrypt and decrypt TLS session tickets.
#   [*ssl_trusted_cert*]           - String: Specifies a file with trusted CA certificates in the PEM format used to verify client
#     certificates and OCSP responses if ssl_stapling is enabled.
#   [*ssl_verify_depth*]           - Integer: Sets the verification depth in the client certificates chain.
#   [*spdy*]                       - Toggles SPDY protocol.
#   [*http2*]                      - Toggles HTTP/2 protocol.
#   [*server_name*]                - List of servernames for which this server will respond. Default [$name].
#   [*www_root*]                   - Specifies the location on disk for files to be read from. Cannot be set in conjunction with $proxy
#   [*rewrite_www_to_non_www*]     - Adds a server directive and rewrite rule to rewrite www.domain.com to domain.com in order to avoid
#     duplicate content (SEO);
#   [*try_files*]                  - Specifies the locations for files to be checked as an array. Cannot be used in conjuction with $proxy.
#   [*proxy_cache*]                - This directive sets name of zone for caching. The same zone can be used in multiple places.
#   [*proxy_cache_key*]            - Override the default proxy_cache_key of $scheme$proxy_host$request_uri
#   [*proxy_cache_use_stale*]      - Override the default proxy_cache_use_stale value of off.
#   [*proxy_cache_valid*]          - This directive sets the time for caching different replies.
#   [*proxy_cache_lock*]           - This directive sets the locking mechanism for pouplating cache.
#   [*proxy_cache_bypass*]         - Defines conditions which the response will not be cached
#   [*proxy_method*]               - If defined, overrides the HTTP method of the request to be passed to the backend.
#   [*proxy_http_version*]         - Sets the proxy http version
#   [*proxy_set_body*]             - If defined, sets the body passed to the backend.
#   [*auth_basic*]                 - This directive includes testing name and password with HTTP Basic Authentication.
#   [*auth_basic_user_file*]       - This directive sets the htpasswd filename for the authentication realm.
#   [*auth_request*]               - This allows you to specify a custom auth endpoint
#   [*client_max_body_size*]       - This directive sets client_max_body_size.
#   [*client_body_timeout*]        - Sets how long the server will wait for a client body. Default is 60s
#   [*client_header_timeout*]      - Sets how long the server will wait for a client header. Default is 60s
#   [*raw_prepend*]                - A single string, or an array of strings to prepend to the server directive (after cfg prepend
#   directives). NOTE: YOU are responsible for a semicolon on each line that requires one.
#   [*raw_append*]                 - A single string, or an array of strings to append to the server directive (after cfg append
#     directives). NOTE: YOU are responsible for a semicolon on each line that requires one.
#   [*location_raw_prepend*]       - A single string, or an array of strings to prepend to the location directive (after custom_cfg
#     directives). NOTE: YOU are responsible for a semicolon on each line that requires one.
#   [*location_raw_append*]        - A single string, or an array of strings to append to the location directive (after custom_cfg
#     directives). NOTE: YOU are responsible for a semicolon on each line that requires one.
#   [*server_cfg_append*]          - It expects a hash with custom directives to put after everything else inside server
#   [*server_cfg_prepend*]         - It expects a hash with custom directives to put before everything else inside server
#   [*server_cfg_ssl_append*]      - It expects a hash with custom directives to put after everything else inside server ssl
#   [*server_cfg_ssl_prepend*]     - It expects a hash with custom directives to put before everything else inside server ssl
#   [*include_files*]              - Adds include files to server
#   [*access_log*]                 - Where to write access log (log format can be set with $format_log). This can be either a string or an
#     array; in the latter case, multiple lines will be created. Additionally, unlike the earlier behavior, setting it to 'absent' in the
#     server context will remove this directive entirely from the server stanza, rather than setting a default. Can also be disabled for
#     this server with the string 'off'.
#   [*error_log*]                  - Where to write error log. May add additional options like error level to the end. May set to 'absent',
#     in which case it will be omitted in this server stanza (and default to nginx.conf setting)
#   [*passenger_cgi_param*]        - Allows one to define additional CGI environment variables to pass to the backend application
#   [*passenger_set_header*]       - Allows one to set headers to pass to the backend application (Passenger 5.0+)
#   [*passenger_env_var*]          - Allows one to set environemnt variables to pass to the backend application (Passenger 5.0+)
#   [*passenger_pre_start*]        - Allows setting a URL to pre-warm the host. Per Passenger docs, the "domain part of the URL" must match
#     a value of server_name. If this is an array, multiple URLs can be specified.
#   [*log_by_lua*]                 - Run the Lua source code inlined as the <lua-script-str> at the log request processing phase. This does
#     not replace the current access logs, but runs after.
#   [*log_by_lua_file*]            - Equivalent to log_by_lua, except that the file specified by <path-to-lua-script-file> contains the Lua
#     code, or, as from the v0.5.0rc32 release, the Lua/LuaJIT bytecode to be executed.
#   [*gzip_types*]                 - Defines gzip_types, nginx default is text/html
#   [*owner*]                      - Defines owner of the .conf file
#   [*group*]                      - Defines group of the .conf file
#   [*mode*]                       - Defines mode of the .conf file
#   [*maintenance*]                - A boolean value to set a server in maintenance
#   [*maintenance_value*]          - Value to return when maintenance is on.  Default to return 503
#   [*error_pages*]                - Hash: setup errors pages, hash key is the http code and hash value the page
#   [*locations*]                  - Hash of servers resources used by this server
#   [*locations_defaults*]         - Hash of location default settings
# Actions:
#
# Requires:
#
# Sample Usage:
#  nginx::resource::server { 'test2.local':
#    ensure   => present,
#    www_root => '/var/www/nginx-default',
#    ssl      => true,
#    ssl_cert => '/tmp/server.crt',
#    ssl_key  => '/tmp/server.pem',
#  }
define nginx::resource::server (
  Enum['absent', 'present'] $ensure                                      = 'present',
  Variant[Enum['*'], Array[Stdlib::Ipv4], Stdlib::Ipv4] $listen_ip       = '*',
  Stdlib::Port $listen_port                                              = 80,
  Optional[String[1]] $listen_options                                    = undef,
  Boolean $listen_unix_socket_enable                                     = false,
  Variant[Array[String[1]], String[1]] $listen_unix_socket = '/var/run/nginx.sock',
  Optional[String[1]] $listen_unix_socket_options                        = undef,
  Optional[Enum['any', 'all']] $location_satisfy                         = undef,
  Array[String[1]] $location_allow                                       = [],
  Array[String[1]] $location_deny                                        = [],
  Boolean $ipv6_enable                                                   = false,
  Variant[Array[Stdlib::Ipv6], Stdlib::Ipv6] $ipv6_listen_ip             = '::',
  Stdlib::Port $ipv6_listen_port                                         = 80,
  String[1] $ipv6_listen_options                                         = 'default ipv6only=on',
  Optional[Hash[String[1],String]] $add_header                           = undef,
  Boolean $ssl                                                           = false,
  Boolean $ssl_listen_option                                             = true,
  Optional[String[1]] $ssl_cert                                          = undef,
  Optional[String[1]] $ssl_client_cert                                   = undef,
  Enum['on', 'off', 'optional', 'optional_no_ca'] $ssl_verify_client     = 'on',
  Optional[String[1]] $ssl_dhparam                                       = $::nginx::ssl_dhparam,
  Optional[String[1]] $ssl_ecdh_curve                                    = undef,
  Boolean $ssl_redirect                                                  = false,
  Optional[Stdlib::Port] $ssl_redirect_port                              = undef,
  Optional[String[1]] $ssl_key                                           = undef,
  Stdlib::Port $ssl_port                                                 = 443,
  Nginx::Toggle $ssl_prefer_server_ciphers                               = $::nginx::ssl_prefer_server_ciphers,
  String[1] $ssl_protocols                                               = $::nginx::ssl_protocols,
  Optional[String[1]] $ssl_buffer_size                                   = undef,
  String[1] $ssl_ciphers                                                 = $::nginx::ssl_ciphers,
  String[1] $ssl_cache                                                   = 'shared:SSL:10m',
  Optional[String[1]] $ssl_crl                                           = undef,
  Boolean $ssl_stapling                                                  = false,
  Optional[String[1]] $ssl_stapling_file                                 = undef,
  Optional[Pattern[/^http:\/\//]] $ssl_stapling_responder                = undef,
  Boolean $ssl_stapling_verify                                           = false,
  Nginx::Duration $ssl_session_timeout                                   = '5m',
  Optional[Nginx::Toggle] $ssl_session_tickets                           = undef,
  Optional[String[1]] $ssl_session_ticket_key                            = undef,
  Optional[String[1]] $ssl_trusted_cert                                  = undef,
  Optional[Integer] $ssl_verify_depth                                    = undef,
  Boolean $spdy                                                          = $::nginx::spdy,
  Boolean $http2                                                         = $::nginx::http2,
  Optional[Stdlib::Httpurl] $proxy                                       = undef,
  Optional[String[1]] $proxy_redirect                                    = undef,
  Nginx::Duration $proxy_read_timeout                                    = $::nginx::proxy_read_timeout,
  Nginx::Duration $proxy_send_timeout                                    = $::nginx::proxy_send_timeout,
  Nginx::Duration $proxy_connect_timeout                                 = $::nginx::proxy_connect_timeout,
  Array[String[1]] $proxy_set_header                                     = $::nginx::proxy_set_header,
  Array[String[1]] $proxy_hide_header                                    = $::nginx::proxy_hide_header,
  Array[String[1]] $proxy_pass_header                                    = $::nginx::proxy_pass_header,
  Optional[String[1]] $proxy_cache                                       = undef,
  Optional[String[1]] $proxy_cache_key                                   = undef,
  Optional[String[1]] $proxy_cache_use_stale                             = undef,
  Optional[Variant[Array[String[1]], String[1]]] $proxy_cache_valid      = undef,
  Optional[Nginx::Toggle] $proxy_cache_lock                              = undef,
  Optional[Variant[Array[String], String]] $proxy_cache_bypass           = undef,
  Optional[String[1]] $proxy_method                                      = undef,
  Optional[Enum['1.0','1.1']] $proxy_http_version                        = undef,
  Optional[String] $proxy_set_body                                       = undef,
  Optional[Nginx::Toggle] $proxy_buffering                               = undef,
  Array[String[1]] $resolver                                             = [],
  Optional[String[1]] $fastcgi                                           = undef,
  Optional[String[1]] $fastcgi_index                                     = undef,
  Optional[Hash[String[1],String]] $fastcgi_param                        = undef,
  String[1] $fastcgi_params                                              = "${::nginx::conf_dir}/fastcgi.conf",
  Optional[String[1]] $fastcgi_script                                    = undef,
  Optional[String[1]] $uwsgi                                             = undef,
  String[1] $uwsgi_params                                                = "${nginx::config::conf_dir}/uwsgi_params",
  Optional[Nginx::Duration] $uwsgi_read_timeout                          = undef,
  Array[String[1]] $index_files                                          = [
    'index.html',
    'index.htm',
    'index.php'],
  Optional[Nginx::Toggle] $autoindex                                     = undef,
  Array[String[1]] $server_name                                          = [$name],
  Optional[String[1]] $www_root                                          = undef,
  Boolean $rewrite_www_to_non_www                                        = false,
  Optional[Nginx::Directives] $location_custom_cfg                       = undef,
  Optional[Nginx::Directives] $location_cfg_prepend                      = undef,
  Optional[Nginx::Directives] $location_cfg_append                       = undef,
  Optional[Nginx::Directives] $location_custom_cfg_prepend               = undef,
  Optional[Nginx::Directives] $location_custom_cfg_append                = undef,
  Optional[Array[String[1]]] $try_files                                  = undef,
  Optional[String[1]] $auth_basic                                        = undef,
  Optional[String[1]] $auth_basic_user_file                              = undef,
  Optional[String[1]] $auth_request                                      = undef,
  Optional[Nginx::Duration] $client_body_timeout                         = undef,
  Optional[Nginx::Duration] $client_header_timeout                       = undef,
  Optional[String[1]] $client_max_body_size                              = undef,
  Optional[Variant[Array[String[1]], String[1]]] $raw_prepend            = undef,
  Optional[Variant[Array[String[1]], String[1]]] $raw_append             = undef,
  Optional[Variant[Array[String[1]], String[1]]] $location_raw_prepend   = undef,
  Optional[Variant[Array[String[1]], String[1]]] $location_raw_append    = undef,
  Optional[Nginx::Directives] $server_cfg_prepend                        = undef,
  Optional[Nginx::Directives] $server_cfg_append                         = undef,
  Optional[Nginx::Directives] $server_cfg_ssl_prepend                    = undef,
  Optional[Nginx::Directives] $server_cfg_ssl_append                     = undef,
  Optional[Array[String[1]]] $include_files                              = undef,
  Optional[Variant[String[1], Array[String[1]]]] $access_log             = undef,
  Optional[Variant[String[1], Array[String[1]]]] $error_log              = undef,
  String[1] $format_log                                                  = 'combined',
  Optional[Hash[String[1],String]] $passenger_cgi_param                  = undef,
  Optional[Hash[String[1],String]] $passenger_set_header                 = undef,
  Optional[Hash[String[1],String]] $passenger_env_var                    = undef,
  Optional[Variant[Array[String[1]], String[1]]] $passenger_pre_start    = undef,
  Optional[String[1]] $log_by_lua                                        = undef,
  Optional[String[1]] $log_by_lua_file                                   = undef,
  Boolean $use_default_location                                          = true,
  Array[String[1]] $rewrite_rules                                        = [],
  Hash $string_mappings                                                  = {},
  Hash $geo_mappings                                                     = {},
  Optional[String[1]] $gzip_types                                        = undef,
  String[1] $owner                                                       = $::nginx::global_owner,
  String[1] $group                                                       = $::nginx::global_group,
  Stdlib::Filemode $mode                                                 = $::nginx::global_mode,
  Boolean $maintenance                                                   = false,
  String[1] $maintenance_value                                           = 'return 503',
  Optional[Hash[String[1],String]] $error_pages                          = undef,
  Hash $locations                                                        = {},
  Hash $locations_defaults                                               = {}
) {

  if ! defined(Class['nginx']) {
    fail('You must include the nginx base class before using any defined resources')
  }

  # Variables
  if $nginx::confd_only {
    $server_dir = "${nginx::conf_dir}/conf.d"
  } else {
    $server_dir = "${nginx::conf_dir}/sites-available"
    $server_enable_dir = "${nginx::conf_dir}/sites-enabled"
    $server_symlink_ensure = $ensure ? {
      'absent' => absent,
      default  => 'link',
    }
  }

  $name_sanitized = regsubst($name, ' ', '_', 'G')
  $config_file = "${server_dir}/${name_sanitized}.conf"

  File {
    ensure => $ensure ? {
      'absent' => absent,
      default  => 'file',
    },
    notify => Class['::nginx::service'],
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }

  # Add IPv6 Logic Check - Nginx service will not start if ipv6 is enabled
  # and support does not exist for it in the kernel.
  if $ipv6_enable and !$ipv6_listen_ip {
    warning('nginx: IPv6 support is not enabled or configured properly')
  }

  # Check to see if SSL Certificates are properly defined.
  if $ssl {
    if $ssl_cert == undef {
      warning('nginx: ssl enabled but ssl_cert undef')
    }
    if $ssl_key == undef {
      warning('nginx: ssl enabled but ssl_key undef')
    }
  }

  # Try to error in the case where the user sets ssl_port == listen_port but
  # doesn't set ssl = true
  if !$ssl and $ssl_port == $listen_port {
    warning('nginx: ssl must be true if listen_port is the same as ssl_port')
  }

  concat { $config_file:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    notify  => Class['::nginx::service'],
    require => File[$server_dir],
  }

  # This deals with a situation where the listen directive for SSL doesn't match
  # the port we want to force the SSL redirect to.
  if $ssl_redirect_port {
    $_ssl_redirect_port = $ssl_redirect_port
  } elsif $ssl_port {
    $_ssl_redirect_port = $ssl_port
  }

  # Suppress unneeded stuff in non-SSL location block when certain conditions are
  # met.
  $ssl_only = ($ssl and $ssl_port == $listen_port) or $ssl_redirect

  # If we're redirecting to SSL, the default location block is useless, *unless*
  # SSL is enabled for this server
  # either       and    ssl -> true
  # ssl redirect and no ssl -> false
  if (!$ssl_redirect or $ssl) and $use_default_location {
    # Create the default location reference for the server
    nginx::resource::location {"${name_sanitized}-default":
      ensure                      => $ensure,
      server                      => $name_sanitized,
      ssl                         => $ssl,
      ssl_only                    => $ssl_only,
      location                    => '/',
      location_satisfy            => $location_satisfy,
      location_allow              => $location_allow,
      location_deny               => $location_deny,
      proxy                       => $proxy,
      proxy_redirect              => $proxy_redirect,
      proxy_read_timeout          => $proxy_read_timeout,
      proxy_send_timeout          => $proxy_send_timeout,
      proxy_connect_timeout       => $proxy_connect_timeout,
      proxy_cache                 => $proxy_cache,
      proxy_cache_key             => $proxy_cache_key,
      proxy_cache_use_stale       => $proxy_cache_use_stale,
      proxy_cache_valid           => $proxy_cache_valid,
      proxy_method                => $proxy_method,
      proxy_http_version          => $proxy_http_version,
      proxy_set_header            => $proxy_set_header,
      proxy_hide_header           => $proxy_hide_header,
      proxy_pass_header           => $proxy_pass_header,
      proxy_cache_lock            => $proxy_cache_lock,
      proxy_set_body              => $proxy_set_body,
      proxy_cache_bypass          => $proxy_cache_bypass,
      proxy_buffering             => $proxy_buffering,
      fastcgi                     => $fastcgi,
      fastcgi_index               => $fastcgi_index,
      fastcgi_param               => $fastcgi_param,
      fastcgi_params              => $fastcgi_params,
      fastcgi_script              => $fastcgi_script,
      uwsgi                       => $uwsgi,
      uwsgi_params                => $uwsgi_params,
      uwsgi_read_timeout          => $uwsgi_read_timeout,
      try_files                   => $try_files,
      www_root                    => $www_root,
      autoindex                   => $autoindex,
      index_files                 => $index_files,
      location_custom_cfg         => $location_custom_cfg,
      location_cfg_prepend        => $location_cfg_prepend,
      location_cfg_append         => $location_cfg_append,
      location_custom_cfg_prepend => $location_custom_cfg_prepend,
      location_custom_cfg_append  => $location_custom_cfg_append,
      rewrite_rules               => $rewrite_rules,
      raw_prepend                 => $location_raw_prepend,
      raw_append                  => $location_raw_append,
      notify                      => Class['nginx::service'],
    }
    $root = undef
  } else {
    $root = $www_root
  }

  # Only try to manage these files if they're the default one (as you presumably
  # usually don't want the default template if you're using a custom file.

  if $fastcgi != undef and !defined(File[$fastcgi_params]) and $fastcgi_params == "${::nginx::conf_dir}/fastcgi.conf" {
    file { $fastcgi_params:
      ensure  => present,
      mode    => '0644',
      content => template('nginx/server/fastcgi.conf.erb'),
    }
  }

  if $uwsgi != undef and !defined(File[$uwsgi_params]) and $uwsgi_params == "${::nginx::conf_dir}/uwsgi_params" {
    file { $uwsgi_params:
      ensure  => present,
      mode    => '0644',
      content => template('nginx/server/uwsgi_params.erb'),
    }
  }

  if $listen_port != $ssl_port {
    concat::fragment { "${name_sanitized}-header":
      target  => $config_file,
      content => template('nginx/server/server_header.erb'),
      order   => '001',
    }

    # Create a proper file close stub.
    concat::fragment { "${name_sanitized}-footer":
      target  => $config_file,
      content => template('nginx/server/server_footer.erb'),
      order   => '699',
    }
  }

  # Create SSL File Stubs if SSL is enabled
  if $ssl {
    # Access and error logs are named differently in ssl template

    concat::fragment { "${name_sanitized}-ssl-header":
      target  => $config_file,
      content => template('nginx/server/server_ssl_header.erb'),
      order   => '700',
    }
    concat::fragment { "${name_sanitized}-ssl-footer":
      target  => $config_file,
      content => template('nginx/server/server_ssl_footer.erb'),
      order   => '999',
    }
  }

  unless $nginx::confd_only {
    file{ "${name_sanitized}.conf symlink":
      ensure  => $server_symlink_ensure,
      path    => "${server_enable_dir}/${name_sanitized}.conf",
      target  => $config_file,
      require => [File[$server_dir], Concat[$config_file]],
      notify  => Class['::nginx::service'],
    }
  }

  create_resources('::nginx::resource::map', $string_mappings)
  create_resources('::nginx::resource::geo', $geo_mappings)
  create_resources('::nginx::resource::location', $locations, {
    ensure   => $ensure,
    server   => $name_sanitized,
    ssl      => $ssl,
    ssl_only => $ssl_only,
    www_root => $www_root,
  } + $locations_defaults)
}
