#/bin/bash
export srcvcnocid=ocid1.vcn.oc1.eu-frankfurt-1.abcdefghijklmnopqrstuvwxyz
srcvcn=$(oci network vcn get --vcn-id $srcvcnocid)


oci network vcn create --generate-full-command-json-input >> vcntmpl.json

cidrblock=$(echo $srcvcn | jq '.data."cidr-block"')
compid=$(echo $srcvcn | jq '.data."compartment-id"')
deftags=$(echo $srcvcn | jq '.data."defined-tags"')
displayname=$(echo $srcvcn | jq '.data."display-name"')
dnslabel=$(echo $srcvcn | jq '.data."dns-label"')
freetags=$(echo $srcvcn | jq '.data."freeform-tags"')
ipv6cidr=$(echo $srcvcn | jq '.data."ipv6-cidr-block"')


cat vcntmpl.json | jq ".cidrBlock = $cidrblock" | \
jq ".compartmentId = $compid" | \
jq ".definedTags = $deftags" | \
jq ".displayName = $displayname" | \
jq ".dnsLabel = $dnslabel" | \
jq ".freeformTags = $freetags" | \
jq 'del(."ipv6CidrBlock")' | \
jq 'del(."isIpv6Enabled")' | \
jq 'del(."maxWaitSeconds")' | \
jq 'del(."waitForState")' | \
jq 'del(."waitIntervalSeconds")' >> vcnbackup.json
