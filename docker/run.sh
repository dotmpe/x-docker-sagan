#!/usr/bin/env bash

################################
# SAGAN-GROUPS
: ${FIFO:="/var/run/sagan.fifo"}
: ${RULE_PATH:="/usr/local/etc/sagan-rules"}
: ${LOCKFILE:="/var/run/sagan/sagan.pid"}
: ${LOG_PATH:="/var/log/sagan"}
####################
# PORT-GROUPS
: ${SSH_PORT:="22"}
: ${HTTP_PORT:="80"}
: ${HTTPS_PORT:="443"}
: ${TELNET_PORT:="23"}
: ${DNS_PORT:="53"}
: ${SNMP_PORT:="161"}
: ${POP3_PORT:="110"}
: ${IMAP_PORT:="143"}
: ${SMTP_PORT:="25"}
: ${MYSQL_PORT:="3306"}
: ${MSSQL_PORT:="1433"}
: ${NTP_PORT:="123"}
: ${OPENVPN_PORT:="1194"}
: ${PPTP_PORT:="1723"}
: ${FTP_PORT:="21"}
: ${RSYNC_PORT:="873"}
: ${SQUID_PORT:="3128"}
####################
# GEOIP-GROUPS
: ${HOME_COUNTRY:="[US]"}
####################
# AETAS-GROUPS
: ${SAGAN_HOURS:="0700-1800"}
: ${SAGAN_DAYS:="12345"}
####################
# MMAP-GROUPS
: ${MMAP_DEFAULT:="10000"}
####################
# ADDRESS-GROUPS
: ${HOME_NET:="any"}
: ${EXTERNAL_NET:="any"}
####################
# MISC-GROUPS
: ${CREDIT_CARD_PREFIXES:="4,34,37,300,301,302,303,304,305,2014,2149,309,36,38,39,54,55,6011,6221,6222, 6223,6224,6225,6226,\
                           6227,6228,6229,644,645,646,647,648,649,65,636,637,638,639,22,23,24,25,26,27,51,52,53,53,55"}
: ${RFC1918:="10.,192.168.,172.16.,172.17.,172.18.,172.19.,172.20.,172.21.,172.22.,172.23.,172.24.,172.25.,172.26.,172.27.,\
               172.28.,172.29.,172.30.,172.31."}
: ${WINDOWS_DOMAINS:="MYCOMPANYDOMAIN,EXAMPLEDOMAIN,ANOTHER_DOMAIN"}

: ${PSEXEC_MD5:="CD23B7C9E0EDEF184930BC8E0CA2264F0608BCB3, 9A46E577206D306D9D2B2AB2F72689E4F5F38FB1,\
             2EDEEFB431663F20A36A63C853108E083F4DA895,B5C62D79EDA4F7E4B60A9CAA5736A3FDC2F1B27E,\
             A7F7A0F74C8B48F1699858B3B6C11EDA"}

####################
# CORE
: ${default_port:="514"}
: ${default_proto:="udp"}
: ${max_threads:="100"}
: ${default_host:="169.254.0.1"}
: ${classification:="$RULE_PATH/classification.config"}
: ${reference:="$RULE_PATH/reference.config"}
: ${gen_msg_map:="$RULE_PATH/gen-msg.map"}
: ${protocol_map:="$RULE_PATH/protocol.map"}
: ${input_type:="pipe"}
: ${json_map:=""}
: ${json_software:=""}
####################
# LIBLOGNORM
: ${normalize_rulebase:="$RULE_PATH/normalization.rulebase"}
####################
# PROCESSORS
: ${trackclients:="720"}
####################
# OUTPUT
: ${SOCKET_PATH:="unix:///Storage/suricata_logs/eve.sock"}
####################
# SELECTOR
: ${USE_SELECTOR:="no"}
: ${SELECTOR_NAME:="selector"}
################################
# MISC INFO
: ${COUNTRY_DB:="/usr/share/GeoIP/Geo-Country.mmdb"}


SAGAN_GROUPS="FIFO RULE_PATH LOCKFILE LOG_PATH"
PORT_GROUPS="SSH_PORT HTTP_PORT HTTPS_PORT TELNET_PORT DNS_PORT SNMP_PORT POP3_PORT IMAP_PORT SMTP_PORT MYSQL_PORT MSSQL_PORT NTP_PORT OPENVPN_PORT PPTP_PORT FTP_PORT RSYNC_PORT SQUID_PORT"
GEOIP_GROUPS="HOME_COUNTRY"
AETAS_GROUPS="SAGAN_HOURS SAGAN_DAYS"
MMAP_GROUPS="MMAP_DEFAULT"
ADDRESS_GROUPS="HOME_NET EXTERNAL_NET"
MISC_GROUPS="CREDIT_CARD_PREFIXES RFC1918 WINDOWS_DOMAINS PSEXEC_MD5"

CORE="default_port default_proto max_threads default_host classification reference gen_msg_map protocol_map input_type json_map json_software"

echo "Updating GeoIP"
mkdir -p /usr/share/GeoIP
cd /usr/share/GeoIP
curl -z Geo-Country.mmdb.gz -o Geo-Country.mmdb.gz https://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz >/dev/null
gzip -fqdk /usr/share/GeoIP/Geo-Country.mmdb.gz

echo "Creating Config"

rm -Rf /usr/local/etc/sagan.yaml
touch /usr/local/etc/sagan.yaml

echo "%YAML 1.1" >> /usr/local/etc/sagan.yaml
echo "---" >> /usr/local/etc/sagan.yaml

