#!/bin/sh
SUBS=$(echo $SUBLIST | tr ";" "\n")

cp /etc/nginx/nginx-template-start.conf /etc/nginx/nginx-template.conf

for SUB in $SUBS
do
    cat /etc/nginx/nginx-location-template.conf | sed 's|${LOCATION_SUB}|'${SUB}'|g' >> /etc/nginx/nginx-template.conf
done

cat /etc/nginx/nginx-template-end.conf >> /etc/nginx/nginx-template.conf

sed 's|${BASE_URL}|'${BASE_URL}'|g' /etc/nginx/nginx-template.conf > /etc/nginx/nginx.conf

echo "Replacements made, starting nginx..."
nginx -g "daemon off;"