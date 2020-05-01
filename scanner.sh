#!/bin/bash
touch /tmp/filtered
#Clear the old scan results file
echo "" > "/tmp/hostscanresults"
echo "" > "scanResults"
# Ensure proper input from user (has argument of an IP range)
if [ -z $1 ]
        then
        printf "\nThis script requires an IP w/ CIDR to run.\n\nSyntax is: proxychains ./hostscanner 192.168.0.1/24\n\n"
#If everything is good, Continue with the scans
else
        #Take the  address and cidr input by the user and store it for reuse
        iprange=$1
        #List out the IPs that fall within the range and add them to an array
        arrayofIPs=($(nmap -sL $iprange | awk '/Nmap scan report/{print $NF}'))

        #This prints how many items are in the array, was for testing
        numberofIPs=${#arrayofIPs[@]}
        #echo "${#arrayofIPs[@]}"
        #Remove the net ID and the brodcast addresses from the list to scan
        if [ $numberofIPs > 3 ]
        then

            unset 'arrayofIPs[0]'
            unset 'arrayofIPs[${#arrayofIPs[@]}-1]'
        fi
        counter=1
        for address in ${arrayofIPs[@]}
        do
                #echo "Scanning $address" >> "/tmp/hostscanresults"
                nc -vnzw1 $address 22 >> "/tmp/hostscanresults" 2>&1
                percentage=$((((10000*$counter)/$numberofIPs)/100))
                echo "Scan is $percentage% complete."
                ((counter+=1))
        done

        #Move all lines that don't contain "(UNKNOWN)" to a new file
        grep -v "Connection timed out" /tmp/hostscanresults > /tmp/filtered
        grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[019]|[01]?[0-9][0-9]?)' /tmp/filtered | grep -v "127.0.0.1" | uniq > /tmp/filtered2
        #add the IPs that returned something to an array for the port scans
        #sort /tmp/filtered | uniq -d > "/tmp/filtered2"
        echo "Scan is done"
fi

mapfile -t validHosts</tmp/filtered2

for ips in ${validHosts[@]}
do
        echo "Now scanning $ips" >> scanResults
        for x in {1..65355}
        do
                echo "${ips}/${x}"
                timeout 1 echo>/dev/tcp/${ips}/${x} 2>&1 >/dev/null &&
                echo "Port open: $x" >> scanResults
        done
done








#TODO:
# Suppress the output of the /dev/tcp port scan
# Ask the user if they want to scan high ports or just Well-known
# Verify scanning a single IP works
# Allow UDP scans
#
#
#
