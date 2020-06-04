#/bin/bash
export srcvcnocid=ocid1.vcn.oc1.eu-frankfurt-1.abcdefghijklmnopqrstuvwxyz
srcvcn=$(oci network vcn get --vcn-id $srcvcnocid)
compocid=$(echo $srcvcn | jq -r '.data."compartment-id"')

srcsub=$(oci network subnet list --compartment-id $compocid --vcn-id $srcvcnocid)


oci network subnet create --generate-full-command-json-input >> subtmpl.json

ad=$(echo $srcsub | jq '.data."availability-domain"')
cidrblock=$(echo $srcsub | jq '.data."cidr-block"')
compid=$(echo $srcsub | jq '.data."compartment-id"')
deftags=$(echo $srcsub | jq '.data."defined-tags"')
dhcpid=$(echo $srcsub | jq '.data."dhcp-options-id"')
displayname=$(echo $srcsub | jq '.data."display-name"')
dnslabel=$(echo $srcsub | jq '.data."dns-label"')
freetags=$(echo $srcsub | jq '.data."freeform-tags"')
ipv6cidr=$(echo $srcsub | jq '.data."ipv6-cidr-block"')
ispriv=$(echo $srcsub | jq '.data."prohibit-public-ip-on-vnic"')
rtid=$(echo $srcsub | jq '.data."route-table-id"')
slid=$(echo $srcsub | jq '.data."security-list-ids"')
vcnid=$(echo $srcsub | jq '.data."vcn-id"')


cat subtmpl.json | jq ".cidrBlock = $cidrblock" | \
jq ".availabilityDomain = $ad" | \
jq ".compartmentId = $compid" | \
jq ".definedTags = $deftags" | \
jq ".dhcpOptionsId = $dhcpid" | \
jq ".displayName = $displayname" | \
jq ".dnsLabel = $dnslabel" | \
jq ".freeformTags = $freetags" | \
jq ".prohibitPublicIpOnVnic = $ispriv" | \
jq ".routeTableId = $rtid" | \
jq ".securityListIds = $slid" | \
jq ".vcnId = $vcnid" | \
jq 'del(."ipv6CidrBlock")' | \
jq 'del(."maxWaitSeconds")' | \
jq 'del(."waitForState")' | \
jq 'del(."waitIntervalSeconds")' >> snbackup.json
