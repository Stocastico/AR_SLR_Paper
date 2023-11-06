urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            " ") printf "+";;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

#readarray list < ./ieee_dois.txt    
#list=("${(@f)$(< ./ieee_dois.txt)}") #Added for mac
#list=("${(f)$(< ieee_dois.txt)}")

#for doi in "${list[@]}"

input="ieee_dois.txt"
while IFS= read doi

do
    echo "Download for term: ${doi}"
        echo "$(urlencode "${doi}")"
    link=$(curl -s -L 'https://sci-hub.se/' --compressed \
        -H 'authority: sci-hub.se' \
        -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
        -H 'accept-language: en-US,en;q=0.9,es-CO;q=0.8,es;q=0.7' \
        -H 'cache-control: max-age=0' \
        -H 'content-type: application/x-www-form-urlencoded' \
        -H 'cookie: __ddg1=BtxiJLnNZJLBkABn4hpt; session=97bea0eea9e31566256d52c73ff7f0c8; refresh=1632424058.9403; __ddgid=ZhCUNBqgvzZw8NyO; __ddgmark=fwbZCB5monJGgo14; __ddg2=xmUHEIajmbeImx4L' \
        -H 'origin: https://sci-hub.se' \
        -H 'referer: https://sci-hub.se/' \
        -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="92", "Opera";v="78"' \
        -H 'sec-ch-ua-mobile: ?0' \
        -H 'sec-fetch-dest: document' \
        -H 'sec-fetch-mode: navigate' \
        -H 'sec-fetch-site: same-origin' \
        -H 'sec-fetch-user: ?1' \
        -H 'upgrade-insecure-requests: 1' \
        -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36 OPR/78.0.4093.231' \
        --data-raw "sci-hub-plugin-check=&request=$(urlencode "${doi}")". | grep -o  "(?<=//).+(?=#)")

    echo "Found link: $link"
    cd ~/Downloads/papers/ && { curl -s -L $link -O ; cd -; }
done < "$input"