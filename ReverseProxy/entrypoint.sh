#!/bin/sh
SUBS=$(echo $SUBLIST | tr ";" "\n")

cp nginx-template-start.conf nginx-template.conf

for SUB in $SUBS
do
    cat nginx-location-template.conf | sed 's|${LOCATION_SUB}|'${SUB}'|g' >> nginx-template.conf
done

cat nginx-template-end.conf >> nginx-template.conf

sed 's|${BASE_URL}|'${BASE_URL}'|g' /etc/nginx/nginx-template.conf > /etc/nginx/nginx.conf

echo "Replacements made, starting nginx..."
nginx -g "daemon off;"