echo "vars:" >> /usr/local/etc/sagan.yaml
echo "  sagan-groups:" >> /usr/local/etc/sagan.yaml
for i in $SAGAN_GROUPS;do
    if [ ! -z "${!i}" ];then
        echo "    ${i}: ${!i}" >> /usr/local/etc/sagan.yaml
    fi
done
echo "  port-groups:" >> /usr/local/etc/sagan.yaml
for i in $PORT_GROUPS;do
    if [ ! -z "${!i}" ];then
        echo "    ${i}: ${!i}" >> /usr/local/etc/sagan.yaml
    fi
done
echo "  geoip-groups:" >> /usr/local/etc/sagan.yaml
for i in $GEOIP_GROUPS;do
    if [ ! -z "${!i}" ];then
        echo "    ${i}: ${!i}" >> /usr/local/etc/sagan.yaml
    fi
done
echo "  aetas-groups:" >> /usr/local/etc/sagan.yaml
for i in $AETAS_GROUPS;do
    if [ ! -z "${!i}" ];then
        echo "    ${i}: ${!i}" >> /usr/local/etc/sagan.yaml
    fi
done
echo "  mmap-groups:" >> /usr/local/etc/sagan.yaml
for i in $MMAP_GROUPS;do
    if [ ! -z "${!i}" ];then
        echo "    ${i}: ${!i}" >> /usr/local/etc/sagan.yaml
    fi
done
echo "  address-groups:" >> /usr/local/etc/sagan.yaml
for i in $ADDRESS_GROUPS;do
    if [ ! -z "${!i}" ];then
        echo "    ${i}: ${!i}" >> /usr/local/etc/sagan.yaml
    fi
done
echo "  misc-groups:" >> /usr/local/etc/sagan.yaml
for i in $MISC_GROUPS;do
    if [ ! -z "${!i}" ];then
        echo "    ${i}: ${!i}" >> /usr/local/etc/sagan.yaml
    fi
done

echo "sagan-core:" >> /usr/local/etc/sagan.yaml
echo "  core:" >> /usr/local/etc/sagan.yaml
for i in $CORE;do
    if [ ! -z "${!i}" ];then
        echo "    $(echo -n $i | sed 's/_/-/g'): ${!i}" >> /usr/local/etc/sagan.yaml
    fi
done

echo "  selector:" >> /usr/local/etc/sagan.yaml
echo "    enabled: ${USE_SELECTOR}" >> /usr/local/etc/sagan.yaml
echo "    name: ${SELECTOR_NAME}" >> /usr/local/etc/sagan.yaml

echo "  mmap-ipc:" >> /usr/local/etc/sagan.yaml
echo "    ipc-directory: /var/run/sagan" >> /usr/local/etc/sagan.yaml
echo "    xbit: \$MMAP_DEFAULT" >> /usr/local/etc/sagan.yaml
echo "    threshold-by-src: \$MMAP_DEFAULT" >> /usr/local/etc/sagan.yaml
echo "    threshold-by-dst: \$MMAP_DEFAULT" >> /usr/local/etc/sagan.yaml
echo "    threshold-by-username: \$MMAP_DEFAULT" >> /usr/local/etc/sagan.yaml
echo "    after-by-src: \$MMAP_DEFAULT" >> /usr/local/etc/sagan.yaml
echo "    after-by-dst: \$MMAP_DEFAULT" >> /usr/local/etc/sagan.yaml
echo "    after-by-username: \$MMAP_DEFAULT" >> /usr/local/etc/sagan.yaml
echo "    track-clients: \$MMAP_DEFAULT" >> /usr/local/etc/sagan.yaml

echo "  geoip:" >> /usr/local/etc/sagan.yaml
echo "    enabled: yes" >> /usr/local/etc/sagan.yaml
echo "    country_database: ${COUNTRY_DB}" >> /usr/local/etc/sagan.yaml

echo "  liblognorm:" >> /usr/local/etc/sagan.yaml
echo "    enabled: yes" >> /usr/local/etc/sagan.yaml
echo "    normalize_rulebase: ${normalize_rulebase}" >> /usr/local/etc/sagan.yaml

echo "processors:" >> /usr/local/etc/sagan.yaml
echo "  - track-clients:" >> /usr/local/etc/sagan.yaml
echo "      enabled: yes" >> /usr/local/etc/sagan.yaml
echo "      timeout: ${trackclients}" >> /usr/local/etc/sagan.yaml

{ cat <<EOM
outputs:
  - syslog:
      enabled: no
  #- eve-log:
  #    enabled: yes
  #    logs: yes
  #    alerts: yes
  #    filename: ${SOCKET_PATH}
  - alert:
      enabled: yes
      filename: "$LOG_PATH/alert.log"
EOM
} >> /usr/local/etc/sagan.yaml

echo "rules-files:" >> /usr/local/etc/sagan.yaml
if [ -f "${RULE_PATH}/config_data" ];then
    for i in $(cat ${RULE_PATH}/config_data | grep \.rules$ | awk '{ print $NF }'); do
        echo "  - ${i}" >> /usr/local/etc/sagan.yaml
    done
fi

echo "" >> /usr/local/etc/sagan.yaml

cat /usr/local/etc/sagan.yaml

mkdir -p /var/run/sagan
mkdir -p /var/log/sagan
chown nobody:sagan /var/run/sagan -R
chown nobody:sagan /var/log/sagan -R

chown -R sagan:sagan /var/log/sagan /var/run/sagan
#chown -R demo:sagan /usr/local/etc/
#mkfifo /var/run/sagan.fifo
chown sagan:sagan /var/run/sagan.fifo
chmod 666 /var/run/sagan.fifo /var/log/*
chmod ugo+x /var/log/sagan

echo "Starting Sagan"
sagan "$@"
