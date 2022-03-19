*** Variables ***
${ENV}                          qa
${URL-IPV4}                     https://ipv4.icanhazip.com
${URL-MIK}                      https://mik.${ENV}.platform.michaels.com/api
${PRJECT}                       mik
${URL}                          https://${PRJECT}.${ENV}.platform.michaels.com/api
${URL-MDA}                      https://${PRJECT}.${ENV}.platform.michaels.com/api/mda
${URL-B2B}                      https://b2b.${ENV}.platform.michaels.com/api
#${URL-USR}                      https://usr.${ENV}.platform.michaels.com/api
#${URL-FIN}                      https://fin.${ENV}.platform.michaels.com/api
#${URL-CMS}                      https://cms.${ENV}.platform.michaels.com/api
#${URL-MAP}                      https://map.${ENV}.platform.michaels.com/api
#${URL-CPM}                      https://cpm${ENV}.platform.michaels.com/api
${URL-B2B-CMS}                  ${URL-B2B}/cms
${URL-B2B-MAP}                  ${URL-B2B}/map
${URL-B2B-CPM}                  ${URL-B2B}/cpm
${URL-MIK-MAP}                  ${URL-MIK}/map
${URL-MIK-MDA}                  ${URL-MIK}/mda
${URL-USR}                      ${URL}/usr
${URL-FIN}                      ${URL}/fin
${URL-CPM}                      ${URL}/cpm
${URL-INV}                      ${URL}/inv
${URL-MPE}                      ${URL-MIK}/mpe
${URL-MAP}                      ${URL}/map

