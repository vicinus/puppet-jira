# Class to install the MySQL Java connector
class jira::mysql_connector (
  $version      = $jira::mysql_connector_version,
  $product      = $jira::mysql_connector_product,
  $format       = $jira::mysql_connector_format,
  $installdir   = $jira::mysql_connector_install,
  $download_url = $jira::mysql_connector_url,
) {
  $file = "${product}-${version}.${format}"

  archive { "/tmp/${file}":
    ensure          => present,
    extract         => true,
    extract_command => 'tar xfz %s --strip-components=1',
    extract_path    => $installdir,
    source          => "${download_url}/${file}",
    creates         => "${installdir}/${product}-${version}",
    cleanup         => true,
    proxy_server    => $jira::proxy_server,
    proxy_type      => $jira::proxy_type,
    before          => File[$jira::homedir],
    require         => [
      File[$jira::installdir],
      File[$jira::webappdir],
      User[$jira::user],
    ],
  }

  file { "${jira::webappdir}/lib/mysql-connector-java.jar":
    ensure => link,
    target => "${installdir}/${product}-${version}/${product}-${version}-bin.jar",
  }
}
