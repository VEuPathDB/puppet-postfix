# == Class: postfix
#
# This class configures postfix as either a node listening on localhost which
# forwards mail on to a relayhost or as a relayhost which delivers mail to its
# final destination.
#
# This module is not intended to be a "do it all" postfix module but rather a
# simple module to configure postfix for one of these two scenarios.
#
#
# === Parameters
#
# [*smtp_relay*]
#   Boolean.  If true, this host will forward to final destinatoin.  If false,
#     postfix will forward to relayhost
#   Default: true
#
# [*relay_host*]
#   String.  If smtp_relay == false, what is the next hop for mail?
#   Default: $::domain
#
# [*mydomain*]
#   String.  Local domain of this machine
#   Default: $::domain
#
# [*relay_networks*]
#   String.  Networks that are allowed to relay mail through this host.
#   Default: 127.0.0.1
#
# [*relay_domains*]
#   String.  Domains this machine will relay mail for.
#   Default: ''
#
# [*relay_username*]
#   String.  Username for relayhosts that require SMTP AUTH.
#   Default: ''
#
# [*relay_password*]
#   String.  Password for relayhosts that require SMTP AUTH.
#   Default: ''
#
# [*relay_port*]
#   String.  Port for relayhosts that require SMTP AUTH.
#   Default: 25
#
# [*tls*]
#   Boolean.  Enable TLS for SMTP connections.
#   Default: false
#
# [*tls_bundle*]
#   String.  Path to TLS certificate bundle.
#   Default: Sensible defaults for RedHat and Debian systems, otherwise false.
#
# [*tls_package*]
#   String.  Package containing TLS certificate bundle..
#   Default: Sensible defaults for RedHat and Debian systems, otherwise false.
#
#
# === Examples
#
#   class { 'postfix':
#     smtp_relay  => false,
#     relay_host  => 'mail.internal.com',
#   }
#
#
class postfix (
  Boolean           $smtp_relay                   = $postfix::params::smtp_relay,
  Optional[String]  $relay_host                   = $postfix::params::relay_host,
  String            $mydomain                     = $postfix::params::mydomain,
  String            $relay_networks               = $postfix::params::relay_networks,
  Optional[String]  $relay_domains                = $postfix::params::relay_domains,
  Optional[String]  $relay_username               = $postfix::params::relay_username,
  Optional[String]  $relay_password               = $postfix::params::relay_password,
                    $relay_port                   = $postfix::params::relay_port,
  Boolean           $tls                          = $postfix::params::tls,
                    $tls_bundle                   = $postfix::params::tls_bundle,
                    $tls_package                  = $postfix::params::tls_package,
  Array             $master_config_services       = $postfix::params::master_config_services,
  Hash              $main_options_hash            = $postfix::params::main_options_hash,
  Optional[String]  $smtpd_client_restrictions    = $postfix::params::smtpd_client_restrictions,
  Optional[String]  $smtpd_helo_restrictions      = $postfix::params::smtpd_helo_restrictions,
  Optional[String]  $smtpd_sender_restrictions    = $postfix::params::smtpd_sender_restrictions,
  Optional[String]  $smtpd_recipient_restrictions = $postfix::params::smtpd_recipient_restrictions,
  Optional[String]  $smtpd_data_restrictions      = $postfix::params::smtpd_data_restrictions,
) inherits postfix::params {

  class { '::postfix::install': } ->
  class { '::postfix::config': } ~>
  class { '::postfix::service': }
  Class['postfix::install'] ~> Class['postfix::service']

  include ::postfix::newaliases

}
